#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void exec_fork() {
    printf("Exécution par création de sous-processus avec fork\n");
    // Exemple de code : exécuter une commande en arrière-plan
    printf("Lancement de la commande en arrière-plan...\n");
    pid_t pid = fork(); // Création d'un nouveau processus
    
    if (pid == -1) {
        perror("fork");
        exit(EXIT_FAILURE);
    } else if (pid == 0) { // Processus fils
        sleep(2); // Exemple : exécute la commande 'sleep 2' en arrière-plan
        printf("Commande lancée en arrière-plan.\n");
        exit(EXIT_SUCCESS);
    } else { // Processus parent
        // Attendre que le processus fils se termine (ici, sleep 2)
        wait(NULL);
    }
}

int main() {
    exec_fork();
    return 0;
}
