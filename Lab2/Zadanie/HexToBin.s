#Heks na Bin

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
movl $4, %r8d
movl $0, %edi
movl $0, %esi

jmp sprawdzanie_int_chr

sprawdzanie_int_chr:
	movb textin(,%edi,1), %al
	subb $64, %al
	movl $0, %ebx
	movl $4, %ecx
	jge pre_chr
	jmp pre_int

pre_chr:
	addb $9, %al
	jmp bin
pre_int:
	addb $16, %al
	jmp bin

bin:
	cmp %ebx, %ecx
	je zamiana
	shrb $1, %al
	jc jedynka
	jmp zero
	
jedynka:
	movb $'1', textout(,%esi,1)
	inc %esi
	inc %ebx
	jmp bin
zero:
	movb $'0', textout(,%esi,1)
	inc %esi
	inc %ebx
	jmp bin

zamiana:
	mov $0, %edi
	mov %r8d, %edx
	dec %edx
	jmp odwracanie

odwracanie:
	movb textout(,%edi,1), %al
	movb textout(,%edx,1), %ah
	movb %al, textout(,%edx,1)
	movb %ah, textout(,%edi,1)
	inc %edi
	dec %edx
	cmp %edx, %edi	
	jge wypisanie
	jmp odwracanie

wypisanie:
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $textout, %ecx
	movl %r8d, %edx
	int $0x80

	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $tekst, %ecx
	movl $tekst_len, %edx
	int $0x80

mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
