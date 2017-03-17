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

.text
.globl _start

_start:
#Printf na zmiennych sterujących. Takie ustawienie do działania potrzebne
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $textin, %ecx
movl $BUFLEN, %edx
int $0x80

#W %rax znajduje sie dlugosc naszego tekstu
movl %eax, %edi

#Wypisanie
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $textin, %ecx
movl %edi, %edx
int $0x80

#return 0; w terminologii Assemblera
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
