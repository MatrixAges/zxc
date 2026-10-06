	.build_version macos, 26, 1
	.section	__TEXT,__text,regular,pure_instructions
	.intel_syntax noprefix
	.p2align	4
l_scalar_assembly.hasContent:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	test	rsi, rsi
	je	LBB0_5
	xor	eax, eax
	movabs	rcx, 4294977024
	.p2align	4
LBB0_2:
	movzx	r8d, byte ptr [rdi + rax]
	mov	dl, 1
	cmp	r8, 32
	ja	LBB0_6
	bt	rcx, r8
	jae	LBB0_6
	inc	rax
	cmp	rsi, rax
	jne	LBB0_2
LBB0_5:
	xor	edx, edx
LBB0_6:
	movzx	eax, dl
	pop	rbp
	ret
	.cfi_endproc

.zerofill __DATA,__bss,l_c.dummy_execute_header,32,2
	.globl	_hasContent
_hasContent = l_scalar_assembly.hasContent
	.weak_reference __mh_execute_header
__mh_execute_header = l_c.dummy_execute_header
.subsections_via_symbols
