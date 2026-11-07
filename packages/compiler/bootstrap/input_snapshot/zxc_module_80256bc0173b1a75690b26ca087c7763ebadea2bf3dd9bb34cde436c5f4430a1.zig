const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    return block_20: {
        const value_10: (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = block_19: {
            const operand_17 = @as(u64, 0);
            const operand_18 = true;

            break :block_19 (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31{
                .index = operand_17,
                .valid = operand_18,
            };
        };

        const value_11: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048 = in;

        break :block_20 block_16: {
            break :block_16 block_15: {
                const operand_2 = ((&value_10)).*;
                var state_1: (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = operand_2;

                while (block_4: {
                    const value_2: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048 = value_11;

                    break :block_4 (((&state_1)).valid and (((&state_1)).index < @as(u64, (((value_2).current).paths).len)));
                }) {
                    state_1 = block_14: {
                        const value_4: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048 = value_11;

                        break :block_14 block_13: {
                            const value_5: (zx_abi).zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99 = block_12: {
                                const operand_7 = (value_4).current;
                                const operand_8 = ((value_4).previous).files;
                                const operand_9 = ((&state_1)).index;
                                const operand_10 = (value_4).now_high;
                                const operand_11 = (value_4).now_low;

                                break :block_12 (zx_abi).zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99{
                                    .current = operand_7,
                                    .previous = operand_8,
                                    .index = operand_9,
                                    .now_high = operand_10,
                                    .now_low = operand_11,
                                };
                            };
                            const value_6: (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = block_6: {
                                break :block_6 (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31{
                                    .index = ((&state_1)).index,
                                    .valid = ((try (@import("zxc_module_d974ecc0cf9f4ffc064a4fa73fd35c6a36cbe9fd417743680672b7f8e36cdd55.zig")).call(allocator, (&value_5))) and (try (@import("zxc_module_709f79f1107b3c306f084d392dd0c423e1e9e17fc064b875afcd008d0f054c61.zig")).call(allocator, (&value_5)))),
                                };
                            };

                            const value_7: u64 = ((&value_6)).index;

                            const value_8: (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = block_5: {
                                break :block_5 (zx_abi).zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31{
                                    .index = (value_7 + @as(u64, 1)),
                                    .valid = ((&value_6)).valid,
                                };
                            };

                            break :block_13 ((&value_8)).*;
                        };
                    };
                }

                break :block_15 (state_1).valid;
            };
        };
    };
}
