.data
STDOUT = 1
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

.text
tekst: .ascii "Witaj Swiecie!\n"
tekst_len = .-tekst

.global _start
_start:
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $tekst, %ecx
movl $tekst_len, %edx
int $0x80

mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
