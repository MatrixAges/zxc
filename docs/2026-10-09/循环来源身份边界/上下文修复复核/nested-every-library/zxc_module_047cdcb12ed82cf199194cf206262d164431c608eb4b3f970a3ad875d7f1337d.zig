const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3 = (try (@import("zxc_module_78cf87f2e8be069d736524e200d7a4e9c318dba56fb7834050ecd92b2b6a6792")).call(allocator, (in).context));

    return block_27: {
        const value_4: []const i64 = (in).items;

        break :block_27 block_26: {
            const operand_11 = block_10: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);
                const operand_4 = true;
                const operand_5 = block_9: {
                    const operand_6 = value_1;

                    break :block_9 block_8: {
                        const operand_7 = (try (allocator).create((zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6));

                        (operand_7).* = @as((zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6, .{ operand_6, });

                        break :block_8 @as(*const (zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6, operand_7);
                    };
                };

                break :block_10 (zx_abi).zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0{ .captures = operand_5, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0 = operand_11;

            while (((((&state_1)).index < @as(u64, (((&state_1)).source).len)) and ((&state_1)).result)) {
                state_1 = block_25: {
                    const value_7: i64 = block_24: {
                        const operand_22 = ((&state_1)).source;
                        const operand_23 = ((&state_1)).index;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };

                    const value_3: *const (zx_abi).zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3 = (((&state_1)).captures).@"0";
                    const value_2: i64 = value_7;
                    const value_8: bool = block_21: {
                        const operand_20 = @as((zx_abi).zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3, block_19: {
                            const operand_17 = value_2;
                            const operand_18 = value_3;

                            break :block_19 .{ operand_17, operand_18, };
                        });

                        break :block_21 (try (@import("zxc_module_432fbde1b5a418d093c2b12d34479328520e91d226b707d1ce325a78a155c8ac")).call(allocator, (&operand_20)));
                    };

                    break :block_25 block_16: {
                        const operand_12 = ((&state_1)).source;
                        const operand_13 = (((&state_1)).index + @as(u64, 1));
                        const operand_14 = value_8;
                        const operand_15 = ((&state_1)).captures;

                        break :block_16 (zx_abi).zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0{ .captures = operand_15, .index = operand_13, .result = operand_14, .source = operand_12, };
                    };
                };
            }

            break :block_26 (state_1).result;
        };
    };
}

