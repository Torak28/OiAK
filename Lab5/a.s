.data
 
.text
.global dodawanie
.type dodawanie, @function

dodawanie:
	push %rbp
    	mov %rsp, %rbp
	
	/* W rejestrze RDI 1 int
    	   W rejestrze RSI znajdzie się 2 int
	   W rejestrze RDX znajduje się 3 int*/

	addq %rdi, %rsi
	movq %rsi, %rax

	mov %rbp, %rsp
   	pop %rbp
ret
	
