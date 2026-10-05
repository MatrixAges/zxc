	ldr	q0, [x12], #16
.Ltmp37182:
	.loc	6 54 14 is_stmt 1 discriminator 2
	sub	x10, x10, #2
.Ltmp37183:
	sub	x9, x9, #2
.Ltmp37184:
	.loc	6 57 137 discriminator 8
	fmul	v1.2d, v0.2d, v0.2d
	.loc	6 57 215 is_stmt 0 discriminator 8
	fadd	v0.2d, v0.2d, v1.2d
	str	q0, [x11], #16
.Ltmp37185:
	.loc	6 54 14 is_stmt 1 discriminator 2
	cbnz	x10, .LBB370_45
.Ltmp37186:
	.loc	6 62 40 discriminator 14
	tbz	w22, #0, .LBB370_50
.Ltmp37187:
.LBB370_49:
	.loc	6 62 40 is_stmt 0 discriminator 2
	ldr	d0, [x23, x8, lsl #3]
.Ltmp37188:
	.loc	6 63 60 is_stmt 1 discriminator 6
	fmul	d1, d0, d0
	.loc	6 63 71 is_stmt 0 discriminator 6
