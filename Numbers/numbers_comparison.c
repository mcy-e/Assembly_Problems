
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <cstdint>

//* function declarations for assembly functions
extern int64_t reverse_asm(int64_t num);
extern char* int_to_str_asm(int64_t num, char* buffer);

//* C implementation of reverse number
int64_t reverse_c(int64_t num) {
    int64_t reversed = 0;
    int is_negative = 0;
    
    // Handle negative numbers
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    // Reverse the digits
    while (num > 0) {
        reversed = reversed * 10 + (num % 10);
        num /= 10;
    }
    
    // Apply sign if needed
    if (is_negative) {
        reversed = -reversed;
    }
    
    return reversed;
}

//* C implementation of integer to string conversion
char* int_to_str_c(int64_t num, char* buffer) {
    int i = 0, j = 0;
    int is_negative = 0;
    char temp[100];
    
    // Handle negative numbers
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    // Handle 0 as a special case
    if (num == 0) {
        buffer[i++] = '0';
        buffer[i] = '\0';
        return buffer;
    }
    
    // Convert number to string in reverse order
    while (num > 0) {
        temp[i++] = (num % 10) + '0';
        num /= 10;
    }
    
    // Add negative sign if needed
    if (is_negative) {
        buffer[j++] = '-';
    }
    
    // Copy the temp array to buffer in correct order
    while (i > 0) {
        buffer[j++] = temp[--i];
    }
    
    buffer[j] = '\0';
    return buffer;
}

//* benchmark functions to calculate time difference
void benchmark_reverse(int64_t num, int iterations) {
    struct timeval start, end;
    double c_time_used, asm_time_used;
    int64_t c_result, asm_result;
    
    //* C implementation run time used
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        c_result = reverse_c(num);
    }
    gettimeofday(&end, NULL);
    c_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* ASM implementation run time used
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        asm_result = reverse_asm(num);
    }
    gettimeofday(&end, NULL);
    asm_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    printf("Number: %ld\n", num);
    printf("C Result: %ld, Time: %.2f μs\n", c_result, c_time_used / iterations);
    printf("ASM Result: %ld, Time: %.2f μs\n", asm_result, asm_time_used / iterations);
    printf("Performance Ratio (C/ASM): %.2f\n\n", c_time_used / asm_time_used);
}

void benchmark_int_to_str(int64_t num, int iterations) {
    struct timeval start, end;
    double c_time_used, asm_time_used;
    char c_buffer[100], asm_buffer[100];
    
    //* C implementation run time used  
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        int_to_str_c(num, c_buffer);
    }
    gettimeofday(&end, NULL);
    c_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    //* reset buffers
    memset(c_buffer, 0, 100);
    memset(asm_buffer, 0, 100);
    
    //* ASM implementation run time used
    gettimeofday(&start, NULL);
    for (int i = 0; i < iterations; i++) {
        int_to_str_asm(num, asm_buffer);
    }
    gettimeofday(&end, NULL);
    asm_time_used = (end.tv_sec - start.tv_sec) * 1000000.0 + (end.tv_usec - start.tv_usec);
    
    printf("Number: %ld\n", num);
    int_to_str_c(num, c_buffer);
    int_to_str_asm(num, asm_buffer);
    printf("C Result: %s, Time: %.2f μs\n", c_buffer, c_time_used / iterations);
    printf("ASM Result: %s, Time: %.2f μs\n", asm_buffer, asm_time_used / iterations);
    printf("Performance Ratio (C/ASM): %.2f\n\n", c_time_used / asm_time_used);
}

int main() {
    printf("numbers functions performance comparison :\n\n");
    
    //* test cases for reverse 
    printf("REVERSE NUMBER FUNCTION\n");
    printf("------------------------\n");
    benchmark_reverse(12345, 1000000);
    benchmark_reverse(-9876, 1000000);
    benchmark_reverse(1, 1000000);
    benchmark_reverse(0, 1000000);
    
    //* test cases for int_to_str
    printf("\nINTEGER TO STRING FUNCTION\n");
    printf("--------------------------\n");
    benchmark_int_to_str(12345, 1000000);
    benchmark_int_to_str(-9876, 1000000);
    benchmark_int_to_str(1, 1000000);
    benchmark_int_to_str(0, 1000000);
    
    return 0;
}