	.loc	6 57 40 discriminator 4
	je	LBB397_71
Ltmp33425:
	.loc	6 57 118 discriminator 8
	movupd	xmm0, xmmword ptr [r14 + rdx]
Ltmp33426:
	.loc	6 57 137 discriminator 8
	movapd	xmm1, xmm0
	mulpd	xmm1, xmm0
	.loc	6 57 215 discriminator 8
	addpd	xmm1, xmm0
	movupd	xmmword ptr [r15 + rdx], xmm1
Ltmp33427:
	.loc	6 54 14 is_stmt 1 discriminator 2
	add	rdx, 16
Ltmp33428:
	cmp	r12, rdx
	jne	LBB397_31
Ltmp33429:
	.loc	6 62 40 discriminator 14
	test	bl, 1
Ltmp33430:
	je	LBB397_36
Ltmp33431:
LBB397_35:
	.loc	6 62 40 is_stmt 0 discriminator 2
