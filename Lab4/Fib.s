.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFF = 16
N_INDEX = 200
# 92 bangla
# dla 93 juz nie :c

/*
E9 jako zawór bezpieczeństwa dla tego Naszego projektu!
*/

.bss
.comm textin, 512
.comm textout,512
.comm wejscie, 512
.comm pierwsza, 1024
.comm druga, 1024
.comm wynik, 1024

.text
.globl _start
_start:
	/*
	r11d - liczba n
	r10d - aktualne n
	*/
	pushf
	movl $N_INDEX, %r11d
	dec %r11d
	movq $0, %rax
	movq $0, %rbx
	movl $0, %r10d
	movq $128, %r12
	movq $0, %r8
	movq $17, %r9
	movq $8, %rdx
	movl $0, pierwsza(,%r12,1)
	movl $1, druga(,%r12,1)
	lea pierwsza, %r13
	lea druga, %r14
	addq %r12, %r13
	addq %r12, %r14
	movl %r12d, %esi
	movl %r12d, %edi
	jmp ciag_fib

ladowanie:
	movl %r12d, %esi
	movl %r12d, %edi
	subq %rdx, %r13
	subq %rdx, %r14
	jmp ciag_fib

ciag_fib:
	movq (%r13), %rax
	movq (%r14), %rbx
	jmp ciag_fib2

ciag_fib2:
	popf
	adcq %rbx, %rax
	pushf
	movq %rax, (%r13)
	movq %rbx, (%r14)	
	/*
	Zamieniam r13 i r14 miejscami
	*/
	cmp %rax, %rbx
	jle pierwsza_wieksza
	jmp druga_wieksza

druga_wieksza:
	movq %rbx, wynik(,%edi,1)
	jmp ciag_fib_dalej

pierwsza_wieksza:
	
	movq %rax, wynik(,%edi,1)
	jmp ciag_fib_dalej

ciag_fib_dalej:
	inc %r8
	subq $8, %r12
	cmp %r8, %r9
	je nastepna
	jmp ladowanie

nastepna:
	movq $0, %r8
	movq $128, %r12
	inc %r10d
	movq %r13, %r15
	movq %r14, %r13
	movq %r15, %r14
	movq $0, %r15
	cmp %r10d, %r11d
	jle wypisz	
	jmp dalej

dalej:
	addq %r12, %r13
	addq %r12, %r14
	movl %r12d, %esi
	movl %r12d, %edi
	jmp ciag_fib
	
	



wypisz:
	/*Bardzo łopatologicznie, lepiej by było z lea ale to się zrobi potem*/
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+16, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+32, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+48, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+64, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+80, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+88, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+104, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+120, %rsi
	movq $BUFF, %rdx
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $wynik+136, %rsi
	movq $BUFF, %rdx
	syscall

	jmp koniec
	
koniec:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx	
	int $0x80

