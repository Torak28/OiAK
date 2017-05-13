.data
STDOUT = 1
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
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
	movl $12, %r11d
	movl $0, %r10d
	movl $0, %esi
	movl $0, %edi
	movl $0, pierwsza(,%esi,1)
	movl $1, druga(,%esi,1)	
	lea pierwsza, %r13
	lea druga, %r14
	jmp ciag_fib

ciag_fib:
	movq (%r13), %rax
	movq (%r14), %rbx
	addq %rbx, %rax
	movq %rax, (%r13)
	movq %rbx, (%r14)
	/*
	Zamieniam r13 i r14 miejscami
	*/
	movq %r13, %r15
	movq %r14, %r13
	movq %r15, %r14
	movq $0, %r15
	cmp %rax, %rbx
	jle druga_wieksza
	jmp pierwsza_wieksza

druga_wieksza:
	movq %rbx, wynik(,%edi,1)
	inc %edi
	jmp ciag_fib_dalej

pierwsza_wieksza:
	movq %rax, wynik(,%edi,1)
	inc %edi
	jmp ciag_fib_dalej

ciag_fib_dalej:
	inc %r10d
	cmp %r10d, %r11d
	jle koniec
	jmp ciag_fib
			
koniec:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx	
	int $0x80

