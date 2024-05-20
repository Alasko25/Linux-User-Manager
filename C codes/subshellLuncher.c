#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void exec_subshell(char* script[], int length) {
    
    printf("Exécution dans un sous-shell\n");
    
    int total_length = 0;
    for (int i = 1; i < length; ++i) {
        total_length += ( strlen(script[i]) + 1 );
    }

    // Allouer de la mémoire pour le tampon
    char *buffer = (char *)malloc(total_length + 6); 
    if (buffer == NULL) {
        fprintf(stderr, "Erreur d'allocation de mémoire\n");
        exit(EXIT_FAILURE);
    }

    // Concaténer tous les arguments dans le tampon
    buffer[0] = '(';
    buffer[1] = ' ';
    buffer[2] = '\0'; 
    for (int i = 1; i < length; ++i) {
        strcat(buffer, script[i]);
        strcat(buffer, " ");
    }
    
    strcat(buffer, ")");
    
    system(buffer); 
    
    printf("Exécution dans un sous-shell terminée.\n");
}

int main(int argc, char* argv[]) {
    exec_subshell(argv, argc);
    return 0;
}
