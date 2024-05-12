#!/bin/bash

# Définir le hachage MD5 enregistré pour surveiller l'intégrité du fichier
saved_md5="hachage_md5_enregistré"

# Fonction d'aide
afficher_aide() {
    echo "Utilisation : $0 [Options] ..."
    echo "Options :"
    echo "  -c : Créer un nouvel utilisateur"
    echo "  -m : Modifier les informations d'un utilisateur"
    echo "  -d : Supprimer un utilisateur"
    echo "  -config : Configurer les droits sudoers"
    echo "  -i : Surveiller l'intégrité des fichiers système"
    echo "  -g : Générer des rapports"
    echo "  -h : Afficher cette aide"
    echo "  -f : Permet une exécution par création de sous-processus avec fork"
    echo "  -t : Permet une exécution par threads"
    echo "  -s : Exécute le programme dans un sous-shell"
    echo "  -l : Permet de spécifier un répertoire pour le stockage du fichier de journalisation"
    echo "  -r : Réinitialise les paramètres par défaut, utilisable uniquement par des administrateurs"
}

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

# Fonction pour surveiller les commandes et gérer les autorisations
surveillance() {
    # Vérifier si le fichier de journalisation des commandes existe
    if [ ! -f "${current_log_directory}command.log" ]; then
        touch ${current_log_directory}command.log
    fi

    # Définir une fonction pour enregistrer les commandes
    log_commande() {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: $1" >> ${current_log_directory}command.log
    }

    # Fonction pour vérifier le type de commande et les autorisations d'accès
    verifier_commande() {
        if [[ "$1" == *"<"* || "$1" == *">"* || "$1" == *"<<"* || "$1" == *">>"* ]]; then
            if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
                # Vérifier les droits d'écriture dans le fichier sudo
                if sudo grep -q "$USER.*ALL.*=.*ALL" /etc/sudoers; then
                    echo "Commande d'écriture autorisée: $1"
                else
                    echo "Droits d'écriture refusés dans le fichier sudo pour $USER: $1"
                    log_commande "Droits d'écriture refusés dans le fichier sudo: $1"
                    bloquer_utilisateur
                    return 1
                fi
            else
                echo "Commande d'écriture non autorisée pour $USER: $1"
                log_commande "Commande d'écriture refusée: $1"
                bloquer_utilisateur
                return 1
            fi
        else
            echo "Commande de lecture autorisée: $1"
        fi
    }

    # Fonction pour bloquer l'utilisateur en cas de demandes refusées répétées
    bloquer_utilisateur() {
        today_denied_requests=$(grep -c "^$(date '+%Y-%m-%d') $USER.*refusée" ${current_log_directory}command.log)
        if [ "$today_denied_requests" -ge 5 ]; then
            echo "Blocage de l'activité pour $USER en raison de trop de demandes refusées."
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER: Activité bloquée" >> ${current_log_directory}command.log
            exit 1
        fi
    }

    # Intercepter chaque commande exécutée
    trap 'verifier_commande "$BASH_COMMAND"' DEBUG

    # Attendre en arrière-plan pour continuer la surveillance
    while true; do
        sleep 1
    done
}

# Démarrer la fonction de surveillance en arrière-plan
surveillance &

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

# Définir le chemin par défaut pour la sauvegarde des rapports et des logs sortants
default_log_directory="/var/log/"

# Définir le chemin actuel de sauvegarde des logs et rapports
current_log_directory="$default_log_directory"

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

# Vérification du nombre d'arguments
if [ $# -eq 0 ]; then
    echo "Utilisation : $0 [-c | -m | -s | -config | -i | -r]"
    exit 1
fi

# Traitement des options
while getopts ":c:m:d:config:i:g:h:f:t:s:l:r" opt; do
    case ${opt} in
        c) creer_utilisateur ;;
        m) modifier_utilisateur ;;
        d) supprimer_utilisateur ;;
        config) configurer_sudoers ;;
        i) surveiller_integrite ;;
        g) generer_rapport ;;
        h) afficher_aide ;;
        f) echo "Exécution par création de sous-processus avec fork" ;;
        t) echo "Exécution par threads" ;;
        s) ( $0 "$@" ) ;;
        l) logs ;;
        r) reinitialiser_parametres ;;
        \?) echo "Option invalide : $OPTARG" ;;
    esac
done
