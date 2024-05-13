#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

void exec_fork(char *script_path) {
    printf("Exécution du script shell en arrière-plan...\n");

    pid_t pid = fork(); // Création d'un nouveau processus
    
    if (pid == -1) {
        perror("fork");
        exit(EXIT_FAILURE);
    } else if (pid == 0) { // Processus fils
        // Exécution du script shell
        execlp("sh", "sh", script_path, NULL);
        // Si execvp retourne, cela signifie qu'il y a eu une erreur
        perror("execlp");
        exit(EXIT_FAILURE);
    } else { // Processus parent
        // Attendre que le processus fils se termine
        wait(NULL);
        printf("Le script shell a été exécuté en arrière-plan.\n");
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <script_shell>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    exec_fork(argv[1]);
    return 0;
}
