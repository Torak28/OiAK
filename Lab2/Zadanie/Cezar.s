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
	movb $0x41, %al
	cmp %al, %bl			#Duze A - 65
	jge litera
	jmp nic
litera:
	movb $0x5a, %al
	cmp %al, %bl			#Duze Z - 90
	jle duza_litera
	movb $0x61, %al
	cmp %al, %bl			#Male a - 97
	jge m_mala_litera
	jmp nic
duza_litera:
	#KOD
	movb $0x58, %al
	cmp %al, %bl			#X
	je X
	movb $0x59, %al
	cmp %al, %bl			#Y
	je Y
	movb $0x5a, %al
	cmp %al, %bl			#Z
	je Z
	addb $0x2, %bl
	movb %bl, textout(,%edi,1)
	jmp dalej
X:
	movb $0x5a, textout(,%edi,1)
	jmp dalej
Y:
	movb $0x41, textout(,%edi,1)
	jmp dalej
Z:
	movb $0x42, textout(,%edi,1)
	jmp dalej
m_mala_litera:
	movb $0x7a, %al
	cmp %al, %bl			#Male z - 122
	jle mala_litera
	jmp nic
mala_litera:
	#KOD
	movb $0x78, %al
	cmp %al, %bl
	je MX
	movb $0x79, %al
	cmp %al, %bl
	je MY
	movb $0x7a, %al
	cmp %al, %bl
	je MZ
	addb $0x2, %bl
	movb %bl, textout(,%edi,1)
	jmp dalej
MX:
	movb $0x7a, textout(,%edi,1)
	jmp dalej
MY:
	movb $0x61, textout(,%edi,1)
	jmp dalej
MZ:
	movb $0x62, textout(,%edi,1)
	jmp dalej
nic:
	movb $0x20, textout(,%edi,1)
	jmp dalej
dalej:
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
