exe: hello.o
	ld -o exe hello.o
hello.o: hello.s
	as -o hello.o hello.s
echo: echo.o
	ld -o echo echo.o
echo.o: echo.s
	as -o echo.o echo.s
clean:
	rm -f exe hello.o echo echo.o
