# Définir le chemin par défaut pour la sauvegarde des rapports et des logs sortants
default_log_directory="/var/log/"

# Définir le chemin actuel de sauvegarde des logs et rapports
current_log_directory="$default_log_directory"

# Fonction pour générer des rapports
generer_rapport() {
    rapport_file="$current_log_directory"

    # Obtenir les activités des utilisateurs
    echo "Activités des utilisateurs :" >> "$rapport_file"
    last | head -n 10 >> "$rapport_file"

    # Obtenir les modifications récentes des droits sudoers
    echo "Modifications récentes des droits sudoers :" >> "$rapport_file"
    sudo grep -R "sudo" /var/log/auth.log | tail -n 10 >> "$rapport_file"

    echo "Rapport généré avec succès : $rapport_file"
}


# Fonction pour changer le chemin de sauvegarde des logs et rapports
logs() {
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
}

# Fonction pour réinitialiser les paramètres par défaut
reinitialiser_parametres() {
    echo "Réinitialisation des paramètres par défaut..."

    # Remettre le chemin de sauvegarde par défaut
    current_log_directory="$default_log_directory"
}