#!/bin/bash

# Fonction pour supprimer un utilisateur

read -p "Nom d'utilisateur à supprimer : " username

# Vérifier si l'utilisateur existe
if id "$username" &>/dev/null; then
    # Supprimer l'utilisateur s'il existe
    sudo userdel -r "$username" > /dev/null 2>&1
    echo "Utilisateur $username supprimé avec succès."
else
    echo "Utilisateur $username non trouvé."
    exit 1
fi
