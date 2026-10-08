const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28d2fa0fb1227bf8e5cc5dd840df0fe27094506db43348afe42fcbe1a1b0f786) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5 = (try (@import("zxc_module_78cf87f2e8be069d736524e200d7a4e9c318dba56fb7834050ecd92b2b6a6792")).call(allocator, (in).context));

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
                        const operand_7 = (try (allocator).create((zx_abi).zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794));

                        (operand_7).* = @as((zx_abi).zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794, .{ operand_6, });

                        break :block_8 @as(*const (zx_abi).zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794, operand_7);
                    };
                };

                break :block_10 (zx_abi).zx_type_af5ae80593a768c07197707e440c9b73a0c955dcf841059d506589fa216f80a8{ .captures = operand_5, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).zx_type_af5ae80593a768c07197707e440c9b73a0c955dcf841059d506589fa216f80a8 = operand_11;

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

                    const value_3: *const (zx_abi).zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5 = (((&state_1)).captures).@"0";
                    const value_2: i64 = value_7;
                    const value_8: bool = block_21: {
                        const operand_20 = @as((zx_abi).zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e, block_19: {
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

                        break :block_16 (zx_abi).zx_type_af5ae80593a768c07197707e440c9b73a0c955dcf841059d506589fa216f80a8{ .captures = operand_15, .index = operand_13, .result = operand_14, .source = operand_12, };
                    };
                };
            }

            break :block_26 (state_1).result;
        };
    };
}

