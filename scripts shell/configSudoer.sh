# Fonction pour configurer les paramètres d'un utilisateur sudo (sudoer)
configurer_sudoer() {
    # Afficher le menu
    echo "Menu :"
    echo "1. Créer sudoer"
    echo "2. Modifier sudoer"
    echo "3. Supprimer sudoer"
    read -p "Choix : " option

    case $option in
        1)
            # Créer sudoer
            read -p "Nom d'utilisateur à configurer en tant que sudoer : " username
            read -p "Indiquer les commandes autorisées (séparées par des virgules) : " allowed_commands

            # Vérifier si l'utilisateur existe
            if grep -q "^$username:" /etc/passwd; then
                echo "Utilisateur $username existe déjà."
                return 1
            fi

            # Ajouter l'utilisateur en tant que sudoer
            echo "$username ALL=($username) $allowed_commands" >> /etc/sudoers
            echo "Utilisateur $username configuré en tant que sudoer dans le fichier sudoers."
            ;;
        2)
            # Modifier sudoer
            read -p "Nom d'utilisateur à modifier en tant que sudoer : " username

            # Vérifier si l'utilisateur existe
            if ! grep -q "^$username:" /etc/passwd; then
                echo "Utilisateur $username introuvable."
                return 1
            fi

            # Vérifier si l'utilisateur est sudoer
            if ! sudo -lU "$username" | grep -q "(ALL) NOPASSWD: ALL"; then
                echo "Utilisateur $username n'est pas sudoer."
                return 1
            fi

            # Afficher les commandes autorisées actuellement
            current_commands=$(sudo -lU "$username" | grep "(ALL)" | awk '{print $NF}' | tr -d '()' | tr ',' '\n')
            echo "Commandes autorisées actuellement pour $username :"
            echo "$current_commands"

            # Demander l'action à effectuer
            echo "Menu :"
            echo "1. Ajouter des commandes"
            echo "2. Enlever des commandes"
            read -p "Choix : " action

            case $action in
                1)
                    read -p "Nouvelles commandes autorisées (séparées par des virgules) : " new_commands
                    updated_commands=$(echo "$current_commands,$new_commands" | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')
                    ;;
                2)
                    read -p "Commandes à enlever (séparées par des virgules) : " remove_commands
                    updated_commands=$(echo "$current_commands" | tr ',' '\n' | grep -v -F -x -f <(echo "$remove_commands" | tr ',' '\n') | tr '\n' ',' | sed 's/,$//')
                    ;;
                *)
                    echo "Option invalide."
                    return 1
                    ;;
            esac

            # Modifier les paramètres du sudoer existant
            sudo sed -i "/^$username ALL=/c $username ALL=($username) $updated_commands" /etc/sudoers
            echo "Paramètres pour $username mis à jour dans le fichier sudoers."
            ;;

        3)
            # Supprimer sudoer
            read -p "Nom d'utilisateur à supprimer en tant que sudoer : " username

            # Vérifier si l'utilisateur est sudoer
            if ! sudo -lU "$username" | grep -q "(ALL) NOPASSWD: ALL"; then
                echo "Utilisateur $username n'est pas sudoer."
                return 1
            fi

            # Supprimer l'utilisateur en tant que sudoer
            sudo sed -i "/^$username ALL=($username) /d" /etc/sudoers
            echo "Utilisateur $username supprimé en tant que sudoer dans le fichier sudoers."
            ;;
        *)
            echo "Option invalide."
            return 1
            ;;
    esac
}
