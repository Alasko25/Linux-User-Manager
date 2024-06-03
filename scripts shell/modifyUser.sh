#!/bin/bash

# Fonction pour modifier les informations d'un utilisateur
username=""
newUsername=""
primary_group=""
secondary_group=""
home_dir=""
change_password=false
kayn_option=false

# Extraire le nom d'utilisateur du premier argument
username="$1"
shift

# Vérifier si le nom d'utilisateur est fourni
if [ -z "$username" ]; then
    echo "Nom d'utilisateur manquant."
    sudo ./createLogs.sh "Nom d'utilisateur manquant."
    exit 101
fi

# Vérifier si l'utilisateur existe
if ! id "$username" &>/dev/null; then
    echo "L'utilisateur $username n'existe pas."
    sudo ./createLogs.sh "L'utilisateur $username n'existe pas."
    exit 101
fi

# Parcourir les arguments
for arg in "$@"; do
    case $arg in
        uname=*)
            newUsername="${arg#uname=}"
            kayn_option=true
            ;;
        gname=*)
            primary_group="${arg#gname=}"
            kayn_option=true
            ;;
        sgname=*)
            secondary_group="${arg#sgname=}"
            kayn_option=true
            ;;
        hdir=*)
            home_dir="${arg#hdir=}"
            kayn_option=true
            ;;
        pass)
            change_password=true
            ;;
        *)
            echo "Option invalide : $arg" >> /dev/null
	    sudo ./createLogs.sh echo "Option invalide : $arg"
            exit 101
            ;;
    esac
done

# Vérifier si le mot de passe doit être changé.
if $change_password; then
    # Obtenir la ligne correspondante dans /etc/shadow pour l'utilisateur spécifié
    shadow_line=$(sudo grep "^$username:" /etc/shadow)

    # Extraire le deuxième champ de la ligne (le mot de passe chiffré)
    encrypted_password=$(echo "$shadow_line" | cut -d: -f2)

    # Vérifier si le mot de passe est non défini (NP) ou s'il est vide
    if [[ "$encrypted_password" == "!" || -z "$encrypted_password" ]]; then
        read -p "Mot de passe (Laisser vide pour aucun mot de passe) : " -s password
        echo
        # Vérifier si un mot de passe a été fourni et le définir si nécessaire
        if [ -n "$password" ] && [ ! -z "$password" ]; then
            echo "$username:$password" | sudo chpasswd
        else
           echo "Aucun mot de passe fourni."
	   sudo ./createLogs.sh "Aucun mot de passe fourni."
        fi
    else
        # Modification du mot de passe.
        if ! sudo -u "$username" passwd "$username" ; then
            echo "Mot de passe incorrect pour l'utilisateur $username. La modification est annulée."
	    sudo ./createLogs.sh "Mot de passe incorrect pour l'utilisateur $username. La modification est annulée."
            exit 101
        fi
    fi
fi


if $kayn_option; then
	# Construire la commande usermod avec les paramètres fournis
	usermod_command="sudo usermod"

	[ -n "$newUsername" ] && usermod_command+=" -l $newUsername"

	# Vérifier si le groupe primaire existe avant de l'ajouter à la commande
	if [ -n "$primary_group" ]; then
	    if getent group "$primary_group" > /dev/null 2>&1; then
		usermod_command+=" -g $primary_group"
	    else
		echo "Le groupe primaire $primary_group n'existe pas."
  		sudo ./createLogs.sh "Le groupe primaire $primary_group n'existe pas."
		exit 101
	    fi
	fi

	# Vérifier si le groupe secondaire existe avant de l'ajouter à la commande
	if [ -n "$secondary_group" ]; then
	    if getent group "$secondary_group" > /dev/null 2>&1; then
		usermod_command+=" -G $secondary_group"
	    else
		echo "Le groupe secondaire $secondary_group n'existe pas."
  		sudo ./createLogs.sh "Le groupe secondaire $secondary_group n'existe pas."
		exit 101
	    fi
	fi

	[ -n "$home_dir" ] && usermod_command+=" -d $home_dir"

	# Exécuter la commande usermod
	$usermod_command "$username"

	# Vérifier si la commande usermod a réussi
	if [ $? -eq 0 ]; then
	    echo "Informations de l'utilisateur $username modifiées avec succès."
     	    sudo ./createLogs.sh "Informations de l'utilisateur $username modifiées avec succès."
	    exit 0
	else
	    echo "Échec de la modification des informations de l'utilisateur $username."
     	    sudo ./createLogs.sh "Échec de la modification des informations de l'utilisateur $username."
	    exit 101
	fi
fi
