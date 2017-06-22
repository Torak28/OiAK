.data
 
.text
.global my_rdtsc
.type my_rdtsc, @function

my_rdtsc:
	push %rbp		
    	mov %rsp, %rbp
	
	/* W rejestrze RDI 1 char
	   W RAX ma byc wynik operacji*/

	movq $0, %r8
	cmp %rdi, %r8
	je zero
	jl wiecej
	jg mniej

zero:
	xor %eax, %eax
	cpuid
	rdtsc
	shlq $32, %rdx
	orq %rdx, %rax
	jmp koniec

wiecej:
	movq $0, %rax
	cpuid
	rdtscp
	shlq $32, %rdx
	orq %rdx, %rax
	jmp koniec

mniej:
	jmp koniec
	
koniec:
	mov %rbp, %rsp
   	pop %rbp
ret
