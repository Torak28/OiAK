.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFF = 16
N_INDEX = 200


format_d: .asciz "%lld",
nowa_linia: .asciz "\n"

.bss
.comm pierwsza, 1024
.comm druga, 1024
.comm wynik, 1024
.comm BE, 1024

.text
.globl main
main:
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
	movq $1016, %r12
	movq $0, %rcx
	movq $0, %r8
	movq $128, %r9
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
	popf
	adcq %rbx, %rax
	pushf
	movq %rax, (%r13)
	movq %rbx, (%r14)	
	jmp zapisz_wynik

zapisz_wynik:
	movq %rax, wynik(,%edi,1)
	jmp zapisz_BE

zapisz_BE:	
	movq $0, %rcx
	
	movb %al, %cl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 XXXXXXXX
	shlq $56, %rcx	#XXXXXXXX 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 YYYYYYYY
	shlq $56, %rbx	#YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rbx	#00000000 YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 ZZZZZZZZ
	shlq $56, %rbx	#ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $16, %rbx	#00000000 00000000 ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 CCCCCCCC
	shlq $56, %rbx	#CCCCCCCC 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $24, %rbx	#00000000 00000000 00000000 CCCCCCCC 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 VVVVVVVV
	shlq $56, %rbx	#VVVVVVVV 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $32, %rbx	#00000000 00000000 00000000 00000000 VVVVVVVV 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 BBBBBBBB
	shlq $56, %rbx	#BBBBBBBB 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $40, %rbx	#00000000 00000000 00000000 00000000 00000000 BBBBBBBB 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 NNNNNNNN
	shlq $56, %rbx	#NNNNNNNN 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $48, %rbx	#00000000 00000000 00000000 00000000 00000000 00000000 NNNNNNNN 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB NNNNNNNN 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 MMMMMMMM
	shlq $56, %rbx	#MMMMMMMM 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $56, %rbx	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 MMMMMMMM
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB NNNNNNNN MMMMMMMM
	
	movq $0, %rbx
	movq %rcx, %rbx	
	movq %rbx, BE(,%edi,1)
	jmp ciag_fib_dalej

ciag_fib_dalej:
	inc %r8
	subq $8, %r12
	cmp %r8, %r9
	je nastepna
	jmp ladowanie

nastepna:
	movq $0, %r8
	movq $1016, %r12
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
	lea wynik, %r12
	movq $0, %r13
	movq $63, %r14
	jmp petla_wypisujaca

petla_wypisujaca:
	/*movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq %r12, %rsi
	movq $BUFF, %rdx
	syscall*/
	
	inc %r13
	addq $16, %r12
	cmp %r13, %r14
	jge petla_wypisujaca
	jmp wypiszBE
	
wypiszBE:
	lea BE, %r12
	movq $0, %r13
	movq $63, %r14
	jmp petla_wypisujacaBE

petla_wypisujacaBE:
	/*movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq %r12, %rsi
	movq $BUFF, %rdx
	syscall*/
	
	movq (%r12), %rsi
	mov $0, %rax
	mov $format_d, %rdi
	call printf
	
	inc %r13
	addq $16, %r12
	cmp %r13, %r14
	jge petla_wypisujacaBE
	jmp koniec

koniec:
	mov $0, %rax 
	mov $nowa_linia, %rdi 	
	call printf	


	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx	
	int $0x80

