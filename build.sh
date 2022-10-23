#!/bin/bash
set -xe

nasm -fbin -o build/boot.bin src/boot/boot.asm
i686-elf-gcc -c src/kernel/kernel.c -Wall -Wextra -O2 -ffreestanding -std=gnu99 -o build/kernel.o
i686-elf-ld -o build/kernel.bin build/kernel.o --oformat binary
dd if=/dev/zero of=build/garb.img bs=512 count=2880
dd if=build/boot.bin of=build/garb.img conv=notrunc seek=0 count=1
dd if=build/kernel.bin of=build/garb.img bs=512 count=1 seek=1
