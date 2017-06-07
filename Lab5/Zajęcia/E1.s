.data
 
.text
.global my_rdtsc
.type my_rdtsc, @function

my_rdtsc:
	push %rbp		
    	mov %rsp, %rbp
	
	/* W rejestrze RDI 1 char*/

	movq %rdi, %rax

	mov %rbp, %rsp
   	pop %rbp
ret
