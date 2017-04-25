HexToBin: HexToBin.o
	ld -o HexToBin HexToBin.o
HexToBin.o: HexToBin.s
	as -o HexToBin.o HexToBin.s
v1: v1.o
	ld -o v1 v1.o
v1.o: v1.s
	as -o v1.o v1.s
v2: v2.o
	ld -o v2 v2.o
v2.o: v2.s
	as -o v2.o v2.s
clean:
	rm -f HexToBin HexToBin.o
	rm -f v1 v1.o
	rm -f v2 v2.o
