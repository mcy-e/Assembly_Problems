
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <cstdint>

//* function declarations for assembly functions
extern void toArray_asm(const char* input, int64_t* array, int* count);
extern void int_to_str_array_asm(int64_t num, char* buffer, int* len);

//* C implementation of string to array 
void toArray_c(const char* input, int64_t* array, int* count) {
    int idx = 0;
    char* temp = strdup(input);  //* make a copy 
    char* token = strtok(temp, " ");//*tokenize  use " " as a delimiter
    
    while (token != NULL && idx < 100) {  //* limit to 100 elements for safety
        array[idx++] = atoll(token);
        token = strtok(NULL, " ");
    }
    
    *count = idx;
    free(temp);
}

//* C implementation of int to str conversion for arrays
void int_to_str_array_c(int64_t num, char* buffer, int* len) {
    char temp[100];
    int i = 0, j = 0;
    int is_negative = 0;
    
    //* handle negatives
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    //* handle 0 as a special case
    if (num == 0) {
        buffer[i++] = '0';
        buffer[i] = '\0';
        *len = i;
        return;
    }
    
    //* convert number to str in reverse 
    while (num > 0) {
        temp[i++] = (num % 10) + '0';
        num /= 10;
    }
    
    //* add negative sign if needed
    if (is_negative) {
        buffer[j++] = '-';
    }
    
    //* copy the temp array to buffer in correct order
    while (i > 0) {
        buffer[j++] = temp[--i];
    }
    
    buffer[j] = '\0';
    *len = j;
}

//* print array function 
void print_array(int64_t* array, int count) {
    printf("[");
    for (int i = 0; i < count; i++) {
        printf("%ld", array[i]);
        if (i < count - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

//* benchmark function for toArray
void benchmark_toArray(const char* input, int iterations) {
    struct timeval start, end;
    double c_time_used, asm_time_used;
    int64_t c_array[100], asm_array[100];
    int c_count, asm_count;
    
    //* benchmark C implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        toArray_c(input, c_array, &c_count);
    }
    gettimeofday(&end, NULL);
    c_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* reset arrays
    memset(c_array, 0, sizeof(c_array));
    memset(asm_array, 0, sizeof(asm_array));
    
    //* benchmark ASM implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        toArray_asm(input, asm_array, &asm_count);
    }
    gettimeofday(&end, NULL);
    asm_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* get final results for display
    toArray_c(input, c_array, &c_count);
    toArray_asm(input, asm_array, &asm_count);
    
    printf("Input: \"%s\"\n", input);
    printf("C Result: "); print_array(c_array, c_count);
    printf("ASM Result: "); print_array(asm_array, asm_count);
    printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time_used / iterations, asm_time_used / iterations);
    printf("Performance Ratio (C/ASM): %.2f\n\n", c_time_used / asm_time_used);
}

//* benchmark function for int_to_str (for arrays)
void benchmark_int_to_str_array(int64_t num, int iterations) {
    struct timeval start, end;
    double c_time_used, asm_time_used;
    char c_buffer[100], asm_buffer[100];
    int c_len, asm_len;
    
    //* benchmark C implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        int_to_str_array_c(num, c_buffer, &c_len);
    }
    gettimeofday(&end, NULL);
    c_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* reset buffers
    memset(c_buffer, 0, 100);
    memset(asm_buffer, 0, 100);
    
    //* benchmark ASM implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        int_to_str_array_asm(num, asm_buffer, &asm_len);
    }
    gettimeofday(&end, NULL);
    asm_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* get final results for display
    int_to_str_array_c(num, c_buffer, &c_len);
    int_to_str_array_asm(num, asm_buffer, &asm_len);
    
    printf("Number: %ld\n", num);
    printf("C Result: \"%s\", Length: %d\n", c_buffer, c_len);
    printf("ASM Result: \"%s\", Length: %d\n", asm_buffer, asm_len);
    printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time_used / iterations, asm_time_used / iterations);
    printf("Performance Ratio (C/ASM): %.2f\n\n", c_time_used / asm_time_used);
}

int main() {
    printf("Array Functions Performance Comparison : \n\n");
    
    //* test cases for toArray function
    printf("STRING TO ARRAY FUNCTION\n");
    printf("-----------------------\n");
    benchmark_toArray("1 2 3 4 5", 100000);
    benchmark_toArray("-10 20 -30 40", 100000);
    benchmark_toArray("123456 -789012", 100000);
    benchmark_toArray("", 100000);
    
    //* test cases for int_to_str function (for arrays)
    printf("\nINTEGER TO STRING FUNCTION (ARRAYS)\n");
    printf("----------------------------------\n");
    benchmark_int_to_str_array(12345, 1000000);
    benchmark_int_to_str_array(-9876, 1000000);
    benchmark_int_to_str_array(1, 1000000);
    benchmark_int_to_str_array(0, 1000000);
    
    return 0;
}