# Linux User Manager (uM.sh)

## Description
Gestionnaire d'Utilisateurs Linux (uM.sh) est un script Bash complet conçu pour simplifier la gestion des comptes utilisateurs et des paramètres système dans un environnement Linux. Ce script offre diverses fonctionnalités, notamment la création, la modification et la suppression d'utilisateurs, la configuration des sudoers, la surveillance des droits des utilisateurs, et l'exécution d'opérations à l'aide de différentes méthodes telles que les sous-processus, les threads et les sous-shells.

## Fonctionnalités
### Gestion des Utilisateurs :
__Créer un Utilisateur (-c)__ : Crée un nouvel utilisateur sur le système.

__Modifier un Utilisateur (-m)__ : Modifie les détails d'un utilisateur existant.

__Supprimer un Utilisateur (-d)__ : Supprime un utilisateur du système.

__Configuration des Sudoers (-g)__ : Configure le fichier sudoers pour gérer les privilèges des utilisateurs.

__Surveillance (-i)__ : Redémarre la surveillance des droits des utilisateurs et de l'utilisation des commandes.

__Aide (-h)__ : Affiche un message d'aide avec une liste des options disponibles et leurs descriptions.

### Méthodes d'Exécution :

__Fork (-f)__ : Exécute des commandes en créant un sous-processus à l'aide de fork.

__Threads (-t)__ : Exécute des commandes en utilisant des threads.

__Sous-Shell (-s)__ : Exécute le script dans un sous-shell.

__Journalisation (-l)__ : Spécifie un répertoire pour stocker les fichiers de journalisation.

__Réinitialisation des Paramètres (-r)__ : Réinitialise les paramètres aux valeurs par défaut, accessible uniquement aux administrateurs.

## Description des Fichiers:
__uM.sh__ : Le script principal qui gère l'ensemble des fonctionnalités.

__printHelp.sh__ : Affiche le message d'aide et les instructions d'utilisation.

__newUser.sh__ : Script pour créer un nouvel utilisateur.

__modifyUser.sh__ : Script pour modifier un utilisateur existant.

__deleteUser.sh__ : Script pour supprimer un utilisateur.

__configSudoer.sh__ : Script pour configurer le fichier sudoers.

__surveillance.sh__ : Script pour surveiller les droits des utilisateurs et l'utilisation des commandes.

__createLogs.sh__ : Script pour créer des journaux.

__resetParams.sh__ : Script pour réinitialiser les paramètres aux valeurs par défaut.

__forkLuncher.c__ : Programme C pour exécuter des commandes en utilisant fork.

__threadLuncher.c__ : Programme C pour exécuter des commandes en utilisant des threads.

__subshellLuncher.c__ : Programme C pour exécuter des commandes dans un sous-shell.

## Utilisation:
Pour utiliser ce script, vous pouvez exécuter uM.sh avec les options appropriées. Voici quelques exemples d'utilisation des différentes fonctionnalités :

### Afficher le message d'aide
./uM.sh -h

### Créer un nouvel utilisateur
./uM.sh -c

### Modifier un utilisateur existant
./uM.sh -m nom_utilisateur uname=nouvelle_valeur

### Supprimer un utilisateur
./uM.sh -d

### Configurer sudoers
./uM.sh -g

### Redémarrer la surveillance
./uM.sh -i

### Exécuter en utilisant fork
./uM.sh -f

### Exécuter en utilisant des threads
./uM.sh -t

### Exécuter dans un sous-shell
./uM.sh -s

### Spécifier un répertoire de journaux
./uM.sh -l /chemin/vers/le/répertoire/de/journaux

### Réinitialiser les paramètres par défaut
./uM.sh -r

## Installation
### Clonez le dépôt :

git clone https://github.com/Alasko25/Linux-User-Manager.git
cd Linux-User-Manager

### Assurez-vous que tous les scripts ont les permissions d'exécution :

chmod a+x uM.sh printHelp.sh newUser.sh modifyUser.sh deleteUser.sh configSudoer.sh surveillance.sh createLogs.sh resetParams.sh

## Contributions
Les contributions sont les bienvenues ! N'hésitez pas à forker le dépôt et à soumettre des pull requests. Pour des changements majeurs, veuillez ouvrir une issue d'abord pour discuter des modifications que vous souhaitez apporter.

## Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## Auteurs
Touré Alassane - Alasko25
Konsebo Wendbénédo Albéric Darius - Darius Konsebo - Jaouad Salah-Eddine

Ce projet vise à simplifier les tâches de gestion des utilisateurs et du système sous Linux en fournissant des scripts polyvalent et conviviaux. Profitez de la gestion de votre environnement Linux en toute simplicité !
