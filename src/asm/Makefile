all:
	avra --listfile main.lst --mapfile main.map main.asm
	../../bin/intel2readmemh main.hex > ../main.mem
clean:
	rm main.mem 2>/dev/null || true 
	rm main.cof main.obj main.map main.lst main.hex main.eep.hex 2>/dev/null || true


