	.file	"GDT.cpp"
	.text
	.align 4
	.globl	_ZN6system14discriptor_setEjmmhh
	.type	_ZN6system14discriptor_setEjmmhh, @function
_ZN6system14discriptor_setEjmmhh:
.LFB0:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	16(%esp), %eax
	movl	20(%esp), %ecx
	movl	24(%esp), %edi
	movw	$0, _ZN6system7GDT_ptrE
	leal	(%eax,%eax,8), %eax
	leal	_ZN6system11GDT_entriesE(%eax), %ebx
	movw	%cx, _ZN6system11GDT_entriesE+2(%eax)
	movl	%ecx, %esi
	shrl	$16, %esi
	movl	%esi, %edx
	movb	%dl, _ZN6system11GDT_entriesE+4(%eax)
	shrl	$24, %ecx
	movb	%cl, _ZN6system11GDT_entriesE+8(%eax)
	movw	%di, _ZN6system11GDT_entriesE(%eax)
	movl	%edi, %edx
	shrl	$16, %edx
	andl	$15, %edx
	movl	28(%esp), %ecx
	movb	%cl, _ZN6system11GDT_entriesE+5(%eax)
	movzbl	32(%esp), %eax
	sall	$4, %eax
	orl	%eax, %edx
	movw	%dx, 6(%ebx)
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE0:
	.size	_ZN6system14discriptor_setEjmmhh, .-_ZN6system14discriptor_setEjmmhh
	.align 4
	.globl	_ZN6system8GDT_initEv
	.type	_ZN6system8GDT_initEv, @function
_ZN6system8GDT_initEv:
.LFB1:
	.cfi_startproc
	movl	$_ZN6system11GDT_entriesE, _ZN6system7GDT_ptrE+2
	movw	$0, _ZN6system7GDT_ptrE
	movw	$0, _ZN6system11GDT_entriesE+2
	movb	$0, _ZN6system11GDT_entriesE+4
	movb	$0, _ZN6system11GDT_entriesE+8
	movw	$0, _ZN6system11GDT_entriesE
	movw	$0, _ZN6system11GDT_entriesE+6
	movb	$0, _ZN6system11GDT_entriesE+5
	movw	$0, _ZN6system11GDT_entriesE+11
	movb	$0, _ZN6system11GDT_entriesE+13
	movb	$0, _ZN6system11GDT_entriesE+17
	movw	$-1, _ZN6system11GDT_entriesE+9
	movb	$-102, _ZN6system11GDT_entriesE+14
	movw	$207, _ZN6system11GDT_entriesE+15
	jmp	GDT_flush
	.cfi_endproc
.LFE1:
	.size	_ZN6system8GDT_initEv, .-_ZN6system8GDT_initEv
	.globl	_ZN6system7GDT_ptrE
	.section	.bss
	.type	_ZN6system7GDT_ptrE, @object
	.size	_ZN6system7GDT_ptrE, 6
_ZN6system7GDT_ptrE:
	.zero	6
	.globl	_ZN6system11GDT_entriesE
	.type	_ZN6system11GDT_entriesE, @object
	.size	_ZN6system11GDT_entriesE, 27
_ZN6system11GDT_entriesE:
	.zero	27
	.ident	"GCC: (GNU) 4.7.2"
