#Wypisuje wpisany przez użytkownika tekst

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
.comm textin, 512

.text
.globl _start

_start:
#Printf na zmiennych sterujących. Takie ustawienie do działania potrzebne
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

#W %rax znajduje sie dlugosc naszego tekstu
movq %rax, %rbx

#Wypisanie
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textin, %rsi
movq %rbx, %rdx
syscall

#return 0; w terminologii Assemblera
koniec: mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
