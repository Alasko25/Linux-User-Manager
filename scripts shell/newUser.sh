#!/bin/bash

# Fonction pour créer un nouvel utilisateur

    read -p "Nom d'utilisateur : " username
    read -p "Mot de passe (Laisser vide pour aucun mot de passe) : " -s password
    echo
    read -p "Groupe primaire (Laisser vide pour par défaut) : " primary_group
    read -p "Groupe secondaire (Laisser vide pour par défaut) : " secondary_group
    read -p "Répertoire personnel (Laisser vide pour par défaut) : " home_dir

    # Vérifier si les chaînes de caractères sont vides et les remplacer par les valeurs par défaut
    [ -z "$primary_group" ] && primary_group=$username
    [ -z "$secondary_group" ] && secondary_group=""
    [ -z "$home_dir" ] && home_dir="/home/$username"

    # Créer l'utilisateur en utilisant sudo useradd avec les paramètres fournis
    sudo useradd -m -g "$primary_group" -G "$secondary_group" -d "$home_dir" "$username"

    # Vérifier si un mot de passe a été fourni et le définir si nécessaire
    if [ -n "$password" ]; then
        echo "$username:$password" | sudo chpasswd
    fi
