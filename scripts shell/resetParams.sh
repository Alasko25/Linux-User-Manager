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

# Fonction pour réinitialiser les paramètres par défaut
reset_default_settings() {
    echo "Réinitialisation des paramètres par défaut..."

    # Réinitialiser le répertoire de journalisation courant au répertoire par défaut
    current_log_directory="$initial_default_log_directory"
    echo "Répertoire de journalisation réinitialisé au répertoire par défaut : $current_log_directory"
    ./createLogs.sh "Répertoire de journalisation réinitialisé au répertoire par défaut : $current_log_directory"

    # Mettre à jour le répertoire par défaut courant et sauvegarder dans un fichier
    current_default_log_directory="$initial_default_log_directory"
    echo "$current_default_log_directory" > "$default_directory_file"
}

# Appeler la fonction pour réinitialiser les paramètres par défaut
reset_default_settings
