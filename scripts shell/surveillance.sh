#!/bin/bash

# Fonction pour surveiller les commandes et gérer les autorisations

# Vérifier si le fichier de journalisation des commandes existe
if [ ! -f "${current_log_directory}command.log" ]; then
    touch ${current_log_directory}command.log
fi

# Définir une fonction pour enregistrer les commandes
log_commande() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: $1" >> ${current_log_directory}command.log
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
    today_denied_requests=$(grep -c "^$(date '+%Y-%m-%d') $USER.*refusée" ${current_log_directory}command.log)
    if [ "$today_denied_requests" -ge 5 ]; then
        echo "Blocage de l'activité pour $USER en raison de trop de demandes refusées."
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: Activité bloquée" >> ${current_log_directory}command.log
        exit 1
    fi
}

# Intercepter chaque commande exécutée
trap 'verifier_commande "$BASH_COMMAND"' DEBUG

# Attendre en arrière-plan pour continuer la surveillance
(sleep 1 &)
