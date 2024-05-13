
#!/bin/bash

# Fonction pour supprimer un utilisateur

    read -p "Nom d'utilisateur à supprimer : " username

    sudo userdel -r $username > /dev/null
