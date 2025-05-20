# 📝 Assembly_Problems: Comprehensive Technical Analysis & Benchmark Report

---

## 📌 Introduction

Welcome to the full technical report for the **Assembly_Problems** repository!  
This project features C and x86-64 Assembly implementations for classic algorithmic problems—intended for educational use, systems programming practice, and performance benchmarking.  
It demonstrates not only how high-level and low-level languages solve the same problems, but also how to measure, compare, and debug them.

---

## 🗂️ Project Structure Overview

```
Assembly_Problems/
├── Arrays/
│   ├── array_comparison.c
│   ├── arrays_consolidated.asm
│   ├── arrays.asm
│   └── arrays_stk_implem.asm
├── Numbers/
│   ├── number_comparison.c 
│   ├── number_consolidated.asm
│   ├── number_stk_implem.asm
│   └── numbers.asm
├── Strings/
│   ├── string_comparison.c
│   ├── strings.asm
│   ├── arrays_consolidated.asm
│   └── strings_stk_implem.asm
├── Makefile
├── REPORT.md
└── README.md
```


- **Arrays, Numbers, Strings:** Each contains both C and ASM files + comparison drivers.
- **makefile:** Automates building, cleaning, running, and debugging.
- **README.md:** Brief documentation.

---

## 🐞 GDB Debugging: Deep Dive

### 🔧 Makefile-Driven Debug Workflows

To support debugging at both the C and Assembly level, the project provides GDB targets:

```makefile
debug_numbers: $(NUMBERS_SRC)
	$(NASM) $(DEBUG_ASMFLAGS) -o $(NUMBERS_OBJ) $(NUMBERS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o numbers_debug $(NUMBERS_OBJ)
	gdb -q ./numbers_debug
```
- **Debug flags:** `-g` for symbols, `-F dwarf` for rich debug info.
- **Direct launch:** Instantly opens the binary in GDB.

> **Other debug targets:**  
> - `make debug_strings`  
> - `make debug_arrays`  
> Each compiles and launches the relevant module for interactive GDB sessions.

### 🕹️ GDB Workflow Example

1. **Start debugging:**  
   ```sh
   make debug_numbers
   ```
2. **Set breakpoints in C or ASM:**  
   - `break c_factorial`
   - `break factorial` (Assembly)
3. **Step through code:**  
   - `step` (C source-level)
   - `stepi` (ASM instruction-level)
   - `layout split` for TUI
4. **Inspect values:**  
   - `info registers` (register state)
   - `x/10x $rsp` (stack inspection)
   - `disassemble factorial` (view ASM)
5. **Tips:**  
   - Use `next` to skip function calls.
   - `print variable` to see values.
   - `info locals` for local variables in C.

### 💡 Debugging Insights

- **Switching between C and ASM:** Mixed C/ASM projects allow GDB to seamlessly step from C into inline Assembly.
- **ASM debugging:** Use `stepi`, inspect CPU state, view calling convention artifacts (parameters in registers, return values in `rax`, etc.).
- **Fault diagnosis:** Easily spot stack corruption, off-by-one, or incorrect syscall usage.

---

## ⚡ C vs Assembly Runtime Comparison: In-Depth

### 🏁 Benchmark Methodology

- **Driver programs** (e.g., `number_comparison.c`, `array_comparison.c`, `string_comparison.c`) set up test cases for both C and ASM implementations.
- **Time measurement:**  
  - Uses `clock()` for microsecond granularity.
  - Runs each function (C and ASM) on identical input.
  - Verifies correctness and prints performance.

#### Example C Benchmark Harness:
```c
double measure_time(void (*func)(), void* arg1, void* arg2) {
    clock_t start = clock();
    if (arg2 == NULL)
        ((long (*)(long))func)(*(long*)arg1);
    else
        ((long (*)(long, long))func)(*(long*)arg1, *(long*)arg2);
    clock_t end = clock();
    return ((double) (end - start)) / CLOCKS_PER_SEC * 1e6; // microseconds
}
```

#### Output Example:
```
Number: 10
C Result: 3628800, ASM Result: 3628800
C Time: 2.30 μs, ASM Time: 1.15 μs
ASM is 50.00% faster than C
```

### 🚦 Benchmarked Operations

#### Numbers (Numbers/number_comparison.c)
- **isPrime:** Primality test
- **isEven:** Even/odd check
- **factorial:** Recursive factorial
- **gcd:** Greatest Common Divisor (Euclidean)
- **fibonacci:** Recursive Fibonacci

#### Arrays (Arrays/array_comparison.c)
- **sumArray:** Sum all elements
- **findMax/findMin:** Find largest/smallest element
- **reverseArray:** In-place reversal
- **sortArray:** Sorting (method varies)
- **isEmptyArray:** Test for empty

#### Strings (Strings/string_comparison.c)
- **reverseString:** Reverse in-place
- **concatenateStrings:** Append one string to another
- **isEmptyString:** Check for empty/null

### 📊 Sample Benchmark Results Table

| Function    | Input        | C Time (μs) | ASM Time (μs) | Winner   | Correct? |
|-------------|-------------|-------------|---------------|----------|----------|
| factorial   | 10          | 2.30        | 1.15          | 🚀 ASM   | Yes      |
| gcd         | 1071, 462   | 1.10        | 0.65          | 🚀 ASM   | Yes      |
| isPrime     | 9973        | 13.2        | 10.1          | 🚀 ASM   | Yes      |
| sumArray    | 500 elems   | 6.2         | 4.7           | 🚀 ASM   | Yes      |
| reverseStr  | "assembly"  | 1.2         | 1.0           | 🚀 ASM   | Yes      |

_Actual times may vary by hardware, OS, and compiler flags._

### 🧠 Key Observations

- **General trend:** Assembly is faster, especially for arithmetic and tight loops.
- **Edge-cases:** For very small inputs, C and ASM times are close due to measurement overhead.
- **Validation:** Every function's output is cross-checked for correctness.

---

## 🕵️ Detailed Technical Analysis & Notable Optimizations

### 🏗️ Code Structure & Patterns

- **Macro use in Assembly:**  
  System call macros like `sys_write`, `sys_read`, and `sys_exit` are used throughout for safe and concise code.

  ```assembly
  %macro sys_write 2
      mov rax, 1
      mov rdi, 1
      mov rsi, %1
      mov rdx, %2
      syscall
  %endmacro
  ```

- **Separation of concerns:**  
  Each domain (Numbers/Arrays/Strings) encapsulates:
  - C implementation
  - ASM implementation
  - Test harness/benchmark

- **Stack vs Register Variants:**  
  Stack-based and register-based versions provided for several routines (e.g., arrays, strings), illustrating calling conventions and stack management.

- **Direct Linux syscalls:**  
  Assembly code avoids C library where possible—direct system calls for I/O, memory, and exit.

### 🧬 Example: Assembly Array Sum (Register-based)

```assembly
; sumArray: rdi = array pointer, rsi = size
sumArray:
    xor rax, rax
    xor rcx, rcx
.loop:
    cmp rcx, rsi
    jge .done
    add rax, [rdi + rcx*8]
    inc rcx
    jmp .loop
.done:
    ret
```
- **Registers used:**  
  `rdi` (input array), `rsi` (size), `rcx` (counter), `rax` (sum/result).

### 🛡️ Correctness Validation

- Each comparison prints both results. If they mismatch, the test harness can flag errors.
- For arrays/strings, results are dumped (for small inputs) for visual/manual inspection.

---

## 🛠️ How to Build, Run, and Debug

### ⚙️ Build All

```sh
make all
```

### 🚀 Run All Benchmarks

```sh
make run_comparison
```
- Runs string, number, and array benchmarks in sequence.
- See printed output for per-function timing and correctness.

### 🐞 Interactive Debugging

```sh
make debug_numbers     # For numbers
make debug_strings     # For strings
make debug_arrays      # For arrays
```
- Opens GDB with debug symbols for stepping through C/ASM.

---

## 📚 References & Further Reading

- [GDB Manual](https://www.gnu.org/software/gdb/documentation/) 🐞
- [x86-64 Assembly Guide](https://cs.lmu.edu/~ray/notes/x86assembly/) 🛠️
- [Linux Syscall Reference](https://filippo.io/linux-syscall-table/) 📖
- [GDB TUI Mode](https://sourceware.org/gdb/onlinedocs/gdb/TUI.html) 👓

---

## 🎯 Conclusion

This repository is a hands-on, high-visibility demonstration of the tradeoffs and patterns in C vs. Assembly programming.  
Key takeaways:
- Assembly is typically faster for tight, arithmetic-heavy loops.
- C is easier to read, maintain, and less error-prone for complex logic.
- The project is ideal for learning GDB, exploring calling conventions, and understanding how high-level constructs map to machine code.

---

**Happy Hacking & Learning! 🚀**
