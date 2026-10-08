const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Child = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_13;
pub const Input = *const (zx_abi).zx_type_15;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .child = zx_shape_11, .count = zx_shape_5, .labels = zx_shape_12, .last = zx_shape_5, .text = zx_shape_10, .total = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .seed = zx_shape_13, .steps = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_14, }, };
pub const input_shape = zx_shape_15;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_6: {
        const operand_1 = in;
        const operand_2 = ((in).count + @as(u64, 1));
        const operand_3 = (in).count;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_4).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_1).child, .count = operand_2, .labels = (operand_1).labels, .last = operand_3, .text = (operand_1).text, .total = (operand_1).total, });

            break :block_5 @as(*const (zx_abi).zx_type_13, operand_4);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_10: {
        const operand_7 = in;
        const operand_8 = ((in).count + @as(u64, 1));
        const operand_9 = (in).count;

        break :block_10 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_7).child, .count = operand_8, .labels = (operand_7).labels, .last = operand_9, .text = (operand_7).text, .total = (operand_7).total, });
    };
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_14: {
        const operand_11 = in;
        const operand_12 = ((in).count + @as(u64, 1));
        const operand_13 = (in).count;

        break :block_14 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_11).child, .count = operand_12, .labels = (operand_11).labels, .last = operand_13, .text = (operand_11).text, .total = (operand_11).total, });
    };
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_20: {
        const operand_15 = in;
        const operand_16 = ((in).count + @as(u64, 1));
        const operand_17 = (in).count;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_18).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_15).child, .count = operand_16, .labels = (operand_15).labels, .last = operand_17, .text = (operand_15).text, .total = (operand_15).total, });

            break :block_19 @as(*const (zx_abi).zx_type_13, operand_18);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_35: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_34: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList([]const u8) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
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

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_21: {
                        break :block_21 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_20: {
                        const operand_16 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_17: {
                            break :block_17 (try function_0_buffered(allocator, value_1, .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, }));
                        });

                        const operand_18 = (((value_1).total + (value_1).count) + block_19: {
                            break :block_19 value_2;
                        });

                        break :block_20 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_16).child, .count = (operand_16).count, .labels = (operand_16).labels, .last = (operand_16).last, .text = (operand_16).text, .total = operand_18, });
                    };

                    break :block_25 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_7;

                        break :block_15 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_26: []const []const u8 = (&[_][]const u8{});

            errdefer (allocator).free(state_owned_26);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).labels).len;
                state_owned_26 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = ((state_1).result).child, .count = ((state_1).result).count, .labels = state_owned_26, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, }), .source = (state_1).source, };
            }

            break :block_34 (if (state_changed_9) block_33: {
                break :block_33 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_31).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_30: {
                        const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_29).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_28: {
                            const operand_27 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_27).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_28 @as(*const (zx_abi).zx_type_11, operand_27);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                    }), .source = (state_1).source, };

                    break :block_32 @as(*const (zx_abi).zx_type_16, operand_31);
                });
            } else operand_8);
        };

        break :block_35 (value_8).result;
    };
}

