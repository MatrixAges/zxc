const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = bool;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .res = zx_shape_1, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .context = zx_shape_12, .items = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .captures = zx_shape_14, .index = zx_shape_5, .result = zx_shape_1, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_1;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_23: {
        const value_3: []const i64 = (in).items;

        break :block_23 block_22: {
            const operand_11 = block_10: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = true;
                const operand_5 = block_9: {
                    const operand_6 = in;

                    break :block_9 block_8: {
                        const operand_7 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_7).* = @as((zx_abi).zx_type_14, .{ operand_6, });

                        break :block_8 @as(*const (zx_abi).zx_type_14, operand_7);
                    };
                };

                break :block_10 (zx_abi).zx_type_15{ .captures = operand_5, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c = (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c{ .captures = @as((zx_abi).value_zx_type_14_d26cf4fcd5483b68fe7ad61978f3c90981fa69aa1dba1771d36fd29e09394b12, .{ (zx_abi).value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3{ .context = (zx_abi).value_zx_type_12_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .res = ((((operand_11).captures).@"0").context).res, .zx_origin = (((operand_11).captures).@"0").context, }, .items = (((operand_11).captures).@"0").items, .zx_origin = ((operand_11).captures).@"0", }, (operand_11).captures, }), .index = (operand_11).index, .result = (operand_11).result, .source = (operand_11).source, .zx_origin = (&operand_11), };

            while ((((state_1).index < @as(u64, ((state_1).source).len)) and (state_1).result)) {
                state_1 = block_21: {
                    _ = block_20: {
                        const operand_18 = (state_1).source;
                        const operand_19 = (state_1).index;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3 = ((state_1).captures).@"0";
                    const value_7: bool = ((value_2).context).res;

                    break :block_21 block_17: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));

                        const operand_14 = block_15: {
                            break :block_15 value_7;
                        };

                        const operand_16 = (state_1).captures;

                        break :block_17 @as((zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c, (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c{ .captures = operand_16, .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };
            }

            break :block_22 (state_1).result;
        };
    };
}

