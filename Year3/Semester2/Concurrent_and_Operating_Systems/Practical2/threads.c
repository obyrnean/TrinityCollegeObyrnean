 /* Practical 2 Threads
 *
 * Task: Add code below to ensure action-functions run atomically.
 *
 * You should add the minimum amount of code necessary to do this.
 * 
 *     Do not modify the order in which action-functions are called.
 *     Do not add or modify action-function calls.
 */

  
#include "globals.c"
#include "actions.c"

#include <pthread.h>
#include <stdio.h>

 /* Practical 2 Threads
 *
 * Task: Add code below to ensure action-functions run atomically.
 *
 * You should add the minimum amount of code necessary to do this.
 * 
 *     Do not modify the order in which action-functions are called.
 *     Do not add or modify action-function calls.
 */

//Mutex and condition variables:
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER; //Mutex for protecting shared variables
pthread_cond_t cond_gX = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_gD = PTHREAD_COND_INITIALIZER;

void *Thread1(void *threadid) {
  printf( "Thread1 Running\n" );

  //Actions to perform: 
  pthread_mutex_lock(&lock);
  ac6tion_11();
  act5ion_12();
  act1ion_13();
  actio5n_14();
  act2ion_15();
  actio7n_16();
  ac6tion_17();
  pthread_mutex_unlock(&lock);
  
  update_gX(gX); //update if any changes have been made to gX
  update_gD(gD); //update if any changes have been made to gD

  //Waiting for gX to be less than 1
  DISPLAY("Waiting for %s\n","(gX < 1)");

  pthread_mutex_lock(&lock); //Lock mutex to check gX safely
  while (!((gX < 1))) { //If condition is false, wait
    pthread_cond_wait(&cond_gX, &lock); //Sleep until gX changes
  }
  pthread_mutex_unlock(&lock); //Unlock after condition is met

  puff();
  ac5tion_18();
  
  update_gX(gX); //update if any changes have been made to gX

  pthread_exit(NULL);
}


void *Thread2(void *threadid) {
  printf( "Thread2 Running\n" );

  //Actions to perform: 
  pthread_mutex_lock(&lock);
  acti3on_21();
  acti3on_21();
  act9ion_22();
  ac2tion_23();
  acti1on_24();
  acti9on_25();
  actio7n_26();
  ac3tion_27();
  pthread_mutex_unlock(&lock);

  update_gX(gX); //update if any changes have been made to gX
  update_gD(gD); //update if any changes have been made to gD
  
  //Waiting for gX to be greater than 1
  DISPLAY("Waiting for %s\n","(gX > 1)");

  pthread_mutex_lock(&lock);
  while (!((gX > 1))) { //If not greater than 1
    pthread_cond_wait(&cond_gX, &lock); //Sleep
  }
  pthread_mutex_unlock(&lock);

  puff();
  actio7n_28();
  
  update_gX(gX); //update if any changes have been made to gX

  pthread_exit(NULL);
}


void *Thread3(void *threadid) {
  printf( "Thread3 Running\n" );

  //Actions to perform: 
  pthread_mutex_lock(&lock);
  actio7n_31();
  act8ion_32();
  actio4n_33();
  ac8tion_34();
  acti8on_35();
  actio7n_36();
  act1ion_37();
  pthread_mutex_unlock(&lock);
  
  update_gX(gX); //update if any changes have been made to gX
  update_gD(gD); //update if any changes have been made to gD

  //Waiting for gD to be equal to 7
  DISPLAY("Waiting for %s\n","(gD == 7)");

  pthread_mutex_lock(&lock);
  while (!((gD == 7))) {
    pthread_cond_wait(&cond_gD, &lock); //Sleep if not 7
  }
  pthread_mutex_unlock(&lock);

  puff();
  actio8n_38();
  
  update_gD(gD); //update if any changes have been made to gD

  pthread_exit(NULL);
}


void *Thread4(void *threadid) {
  printf( "Thread4 Running\n" );

  //Actions to perform: 
  pthread_mutex_lock(&lock);
  act9ion_41();
  act8ion_42();
  act7ion_43();
  act3ion_44();
  ac1tion_45();
  acti4on_46();
  ac4tion_47();
  pthread_mutex_unlock(&lock);
  
  update_gX(gX); //update if any changes have been made to gX
  update_gD(gD); //update if any changes have been made to gD

  //Waiting for gD to be equal to 4
  DISPLAY("Waiting for %s\n","(gD == 4)");

  pthread_mutex_lock(&lock);
  while (!((gD == 4))) {
    pthread_cond_wait(&cond_gD, &lock); //Sleep if not 4
  }
  pthread_mutex_unlock(&lock);

  puff();
  acti9on_48();
  
  update_gD(gD); //update if any changes have been made to gD

  pthread_exit(NULL);
}


void *Thread5(void *threadid) {
  printf( "Thread5 Running\n" );

  //Actions to perform: 
  pthread_mutex_lock(&lock);
  actio6n_51();
  actio5n_52();
  actio7n_53();
  ac1tion_54();
  actio4n_55();
  act8ion_56();
  acti6on_57();
  pthread_mutex_unlock(&lock);
  
  update_gX(gX); //update if any changes have been made to gX
  update_gD(gD); //update if any changes have been made to gD

  //Waiting for gD to be equal to 11
  DISPLAY("Waiting for %s\n","(gD == 11)");

  pthread_mutex_lock(&lock);
  while (!((gD == 11))) {
    pthread_cond_wait(&cond_gD, &lock); //Sleep if not 11
  }
  pthread_mutex_unlock(&lock);

  puff();
  ac9tion_58();
  
  update_gD(gD); //update if any changes have been made to gD

  pthread_exit(NULL);
}


// Function that updates gX or gD (ensure it signals the waiting threads)
void update_gX(int value) {
  pthread_mutex_lock(&lock); //Lock to safely update gX
  gX = value; //Update gX
  pthread_cond_broadcast(&cond_gX); //Wake up all threads waiting on gX
  pthread_mutex_unlock(&lock); //Unlock after updating 
}

void update_gD(int value) {
  pthread_mutex_lock(&lock);//Lock to safely update gD
  gD = value; //Update gD
  pthread_cond_broadcast(&cond_gD); //Wake up all threads waiting on gD
  pthread_mutex_unlock(&lock); //Unlock after updating 
}
