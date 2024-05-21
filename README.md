Linux User Manager (uM.sh)

Description
Gestionnaire d'Utilisateurs Linux (uM.sh) est un script Bash complet conçu pour simplifier la gestion des comptes utilisateurs et des paramètres système dans un environnement Linux. Ce script offre diverses fonctionnalités, notamment la création, la modification et la suppression d'utilisateurs, la configuration des sudoers, la surveillance des droits des utilisateurs, et l'exécution d'opérations à l'aide de différentes méthodes telles que les sous-processus, les threads et les sous-shells.

Fonctionnalités

Gestion des Utilisateurs :
Créer un Utilisateur (-c) : Crée un nouvel utilisateur sur le système.
Modifier un Utilisateur (-m) : Modifie les détails d'un utilisateur existant.
Supprimer un Utilisateur (-d) : Supprime un utilisateur du système.
Configuration des Sudoers (-g) : Configure le fichier sudoers pour gérer les privilèges des utilisateurs.

Surveillance (-i) : Redémarre la surveillance des droits des utilisateurs et de l'utilisation des commandes.

Aide (-h) : Affiche un message d'aide avec une liste des options disponibles et leurs descriptions.

Méthodes d'Exécution :

Fork (-f) : Exécute des commandes en créant un sous-processus à l'aide de fork.
Threads (-t) : Exécute des commandes en utilisant des threads.
Sous-Shell (-s) : Exécute le script dans un sous-shell.
Journalisation (-l) : Spécifie un répertoire pour stocker les fichiers de journalisation.

Réinitialisation des Paramètres (-r) : Réinitialise les paramètres aux valeurs par défaut, accessible uniquement aux administrateurs.

Description des Fichiers:
uM.sh : Le script principal qui gère l'ensemble des fonctionnalités.
printHelp.sh : Affiche le message d'aide et les instructions d'utilisation.
newUser.sh : Script pour créer un nouvel utilisateur.
modifyUser.sh : Script pour modifier un utilisateur existant.
deleteUser.sh : Script pour supprimer un utilisateur.
configSudoer.sh : Script pour configurer le fichier sudoers.
surveillance.sh : Script pour surveiller les droits des utilisateurs et l'utilisation des commandes.
createLogs.sh : Script pour créer des journaux.
resetParams.sh : Script pour réinitialiser les paramètres aux valeurs par défaut.
forkLuncher.c : Programme C pour exécuter des commandes en utilisant fork.
threadLuncher.c : Programme C pour exécuter des commandes en utilisant des threads.
subshellLuncher.c : Programme C pour exécuter des commandes dans un sous-shell.

Utilisation:
Pour utiliser ce script, vous pouvez exécuter uM.sh avec les options appropriées. Voici quelques exemples d'utilisation des différentes fonctionnalités :

# Afficher le message d'aide
./uM.sh -h

# Créer un nouvel utilisateur
./uM.sh -c

# Modifier un utilisateur existant
./uM.sh -m nom_utilisateur nouvelle_valeur

# Supprimer un utilisateur
./uM.sh -d

# Configurer sudoers
./uM.sh -g

# Redémarrer la surveillance
./uM.sh -i

# Exécuter en utilisant fork
./uM.sh -f

# Exécuter en utilisant des threads
./uM.sh -t

# Exécuter dans un sous-shell
./uM.sh -s

# Spécifier un répertoire de journaux
./uM.sh -l /chemin/vers/le/répertoire/de/journaux

# Réinitialiser les paramètres par défaut
./uM.sh -r
Installation
Clonez le dépôt :

git clone https://github.com/Alasko25/Linux-User-Manager.git
cd Linux-User-Manager

Assurez-vous que tous les scripts ont les permissions d'exécution :

chmod a+x uM.sh printHelp.sh newUser.sh modifyUser.sh deleteUser.sh configSudoer.sh surveillance.sh createLogs.sh resetParams.sh

Contributions
Les contributions sont les bienvenues ! N'hésitez pas à forker le dépôt et à soumettre des pull requests. Pour des changements majeurs, veuillez ouvrir une issue d'abord pour discuter des modifications que vous souhaitez apporter.

Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

Auteurs
Touré Alassane - Alasko25
Ce projet vise à simplifier les tâches de gestion des utilisateurs et du système sous Linux en fournissant des scripts polyvalent et conviviaux. Profitez de la gestion de votre environnement Linux en toute simplicité !
