# Makefile
CC =gcc
ASM = nasm
LD = ld
ASMFLAGS = -f elf64
LDFLAGS = -m elf_x86_64
CFLAGS = -g -Wall -no-pie
NUMBERS_SRC = Numbers/number.asm
STRINGS_SRC = Strings/strings.asm
ARRAYS_SRC = Arrays/arrays.asm

NUMBERS_OBJ = Numbers/number.o
STRINGS_OBJ = Strings/string.o
ARRAYS_OBJ = Arrays/array.o

NUMBERS_STK_SRC = Numbers/numbers_stk_implem.asm
STRINGS_STK_SRC = Strings/strings_stk_implem.asm
ARRAYS_STK_SRC = Arrays/arrays_stk_implem.asm

NUMBERS_STK_OBJ = Numbers/numbers_stk_implem.asm.o
STRINGS_STK_OBJ = Strings/strings_stk_implem.o
ARRAYS_STK_OBJ = Arrays/arrays_stk_implem.o

SRC_DIR = .
OBJ_DIR = obj
BIN_DIR = bin
STRINGS_DIR = Strings
NUMBERS_DIR = Numbers
ARRAYS_DIR = Arrays




all: numbers strings arrays numbers_stk strings_stk arrays_stk

is_prime:

	$(ASM) $(ASMFLAGS) -o Numbers/isPrime.o Numbers/isPrime.asm
	$(LD) $(LDFLAGS) -o isPrime_exec Numbers/isPrime.o

is_even:
	$(ASM) $(ASMFLAGS) -o Numbers/EvenOdd.o Numbers/EvenOdd.asm 
	$(LD) $(LDFLAGS) -o EvenOdd_exec Numbers/EvenOdd.o

string_length:
	$(ASM) $(ASMFLAGS) -o Strings/stringLength.o Strings/stringLength.asm
	$(LD) $(LDFLAGS) -o strLen_exec Strings/stringLength.o

is_empty_string:
	$(ASM) $(ASMFLAGS) -o Strings/isEmptyString.o Strings/isEmptyString.asm
	$(LD) $(LDFLAGS) -o isEmptyString_exec Strings/isEmptyString.o

sum_array:
	$(ASM) $(ASMFLAGS) -o Arrays/sumArray.o Arrays/sumArray.asm
	$(LD) $(LDFLAGS) -o sumArray_exec Arrays/sumArray.o
is_empty_array:
	$(ASM) $(ASMFLAGS) -o Arrays/isEmptyArray.o Arrays/isEmptyArray.asm
	$(LD) $(LDFLAGS) -o isEmpty_exec Arrays/isEmptyArray.o

numbers: $(NUMBERS_SRC)
	$(ASM) $(ASMFLAGS) -o $(NUMBERS_OBJ) $(NUMBERS_SRC)
	$(LD) $(LDFLAGS) -o numbers_exec $(NUMBERS_OBJ)

strings: $(STRINGS_SRC)
	$(ASM) $(ASMFLAGS) -o $(STRINGS_OBJ) $(STRINGS_SRC)
	$(LD) $(LDFLAGS) -o strings_exec $(STRINGS_OBJ)

arrays: $(ARRAYS_SRC)
	$(ASM) $(ASMFLAGS) -o $(ARRAYS_OBJ) $(ARRAYS_SRC)
	$(LD) $(LDFLAGS) -o arrays_exec $(ARRAYS_OBJ)
	
run_numbers: numbers
	./numbers_exec

run_strings: strings
	./strings_exec

run_arrays: arrays
	./arrays_exec

DEBUG_ASMFLAGS = $(ASMFLAGS) -g -F dwarf
DEBUG_LDFLAGS = $(LDFLAGS) -g

debug_numbers: $(NUMBERS_SRC)
	$(NASM) $(DEBUG_ASMFLAGS) -o $(NUMBERS_OBJ) $(NUMBERS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o numbers_debug $(NUMBERS_OBJ)
	gdb -q ./numbers_debug

debug_strings: $(STRINGS_SRC)
	$(ASM) $(DEBUG_ASMFLAGS) -o $(STRINGS_OBJ) $(STRINGS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o strings_debug $(STRINGS_OBJ)
	gdb -q ./strings_debug

debug_arrays: $(ARRAYS_SRC)
	$(ASM) $(DEBUG_ASMFLAGS) -o $(ARRAYS_OBJ) $(ARRAYS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o arrays_debug $(ARRAYS_OBJ)
	gdb -q ./arrays_debug



numbers_stk: $(NUMBERS_STK_SRC)
	$(ASM) $(ASMFLAGS) -o $(NUMBERS_STK_OBJ) $(NUMBERS_STK_SRC)
	$(LD) $(LDFLAGS) -o numbers_stk_exec $(NUMBERS_STK_OBJ)

strings_stk: $(STRINGS_STK_SRC)
	$(ASM) $(ASMFLAGS) -o $(STRINGS_STK_OBJ) $(STRINGS_STK_SRC)
	$(LD) $(LDFLAGS) -o strings_stk_exec $(STRINGS_STK_OBJ)

arrays_stk: $(ARRAYS_STK_SRC)
	$(ASM) $(ASMFLAGS) -o $(ARRAYS_STK_OBJ) $(ARRAYS_STK_SRC)
	$(LD) $(LDFLAGS) -o arrays_stk_exec $(ARRAYS_STK_OBJ)
	
run_numbers_stk: numbers
	./numbers_stk_exec

run_strings_stk: strings
	./strings_stk_exec

run_arrays_stk: arrays
	./arrays_stk_exec


DEBUG_ASMFLAGS = $(ASMFLAGS) -g -F dwarf
DEBUG_LDFLAGS = $(LDFLAGS) -g

debug_numbers_stk: $(NUMBERS_STK_SRC)
	$(ASM) $(DEBUG_ASMFLAGS) -o $(NUMBERS_STK_OBJ) $(NUMBERS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o numbers_stk_debug $(NUMBERS_STK_OBJ)
	gdb -q ./numbers_stk_debug

debug_strings_stk: $(STRINGS_STK_SRC)
	$(ASM) $(DEBUG_ASMFLAGS) -o $(STRINGS_STK_OBJ) $(STRINGS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o strings_stk_debug $(STRINGS_STK_OBJ)
	gdb -q ./strings_stk_debug

debug_arrays_stk: $(ARRAYS_STK_SRC)
	$(ASM) $(DEBUG_ASMFLAGS) -o $(ARRAYS_STK_OBJ) $(ARRAYS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o arrays_stk_debug $(ARRAYS_STK_OBJ)
	gdb -q ./arrays_stk_debug


# String test (original target)
string_test: $(OBJ_DIR)/string_test.o $(OBJ_DIR)/string.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $^

$(OBJ_DIR)/string_test.o: $(STRINGS_DIR)/string_test.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/string.o: $(STRINGS_DIR)/string.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Number test (original target)
number_test: $(OBJ_DIR)/number_test.o $(OBJ_DIR)/number.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $^

$(OBJ_DIR)/number_test.o: $(NUMBERS_DIR)/number_test.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/number.o: $(NUMBERS_DIR)/number.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# New targets for comparison tests
comparison: string_comparison number_comparison array_comparison

# String comparison
string_comparison: $(OBJ_DIR)/string_comparison.o $(OBJ_DIR)/strings_consolidated.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $^ -lm

$(OBJ_DIR)/string_comparison.o: $(STRINGS_DIR)/string_comparison.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/strings_consolidated.o: $(STRINGS_DIR)/strings_consolidated.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Number comparison
number_comparison: $(OBJ_DIR)/number_comparison.o $(OBJ_DIR)/numbers_consolidated.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $^ -lm

$(OBJ_DIR)/number_comparison.o: $(NUMBERS_DIR)/number_comparison.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/numbers_consolidated.o: $(NUMBERS_DIR)/numbers_consolidated.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Array comparison
array_comparison: $(OBJ_DIR)/array_comparison.o $(OBJ_DIR)/arrays_consolidated.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $^ -lm

$(OBJ_DIR)/array_comparison.o: $(ARRAYS_DIR)/array_comparison.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/arrays_consolidated.o: $(ARRAYS_DIR)/arrays_consolidated.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Run all comparison tests
run_comparison: comparison
	$(BIN_DIR)/string_comparison
	$(BIN_DIR)/number_comparison
	$(BIN_DIR)/array_comparison



# Add to clean
clean:
	rm -f Numbers/*.o Strings/*.o Arrays/*.o numbers_exec strings_exec arrays_exec \numbers_debug strings_debug arrays_debug numbers_stk_exec strings_stk_exec arrays_stk_exec \numbers_stk_debug strings_stk_debug arrays_stk_debug $(OBJ_DIR)/* $(BIN_DIR)/* *_exec 