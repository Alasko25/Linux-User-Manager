#!/bin/bash

# Fonction pour changer le chemin de sauvegarde des logs et rapports

    read -p "Spécifier le nouvel emplacement pour le stockage du fichier de journalisation : " log_directory

    # Vérifier si le répertoire spécifié existe
    if [ ! -d "$log_directory" ]; then
        echo "Répertoire spécifié non trouvé. Création du répertoire : $log_directory"
        mkdir -p "$log_directory"
    fi

    # Copier les anciens logs dans le nouvel emplacement
    cp "${current_log_directory}command.log" "$log_directory"
    cp "${current_log_directory}rapport.txt" "$log_directory"

    # Mettre à jour le chemin actuel de sauvegarde des logs et rapports
    current_log_directory="$log_directory"
    echo "Répertoire de journalisation mis à jour : $current_log_directory"
