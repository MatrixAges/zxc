const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_13;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .calls = zx_shape_5, .result = zx_shape_1, .visited = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_13 = block_43: {
        const operand_37 = true;
        const operand_38 = @as(u64, 0);

        const operand_39 = block_40: {
            break :block_40 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_41).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .result = operand_37, .calls = operand_38, .visited = operand_39, });

            break :block_42 @as(*const (zx_abi).zx_type_13, operand_41);
        };
    };

    return block_36: {
        const value_4: []const i64 = (in).items;

        const value_9: *const (zx_abi).zx_type_15 = block_35: {
            const operand_8 = block_7: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);
                const operand_4 = value_1;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_5).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_15, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(i64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f = (zx_abi).value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .calls = ((operand_8).result).calls, .result = ((operand_8).result).result, .visited = ((operand_8).result).visited, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_28: {
                    const value_7: i64 = block_27: {
                        const operand_25 = (state_1).source;
                        const operand_26 = (state_1).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (state_1).result;

                    const value_3: i64 = block_24: {
                        break :block_24 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (if ((value_2).result) block_23: {
                        const operand_16 = true;
                        const operand_17 = ((value_2).calls + @as(u64, 1));

                        const operand_18 = (block_22: {
                            const operand_19 = (value_2).visited;

                            const operand_21 = block_20: {
                                break :block_20 value_3;
                            };

                            _ = (try ((std).math).add(usize, (operand_19).len, 1));

                            if ((!state_capacity_started_11)) {
                                (try (state_capacity_10).appendSlice(allocator, operand_19));
                                state_capacity_started_11 = true;
                            } else {
                                ((state_capacity_10).items).len = (operand_19).len;
                            }

                            (try (state_capacity_10).append(allocator, operand_21));

                            break :block_22 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                        }).@"0";

                        break :block_23 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .result = operand_16, .calls = operand_17, .visited = operand_18, });
                    } else value_2);

                    break :block_28 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_8;

                        break :block_15 @as((zx_abi).value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f, (zx_abi).value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_29: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_29);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).visited).len;
                state_owned_29 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .visited = state_owned_29, }), .source = (state_1).source, };
            }

            break :block_35 (if (state_changed_9) block_34: {
                break :block_34 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_33: {
                    const operand_32 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_32).* = (zx_abi).zx_type_15{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_31: {
                        const operand_30 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_30).* = (zx_abi).zx_type_13{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .visited = ((state_1).result).visited, };

                        break :block_31 @as(*const (zx_abi).zx_type_13, operand_30);
                    }), .source = (state_1).source, };

                    break :block_33 @as(*const (zx_abi).zx_type_15, operand_32);
                });
            } else operand_8);
        };

        break :block_36 (value_9).result;
    };
}

