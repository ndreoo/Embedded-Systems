default: main.elf

main.o: main.c
	riscv64-unknown-elf-gcc -c -g -O0 -ffreestanding -march=rv32i -mabi=ilp32 -o main.o main.c

start.o: start.s
	riscv64-unknown-elf-as -g -march=rv32i -mabi=ilp32 -o start.o start.s

main.elf: main.o start.o baremetal.ld
	riscv64-unknown-elf-ld -T baremetal.ld -m elf32lriscv -o main.elf main.o start.o

run: main.elf
	spike main.elf

clean:
	rm -f main.o start.o main.elf asm_routine.o
