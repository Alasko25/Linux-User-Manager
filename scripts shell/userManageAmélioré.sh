#!/bin/bash

# Définir le hachage MD5 enregistré pour surveiller l'intégrité du fichier
saved_md5="hachage_md5_enregistré"

# Fonction pour créer un nouvel utilisateur
creer_utilisateur() {
    read -p "Nom d'utilisateur : " username
    read -p "Mot de passe : " -s password
    echo
    read -p "Groupe primaire : " primary_group
    read -p "Groupe secondaire : " secondary_group
    read -p "Répertoire personnel : " home_dir

    sudo useradd -m -g $primary_group -G $secondary_group -d $home_dir $username
    echo "$username:$password" | sudo chpasswd
}

# Fonction pour modifier les informations d'un utilisateur
modifier_utilisateur() {
    read -p "Nom d'utilisateur à modifier : " username
    read -p "Nouveau groupe primaire : " primary_group
    read -p "Nouveau groupe secondaire : " secondary_group
    read -p "Nouveau répertoire personnel : " home_dir

    sudo usermod -g $primary_group -G $secondary_group -d $home_dir $username
}

# Fonction pour supprimer un utilisateur
supprimer_utilisateur() {
    read -p "Nom d'utilisateur à supprimer : " username

    sudo userdel -r $username
}

# Fonction pour configurer les droits sudoers
configurer_sudoers() {
    read -p "Nom d'utilisateur ou groupe à configurer pour sudo : " sudo_user

    sudo visudo -f /etc/sudoers.d/$sudo_user
}

# Fonction pour surveiller l'intégrité des fichiers système
surveiller_integrite() {
    file_path="/chemin/vers/votre/fichier"

    # Calculer le hachage MD5 du fichier
    current_md5=$(md5sum "$file_path" | awk '{print $1}')

    # Comparer le hachage MD5 actuel avec celui enregistré
    if [ "$current_md5" != "$saved_md5" ]; then
        echo "Modification détectée dans le fichier $file_path"
        # Ajoutez ici les actions à effectuer en cas de modification détectée
    else
        echo "Aucune modification détectée dans le fichier $file_path"
    fi
}

# Fonction pour générer des rapports
generer_rapport() {
    rapport_file="/chemin/vers/votre/rapport.txt"

    # Obtenir les activités des utilisateurs
    echo "Activités des utilisateurs :" >> "$rapport_file"
    last | head -n 10 >> "$rapport_file"

    # Obtenir les modifications récentes des droits sudoers
    echo "Modifications récentes des droits sudoers :" >> "$rapport_file"
    sudo grep -R "sudo" /var/log/auth.log | tail -n 10 >> "$rapport_file"

    echo "Rapport généré avec succès : $rapport_file"
}

# Menu principal
while true; do
    echo "1. Créer un nouvel utilisateur"
    echo "2. Modifier les informations d'un utilisateur"
    echo "3. Supprimer un utilisateur"
    echo "4. Configurer les droits sudoers"
    echo "5. Surveiller l'intégrité des fichiers système"
    echo "6. Générer des rapports"
    echo "7. Quitter"

    read -p "Choix : " choice

    case $choice in
        1) creer_utilisateur ;;
        2) modifier_utilisateur ;;
        3) supprimer_utilisateur ;;
        4) configurer_sudoers ;;
        5) surveiller_integrite ;;
        6) generer_rapport ;;
        7) exit ;;
        *) echo "Choix invalide";;
    esac
done
