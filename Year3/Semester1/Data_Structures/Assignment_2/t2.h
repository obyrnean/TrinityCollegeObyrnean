#ifndef T2_H_
#define T2_H_
void selectionSort(int arr[], int size);
void insertionSort(int arr[], int size);
void quickSort(int arr[], int size);

void swapElements(int* i, int* j);
int partitionQuicksort (int arr[], int smaller, int larger);
void quickSorting(int arr[], int smallest, int largest);

extern int number_comparisons;
extern int number_swaps;


#endif
