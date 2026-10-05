	local.get	12
	local.get	20
	v128.load	0:p2align=3
.Ltmp2146:
	.loc	7 57 137 discriminator 8
	local.tee	3
	local.get	3
	local.get	3
	f64x2.mul
	.loc	7 57 215 discriminator 8
	f64x2.add
	v128.store	0:p2align=3
	local.get	12
	i32.const	16
.Ltmp2147:
	.loc	7 54 14 is_stmt 1 discriminator 2
	i32.add 
	local.set	12
	local.get	20
	i32.const	16
	i32.add 
	local.set	20
	local.get	13
	i32.const	2
	i32.add 
	local.set	13
