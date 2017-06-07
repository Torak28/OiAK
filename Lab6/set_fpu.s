.bss
.comm control, 2

.data
p_pojedyncza: .long 0xFCFF  	
p_podwojna: .long 0x0200
p_rozszerzona: .long 0x0300
r_najblizsza: .long 0xF3FF
r_zero: .long 0x0C00
r_dol_o: .long 0x0400
r_dol_a: .long 0xF7FF
r_gora_o: .long 0x0800
r_gora_a: .long 0xFBFF


.text
.global set_fpu
.type set_fpu, @function

set_fpu:
	pushq %rbp
        movq %rsp, %rbp

        fstcw control

        movl $0 ,%edx
        movw control(,%edx,2), %ax
	/*W %ax jest aktualny control word*/

	cmp $0, %rdi
	je Spr_zaokrag
	jmp dalej

dalej:
	cmp $2, %rdi
	jl pojedyncza
	je podwojna
	jg rozszerzona

pojedyncza:
	movw p_pojedyncza(,%edx,2), %cx
	andw %cx, %ax
	movw %ax, control(,%edx,2)

	/*Zapisanie control word*/
	fldcw control
	jmp Spr_zaokrag
podwojna:
	/*Pierw przygotowanie przez AND, patrz readme*/
	movw p_pojedyncza(,%edx,2), %cx
	andw %cx, %ax
	movw p_podwojna(,%edx,2), %cx
	xorw %cx, %ax
	movw %ax, control(,%edx,2)
	
	/*Zapisanie control word*/
	fldcw control
	jmp Spr_zaokrag
rozszerzona:
	/*Pierw przygotowanie przez AND, patrz readme*/
	movw p_pojedyncza(,%edx,2), %cx
	andw %cx, %ax
	movw p_rozszerzona(,%edx,2), %cx
	xorw %cx, %ax
	movw %ax, control(,%edx,2)
	
	/*Zapisanie control word*/
	fldcw control
	jmp Spr_zaokrag

Spr_zaokrag:
	cmp $3, %rsi
	jl zaokrag
	je zero
	jg koniec

zaokrag:
	cmp $1, %rsi
	jl najblizsza
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
	popq %rbp
        ret

	
