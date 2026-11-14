const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521) error{ }!f64 {
    @setRuntimeSafety(true);

    if ((in).single) {
        const value_1: f32 = (try (@import("zxc_module_c337801a26634b95120fd4f5026d0bc71036a0fca26e47fde33c315fdfdfb552.zig")).call(allocator, (in).left));
        const value_2: f32 = (try (@import("zxc_module_c337801a26634b95120fd4f5026d0bc71036a0fca26e47fde33c315fdfdfb552.zig")).call(allocator, (in).right));

        const value_3: f32 = block_15: {
            const operand_4 = (in).operator;

            break :block_15 switch (operand_4) { @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add) => (block_13: {
                break :block_13 value_1;
            } + block_14: {
                break :block_14 value_2;
            }), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract) => (block_11: {
                break :block_11 value_1;
            } - block_12: {
                break :block_12 value_2;
            }), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply) => (block_9: {
                break :block_9 value_1;
            } * block_10: {
                break :block_10 value_2;
            }), else => (if ((operand_4 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Divide))) (block_7: {
                break :block_7 value_1;
            } / block_8: {
                break :block_8 value_2;
            }) else @rem(block_5: {
                break :block_5 value_1;
            }, block_6: {
                break :block_6 value_2;
            })), };
        };

        return (try (@import("zxc_module_a072f1f93e9051e35be723849a793eb264a3aa8ed873405b14ff6aca9c198cd7.zig")).call(allocator, block_3: {
            break :block_3 value_3;
        }));
    }

    return block_2: {
        const operand_1 = (in).operator;

        break :block_2 switch (operand_1) { @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add) => ((in).left + (in).right), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract) => ((in).left - (in).right), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply) => ((in).left * (in).right), else => (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Divide))) ((in).left / (in).right) else @rem((in).left, (in).right)), };
    };
}
