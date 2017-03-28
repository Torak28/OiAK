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
.comm textout, 512

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
movb text(,%edi,1), %ah #Wczytanie 1 liczby jako min
jmp loop

loop:
	movb text(,%edi,1), %al #Wczytywanie liczby
	cmp %al, %ah
	jge zmiana
	jmp dalej

zmiana:
	movb %al, %ah #Przeniesienie mniejszej do min
	jmp dalej

dalej:
	inc %edi
	cmp %edx, %edi
	jge printf
	jmp loop

#Wypisanie
printf:
mov %ah, %al
mov $0, %ebx
mov %al, textout(, %ebx, 1) #Przepisanie wyniku min
inc %ebx
mov $0xA, %al		    #Koniec linii
mov %al, textout(, %ebx, 1)
inc %ebx

movl %ebx, %edx
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $textout, %ecx
int $0x80

#return 0; w terminologii Assemblera
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
