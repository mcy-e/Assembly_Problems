
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

//* function declarations for assembly functions
extern void reverse_str_asm(const char* input, char* output, int* len);

//* C implementation of string reversal
void reverse_str_c(const char* input, char* output, int* len) {
    int length = strlen(input);
    //* remove newline if present
    if (length > 0 && input[length-1] == '\n') {
        length--;
    }
    
    *len = length;
    
    //*reverse the string
    for (int i = 0; i < length; i++) {
        output[i] = input[length - i - 1];
    }
    output[length] = '\0';
}

//* benchmark function
void benchmark_reverse_str(const char* input, int iterations) {
    struct timeval start, end;
    double c_time_used, asm_time_used;
    char c_output[100], asm_output[100];
    int c_len, asm_len;
    
    //* C implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        reverse_str_c(input, c_output, &c_len);
    }
    gettimeofday(&end, NULL);
    c_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* reset output buffers
    memset(c_output, 0, 100);
    memset(asm_output, 0, 100);
    
    //* ASM implementation
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        reverse_str_asm(input, asm_output, &asm_len);
    }
    gettimeofday(&end, NULL);
    asm_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* Get final results for display
    reverse_str_c(input, c_output, &c_len);
    reverse_str_asm(input, asm_output, &asm_len);
    
    printf("Input: \"%s\"\n", input);
    printf("C Result: \"%s\", Length: %d, Time: %.2f μs\n", c_output, c_len, c_time_used / iterations);
    printf("ASM Result: \"%s\", Length: %d, Time: %.2f μs\n", asm_output, asm_len, asm_time_used / iterations);
    printf("Performance Ratio (C/ASM): %.2f\n\n", c_time_used / asm_time_used);
}

int main() {
    printf("string functions performance comparison : \n\n");
    
    //* test cases for string reverse
    printf("STRING REVERSAL FUNCTION\n");
    printf("------------------------\n");
    benchmark_reverse_str("Hello, World!", 1000000);
    benchmark_reverse_str("Assembly is fun", 1000000);
    benchmark_reverse_str("a", 1000000);
    benchmark_reverse_str("", 1000000);
    benchmark_reverse_str("12345", 1000000);
    
    //* test with longer strings
    printf("\nLONGER STRING TEST\n");
    printf("-----------------\n");
    benchmark_reverse_str("This is a much longer string to test performance with realistic data", 1000000);
    
    return 0;
}