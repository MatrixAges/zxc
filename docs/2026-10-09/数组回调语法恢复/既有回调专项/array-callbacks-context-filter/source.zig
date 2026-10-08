const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = []const i64;
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
const zx_shape_15 = .{ .kind = .object, .fields = .{ .captures = zx_shape_14, .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_31: {
        const value_3: []const i64 = (in).items;

        break :block_31 block_30: {
            const operand_12 = block_11: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(i64, (&[_]i64{})));
                };
                const operand_6 = block_10: {
                    const operand_7 = in;

                    break :block_10 block_9: {
                        const operand_8 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_8).* = @as((zx_abi).zx_type_14, .{ operand_7, });

                        break :block_9 @as(*const (zx_abi).zx_type_14, operand_8);
                    };
                };

                break :block_11 (zx_abi).zx_type_15{ .captures = operand_6, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_13: (std).ArrayList(i64) = .empty;
            var state_capacity_started_14 = false;

            defer (state_capacity_13).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c = (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c{ .captures = @as((zx_abi).value_zx_type_14_d26cf4fcd5483b68fe7ad61978f3c90981fa69aa1dba1771d36fd29e09394b12, .{ (zx_abi).value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3{ .context = (zx_abi).value_zx_type_12_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .res = ((((operand_12).captures).@"0").context).res, .zx_origin = (((operand_12).captures).@"0").context, }, .items = (((operand_12).captures).@"0").items, .zx_origin = ((operand_12).captures).@"0", }, (operand_12).captures, }), .index = (operand_12).index, .result = (operand_12).result, .source = (operand_12).source, .zx_origin = (&operand_12), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_28: {
                    const value_6: i64 = block_27: {
                        const operand_25 = (state_1).source;
                        const operand_26 = (state_1).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3 = ((state_1).captures).@"0";
                    const value_7: bool = ((value_2).context).res;

                    break :block_28 block_24: {
                        const operand_15 = (state_1).source;
                        const operand_16 = ((state_1).index + @as(u64, 1));

                        const operand_17 = (if (block_18: {
                            break :block_18 value_7;
                        }) (block_22: {
                            const operand_19 = (state_1).result;

                            const operand_21 = block_20: {
                                break :block_20 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_19).len, 1));

                            if ((!state_capacity_started_14)) {
                                (try (state_capacity_13).appendSlice(allocator, operand_19));

                                state_capacity_started_14 = true;
                            } else {
                                ((state_capacity_13).items).len = (operand_19).len;
                            }

                            (try (state_capacity_13).append(allocator, operand_21));

                            break :block_22 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_13).items, {}, null, });
                        }).@"0" else (state_1).result);

                        const operand_23 = (state_1).captures;

                        break :block_24 @as((zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c, (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c{ .captures = operand_23, .index = operand_16, .result = operand_17, .source = operand_15, });
                    };
                };
            }

            var state_owned_29: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_29);

            if (state_capacity_started_14) {
                ((state_capacity_13).items).len = ((state_1).result).len;
                state_owned_29 = (try (state_capacity_13).toOwnedSlice(allocator));
            }

            if (state_capacity_started_14) {
                state_1 = (zx_abi).value_zx_type_15_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c{ .captures = (state_1).captures, .index = (state_1).index, .result = state_owned_29, .source = (state_1).source, };
            }

            break :block_30 (state_1).result;
        };
    };
}

