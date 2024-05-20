#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

void exec_fork(char* script_path[]) {
    printf("Exécution du script shell en arrière-plan...\n");

    pid_t pid = fork(); // Création d'un nouveau processus
    
    if (pid == -1) {
        perror("fork");
        exit(EXIT_FAILURE);
    } else if (pid == 0) { // Processus fils
        // Exécution du script shell
        printf("Le fils %d: debut du script \n", getpid());
        execv("../scripts shell/uM.sh", script_path);
        // Si execvp retourne, cela signifie qu'il y a eu une erreur
        perror("execv");
        exit(EXIT_FAILURE);
    } else { // Processus parent
        // Attendre que le processus fils se termine
        wait(NULL);
        printf("Le pere %d: ", getpid());
        printf("Le script shell a été exécuté en arrière-plan.\n");
    }
}

int main(int argc, char *argv[]) {

    printf("Le pere %d: ouverture du fils \n", getpid());

    exec_fork(argv);
    
    return 0;
}
