#Wypisuje wpisany przez użytkownika tekst odwrotnie

#Sekacja zmiennych sterujących pracą. Takie stałe procesorowe
.data
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm text, 512

.text
.globl _start

_start:
#Printf na zmiennych sterujących. Takie ustawienie do działania potrzebne
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $text, %ecx
movl $BUFLEN, %edx
int $0x80

mov $0, %edi	#licznik do przodu
mov %eax, %edx	#W eax jest ilość wprowadzonych znaków
dec %edx	#Teraz od ilści znaków odejmujemy 1 - odejmujemy nową linie
dec %edx
jmp loop

loop:
	movb text(,%edi,1), %al #Wczytywanie znaków od początku
	movb text(,%edx,1), %ah	#Wczytywanie znaków od końca
	movb %al, text(,%edx,1) #Zamiana kolejnosci
	movb %ah, text(,%edi,1)
	inc %edi
	dec %edx
	cmp %edx, %edi
	jge printf
	jmp loop

#Wypisanie
printf:
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $text, %ecx
movl $BUFLEN, %edx
int $0x80

#return 0; w terminologii Assemblera
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
