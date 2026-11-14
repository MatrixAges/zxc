const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a) error{ OutOfMemory, }!(zx_abi).value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: bool = ((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual)));

    const value_2: bool = block_9: {
        const operand_8 = in;

        break :block_9 switch (operand_8) { @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less) => true, @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual) => true, @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater) => true, else => (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .GreaterEqual))) true else false), };
    };

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

        break :block_7 @as((zx_abi).value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26, (zx_abi).value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26{ .logical = operand_1, .comparison = operand_2, .equality = operand_5, });
    };
}
