Fib: Fib.o
	ld -o Fib Fib.o
Fib.o: Fib.s
	as -o Fib.o -gstabs Fib.s
C: C.o
	ld -o C C.o
C.o: C.s
	as -o C.o -gstabs C.s
clean:
	rm -f C C.o
	rm -f Fib Fib.o
