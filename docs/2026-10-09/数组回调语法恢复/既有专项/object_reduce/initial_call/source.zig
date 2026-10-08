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

    return block_4: {
        const operand_1 = in;

        break :block_4 block_3: {
            const operand_2 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_2).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_1).child, .count = (operand_1).count, .labels = (operand_1).labels, .last = (operand_1).last, .text = (operand_1).text, .total = (operand_1).total, });

            break :block_3 @as(*const (zx_abi).zx_type_13, operand_2);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_6: {
        const operand_5 = in;

        break :block_6 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_5).child, .count = (operand_5).count, .labels = (operand_5).labels, .last = (operand_5).last, .text = (operand_5).text, .total = (operand_5).total, });
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

    return block_8: {
        const operand_7 = in;

        break :block_8 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_7).child, .count = (operand_7).count, .labels = (operand_7).labels, .last = (operand_7).last, .text = (operand_7).text, .total = (operand_7).total, });
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

    return block_12: {
        const operand_9 = in;

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_10).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_9).child, .count = (operand_9).count, .labels = (operand_9).labels, .last = (operand_9).last, .text = (operand_9).text, .total = (operand_9).total, });

            break :block_11 @as(*const (zx_abi).zx_type_13, operand_10);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_43: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_42: {
            const operand_15 = block_14: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = block_11: {
                    const operand_5 = (in).seed;
                    const operand_6 = (try function_0_value(allocator, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = ((operand_5).child).value, .zx_origin = (operand_5).child, }, .count = (operand_5).count, .labels = (operand_5).labels, .last = (operand_5).last, .text = (operand_5).text, .total = (operand_5).total, .zx_origin = operand_5, }));

                    break :block_11 (if (((operand_6).zx_origin != null)) (operand_6).zx_origin.? else block_10: {
                        const operand_9 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_9).* = (zx_abi).zx_type_13{ .child = (if ((((operand_6).child).zx_origin != null)) ((operand_6).child).zx_origin.? else block_8: {
                            const operand_7 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_7).* = (zx_abi).zx_type_11{ .value = ((operand_6).child).value, };

                            break :block_8 @as(*const (zx_abi).zx_type_11, operand_7);
                        }), .count = (operand_6).count, .labels = (operand_6).labels, .last = (operand_6).last, .text = (operand_6).text, .total = (operand_6).total, };

                        break :block_10 @as(*const (zx_abi).zx_type_13, operand_9);
                    });
                };

                break :block_14 block_13: {
                    const operand_12 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_12).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_13 @as(*const (zx_abi).zx_type_16, operand_12);
                };
            };
            const state_type_17 = struct {
                value: u64,
            };
            const state_type_18 = struct {
                child: state_type_17,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_19 = struct {
                index: u64,
                result: state_type_18,
                source: []const u64,
            };

            var state_1: state_type_19 = state_type_19{ .index = (operand_15).index, .result = state_type_18{ .child = state_type_17{ .value = (((operand_15).result).child).value, }, .count = ((operand_15).result).count, .labels = ((operand_15).result).labels, .last = ((operand_15).result).last, .text = ((operand_15).result).text, .total = ((operand_15).result).total, }, .source = (operand_15).source, };
            var state_changed_16 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_34: {
                    const value_6: u64 = block_33: {
                        const operand_31 = (state_1).source;
                        const operand_32 = (state_1).index;

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    };

                    const value_1: state_type_18 = (state_1).result;
                    const value_2: u64 = value_6;

                    const value_7: state_type_18 = block_30: {
                        const operand_24 = ((value_1).count + @as(u64, 1));
                        const operand_25 = (((value_1).total + (value_1).count) + value_2);
                        const operand_26 = (value_1).count;
                        const operand_27 = (value_1).labels;
                        const operand_28 = (value_1).text;
                        const operand_29 = (value_1).child;

                        break :block_30 state_type_18{ .count = operand_24, .total = operand_25, .last = operand_26, .labels = operand_27, .text = operand_28, .child = operand_29, };
                    };

                    break :block_34 block_23: {
                        const operand_20 = (state_1).source;
                        const operand_21 = ((state_1).index + @as(u64, 1));
                        const operand_22 = value_7;

                        break :block_23 state_type_19{ .index = operand_21, .result = operand_22, .source = operand_20, };
                    };
                };

                state_changed_16 = true;
            }

            break :block_42 (if (state_changed_16) block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_40).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_39: {
                    const operand_38 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_38).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_37: {
                        const operand_36 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_36).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_37 @as(*const (zx_abi).zx_type_11, operand_36);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_39 @as(*const (zx_abi).zx_type_13, operand_38);
                }, .source = (state_1).source, });

                break :block_41 @as(*const (zx_abi).zx_type_16, operand_40);
            } else operand_15);
        };

        break :block_43 (value_8).result;
    };
}

