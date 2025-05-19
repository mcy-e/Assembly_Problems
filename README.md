# 🛠️ Assembly_Problems

Welcome to **Assembly_Problems** — a hands-on repository for exploring classic algorithmic problems implemented in both C and x86-64 Assembly. This project is ideal for students, educators, and systems enthusiasts interested in understanding low-level programming, performance benchmarking, and debugging with GDB.

---

## 📂 Project Structure

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

- **Arrays, Numbers, Strings:** Each folder contains both C and Assembly implementations, plus benchmarking drivers.
- **makefile:** Automates building, cleaning, debugging, and running benchmarks.

---

## 🚀 Quick Start

### 1. Build All Binaries

```bash
make all
```

### 2. Run All Benchmarks

```bash
make run_comparison
```
This will run performance comparisons for number, array, and string routines, printing C vs Assembly results.

### 3. Debug with GDB

```bash
make debug_numbers    # For number routines
make debug_arrays     # For array routines
make debug_strings    # For string routines
```
The above commands build with debug symbols and launch GDB for interactive inspection.

---

## 🔍 What’s Inside?

- **Algorithms Implemented (in C & ASM):**
  - Numbers: isPrime, isEven, factorial, gcd, fibonacci, etc.
  - Arrays: sum, findMax, findMin, reverse, sort, isEmpty, etc.
  - Strings: reverseString, concatenateStrings, isEmptyString, etc.

- **Performance Benchmarks:**  
  Each driver compares runtime between C and Assembly implementations, showing how low-level optimizations affect speed.

- **GDB-Ready:**  
  Easily debug any module at source or assembly level using automated make targets.

- **Learning Focus:**  
  See how calling conventions, stack vs register usage, and system calls work in real assembly programs.

---

## 📊 Detailed Report

For a comprehensive technical analysis, benchmarking results, GDB usage walkthroughs, and deep dives into optimizations, see:

👉 [REPORT.md](./REPORT.md)

---

## 🤝 Contributing

Contributions and improvements are welcome! Fork the repo, make your changes, and open a pull request.

---

## 📚 References

- [GDB Documentation](https://www.gnu.org/software/gdb/documentation/)
- [x86-64 Assembly Guide](https://cs.lmu.edu/~ray/notes/x86assembly/)
- [Linux Syscall Reference](https://filippo.io/linux-syscall-table/)

---

**Happy Hacking & Learning! 🚀**
