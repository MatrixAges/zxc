Ltmp33488:
	.loc	45 1277 41
	cmp	r15, r12
Ltmp33489:
	.loc	45 0 41
	jae	LBB397_61
Ltmp33490:
	.p2align	4
LBB397_59:
	movapd	xmm0, xmm1
	mulsd	xmm0, xmm1
	addsd	xmm0, xmm1
Ltmp33491:
	.loc	45 905 13 is_stmt 1
	movsd	qword ptr [rsi + 8*r15], xmm0
Ltmp33492:
	.loc	45 0 13 is_stmt 0
	mov	r15, rbx
Ltmp33493:
	.loc	6 53 14 is_stmt 1 discriminator 4
	cmp	rbx, r13
	jne	LBB397_32
Ltmp33494:
	.loc	6 0 14 is_stmt 0
	xor	r15d, r15d
Ltmp33495:
	.loc	61 557 11 is_stmt 1 discriminator 6
	test	r15b, r15b
