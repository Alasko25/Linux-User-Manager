#!/bin/bash

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

    sudo echo "$sudo_user ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
}

# Fonction pour surveiller l'intégrité des fichiers système
surveiller_integrite() {
    # Ici, vous pouvez utiliser des outils comme tripwire
    # ou écrire des scripts personnalisés pour surveiller l'intégrité des fichiers système
    # Je vais laisser cet exemple avec un simple affichage
    echo "Surveillance de l'intégrité des fichiers système..."
    # Ici, vous pouvez ajouter votre propre logique de surveillance
}

# Fonction pour générer des rapports
generer_rapport() {
    # Ici, vous pouvez écrire la logique pour générer des rapports
    echo "Génération de rapports..."
    # Vous pouvez inclure des informations sur les activités liées à la gestion des utilisateurs,
    # les droits sudoers, les modifications du système, etc.
}

# Menu principal
while true; do
    echo "1. Créer un nouvel utilisateur"
    echo "2. Modifier les informations d'un utilisateur"
    echo "3. Supprimer un utilisateur"
    echo "4. Configurer les droits sudoers"
    echo "5. Quitter"

    read -p "Choix : " choice

    case $choice in
        1) creer_utilisateur ;;
        2) modifier_utilisateur ;;
        3) supprimer_utilisateur ;;
        4) configurer_sudoers ;;
        5) exit ;;
        *) echo "Choix invalide";;
    esac
done &

# Surveiller l'intégrité des fichiers système en arrière-plan
surveiller_integrite &

# Générer des rapports en arrière-plan
generer_rapport &

# Exemple de script de démarrage (peut varier selon le système)
# Placez ce script dans le répertoire /etc/init.d/ et créez un lien symbolique dans /etc/rc.d/rc3.d/ pour l'exécuter au démarrage
# Assurez-vous que le script est exécutable (chmod +x /etc/init.d/mon_script_de_demarrage)
# Exemple de contenu du script de démarrage :
# 
# #!/bin/bash
# /chemin/vers/votre/script.sh >/dev/null 2>&1 &

# Vous pouvez également utiliser des tâches planifiées pour démarrer le script au démarrage du système
# Par exemple, en utilisant cron, vous pouvez ajouter une ligne dans crontab :
# @reboot /chemin/vers/votre/script.sh >/dev/null 2>&1 &

