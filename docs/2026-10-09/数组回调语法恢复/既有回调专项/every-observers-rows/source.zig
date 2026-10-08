const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = *const (zx_abi).zx_type_14;
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
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .items = zx_shape_12, .threshold = zx_shape_7, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .calls = zx_shape_5, .result = zx_shape_1, .threshold = zx_shape_7, .visited = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_14, .source = zx_shape_12, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_14 = block_52: {
        const operand_45 = true;
        const operand_46 = @as(u64, 0);

        const operand_47 = block_48: {
            break :block_48 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        const operand_49 = (in).threshold;

        break :block_52 block_51: {
            const operand_50 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_50).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .result = operand_45, .calls = operand_46, .visited = operand_47, .threshold = operand_49, });

            break :block_51 @as(*const (zx_abi).zx_type_14, operand_50);
        };
    };

    return block_44: {
        const value_4: []const []const i64 = (in).items;

        const value_9: *const (zx_abi).zx_type_16 = block_43: {
            const operand_8 = block_7: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);
                const operand_4 = value_1;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(i64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = (zx_abi).value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((operand_8).result).calls, .result = ((operand_8).result).result, .threshold = ((operand_8).result).threshold, .visited = ((operand_8).result).visited, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_36: {
                    const value_7: []const i64 = block_35: {
                        const operand_33 = (state_1).source;
                        const operand_34 = (state_1).index;

                        if ((operand_34 >= (operand_33).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_35 (operand_33)[@intCast(operand_34)];
                    };

                    const value_2: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (state_1).result;

                    const value_3: []const i64 = block_32: {
                        break :block_32 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if ((value_2).result) block_31: {
                        const operand_16 = (block_20: {
                            const operand_18 = block_17: {
                                break :block_17 value_3;
                            };
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        } > (value_2).threshold);

                        const operand_21 = ((value_2).calls + @as(u64, 1));

                        const operand_22 = (block_29: {
                            const operand_23 = (value_2).visited;

                            const operand_28 = block_27: {
                                const operand_25 = block_24: {
                                    break :block_24 value_3;
                                };
                                const operand_26 = @as(u64, 0);

                                if ((operand_26 >= (operand_25).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_27 (operand_25)[@intCast(operand_26)];
                            };

                            _ = (try ((std).math).add(usize, (operand_23).len, 1));

                            if ((!state_capacity_started_11)) {
                                (try (state_capacity_10).appendSlice(allocator, operand_23));
                                state_capacity_started_11 = true;
                            } else {
                                ((state_capacity_10).items).len = (operand_23).len;
                            }

                            (try (state_capacity_10).append(allocator, operand_28));

                            break :block_29 @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                        }).@"0";

                        const operand_30 = (value_2).threshold;

                        break :block_31 @as((zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_16, .calls = operand_21, .visited = operand_22, .threshold = operand_30, });
                    } else value_2);

                    break :block_36 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_8;

                        break :block_15 @as((zx_abi).value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_37: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_37);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).visited).len;
                state_owned_37 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .threshold = ((state_1).result).threshold, .visited = state_owned_37, }), .source = (state_1).source, };
            }

            break :block_43 (if (state_changed_9) block_42: {
                break :block_42 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_41: {
                    const operand_40 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_40).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_39: {
                        const operand_38 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_38).* = (zx_abi).zx_type_14{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .threshold = ((state_1).result).threshold, .visited = ((state_1).result).visited, };

                        break :block_39 @as(*const (zx_abi).zx_type_14, operand_38);
                    }), .source = (state_1).source, };

                    break :block_41 @as(*const (zx_abi).zx_type_16, operand_40);
                });
            } else operand_8);
        };

        break :block_44 (value_9).result;
    };
}

