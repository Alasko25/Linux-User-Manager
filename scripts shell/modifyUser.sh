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