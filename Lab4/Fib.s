.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFF = 16
N_INDEX = 5
#N_INDEX = 1 to zwykłe dodawanie i to działa super
#48 dziala

/*
Dla N = 100 powinno być:
100110011001111011011011101101010011111000101100101001011111111000011
A jest:
     0011001111011011011101101010011111000101100101001011111111000011
Końcówka jest dobra ale ucina tył :c
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
	movl $N_INDEX, %r11d
	dec %r11d
	movq $0, %rax
	movq $0, %rbx
	movl $0, %r10d
	movq $16, %r12
	movq $0, %rdx
	jmp ladowanie

ladowanie:
	/*128 jako zmienna*/
	movl %r12d, %esi
	movl %r12d, %edi
	movq $2, pierwsza(,%esi,1)
	movq $5, druga(,%esi,1)	
	lea pierwsza, %r13
	lea druga, %r14
	addq %r12, %r13
	addq %r12, %r14
	jmp ciag_fib

ladowanie2:
	movl %r12d, %esi
	movl %r12d, %edi
	lea pierwsza, %r13
	lea druga, %r14
	addq %r12, %r13
	addq %r12, %r14

	/*movq %r13, %r15
	movq %r14, %r13
	movq %r15, %r14
	movq $0, %r15*/	

	jmp ciag_fib

ciag_fib:
	/*Gubie drugą liczbę :c*/
	/*Przy drugim są dobre wartości ale są odwrotnie*/
	/*Przy trzecim wejsciu po next rbx ma poprzednią liczbę a nie ta którą potrzebuje*/
	movq (%r13), %rax
	movq (%r14), %rbx
	adcq %rbx, %rax
	movq %rax, (%r13)
	movq %rbx, (%r14)	
	/*
	Zamieniam r13 i r14 miejscami
	*/
	cmp %rax, %rbx
	jle pierwsza_wieksza
	jmp druga_wieksza


druga_wieksza:
	movq %rbx, wynik(,%r12,1)
	#inc %edi
	jmp ciag_fib_dalej

pierwsza_wieksza:
	
	movq %rax, wynik(,%r12,1)
	#inc %edi
	jmp ciag_fib_dalej

ciag_fib_dalej:
	cmp %rdx, %r12
	jle next
	/*16 przeskakuje za daleko, 8 nie pomaga :c*/
	subq $8, %r12
	jmp ladowanie2

next:
	movq $128, %r12
	inc %r10d
	cmp %r10d, %r11d
	jle wypisz
	jmp ladowanie2
		
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

	jmp koniec
	
koniec:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx	
	int $0x80

