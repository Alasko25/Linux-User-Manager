#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void *thread_function(void *arg) {
    int seconds = *((int *)arg);
    sleep(seconds);
    printf("Tâche terminée en %d secondes\n", seconds);
    pthread_exit(NULL);
}

void exec_threads() {
    printf("Exécution par threads\n");
    // Exemple de code : lancer une tâche en parallèle avec pthreads
    pthread_t thread1, thread2;
    int seconds1 = 2, seconds2 = 3;

    pthread_create(&thread1, NULL, thread_function, (void *)&seconds1);
    pthread_create(&thread2, NULL, thread_function, (void *)&seconds2);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Tâches lancées en parallèle terminées.\n");
}

int main() {
    exec_threads();
    return 0;
}
