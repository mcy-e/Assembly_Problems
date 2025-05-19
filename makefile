# Makefile

NASM = nasm
LD = ld
ASMFLAGS = -f elf64
LDFLAGS = -m elf_x86_64

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

all: numbers strings arrays numbers_stk strings_stk arrays_stk

numbers: $(NUMBERS_SRC)
	$(NASM) $(ASMFLAGS) -o $(NUMBERS_OBJ) $(NUMBERS_SRC)
	$(LD) $(LDFLAGS) -o numbers_exec $(NUMBERS_OBJ)

strings: $(STRINGS_SRC)
	$(NASM) $(ASMFLAGS) -o $(STRINGS_OBJ) $(STRINGS_SRC)
	$(LD) $(LDFLAGS) -o strings_exec $(STRINGS_OBJ)

arrays: $(ARRAYS_SRC)
	$(NASM) $(ASMFLAGS) -o $(ARRAYS_OBJ) $(ARRAYS_SRC)
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
	$(NASM) $(DEBUG_ASMFLAGS) -o $(STRINGS_OBJ) $(STRINGS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o strings_debug $(STRINGS_OBJ)
	gdb -q ./strings_debug

debug_arrays: $(ARRAYS_SRC)
	$(NASM) $(DEBUG_ASMFLAGS) -o $(ARRAYS_OBJ) $(ARRAYS_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o arrays_debug $(ARRAYS_OBJ)
	gdb -q ./arrays_debug



numbers_stk: $(NUMBERS_STK_SRC)
	$(NASM) $(ASMFLAGS) -o $(NUMBERS_STK_OBJ) $(NUMBERS_STK_SRC)
	$(LD) $(LDFLAGS) -o numbers_stk_exec $(NUMBERS_STK_OBJ)

strings_stk: $(STRINGS_STK_SRC)
	$(NASM) $(ASMFLAGS) -o $(STRINGS_STK_OBJ) $(STRINGS_STK_SRC)
	$(LD) $(LDFLAGS) -o strings_stk_exec $(STRINGS_STK_OBJ)

arrays_stk: $(ARRAYS_STK_SRC)
	$(NASM) $(ASMFLAGS) -o $(ARRAYS_STK_OBJ) $(ARRAYS_STK_SRC)
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
	$(NASM) $(DEBUG_ASMFLAGS) -o $(NUMBERS_STK_OBJ) $(NUMBERS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o numbers_stk_debug $(NUMBERS_STK_OBJ)
	gdb -q ./numbers_stk_debug

debug_strings_stk: $(STRINGS_STK_SRC)
	$(NASM) $(DEBUG_ASMFLAGS) -o $(STRINGS_STK_OBJ) $(STRINGS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o strings_stk_debug $(STRINGS_STK_OBJ)
	gdb -q ./strings_stk_debug

debug_arrays_stk: $(ARRAYS_STK_SRC)
	$(NASM) $(DEBUG_ASMFLAGS) -o $(ARRAYS_STK_OBJ) $(ARRAYS_STK_SRC)
	$(LD) $(DEBUG_LDFLAGS) -o arrays_stk_debug $(ARRAYS_STK_OBJ)
	gdb -q ./arrays_stk_debug


# Add to clean
clean:
	rm -f Numbers/*.o Strings/*.o Arrays/*.o numbers_exec strings_exec arrays_exec \numbers_debug strings_debug arrays_debug numbers_stk_exec strings_stk_exec arrays_stk_exec \numbers_stk_debug strings_stk_debug arrays_stk_debug 