#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

//* Assembly function declarations
extern long sumArray(long* arr, long size);
extern long findMax(long* arr, long size);
extern long findMin(long* arr, long size);
extern int isEmptyArray(long size);
extern void reverseArray(long* arr, long size);
extern void sortArray(long* arr, long size);

//* C implementations for comparison
long c_sumArray(long* arr, long size) {
    long sum = 0;
    for (long i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

long c_findMax(long* arr, long size) {
    if (size == 0) return 0;
    
    long max = arr[0];
    for (long i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

long c_findMin(long* arr, long size) {
    if (size == 0) return 0;
    
    long min = arr[0];
    for (long i = 1; i < size; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}

int c_isEmptyArray(long size) {
    return size == 0;
}

void c_reverseArray(long* arr, long size) {
    for (long i = 0, j = size - 1; i < j; i++, j--) {
        long temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

void c_sortArray(long* arr, long size) {
    //* bubble sort
    for (long i = 0; i < size - 1; i++) {
        for (long j = 0; j < size - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                long temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

//* function to measure execution time
double measure_time(void (*func)(), void* arg1, void* arg2) {
    clock_t start, end;
    start = clock();
    
    //* Call the function with appropriate arguments
    if (arg2 == NULL) {
        ((long (*)(long))func)(*(long*)arg1);
    } else if (func == (void (*)())c_sumArray || func == (void (*)())sumArray ||
               func == (void (*)())c_findMax || func == (void (*)())findMax ||
               func == (void (*)())c_findMin || func == (void (*)())findMin) {
        ((long (*)(long*, long))func)((long*)arg1, *(long*)arg2);
    } else {
        ((void (*)(long*, long))func)((long*)arg1, *(long*)arg2);
    }
    
    end = clock();
    return ((double) (end - start)) / CLOCKS_PER_SEC * 1000000; //* convert to microseconds
}

//* function to print an array
void printArray(long* arr, long size) {
    printf("[");
    for (long i = 0; i < size; i++) {
        printf("%ld", arr[i]);
        if (i < size - 1) printf(", ");
    }
    printf("]");
}

//* function to generate a random array
long* generateRandomArray(long size, long min, long max) {
    long* arr = (long*)malloc(size * sizeof(long));
    for (long i = 0; i < size; i++) {
        arr[i] = min + rand() % (max - min + 1);
    }
    return arr;
}

int main() {
    printf("=============================================================");
    printf("===== array Functions Comparison: C vs Assembly =====\n\n");
    
    //* seed random number generator
    srand(time(NULL));
    
    //* test arrays
    long empty_array[] = {};
    long single_element[] = {42};
    long small_array[] = {5, 2, 9, 1, 7, 3};
    long* medium_array = generateRandomArray(50, 1, 1000);
    long* large_array = generateRandomArray(500, 1, 10000);
    //* a dictionary
    struct {
        long* arr;
        long size;
        char* name;
    } test_arrays[] = {
        {empty_array, 0, "Empty Array"},
        {single_element, 1, "Single Element Array"},
        {small_array, 6, "Small Array"},
        {medium_array, 50, "Medium Array"},
        {large_array, 500, "Large Array"}
    };
    int num_arrays = sizeof(test_arrays) / sizeof(test_arrays[0]);
    
    //* test sumArray
    printf("1. Sum Array Function\n");
    printf("-------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        long* arr = test_arrays[i].arr;
        long size = test_arrays[i].size;
        
        long c_result = c_sumArray(arr, size);
        long asm_result = sumArray(arr, size);
        
        double c_time = measure_time((void (*)())c_sumArray, arr, &size);
        double asm_time = measure_time((void (*)())sumArray, arr, &size);
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        if (size <= 10) {
            printf("Elements: ");
            printArray(arr, size);
            printf("\n");
        }
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    //* test findMax
    printf("2. Find Max Function\n");
    printf("------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        long* arr = test_arrays[i].arr;
        long size = test_arrays[i].size;
        
        long c_result = c_findMax(arr, size);
        long asm_result = findMax(arr, size);
        
        double c_time = measure_time((void (*)())c_findMax, arr, &size);
        double asm_time = measure_time((void (*)())findMax, arr, &size);
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        if (size <= 10) {
            printf("Elements: ");
            printArray(arr, size);
            printf("\n");
        }
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    //* test findMin
    printf("3. Find Min Function\n");
    printf("------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        long* arr = test_arrays[i].arr;
        long size = test_arrays[i].size;
        
        long c_result = c_findMin(arr, size);
        long asm_result = findMin(arr, size);
        
        double c_time = measure_time((void (*)())c_findMin, arr, &size);
        double asm_time = measure_time((void (*)())findMin, arr, &size);
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        if (size <= 10) {
            printf("Elements: ");
            printArray(arr, size);
            printf("\n");
        }
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    //* test isEmptyArray
    printf("4. Is Empty Array Function\n");
    printf("------------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        long size = test_arrays[i].size;
        
        int c_result = c_isEmptyArray(size);
        int asm_result = isEmptyArray(size);
        
        double c_time = measure_time((void (*)())c_isEmptyArray, &size, NULL);
        double asm_time = measure_time((void (*)())isEmptyArray, &size, NULL);
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        printf("C Result: %d, ASM Result: %d\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    //* test reverseArray
    printf("5. Reverse Array Function\n");
    printf("-----------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        if (test_arrays[i].size == 0) continue; // Skip empty array
        
        long size = test_arrays[i].size;
        
        // Create copies of the array for C and ASM
        long* c_arr = (long*)malloc(size * sizeof(long));
        long* asm_arr = (long*)malloc(size * sizeof(long));
        memcpy(c_arr, test_arrays[i].arr, size * sizeof(long));
        memcpy(asm_arr, test_arrays[i].arr, size * sizeof(long));
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        if (size <= 10) {
            printf("Original: ");
            printArray(test_arrays[i].arr, size);
            printf("\n");
        }
        
        double c_time = measure_time((void (*)())c_reverseArray, c_arr, &size);
        double asm_time = measure_time((void (*)())reverseArray, asm_arr, &size);
        
        if (size <= 10) {
            printf("C Result: ");
            printArray(c_arr, size);
            printf("\n");
            printf("ASM Result: ");
            printArray(asm_arr, size);
            printf("\n");
        }
        
        //* check if results match
        int match = 1;
        for (long j = 0; j < size; j++) {
            if (c_arr[j] != asm_arr[j]) {
                match = 0;
                break;
            }
        }
        
        printf("Results match: %s\n", match ? "Yes" : "No");
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(c_arr);
        free(asm_arr);
    }
    
    //* test sortArray
    printf("6. Sort Array Function\n");
    printf("--------------------\n");
    for (int i = 0; i < num_arrays; i++) {
        if (test_arrays[i].size == 0) continue; //* skip empty array
        
        long size = test_arrays[i].size;
        
        //* create copies of the array for C and ASM
        long* c_arr = (long*)malloc(size * sizeof(long));
        long* asm_arr = (long*)malloc(size * sizeof(long));
        memcpy(c_arr, test_arrays[i].arr, size * sizeof(long));
        memcpy(asm_arr, test_arrays[i].arr, size * sizeof(long));
        
        printf("Array: %s (size %ld)\n", test_arrays[i].name, size);
        if (size <= 10) {
            printf("Original: ");
            printArray(test_arrays[i].arr, size);
            printf("\n");
        }
        
        double c_time = measure_time((void (*)())c_sortArray, c_arr, &size);
        double asm_time = measure_time((void (*)())sortArray, asm_arr, &size);
        
        if (size <= 10) {
            printf("C Result: ");
            printArray(c_arr, size);
            printf("\n");
            printf("ASM Result: ");
            printArray(asm_arr, size);
            printf("\n");
        }
        
        //* check if results match
        int match = 1;
        for (long j = 0; j < size; j++) {
            if (c_arr[j] != asm_arr[j]) {
                match = 0;
                break;
            }
        }
        
        printf("Results match: %s\n", match ? "Yes" : "No");
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(c_arr);
        free(asm_arr);
    }
    
    printf("===== Array Functions Comparison Complete =====\n");
    
    //* free dynamically allocated arrays
    free(medium_array);
    free(large_array);
    
    return 0;
}
