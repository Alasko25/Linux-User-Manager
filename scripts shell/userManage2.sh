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
    local username=""
    local newUsername=""
    local primary_group=""
    local secondary_group=""
    local home_dir=""
    local change_password=false

    # Extraire le nom d'utilisateur du premier argument
    username="$1"
    shift

    # Vérifier si le nom d'utilisateur est fourni
    if [ -z "$username" ]; then
        echo "Nom d'utilisateur manquant."
        return 1
    fi

    # Parcourir les arguments
    for arg in "$@"; do
        case $arg in
            uname=*)
                newUsername="${arg#uname=}"
                ;;
            gname=*)
                primary_group="${arg#gname=}"
                ;;
            sgname=*)
                secondary_group="${arg#sgname=}"
                ;;
            hdir=*)
                home_dir="${arg#hdir=}"
                ;;
            pass)
                change_password=true
                ;;
            *)
                echo "Argument invalide : $arg"
                return 1
                ;;
        esac
    done

    # Vérifier si le mot de passe doit être modifié
    if $change_password; then
        # Demander le mot de passe actuel de l'utilisateur
        read -sp "Mot de passe actuel de $username : " current_password
        echo

        # Vérifier si le mot de passe actuel est correct
        if sudo echo "$username:$current_password" | sudo chpasswd &> /dev/null; then
            # Demander le nouveau mot de passe
            read -sp "Nouveau mot de passe pour $username : " new_password
            echo

            # Modifier le mot de passe de l'utilisateur
            echo "$username:$new_password" | sudo chpasswd
            echo "Mot de passe de l'utilisateur $username modifié avec succès."
        else
            echo "Mot de passe incorrect pour l'utilisateur $username. La modification est annulée."
            return 1
        fi
    fi

    # Modifier les informations de l'utilisateur
    sudo usermod ${username:+"-l"} $newUsername ${primary_group:+"-g"} $primary_group ${secondary_group:+"-G"} $secondary_group ${home_dir:+"-d"} $home_dir $username
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

# Vérification du nombre d'arguments
if [ $# -eq 0 ]; then
    echo "Utilisation : $0 [-c | -m | -s | -config | -i | -r]"
    exit 1
fi

# Traitement des options
while getopts ":c:m:s:config:i:r:" opt; do
    case ${opt} in
        c) creer_utilisateur ;;
        m) modifier_utilisateur ;;
        s) supprimer_utilisateur ;;
        config) configurer_sudoers ;;
        i) surveiller_integrite ;;
        r) generer_rapport ;;
        \?) echo "Option invalide : $OPTARG" ;;
    esac
done

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

