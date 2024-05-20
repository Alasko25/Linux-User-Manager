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
fi

current_log_directory="$current_default_log_directory"

# Fonction pour gérer les sorties standard et d'erreur vers le journal
log_command() {
    # Obtenir la date et l'heure au format yyyy-mm-dd-hh-mm-ss
    local timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

    # Obtenir le nom d'utilisateur connecté
    local username=$(whoami)

    # Extraire la dernière commande exécutée
    local command=$(history 1 | sed 's/^ *[0-9]* *//')

    # Construire le message complet avec le format requis
    local log_entry="$timestamp : $username : COMMAND : $command"

    # Écrire le message dans le journal history.log
    echo "$log_entry" >> "${current_log_directory}history.log"

    # Afficher le message sur le terminal
    echo "$log_entry"
}

# Fonction pour changer le répertoire de journalisation
change_log_directory() {
    local new_directory="$1"

    # Vérifier si le répertoire spécifié existe
    if [ ! -d "$new_directory" ]; then
        echo "Répertoire spécifié non trouvé. Création du répertoire : $new_directory"
        mkdir -p "$new_directory"
    fi

    # Copier les anciens logs dans le nouvel emplacement s'ils existent
    if [ -f "${current_log_directory}history.log" ]; then
        cp "${current_log_directory}history.log" "$new_directory"
    fi

    # Mettre à jour le chemin actuel de sauvegarde des logs
    current_log_directory="$new_directory/"
    echo "Répertoire de journalisation mis à jour : $current_log_directory"

    # Mettre à jour le répertoire par défaut courant et sauvegarder dans un fichier
    current_default_log_directory="$new_directory/"
    echo "$current_default_log_directory" > "$default_directory_file"
}

# Vérifier si le répertoire de journalisation par défaut initial existe
if [ ! -d "$initial_default_log_directory" ]; then
    echo "Répertoire de journalisation par défaut initial introuvable. Création du répertoire : $initial_default_log_directory"
    mkdir -p "$initial_default_log_directory"
fi

# Demander à l'utilisateur de spécifier un nouveau répertoire de journalisation
read -p "Spécifier le nouvel emplacement pour le stockage du fichier de journalisation (laisser vide pour utiliser le répertoire par défaut) : " log_directory

# Vérifier si l'utilisateur a spécifié un nouveau répertoire de journalisation
if [ -n "$log_directory" ]; then
    change_log_directory "$log_directory"
else
    echo "Utilisation du répertoire de journalisation par défaut courant : $current_default_log_directory"
fi

# Configurer un piège pour intercepter les commandes avant leur exécution
trap 'log_command' DEBUG

# Exemple d'utilisation de la fonction log_command
log_command "INFOS" "Le répertoire de journalisation a été mis à jour avec succès."

# Démarrer un shell interactif pour permettre à l'utilisateur de saisir des commandes
exec "$SHELL"
