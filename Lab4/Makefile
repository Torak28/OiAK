Fib: Fib.o
	ld -o Fib Fib.o
Fib.o: Fib.s
	as -o Fib.o -gstabs Fib.s
E6: E6.o
	ld -o E6 E6.o
E6.o: E6.s
	as -o E6.o -gstabs E6.s
clean:
	rm -f Fib Fib.o
	rm -f E6 E6.o
