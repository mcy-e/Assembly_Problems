#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// Assembly function declarations
extern int isPrime(long num);
extern int isEven(long num);
extern long factorial(long num);
extern long gcd(long a, long b);
extern long fibonacci(long n);

// C implementations for comparison
int c_isPrime(long num) {
    if (num <= 1) return 0;
    if (num == 2) return 1;
    if (num % 2 == 0) return 0;
    
    for (long i = 3; i * i <= num; i += 2) {
        if (num % i == 0) return 0;
    }
    
    return 1;
}

int c_isEven(long num) {
    return num % 2 == 0;
}

long c_factorial(long num) {
    if (num <= 0) return 1;
    
    long result = 1;
    for (long i = 1; i <= num; i++) {
        result *= i;
    }
    
    return result;
}

long c_gcd(long a, long b) {
    while (b != 0) {
        long temp = b;
        b = a % b;
        a = temp;
    }
    
    return a;
}

long c_fibonacci(long n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    
    long a = 0, b = 1, result;
    for (long i = 2; i <= n; i++) {
        result = a + b;
        a = b;
        b = result;
    }
    
    return b;
}

// Function to measure execution time
double measure_time(void (*func)(), void* arg1, void* arg2) {
    clock_t start, end;
    start = clock();
    
    // Call the function with appropriate arguments
    if (arg2 == NULL) {
        ((long (*)(long))func)(*(long*)arg1);
    } else {
        ((long (*)(long, long))func)(*(long*)arg1, *(long*)arg2);
    }
    
    end = clock();
    return ((double) (end - start)) / CLOCKS_PER_SEC * 1000000; // Convert to microseconds
}

int main() {
    printf("===== Number Functions Comparison: C vs Assembly =====\n\n");
    
    // Test isPrime
    printf("1. Is Prime Function\n");
    printf("------------------\n");
    long prime_tests[] = {0, 1, 2, 3, 4, 7, 13, 17, 20, 97, 100, 9973};
    int num_prime_tests = sizeof(prime_tests) / sizeof(prime_tests[0]);
    
    for (int i = 0; i < num_prime_tests; i++) {
        long num = prime_tests[i];
        
        int c_result = c_isPrime(num);
        int asm_result = isPrime(num);
        
        double c_time = measure_time((void (*)())c_isPrime, &num, NULL);
        double asm_time = measure_time((void (*)())isPrime, &num, NULL);
        
        printf("Number: %ld\n", num);
        printf("C Result: %d, ASM Result: %d\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    // Test isEven
    printf("2. Is Even Function\n");
    printf("------------------\n");
    long even_tests[] = {0, 1, 2, 3, 4, 7, 10, 15, 20, 99, 100};
    int num_even_tests = sizeof(even_tests) / sizeof(even_tests[0]);
    
    for (int i = 0; i < num_even_tests; i++) {
        long num = even_tests[i];
        
        int c_result = c_isEven(num);
        int asm_result = isEven(num);
        
        double c_time = measure_time((void (*)())c_isEven, &num, NULL);
        double asm_time = measure_time((void (*)())isEven, &num, NULL);
        
        printf("Number: %ld\n", num);
        printf("C Result: %d, ASM Result: %d\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    // Test factorial
    printf("3. Factorial Function\n");
    printf("--------------------\n");
    long factorial_tests[] = {0, 1, 2, 3, 4, 5, 10, 12};
    int num_factorial_tests = sizeof(factorial_tests) / sizeof(factorial_tests[0]);
    
    for (int i = 0; i < num_factorial_tests; i++) {
        long num = factorial_tests[i];
        
        long c_result = c_factorial(num);
        long asm_result = factorial(num);
        
        double c_time = measure_time((void (*)())c_factorial, &num, NULL);
        double asm_time = measure_time((void (*)())factorial, &num, NULL);
        
        printf("Number: %ld\n", num);
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    // Test GCD
    printf("4. GCD Function\n");
    printf("--------------\n");
    struct {
        long a;
        long b;
    } gcd_tests[] = {
        {0, 0}, {1, 1}, {12, 8}, {48, 18}, {1071, 462}, {128, 96}, {17, 13}
    };
    int num_gcd_tests = sizeof(gcd_tests) / sizeof(gcd_tests[0]);
    
    for (int i = 0; i < num_gcd_tests; i++) {
        long a = gcd_tests[i].a;
        long b = gcd_tests[i].b;
        
        long c_result = c_gcd(a, b);
        long asm_result = gcd(a, b);
        
        double c_time = measure_time((void (*)())c_gcd, &a, &b);
        double asm_time = measure_time((void (*)())gcd, &a, &b);
        
        printf("Numbers: %ld, %ld\n", a, b);
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    // Test Fibonacci
    printf("5. Fibonacci Function\n");
    printf("--------------------\n");
    long fibonacci_tests[] = {0, 1, 2, 3, 5, 10, 15, 20, 25, 30};
    int num_fibonacci_tests = sizeof(fibonacci_tests) / sizeof(fibonacci_tests[0]);
    
    for (int i = 0; i < num_fibonacci_tests; i++) {
        long n = fibonacci_tests[i];
        
        long c_result = c_fibonacci(n);
        long asm_result = fibonacci(n);
        
        double c_time = measure_time((void (*)())c_fibonacci, &n, NULL);
        double asm_time = measure_time((void (*)())fibonacci, &n, NULL);
        
        printf("N: %ld\n", n);
        printf("C Result: %ld, ASM Result: %ld\n", c_result, asm_result);
        printf("C Time: %.2f μs, ASM Time: %.2f μs\n", c_time, asm_time);
        printf("ASM is %.2f%% %s than C\n\n", 
               fabs(c_time - asm_time) / c_time * 100,
               asm_time < c_time ? "faster" : "slower");
    }
    
    printf("===== Number Functions Comparison Complete =====\n");
    
    return 0;
}
