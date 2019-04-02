.bss
.comm control, 2

.data
r_najblizsza: .long 0xF3FF
r_zero: .long 0x0C00
r_dol_o: .long 0x0400
r_dol_a: .long 0xF7FF
r_gora_o: .long 0x0800
r_gora_a: .long 0xFBFF


.text
.global set_round
.type set_round, @function

set_round:
	pushq %rbp
        movq %rsp, %rbp

        fstcw control
	fwait

	movq $0, %rax
        movl $0 ,%edx
        movw control(,%edx,2), %ax
	/*W %ax jest aktualny control word*/

	jmp Spr_zaokrag	

Spr_zaokrag:
	cmp $3, %rdi
	jl zaokrag
	je zero
	jg najblizsza

zaokrag:
	cmp $1, %rdi
	jl koniec
	je dol
	jg gora
		
zero:
	movw r_zero(,%edx,2), %cx
       	orw %cx, %ax
	movw %ax, control(,%edx,2)
        
	/*Zapisanie control word*/
	fldcw control
	jmp koniec

najblizsza:
	movw r_najblizsza(,%edx,2), %cx
       	andw %cx, %ax
	movw %ax, control(,%edx,2)
        
	/*Zapisanie control word*/
	fldcw control
	jmp koniec

dol:
	movw r_dol_o(,%edx,2), %cx
       	orw %cx, %ax
	movw r_dol_a(,%edx,2), %cx
       	andw %cx, %ax
	movw %ax, control(,%edx,2)
        
	/*Zapisanie control word*/
	fldcw control
	jmp koniec

gora:
	movw r_gora_o(,%edx,2), %cx
       	orw %cx, %ax
	movw r_gora_a(,%edx,2), %cx
       	andw %cx, %ax
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

