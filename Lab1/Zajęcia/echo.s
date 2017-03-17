.data
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BUFOR = 512

.bss
.comm wpisane, 512

.text
.global _start
_start:
	#Wczytanie do pliczku
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $wpisane, %ecx
	mov $BUFOR, %edx
	int $0x80

	#W %eax znajduje sie dlugosc naszego tekstu
	mov %eax, %edi

	#Wypisanie naszego Imputu
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $wpisane, %ecx
	mov %edi, %edx
	int $0x80

	#Cos w stylu return 0
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80
