Fib: Fib.o
	ld -o Fib Fib.o
Fib.o: Fib.s
	as -o Fib.o -gstabs Fib.s
E4: E4.o
	ld -o E4 E4.o
E4.o: E4.s
	as -o E4.o -gstabs E4.s
E5: E5.o
	ld -o E5 E5.o
E5.o: E5.s
	as -o E5.o -gstabs E5.s
E6: E6.o
	ld -o E6 E6.o
E6.o: E6.s
	as -o E6.o -gstabs E6.s
E7: E7.o
	ld -o E7 E7.o
E7.o: E7.s
	as -o E7.o -gstabs E7.s
E8: E8.o
	ld -o E8 E8.o
E8.o: E8.s
	as -o E8.o -gstabs E8.s
E9: E9.o
	ld -o E9 E9.o
E9.o: E9.s
	as -o E9.o -gstabs E9.s
clean:
	rm -f Fib Fib.o
	rm -f E4 E4.o
	rm -f E5 E5.o
	rm -f E6 E6.o
	rm -f E7 E7.o
	rm -f E8 E8.o
	rm -f E9 E9.o
Debug:
	./Fib
	./Fib | hexdump
	gdb ./Fib
