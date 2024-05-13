#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void exec_subshell() {
    printf("Exécution dans un sous-shell\n");
    // Exemple de code : exécuter une série de commandes dans un sous-shell
    system("(echo \"Début du sous-shell...\"; ls -l; echo \"Fin du sous-shell\") > subshell_output.txt");
    printf("Exécution dans un sous-shell terminée.\n");
}

int main() {
    exec_subshell();
    return 0;
}