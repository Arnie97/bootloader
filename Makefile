main.img: main.asm
	nasm -f bin -o main.img main.asm
	# qemu main.img
