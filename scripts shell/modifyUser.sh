#!/bin/bash

# Fonction pour modifier les informations d'un utilisateur
username=""
newUsername=""
primary_group=""
secondary_group=""
home_dir=""
change_password=false

# Extraire le nom d'utilisateur du premier argument
username="$1"
shift

# Vérifier si le nom d'utilisateur est fourni
if [ -z "$username" ]; then
    echo "Nom d'utilisateur manquant."
    exit 1
fi

# Vérifier si l'utilisateur existe
if ! id "$username" &>/dev/null; then
    echo "L'utilisateur $username n'existe pas."
    exit 1
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
            echo "Option invalide : $arg" >> /dev/null
            exit 1
            ;;
    esac
done

# Vérifier si le mot de passe doit être modifié
if $change_password; then
    # Demander le mot de passe actuel de l'utilisateur
    read -sp "Mot de passe actuel de $username : " current_password
    echo

    # Vérifier si le mot de passe actuel est correct
    if echo "$username:$current_password" | sudo chpasswd --stdin &> /dev/null; then
        # Demander le nouveau mot de passe
        read -sp "Nouveau mot de passe pour $username : " new_password
        echo

        # Modifier le mot de passe de l'utilisateur
        echo "$username:$new_password" | sudo chpasswd
        echo "Mot de passe de l'utilisateur $username modifié avec succès."
    else
        echo "Mot de passe incorrect pour l'utilisateur $username. La modification est annulée."
        exit 1
    fi
fi

# Construire la commande usermod avec les paramètres fournis
usermod_command="sudo usermod"

[ -n "$newUsername" ] && usermod_command+=" -l $newUsername"

# Vérifier si le groupe primaire existe avant de l'ajouter à la commande
if [ -n "$primary_group" ]; then
    if getent group "$primary_group" > /dev/null 2>&1; then
        usermod_command+=" -g $primary_group"
    else
        echo "Le groupe primaire $primary_group n'existe pas."
        exit 1
    fi
fi

# Vérifier si le groupe secondaire existe avant de l'ajouter à la commande
if [ -n "$secondary_group" ]; then
    if getent group "$secondary_group" > /dev/null 2>&1; then
        usermod_command+=" -G $secondary_group"
    else
        echo "Le groupe secondaire $secondary_group n'existe pas."
        exit 1
    fi
fi

[ -n "$home_dir" ] && usermod_command+=" -d $home_dir"

# Exécuter la commande usermod
$usermod_command "$username"

# Vérifier si la commande usermod a réussi
if [ $? -eq 0 ]; then
    echo "Informations de l'utilisateur $username modifiées avec succès."
else
    echo "Échec de la modification des informations de l'utilisateur $username."
    exit 1
fi
