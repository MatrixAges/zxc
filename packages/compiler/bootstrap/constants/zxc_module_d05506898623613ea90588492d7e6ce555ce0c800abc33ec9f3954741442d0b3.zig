const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd) error{ }!f64 {
    @setRuntimeSafety(true);

    if ((in).single) {
        const value_1: f32 = (try (@import("zxc_module_de1a111ed60bf34b9e6e18148d1355e92c7b19e79010c48edcf427c8b06a3bff.zig")).call(allocator, (in).left));
        const value_2: f32 = (try (@import("zxc_module_de1a111ed60bf34b9e6e18148d1355e92c7b19e79010c48edcf427c8b06a3bff.zig")).call(allocator, (in).right));

        const value_3: f32 = block_4: {
            const operand_3 = (in).operator;

            break :block_4 (if ((operand_3 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add))) (value_1 + value_2) else (if ((operand_3 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract))) (value_1 - value_2) else (if ((operand_3 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply))) (value_1 * value_2) else (if ((operand_3 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Divide))) (value_1 / value_2) else @rem(value_1, value_2)))));
        };

        return (try (@import("zxc_module_04380edce0027f58400dc9ef4753debfb5b09edde8c642c348e6e9d41df48589.zig")).call(allocator, value_3));
    }

    return block_2: {
        const operand_1 = (in).operator;

        break :block_2 (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add))) ((in).left + (in).right) else (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract))) ((in).left - (in).right) else (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply))) ((in).left * (in).right) else (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Divide))) ((in).left / (in).right) else @rem((in).left, (in).right)))));
    };
}

