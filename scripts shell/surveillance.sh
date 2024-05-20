#!/bin/bash

# Définition du nom du programme (remplacez 'yourprogramname' par le nom de votre programme)
program_name="um"

# Définition du répertoire de journalisation par défaut initial
initial_default_log_directory="/var/log/$program_name/"

# Nom du fichier pour sauvegarder le répertoire par défaut courant
default_directory_file="/tmp/${program_name}_current_default_log_directory"

# Initialiser le répertoire de journalisation courant au répertoire par défaut initial
if [ -f "$default_directory_file" ]; then
    current_default_log_directory=$(cat "$default_directory_file")
else
    current_default_log_directory="$initial_default_log_directory"
    echo "$current_default_log_directory" > "$default_directory_file"
fi

current_log_directory="$current_default_log_directory"

# Vérifier si le fichier de journalisation des commandes existe
if [ ! -f "${current_log_directory}command.log" ]; then
    touch "${current_log_directory}command.log"
fi

# Définir une fonction pour enregistrer les commandes
log_commande() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: $1" >> "${current_log_directory}command.log"
}

# Fonction pour vérifier le type de commande et les autorisations d'accès
verifier_commande() {
    if [[ "$1" == *"<"* || "$1" == *">"* || "$1" == *"<<"* || "$1" == *">>"* ]]; then
        if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
            # Vérifier les droits d'écriture dans le fichier sudo
            if sudo grep -q "$USER.*ALL.*=.*ALL" /etc/sudoers; then
                echo ""
            else
                echo "Droits d'écriture refusés dans le fichier sudo pour $USER: $1"
                log_commande "Droits d'écriture refusés dans le fichier sudo: $1"
                bloquer_utilisateur
                return 1
            fi
        else
            echo "Commande d'écriture non autorisée pour $USER: $1"
            log_commande "Commande d'écriture refusée: $1"
            bloquer_utilisateur
            return 1
        fi
    fi
}

# Fonction pour bloquer l'utilisateur en cas de demandes refusées répétées
bloquer_utilisateur() {
    today_denied_requests=$(grep -c "^$(date '+%Y-%m-%d') $USER.*refusée" "${current_log_directory}command.log")
    if [ "$today_denied_requests" -ge 5 ]; then
        echo "Blocage de l'activité pour $USER en raison de trop de demandes refusées."
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: Activité bloquée" >> "${current_log_directory}command.log"
        exit 1
    fi
}


# Configurer un piège pour intercepter les commandes avant leur exécution
trap 'verifier_commande "$BASH_COMMAND"' DEBUG

# Attendre en arrière-plan pour continuer la surveillance
(sleep 1 &)
