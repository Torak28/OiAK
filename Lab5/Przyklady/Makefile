c: c.o
	ld -o C c.o
c.o: C.s
	as -o c.o -gstabs c.s
clean:
	rm -f c c.o
