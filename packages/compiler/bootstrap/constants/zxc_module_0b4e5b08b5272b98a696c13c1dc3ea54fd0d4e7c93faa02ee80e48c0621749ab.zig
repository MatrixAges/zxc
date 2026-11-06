const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a) error{ OutOfMemory, }!(zx_abi).value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: bool = ((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual)));

    return block_8: {
        const value_2: bool = ((((!(!(in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less)))) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual))) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .GreaterEqual)));

        break :block_8 block_7: {
            const operand_1 = ((in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd)) or (in == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalOr)));

            const operand_2 = (block_3: {
                break :block_3 value_1;
            } or block_4: {
                break :block_4 value_2;
            });

            const operand_5 = block_6: {
                break :block_6 value_1;
            };

            break :block_7 @as((zx_abi).value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74, (zx_abi).value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74{ .logical = operand_1, .comparison = operand_2, .equality = operand_5, });
        };
    };
}

