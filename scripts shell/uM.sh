#!/bin/bash

# Bloc d'initialisation
if [ -z "$init" ]; then
    init="true"
    current_log_directory="/var/log/"
fi

#Cas de commande appeler sans option
if [ $# -eq 0 ]; then 
    ./printHelp.sh
else
#traitement des differentes options
    case "$1" in
        -c)
            ./newUser.sh
            shift
            ;;
            
        -m)
            shift
            ./modifyUser.sh "$@"
            shift
            ;;
        -d)
            ./deleteUser.sh
            shift
            ;;
        -config)
            ./configSudoer.sh
            shift
            ;;
        -i)            
            ./surveillance.sh
            shift
            ;;
        -g)
            ./generateRapport.sh
            shift
            ;;
        -h)
            ./printHelp.sh
            exit 0
            ;;
        -f)
            echo "Exécution par création de sous-processus avec fork"
            ./forkLuncher.c
            shift
            ;;
        -t)
            echo "Exécution par threads"
            ./threadLuncher.c
            shift
            ;;
        -s)
            echo "Exécuter le script dans un sous-shell"
            ./subshellLuncher.c
            shift
            ;;
        -l)
            ./createLogs.sh
            shift
            ;;
        -r)
            ./resetParams.sh
            shift
            ;;
        *)
            echo "Option invalide : $1"
            exit 100
            ;;
    esac
fi

