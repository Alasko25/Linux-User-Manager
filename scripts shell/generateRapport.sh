#!/bin/bash

# Définir le chemin par défaut pour la sauvegarde des rapports et des logs sortants
default_log_directory="/var/log/"

# Définir le chemin actuel de sauvegarde des logs et rapports
current_log_directory="$default_log_directory"

# Fonction pour générer des rapports

    rapport_file="$current_log_directory"

    # Obtenir les activités des utilisateurs
    echo "Activités des utilisateurs :" >> "$rapport_file"
    last | head -n 10 >> "$rapport_file"

    # Obtenir les modifications récentes des droits sudoers
    echo "Modifications récentes des droits sudoers :" >> "$rapport_file"
    sudo grep -R "sudo" /var/log/auth.log | tail -n 10 >> "$rapport_file"

    echo "Rapport généré avec succès : $rapport_file"

