#!/bin/bash

 # Généreration des rapports

    rapport_file="$current_log_directory"

    # Vérifier si le répertoire de log existe, sinon le créer
if [ ! -d "$default_log_directory" ]; then
    mkdir -p "$rapport_file"
fi

    # Obtenir les activités des utilisateurs
    echo "Activités des utilisateurs :" >> "$rapport_file"
    last | head -n 10 >> "$rapport_file"

    # Obtenir les modifications récentes des droits sudoers
    echo "Modifications récentes des droits sudoers :" >> "$rapport_file"
    sudo grep -R "sudo" /var/log/auth.log | tail -n 10 >> "$rapport_file"

    echo "Rapport généré avec succès : $rapport_file"

