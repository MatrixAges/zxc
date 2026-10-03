const std = @import("std");
const runtime = @import("zx_runtime");

const zx_type_11 = struct {
    discount: u64,
    free_shipping_minimum: u64,
    shipping_fee: u64,
    subtotal: u64,
};

const zx_type_12 = struct {
    payable: u64,
    shipping: u64,
};

pub const Input = zx_type_11;
pub const Output = zx_type_12;

pub fn execute(arena: *(runtime).Arena, in: zx_type_11) anyerror!zx_type_12 {
    @setRuntimeSafety(true);

    _ = arena;

    const value_1: u64 = (if (((in).discount > (in).subtotal)) (in).subtotal else (in).discount);
    const value_2: u64 = ((in).subtotal - value_1);
    const value_3: u64 = (if ((value_2 >= (in).free_shipping_minimum)) @as(u64, 0) else (in).shipping_fee);

    return block_3: {
        const operand_1 = value_3;
        const operand_2 = (value_2 + value_3);

        break :block_3 zx_type_12{ .shipping = operand_1, .payable = operand_2, };
    };
}

