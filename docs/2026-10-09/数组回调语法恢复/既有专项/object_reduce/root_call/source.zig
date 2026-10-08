const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Child = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_13;
pub const Input = *const (zx_abi).zx_type_16;
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
const zx_shape_14 = .{ .kind = .object, .fields = .{ .item = zx_shape_5, .state = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .seed = zx_shape_13, .steps = zx_shape_15, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_15, }, };
pub const input_shape = zx_shape_16;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_7: {
        const operand_1 = (in).state;
        const operand_2 = (((in).state).count + @as(u64, 1));
        const operand_3 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_4 = ((in).state).count;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_5).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_1).child, .count = operand_2, .labels = (operand_1).labels, .last = operand_4, .text = (operand_1).text, .total = operand_3, });

            break :block_6 @as(*const (zx_abi).zx_type_13, operand_5);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_12: {
        const operand_8 = (in).state;
        const operand_9 = (((in).state).count + @as(u64, 1));
        const operand_10 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_11 = ((in).state).count;

        break :block_12 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_8).child, .count = operand_9, .labels = (operand_8).labels, .last = operand_11, .text = (operand_8).text, .total = operand_10, });
    };
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_17: {
        const operand_13 = (in).state;
        const operand_14 = (((in).state).count + @as(u64, 1));
        const operand_15 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_16 = ((in).state).count;

        break :block_17 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_13).child, .count = operand_14, .labels = (operand_13).labels, .last = operand_16, .text = (operand_13).text, .total = operand_15, });
    };
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_24: {
        const operand_18 = (in).state;
        const operand_19 = (((in).state).count + @as(u64, 1));
        const operand_20 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_21 = ((in).state).count;

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_22).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = (operand_18).child, .count = operand_19, .labels = (operand_18).labels, .last = operand_21, .text = (operand_18).text, .total = operand_20, });

            break :block_23 @as(*const (zx_abi).zx_type_13, operand_22);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_48: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_47: {
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

            var state_capacity_10: (std).ArrayList([]const u8) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            const state_type_12 = struct {
                value: u64,
            };
            const state_type_13 = struct {
                child: state_type_12,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_14 = struct {
                index: u64,
                result: state_type_13,
                source: []const u64,
            };
            const state_type_19 = struct {
                item: u64,
                state: state_type_13,
            };

            var state_1: state_type_14 = state_type_14{ .index = (operand_8).index, .result = state_type_13{ .child = state_type_12{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_38: {
                    const value_6: u64 = block_37: {
                        const operand_35 = (state_1).source;
                        const operand_36 = (state_1).index;

                        if ((operand_36 >= (operand_35).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_37 (operand_35)[@intCast(operand_36)];
                    };

                    const value_1: state_type_13 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_13 = block_34: {
                        const operand_23 = block_22: {
                            const operand_20 = value_1;
                            const operand_21 = value_2;

                            break :block_22 state_type_19{ .state = operand_20, .item = operand_21, };
                        };

                        const operand_24 = (zx_abi).zx_type_11{ .value = (((operand_23).state).child).value, };
                        const operand_25 = (zx_abi).zx_type_13{ .child = (&operand_24), .count = ((operand_23).state).count, .labels = ((operand_23).state).labels, .last = ((operand_23).state).last, .text = ((operand_23).state).text, .total = ((operand_23).state).total, };
                        const operand_26 = (zx_abi).zx_type_14{ .item = (operand_23).item, .state = (&operand_25), };

                        const operand_33 = block_32: {
                            const operand_27 = (&operand_26);
                            const operand_28 = (try function_0_buffered(allocator, (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c{ .item = (operand_27).item, .state = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_27).state).child).value, .zx_origin = ((operand_27).state).child, }, .count = ((operand_27).state).count, .labels = ((operand_27).state).labels, .last = ((operand_27).state).last, .text = ((operand_27).state).text, .total = ((operand_27).state).total, .zx_origin = (operand_27).state, }, .zx_origin = operand_27, }, .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, }));

                            break :block_32 (if (((operand_28).zx_origin != null)) ((operand_28).zx_origin.?).* else block_31: {
                                break :block_31 (zx_abi).zx_type_13{ .child = (if ((((operand_28).child).zx_origin != null)) ((operand_28).child).zx_origin.? else block_30: {
                                    const operand_29 = (try (allocator).create((zx_abi).zx_type_11));

                                    (operand_29).* = (zx_abi).zx_type_11{ .value = ((operand_28).child).value, };

                                    break :block_30 @as(*const (zx_abi).zx_type_11, operand_29);
                                }), .count = (operand_28).count, .labels = (operand_28).labels, .last = (operand_28).last, .text = (operand_28).text, .total = (operand_28).total, };
                            });
                        };

                        break :block_34 state_type_13{ .child = state_type_12{ .value = ((operand_33).child).value, }, .count = (operand_33).count, .labels = (operand_33).labels, .last = (operand_33).last, .text = (operand_33).text, .total = (operand_33).total, };
                    };

                    break :block_38 block_18: {
                        const operand_15 = (state_1).source;
                        const operand_16 = ((state_1).index + @as(u64, 1));
                        const operand_17 = value_7;

                        break :block_18 state_type_14{ .index = operand_16, .result = operand_17, .source = operand_15, };
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_39: []const []const u8 = (&[_][]const u8{});

            errdefer (allocator).free(state_owned_39);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).labels).len;
                state_owned_39 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                ((state_1).result).labels = state_owned_39;
            }

            break :block_47 (if (state_changed_9) block_46: {
                const operand_45 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_45).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_1).index, .result = block_44: {
                    const operand_43 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_43).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_42: {
                        const operand_41 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_41).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_42 @as(*const (zx_abi).zx_type_11, operand_41);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_44 @as(*const (zx_abi).zx_type_13, operand_43);
                }, .source = (state_1).source, });

                break :block_46 @as(*const (zx_abi).zx_type_17, operand_45);
            } else operand_8);
        };

        break :block_48 (value_8).result;
    };
}

