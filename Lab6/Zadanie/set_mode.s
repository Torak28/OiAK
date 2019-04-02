.bss
.comm control, 2

.data
p_pojedyncza: .long 0xFCFF  	
p_podwojna: .long 0x0200


.text
.global set_mode
.type set_mode, @function

set_mode:
	pushq %rbp
        movq %rsp, %rbp

        fstcw control
	fwait

        movl $0 ,%edx
        movw control(,%edx,2), %ax
	/*W %ax jest aktualny control word*/

	cmp $0, %rdi
	je koniec
	jmp dalej

dalej:
	cmp $2, %rdi
	jl pojedyncza
	je podwojna

pojedyncza:
	movw p_pojedyncza(,%edx,2), %cx
	andw %cx, %ax
	movw %ax, control(,%edx,2)

	/*Zapisanie control word*/
	fldcw control
	jmp koniec
podwojna:
	/*Pierw przygotowanie przez AND, patrz readme*/
	movw p_pojedyncza(,%edx,2), %cx
	andw %cx, %ax	
	movw p_podwojna(,%edx,2), %cx
	xorw %cx, %ax
	movw %ax, control(,%edx,2)
	
	/*Zapisanie control word*/
	fldcw control
	jmp koniec

koniec:
      	/*Czyszczenie na początek bo pojawiały mi się tam jakieś liczby*/
	movq $0, %rax
	movq $0, %rdx
	
	/*Odczytanie i przekazanie*/
	fstcw control
	fwait
	mov control, %ax

	popq %rbp
        ret

	
