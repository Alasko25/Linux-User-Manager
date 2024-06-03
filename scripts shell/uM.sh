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
        -g)
            ./configSudoer.sh
            shift
            ;;
        -i)            
            ./surveillance.sh
            shift
            ;;
        -h)
            ./printHelp.sh
            exit 0
            ;;
        -f)
            shift
            echo "Exécution par création de sous-processus avec fork"
            gcc ../"C codes"/forkLuncher.c -o ../"C codes"/forkLunch
            chmod u+x ../"C codes"/forkLunch
            ../"C codes"/forkLunch "$@"
            shift
            ;;
        -t)
            shift
            echo "Exécution par threads"
            ../C codes/threadLuncher.c
            shift
            ;;
        -s)
            shift
            echo "Exécuter le script dans un sous-shell"
            gcc ../"C codes"/subshellLuncher.c -o ../"C codes"/subshellLunch
            chmod u+x ../"C codes"/subshellLunch
            ../"C codes"/subshellLunch "/home/user/'Linux-User-Manager-main'/'scripts shell'/uM.sh" "$@"
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
            sudo./createLogs.sh "Option invalide : $1"
            exit 100
            ;;
    esac
fi
