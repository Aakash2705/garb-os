#!/bin/bash
set -xe

nasm -fbin -o build/boot.bin src/boot/boot.asm
nasm -fbin -o build/kernel.bin src/kernel/kernel.asm
dd if=/dev/zero of=build/garb.img bs=512 count=2880
dd if=build/boot.bin of=build/garb.img conv=notrunc seek=0 count=1
dd if=build/kernel.bin of=build/garb.img bs=512 count=1 seek=1
