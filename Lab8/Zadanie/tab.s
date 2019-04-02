	.file	"tab.c"
	.section	.rodata
.LC0:
	.string	"Roznica: %llu\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movl	$0, -72(%rbp)
	jmp	.L2
.L3:
	movl	-72(%rbp), %eax
	cltq
	movl	-72(%rbp), %edx
	movl	%edx, -48(%rbp,%rax,4)
	addl	$1, -72(%rbp)
.L2:
	cmpl	$9, -72(%rbp)
	jle	.L3
	movl	$0, -68(%rbp)
	jmp	.L4
.L5:
	movl	$1, %edi
	call	my_rdtsc
	movq	%rax, -64(%rbp)
	movl	$1, %edi
	call	my_rdtsc
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	subq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -68(%rbp)
.L4:
	cmpl	$9, -68(%rbp)
	jle	.L5
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
