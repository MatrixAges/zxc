const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Cell = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_14;
pub const Input = *const (zx_abi).zx_type_16;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_13 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .cell = zx_shape_11, .count = zx_shape_5, .items = zx_shape_12, .saved = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .item = zx_shape_5, .state = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .seed = zx_shape_14, .steps = zx_shape_12, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_14, .source = zx_shape_12, }, };
pub const input_shape = zx_shape_16;
pub const output_shape = zx_shape_14;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_14 = block_7: {
        const operand_1 = (((in).state).count + (in).item);
        const operand_2 = ((in).state).items;
        const operand_3 = ((in).state).cell;
        const operand_4 = ((in).state).saved;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_5).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .count = operand_1, .items = operand_2, .cell = operand_3, .saved = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_14, operand_5);
        };
    };

    return value_1;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2) error{ OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = block_12: {
        const operand_8 = (((in).state).count + (in).item);
        const operand_9 = ((in).state).items;
        const operand_10 = ((in).state).cell;
        const operand_11 = ((in).state).saved;

        break :block_12 @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .count = operand_8, .items = operand_9, .cell = operand_10, .saved = operand_11, });
    };

    return value_1;
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = block_17: {
        const operand_13 = (((in).state).count + (in).item);
        const operand_14 = ((in).state).items;
        const operand_15 = ((in).state).cell;
        const operand_16 = ((in).state).saved;

        break :block_17 @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .count = operand_13, .items = operand_14, .cell = operand_15, .saved = operand_16, });
    };

    return value_1;
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = buffers;

    const value_1: *const (zx_abi).zx_type_14 = block_24: {
        const operand_18 = (((in).state).count + (in).item);
        const operand_19 = ((in).state).items;
        const operand_20 = ((in).state).cell;
        const operand_21 = ((in).state).saved;

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_22).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .count = operand_18, .items = operand_19, .cell = operand_20, .saved = operand_21, });

            break :block_23 @as(*const (zx_abi).zx_type_14, operand_22);
        };
    };

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_33: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_32: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_5).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_17, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(u64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((operand_8).result).cell, .count = ((operand_8).result).count, .items = ((operand_8).result).items, .saved = ((operand_8).result).saved, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_25: {
                    const value_6: u64 = block_24: {
                        const operand_22 = (state_1).source;
                        const operand_23 = (state_1).index;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_1).result;

                    const value_2: u64 = block_21: {
                        break :block_21 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_20: {
                        break :block_20 (try function_0_buffered(allocator, block_19: {
                            const operand_16 = value_1;

                            const operand_17 = block_18: {
                                break :block_18 value_2;
                            };

                            break :block_19 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_16, .item = operand_17, });
                        }, .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, }));
                    });

                    break :block_25 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_7;

                        break :block_15 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_26: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_26);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).items).len;
                state_owned_26 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = state_owned_26, .saved = ((state_1).result).saved, }), .source = (state_1).source, };
            }

            break :block_32 (if (state_changed_9) block_31: {
                break :block_31 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_29).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_27).* = (zx_abi).zx_type_14{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = ((state_1).result).items, .saved = ((state_1).result).saved, };

                        break :block_28 @as(*const (zx_abi).zx_type_14, operand_27);
                    }), .source = (state_1).source, };

                    break :block_30 @as(*const (zx_abi).zx_type_17, operand_29);
                });
            } else operand_8);
        };

        break :block_33 (value_8).result;
    };
}

