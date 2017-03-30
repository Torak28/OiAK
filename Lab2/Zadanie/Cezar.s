#Wypisuje wpisany przez użytkownika tekst

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
.comm textin, 512
.comm textout, 512

.text
tekst: .ascii "\n"
tekst_len = .-tekst

.globl _start

_start:
#Printf na zmiennych sterujących. Takie ustawienie do działania potrzebne
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $textin, %ecx
movl $BUFLEN, %edx
int $0x80

#W %rax znajduje sie dlugosc naszego tekstu
decl %eax
movl %eax, %edx
movl $0, %edi

jmp loop

loop:
	movb textin(,%edi,1), %bl
	addb $0x2, %bl
	movb %bl, textout(,%edi,1)
	inc %edi
	cmp %edx, %edi
	jle loop
	jmp printf

#Wypisanie
printf:
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $textout, %ecx
int $0x80

movl $SYSWRITE, %eax	#Dopisanie znaku nowej linii
movl $STDOUT, %ebx
movl $tekst, %ecx
movl $tekst_len, %edx
int $0x80

#return 0; w terminologii Assemblera
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
