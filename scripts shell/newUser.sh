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