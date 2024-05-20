#!/bin/bash

# Fonction pour configurer les paramètres d'un utilisateur sudo (sudoer)

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
		if ! grep -q "^$username:" /etc/passwd; then
		    echo "Utilisateur $username n'existe pas dans le système."
		    exit 103
		fi

		# Parcourir chaque commande autorisée et obtenir son chemin complet
		commands_with_path=""
		if [ "$allowed_commands" == "ALL" ]; then
			commands_with_path+="ALL"
		else
			# Remplacer ', ' par ',' dans allowed_commands
			allowed_commands="${allowed_commands//, /,}"
			IFS=',' read -ra commands <<< "$allowed_commands"
			for command in "${commands[@]}"; do
			    command_path=$(which "$command")
			    if [ -n "$command_path" ]; then
				commands_with_path+="$command_path, "
			    else
				echo "La commande $command n'a pas été trouvée dans le chemin d'exécution. Elle ne sera pas ajoutée dans le fichier sudoers."
			    fi
			done
		fi

		# Ajouter l'utilisateur en tant que sudoer avec les commandes autorisées (avec leurs chemins complets)
		# Supprimer la virgule et l'espace inutiles à la fin de commands_with_path
		commands_with_path=${commands_with_path%, *}
		echo "$username ALL=(ALL) $commands_with_path" >> /etc/sudoers
		echo "Utilisateur $username configuré en tant que sudoer dans le fichier sudoers."
            ;;
        2)
            # Modifier sudoer
            read -p "Nom d'utilisateur à modifier en tant que sudoer : " username

            # Vérifier si l'utilisateur existe
            if ! grep -q "^$username:" /etc/passwd; then
                echo "Utilisateur $username n'existe pas dans le système."
                exit 103
            fi

            # Vérifier si l'utilisateur est sudoer
            if ! sudo grep "$username" /etc/sudoers > /dev/null 2>&1; then
                echo "Utilisateur $username n'est pas sudoer."
                exit 104
            fi

            # Afficher les commandes autorisées actuellement
            current_commands=$(sudo grep "$username" /etc/sudoers | awk '{for(i=3;i<=NF;i++) if ($i != "" && $i != " ") print $i}' | tr -d ',' | tr '\n' ',')
            
            #formatage de la liste des commandes
            current_commands="${current_commands%,*}"
            current_commands=${current_commands//,/, }
            
	    echo "Commandes autorisées actuellement pour $username : $current_commands"


            if [ "$current_commands" != "ALL" ]; then
            	    # Demander l'action à effectuer
		    echo "Menu :"
		    echo "1. Ajouter des commandes"
		    echo "2. Enlever des commandes"
		    read -p "Choix : " action

		    case $action in
		        1)
		            read -p "Nouvelles commandes autorisées (séparées par des virgules) : " new_commands
		            # Parcourir chaque nouvelle commande autorisée et obtenir son chemin complet
			commands_with_path=""
			# Remplacer ', ' par ',' dans allowed_commands
			new_commands="${new_commands//, /,}"
			IFS=',' read -ra commands <<< "$new_commands"
			for command in "${commands[@]}"; do
			    command_path=$(which "$command")
			    if [ -n "$command_path" ]; then
				commands_with_path+="$command_path, "
			    else
				echo "La commande $command n'a pas été trouvée dans le chemin d'exécution. Elle ne sera pas ajoutée dans le fichier sudoers."
			    fi
			done

			# Ajouter l'utilisateur en tant que sudoer avec les commandes autorisées (avec leurs chemins complets)
			# Supprimer la virgule et l'espace inutiles à la fin de commands_with_path
			commands_with_path=${commands_with_path%, *}
			updated_commands=$(echo "$current_commands, $commands_with_path" | tr -d ' ' | tr ',' '\n' | sort -u | tr '\n' ',')
			
			#formatage de la liste des commandes
			updated_commands="${updated_commands%,*}"
			updated_commands=${updated_commands//,/, }

		            ;;
		        2)
		            read -p "Commandes à enlever (séparées par des virgules) : " remove_commands                   
		            # Parcourir chaque nouvelle commande autorisée et obtenir son chemin complet
			commands_with_path=""
			# Remplacer ', ' par ',' dans allowed_commands
			remove_commands="${remove_commands//, /,}"
			IFS=',' read -ra commands <<< "$remove_commands"
			for command in "${commands[@]}"; do
			    command_path=$(which "$command")
			    if [ -n "$command_path" ]; then
				commands_with_path+="$command_path,"
			    else
				echo "La commande $command n'a pas été trouvée dans le chemin d'exécution. Elle ne sera pas ajoutée dans le fichier sudoers."
			    fi
			done
			
			# Supprimer la virgule et l'espace inutiles à la fin de commands_with_path
			commands_with_path=${commands_with_path%,*}
		            updated_commands=$(echo "$current_commands" | tr -d ' ' | tr ',' '\n' | grep -v -F -x -f <(echo "$commands_with_path" | tr ',' '\n') | tr '\n' ',')
		            
		            #formatage de la liste des commandes
		            updated_commands="${updated_commands%,*}"
			    updated_commands=${updated_commands//,/, }
			
		            ;;
		        *)
		            echo "Option invalide."
		            exit 101
		            ;;
		    esac

		    # Modifier les paramètres du sudoer existant
		    sudo sed -i "/^$username ALL=/c $username ALL=(ALL) $updated_commands" /etc/sudoers
		    echo "Paramètres pour $username mis à jour dans le fichier sudoers."		    
            fi
            
            ;;

        3)
            # Supprimer sudoer
            read -p "Nom d'utilisateur à supprimer en tant que sudoer : " username

            # Vérifier si l'utilisateur est sudoer
            if ! sudo grep "$username" /etc/sudoers > /dev/null 2>&1; then
                echo "Utilisateur $username n'est pas sudoer."
                exit 104
            fi

            # Supprimer l'utilisateur en tant que sudoer
            sudo sed -i "/^$username ALL=(ALL) /d" /etc/sudoers
            echo "Utilisateur $username supprimé en tant que sudoer dans le fichier sudoers."
            ;;
        *)
            echo "Option invalide."
            exit 101
            ;;
    esac
