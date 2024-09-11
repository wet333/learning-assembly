nasm -f elf64 -g -F dwarf sum.asm -o sum.o && ld sum.o -o sum && rm sum.o
