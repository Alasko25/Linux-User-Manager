# Fonction pour supprimer un utilisateur
supprimer_utilisateur() {
    read -p "Nom d'utilisateur à supprimer : " username

    sudo userdel -r $username
}