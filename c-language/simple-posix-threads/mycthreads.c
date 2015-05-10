/* mycthreads.c */
/* Author: Imran Ahmed <researcher6@live.com>
/* Description : This is a simple implementation of POSIX threads in C */


#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_THREADS      10
#define AR_SIZE          1000000
#define SEGMENTS       AR_SIZE / MAX_THREADS

long int  sum=0, AR[AR_SIZE];
pthread_mutex_t add_mutex;



void popArray (int start, int end)
{
int j, st, ed;
long int u;
st = start;
ed = end;
 for (j=st; j < ed ; j++) {         //  WE POPULATE THE ARRAY FOR OUR SECTION ONLY
  u = 10+j;
  AR[j] = u;
        }
}

void *threadTask(void *tid ) 
{
  int i, start, *mytid, end ;
  long int mysum=0;
  long int sumVal=0;  /* A LOCAL VARIABLE TO STORE CUBE VALUE */
  /* PROCESS SECTION OF THE LARGE ARRAY . WE ARE INTERESTED IN PART OF ARRAY ASSIGNED TO THIS THREAD ONLY  */
  mytid = (int *) tid;
  start = (*mytid * SEGMENTS);
  end = start + SEGMENTS;
  FILE *fptr;
  char fname[100];

  printf ("New thread ID : %d created. It will process array members  : AR[ %d ] to AR[ %d ].\n",*mytid,start,end-1); 
  popArray(start, end);
// WE WRITE OUTPUTS TO A FILE
   snprintf (fname, sizeof(fname), "Processed_by_thread_%d.txt",*mytid); // print thread id into filename 
   pthread_mutex_lock (&add_mutex);
   fptr=fopen(fname,"w");
   if(fptr==NULL){
      printf("Error!");
      exit(1);
   }
   

  for (i=start; i < end ; i++) {
    	sumVal = (AR[i] + AR[i]) ;      /* CALCULATE THE SUM OF A MEMBER WITH ITSELF AND STORE IN LOCAL VARIABLE */
	 fprintf(fptr,"Sum of %d + %d = %d \n", AR[i], AR[i], sumVal);

 	}
	
  printf ("Thread ID %d completed its job! Output saved to file :   Processed_by_thread_%d.txt \n",*mytid, *mytid);
  /* Lock the mutex and update the global sum, then exit */
  fclose(fptr);
  pthread_mutex_unlock (&add_mutex);
  pthread_exit(NULL);
}


int main(void)
{
  int i, start, maxT;
  printf(" Please enter the number of threads required (not more than 10) : ");
  scanf("%d",&maxT);
  if((maxT>10) || (maxT <1)){
maxT =1;
}
  int  tids[maxT];
  pthread_t threads[maxT];
  pthread_attr_t attr;
 

  /* HERE WE SETUP PTHREADS. We initialize mutex and explicitly create threads in a
     joinable state. We pass each thread its loop offset */
  pthread_mutex_init(&add_mutex, NULL);
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
  for (i=0; i<maxT; i++) {
    tids[i] = i;
    pthread_create(&threads[i], &attr, threadTask, (void *) &tids[i]);
    }

  /* Wait for all threads to complete */ 
  for (i=0; i<maxT; i++) {
    pthread_join(threads[i], NULL);
  }
  


  /* Clean up and exit */
  pthread_attr_destroy(&attr);
  pthread_mutex_destroy(&add_mutex);
  pthread_exit (NULL);
}
