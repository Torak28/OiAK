#Wypisuje wpisany przez użytkownika tekst odwrotnie

#Sekacja zmiennych sterujących pracą. Takie stałe procesorowe
.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm text, 512

.text
.globl _start

_start:
#Printf na zmiennych sterujących. Takie ustawienie do działania potrzebne
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $text, %rsi
movq $BUFLEN, %rdx
syscall

mov $0, %rdi	#licznik do przodu
mov %rax, %rdx	#W eax jest ilość wprowadzonych znaków
dec %rdx	#Teraz od ilści znaków odejmujemy 1 - odejmujemy nową linie
dec %rdx
jmp loop

loop:
	movb text(,%rdi,1), %al #Wczytywanie znaków od początku
	movb text(,%rdx,1), %ah	#Wczytywanie znaków od końca
	movb %al, text(,%rdx,1) #Zamiana kolejnosci
	movb %ah, text(,%rdi,1)
	inc %rdi
	dec %rdx
	cmp %rdx, %rdi
	jge printf
	jmp loop

#Wypisanie
printf:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $text, %rsi
movq $BUFLEN, %rdx
syscall

#return 0; w terminologii Assemblera
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
