Ltmp33342:
	.loc	6 57 40 discriminator 4
	je	LBB398_75
Ltmp33343:
	.loc	6 57 118 discriminator 8
	vmovupd	ymm0, ymmword ptr [r12 + rdx]
Ltmp33344:
	.loc	6 57 137 discriminator 8
	vmulpd	ymm1, ymm0, ymm0
	.loc	6 57 215 discriminator 8
	vaddpd	ymm0, ymm0, ymm1
	vmovupd	ymmword ptr [r15 + rdx], ymm0
Ltmp33345:
	.loc	6 54 14 is_stmt 1 discriminator 2
	add	rdx, 32
Ltmp33346:
	cmp	r8, rdx
	jne	LBB398_47
Ltmp33347:
LBB398_50:
	.loc	6 62 40 discriminator 14
	mov	rcx, r14
	and	rcx, 3
	je	LBB398_57
Ltmp33348:
	.loc	6 0 40 is_stmt 0
