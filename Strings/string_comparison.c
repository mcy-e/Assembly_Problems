#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>  

//* Assembly function declarations
extern int stringLength(const char* str);
extern int isEmptyString(const char* str);
extern void reverseString(char* str);
extern void concatenateStrings(char* dest, const char* src);

//* C implementations for comparison
int c_stringLength(const char* str) {
    int len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}

int c_isEmptyString(const char* str) {
    return str[0] == '\0';
}

void c_reverseString(char* str) {
    int len = strlen(str);
    int i, j;
    char temp;
    
    for (i = 0, j = len - 1; i < j; i++, j--) {
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
    }
}

void c_concatenateStrings(char* dest, const char* src) {
    int i = 0;
    int j = 0;
    
    //* find the end of dest
    while (dest[i] != '\0') {
        i++;
    }
    
    //* copy src to the end of dest
    while (src[j] != '\0') {
        dest[i++] = src[j++];
    }
    
    dest[i] = '\0';
}

//* function to measure time
double measure_time(void (*func)(), void* arg1, void* arg2) {
    clock_t start, end;
    start = clock();
    
    //* call the function with appropriate args
    if (arg2 == NULL) {
        ((void (*)(void*))func)(arg1);
    } else {
        ((void (*)(void*, void*))func)(arg1, arg2);
    }
    
    end = clock();
    return ((double) (end - start)) / CLOCKS_PER_SEC * 1000000; //* xconvert to microseconds
}

int main() {
    printf("============================================================");
    printf("===== String Functions Comparison: C vs Assembly =====\n\n");
    
    //* test strings
    char* test_strings[] = {
        "",
        "Hello",
        "Hello, World!",
        "This is a longer string to test performance differences"
    };
    int num_strings = sizeof(test_strings) / sizeof(test_strings[0]);
    
    //* test stringLength
    printf("1. String Length Function\n");
    printf("------------------------\n");
    for (int i = 0; i < num_strings; i++) {
        char* str = strdup(test_strings[i]);
        
        int c_result = c_stringLength(str);
        int asm_result = stringLength(str);
        
        double c_time = measure_time((void (*)())c_stringLength, str, NULL);
        double asm_time = measure_time((void (*)())stringLength, str, NULL);
        
        printf("String: \"%s\"\n", str);
        printf("C Result: %d, ASM Result: %d\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(str);
    }
    
    //* test isEmptyString
    printf("2. Is Empty String Function\n");
    printf("--------------------------\n");
    for (int i = 0; i < num_strings; i++) {
        char* str = strdup(test_strings[i]);
        
        int c_result = c_isEmptyString(str);
        int asm_result = isEmptyString(str);
        
        double c_time = measure_time((void (*)())c_isEmptyString, str, NULL);
        double asm_time = measure_time((void (*)())isEmptyString, str, NULL);
        
        printf("String: \"%s\"\n", str);
        printf("C Result: %d, ASM Result: %d\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(str);
    }
    
    //* test reverseString
    printf("3. Reverse String Function\n");
    printf("-------------------------\n");
    for (int i = 0; i < num_strings; i++) {
        char* c_str = strdup(test_strings[i]);
        char* asm_str = strdup(test_strings[i]);
        
        printf("Original String: \"%s\"\n", test_strings[i]);
        
        double c_time = measure_time((void (*)())c_reverseString, c_str, NULL);
        double asm_time = measure_time((void (*)())reverseString, asm_str, NULL);
        
        printf("C Result: \"%s\", ASM Result: \"%s\"\n", c_str, asm_str);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(c_str);
        free(asm_str);
    }
    
    //* test concatenateStrings
    printf("4. Concatenate Strings Function\n");
    printf("------------------------------\n");
    char* append_str = " - Appended Text";
    
    for (int i = 0; i < num_strings; i++) {
        //* allocate enough space for concatenation
        char* c_str = (char*)malloc(strlen(test_strings[i]) + strlen(append_str) + 1);
        char* asm_str = (char*)malloc(strlen(test_strings[i]) + strlen(append_str) + 1);
        
        strcpy(c_str, test_strings[i]);
        strcpy(asm_str, test_strings[i]);
        
        printf("Original String: \"%s\", Append: \"%s\"\n", test_strings[i], append_str);
        
        double c_time = measure_time((void (*)())c_concatenateStrings, c_str, (void*)append_str);
        double asm_time = measure_time((void (*)())concatenateStrings, asm_str, (void*)append_str);
        
        printf("C Result: \"%s\", ASM Result: \"%s\"\n", c_str, asm_str);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
        
        free(c_str);
        free(asm_str);
    }
    
    printf("===== String Functions Comparison Complete =====\n");
    
    return 0;
}