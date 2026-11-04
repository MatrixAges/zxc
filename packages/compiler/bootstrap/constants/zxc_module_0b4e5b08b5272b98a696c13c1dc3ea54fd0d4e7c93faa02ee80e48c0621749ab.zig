const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a) error{ OutOfMemory, }!(zx_abi).value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: bool = ((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual)));
    const value_2: bool = ((((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual))) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .GreaterEqual)));

    return block_7: {
        const operand_1 = ((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalOr)));

        const operand_2 = (block_3: {
            break :block_3 value_1;
        } or block_4: {
            break :block_4 value_2;
        });

        const operand_5 = block_6: {
            break :block_6 value_1;
        };

        break :block_7 @as((zx_abi).value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123, (zx_abi).value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123{ .logical = operand_1, .comparison = operand_2, .equality = operand_5, });
    };
}

