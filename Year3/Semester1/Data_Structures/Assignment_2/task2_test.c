#include "t1.h"
#include "t2.h"
#include <stdio.h>
#include "task1.c"
#include "task2.c"



int main()
{
    int size = 6;
    int arr[6];

    printf("1st random Array (without duplicates): \n");
    fill_without_duplicates(arr, size);
    printArray(arr, size);

    printf("Array after Insertion Sort funtion: \n");
    insertionSort(arr, size);
    printArray(arr, size);

    printf("2nd random Array (without duplicates): \n");
    fill_without_duplicates(arr, size);
    printArray(arr, size);

    printf("Array after Selection Sort funtion: \n");
    selectionSort(arr, size);
    printArray(arr, size);

    printf("3rd random Array (without duplicates): \n");
    fill_without_duplicates(arr, size);
    printArray(arr, size);

    printf("Array after Quick Sort funtion: \n");
    quickSort(arr, size);
    printArray(arr, size);


  return 0; 
}
