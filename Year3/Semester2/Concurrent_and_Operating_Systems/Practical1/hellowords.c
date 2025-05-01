#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

#define USERNAME "obyrnean"

#define NUM_THREADS 18
int magic[] = {907,806,307,874,886,562,320,828,733,199,851,637,973,877,974,698,994,645};

// Function addthis should add 87649200 to its input
// Make it so!
int addthis(int x) {
  return (x + 87649200);
}

int x; // Global variable !!

void *PrintHello(void *threadid){
    int y ; // (Thread) local variable
    int tid;

    tid = (int)(long)threadid;
    y = x; // read that global
    printf( "\n%d: Hello World-%d, from %s!\n"
          , tid
          , magic[tid]
          , USERNAME );
    x = y+1; // write that global
    pthread_exit(NULL);
}

int main(int argc, const char * argv[]) {
    pthread_t threads[NUM_THREADS];
    int rc,t;
    x = 0; // Initialise that global !
    printf("\nHello Worlds [%d]!\n",addthis(0));
    printf("\nRunning %d threads\n",NUM_THREADS);
    for (t=0;t<NUM_THREADS;t++){
        printf("Creating thread %d\n",t);
        rc = pthread_create(&threads[t],NULL,PrintHello,(void *)(long)t);
        if (rc) {
            printf("ERROR return code from pthread_create(): %d\n",rc );
            exit(-1);
        }
    }
    // wait for threads to exit
    for(t=0;t<NUM_THREADS;t++){
        pthread_join(threads[t],NULL);
    }
    // Display that global !
    printf("\nAll threads done by %s, x = %d\n",USERNAME,x);
    exit(0);
}

