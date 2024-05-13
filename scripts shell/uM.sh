#!/bin/bash

# Bloc d'initialisation
if [ -z "$init" ]; then
    init="true"
    current_log_directory="/var/log/"
fi

#traitement des differentes options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c)
            ./newUser.sh
            shift
            ;;
        -m)
            ./modifyUser.sh
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
            surveiller_integrite
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
            shift
            ;;
    esac
done

