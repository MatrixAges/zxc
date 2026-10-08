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

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

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

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_63: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_62: {
            const operand_42 = block_41: {
                const operand_37 = block_38: {
                    break :block_38 value_3;
                };

                const operand_39 = @as(u64, 0);
                const operand_40 = (in).seed;

                break :block_41 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_39, .result = operand_40, .source = operand_37, });
            };

            var state_capacity_44: (std).ArrayList([]const u8) = .empty;
            var state_capacity_started_45 = false;

            defer (state_capacity_44).deinit(allocator);

            var state_36: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_42;
            var state_changed_43 = false;

            while (((state_36).index < @as(u64, ((state_36).source).len))) {
                state_36 = block_59: {
                    const value_6: u64 = block_58: {
                        const operand_56 = (state_36).source;
                        const operand_57 = (state_36).index;

                        if ((operand_57 >= (operand_56).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_58 (operand_56)[@intCast(operand_57)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_36).result;

                    const value_2: u64 = block_55: {
                        break :block_55 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_54: {
                        const operand_50 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_51: {
                            break :block_51 (try function_0_buffered(allocator, value_1, .{ .lane_0 = .{ .buffer = (&state_capacity_44), .started = (&state_capacity_started_45), }, }));
                        });

                        const operand_52 = (((value_1).total + (value_1).count) + block_53: {
                            break :block_53 value_2;
                        });

                        break :block_54 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_50).child, .count = (operand_50).count, .labels = (operand_50).labels, .last = (operand_50).last, .text = (operand_50).text, .total = operand_52, });
                    };

                    break :block_59 block_49: {
                        const operand_46 = (state_36).source;
                        const operand_47 = ((state_36).index + @as(u64, 1));
                        const operand_48 = value_7;

                        break :block_49 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_47, .result = operand_48, .source = operand_46, });
                    };
                };

                state_changed_43 = true;
            }

            var state_owned_60: []const []const u8 = (&[_][]const u8{});

            errdefer (allocator).free(state_owned_60);

            if (state_capacity_started_45) {
                ((state_capacity_44).items).len = (((state_36).result).labels).len;
                state_owned_60 = (try (state_capacity_44).toOwnedSlice(allocator));
            }

            if (state_capacity_started_45) {
                state_36 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (state_36).index, .result = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = ((state_36).result).child, .count = ((state_36).result).count, .labels = state_owned_60, .last = ((state_36).result).last, .text = ((state_36).result).text, .total = ((state_36).result).total, }), .source = (state_36).source, };
            }

            break :block_62 (if (state_changed_43) state_36 else operand_42);
        };

        break :block_63 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_88: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_87: {
            const operand_70 = block_69: {
                const operand_65 = block_66: {
                    break :block_66 value_3;
                };

                const operand_67 = @as(u64, 0);
                const operand_68 = (in).seed;

                break :block_69 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_67, .result = operand_68, .source = operand_65, });
            };

            var state_64: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_70;
            var state_changed_71 = false;

            while (((state_64).index < @as(u64, ((state_64).source).len))) {
                state_64 = block_85: {
                    const value_6: u64 = block_84: {
                        const operand_82 = (state_64).source;
                        const operand_83 = (state_64).index;

                        if ((operand_83 >= (operand_82).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_84 (operand_82)[@intCast(operand_83)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_64).result;

                    const value_2: u64 = block_81: {
                        break :block_81 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_80: {
                        const operand_76 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_77: {
                            break :block_77 (try function_0_buffered(allocator, value_1, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                        });

                        const operand_78 = (((value_1).total + (value_1).count) + block_79: {
                            break :block_79 value_2;
                        });

                        break :block_80 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_76).child, .count = (operand_76).count, .labels = (operand_76).labels, .last = (operand_76).last, .text = (operand_76).text, .total = operand_78, });
                    };

                    break :block_85 block_75: {
                        const operand_72 = (state_64).source;
                        const operand_73 = ((state_64).index + @as(u64, 1));
                        const operand_74 = value_7;

                        break :block_75 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_73, .result = operand_74, .source = operand_72, });
                    };
                };

                state_changed_71 = true;
            }

            break :block_87 (if (state_changed_71) state_64 else operand_70);
        };

        break :block_88 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_120: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_119: {
            const operand_96 = block_95: {
                const operand_90 = value_3;
                const operand_91 = @as(u64, 0);
                const operand_92 = (in).seed;

                break :block_95 block_94: {
                    const operand_93 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_93).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_91, .result = operand_92, .source = operand_90, });

                    break :block_94 @as(*const (zx_abi).zx_type_16, operand_93);
                };
            };

            var state_89: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_96).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_96).result).child).value, .zx_origin = ((operand_96).result).child, }, .count = ((operand_96).result).count, .labels = ((operand_96).result).labels, .last = ((operand_96).result).last, .text = ((operand_96).result).text, .total = ((operand_96).result).total, .zx_origin = (operand_96).result, }, .source = (operand_96).source, .zx_origin = operand_96, };
            var state_changed_97 = false;

            while (((state_89).index < @as(u64, ((state_89).source).len))) {
                state_89 = block_111: {
                    const value_6: u64 = block_110: {
                        const operand_108 = (state_89).source;
                        const operand_109 = (state_89).index;

                        if ((operand_109 >= (operand_108).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_110 (operand_108)[@intCast(operand_109)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_89).result;

                    const value_2: u64 = block_107: {
                        break :block_107 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_106: {
                        const operand_102 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_103: {
                            break :block_103 (try function_0_buffered(allocator, value_1, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                        });

                        const operand_104 = (((value_1).total + (value_1).count) + block_105: {
                            break :block_105 value_2;
                        });

                        break :block_106 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_102).child, .count = (operand_102).count, .labels = (operand_102).labels, .last = (operand_102).last, .text = (operand_102).text, .total = operand_104, });
                    };

                    break :block_111 block_101: {
                        const operand_98 = (state_89).source;
                        const operand_99 = ((state_89).index + @as(u64, 1));
                        const operand_100 = value_7;

                        break :block_101 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_99, .result = operand_100, .source = operand_98, });
                    };
                };

                state_changed_97 = true;
            }

            break :block_119 (if (state_changed_97) block_118: {
                break :block_118 (if (((state_89).zx_origin != null)) (state_89).zx_origin.? else block_117: {
                    const operand_116 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_116).* = (zx_abi).zx_type_16{ .index = (state_89).index, .result = (if ((((state_89).result).zx_origin != null)) ((state_89).result).zx_origin.? else block_115: {
                        const operand_114 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_114).* = (zx_abi).zx_type_13{ .child = (if (((((state_89).result).child).zx_origin != null)) (((state_89).result).child).zx_origin.? else block_113: {
                            const operand_112 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_112).* = (zx_abi).zx_type_11{ .value = (((state_89).result).child).value, };

                            break :block_113 @as(*const (zx_abi).zx_type_11, operand_112);
                        }), .count = ((state_89).result).count, .labels = ((state_89).result).labels, .last = ((state_89).result).last, .text = ((state_89).result).text, .total = ((state_89).result).total, };

                        break :block_115 @as(*const (zx_abi).zx_type_13, operand_114);
                    }), .source = (state_89).source, };

                    break :block_117 @as(*const (zx_abi).zx_type_16, operand_116);
                });
            } else operand_96);
        };

        break :block_120 (value_8).result;
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

