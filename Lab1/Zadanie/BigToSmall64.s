#Wypisuje wpisany przez użytkownika tekst zamieniajac duze litery na male i male na duze

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
.comm textout, 512

.text
tekst: .ascii "\n"
tekst_len = .-tekst
.globl _start

_start:
#Scanf
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

#W %rax znajduje sie dlugosc naszego tekstu
movq %rax, %r8

#Zerowanie licznika pętli
movq $0, %rdi
jmp loop

loop:
movb textin(, %rdi, 1), %al
xor $0x20, %al
movb %al, textout(, %rdi, 1)
inc %rdi			#Zwiekszenie licznika petli
cmp %r8, %rdi			#Porównanie czy juz przeszlismy wszystkie
jle loop
jmp printf

#Wypisanie
printf:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq %r8, %rdx
syscall

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx
syscall

#return 0; w terminologii Assemblera
koniec: mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
