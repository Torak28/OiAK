#Hello World

.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0

tekst: .ascii "Hello World\n"
tekst_len = .-tekst

.text
.globl _start

_start:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx
syscall


mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
