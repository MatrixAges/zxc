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

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

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

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_76: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_75: {
            const operand_55 = block_54: {
                const operand_50 = block_51: {
                    break :block_51 value_3;
                };

                const operand_52 = @as(u64, 0);
                const operand_53 = (in).seed;

                break :block_54 @as((zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_52, .result = operand_53, .source = operand_50, });
            };

            var state_capacity_57: (std).ArrayList([]const u8) = .empty;
            var state_capacity_started_58 = false;

            defer (state_capacity_57).deinit(allocator);

            var state_49: (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_55;
            var state_changed_56 = false;

            while (((state_49).index < @as(u64, ((state_49).source).len))) {
                state_49 = block_72: {
                    const value_6: u64 = block_71: {
                        const operand_69 = (state_49).source;
                        const operand_70 = (state_49).index;

                        if ((operand_70 >= (operand_69).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_71 (operand_69)[@intCast(operand_70)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_49).result;

                    const value_2: u64 = block_68: {
                        break :block_68 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_67: {
                        break :block_67 (try function_0_buffered(allocator, block_66: {
                            const operand_63 = value_1;

                            const operand_64 = block_65: {
                                break :block_65 value_2;
                            };

                            break :block_66 @as((zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c, (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c{ .state = operand_63, .item = operand_64, });
                        }, .{ .lane_0 = .{ .buffer = (&state_capacity_57), .started = (&state_capacity_started_58), }, }));
                    });

                    break :block_72 block_62: {
                        const operand_59 = (state_49).source;
                        const operand_60 = ((state_49).index + @as(u64, 1));
                        const operand_61 = value_7;

                        break :block_62 @as((zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_60, .result = operand_61, .source = operand_59, });
                    };
                };

                state_changed_56 = true;
            }

            var state_owned_73: []const []const u8 = (&[_][]const u8{});

            errdefer (allocator).free(state_owned_73);

            if (state_capacity_started_58) {
                ((state_capacity_57).items).len = (((state_49).result).labels).len;
                state_owned_73 = (try (state_capacity_57).toOwnedSlice(allocator));
            }

            if (state_capacity_started_58) {
                state_49 = (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (state_49).index, .result = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = ((state_49).result).child, .count = ((state_49).result).count, .labels = state_owned_73, .last = ((state_49).result).last, .text = ((state_49).result).text, .total = ((state_49).result).total, }), .source = (state_49).source, };
            }

            break :block_75 (if (state_changed_56) state_49 else operand_55);
        };

        break :block_76 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_101: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_100: {
            const operand_83 = block_82: {
                const operand_78 = block_79: {
                    break :block_79 value_3;
                };

                const operand_80 = @as(u64, 0);
                const operand_81 = (in).seed;

                break :block_82 @as((zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_80, .result = operand_81, .source = operand_78, });
            };

            var state_77: (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_83;
            var state_changed_84 = false;

            while (((state_77).index < @as(u64, ((state_77).source).len))) {
                state_77 = block_98: {
                    const value_6: u64 = block_97: {
                        const operand_95 = (state_77).source;
                        const operand_96 = (state_77).index;

                        if ((operand_96 >= (operand_95).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_97 (operand_95)[@intCast(operand_96)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_77).result;

                    const value_2: u64 = block_94: {
                        break :block_94 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_93: {
                        break :block_93 (try function_0_buffered(allocator, block_92: {
                            const operand_89 = value_1;

                            const operand_90 = block_91: {
                                break :block_91 value_2;
                            };

                            break :block_92 @as((zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c, (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c{ .state = operand_89, .item = operand_90, });
                        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                    });

                    break :block_98 block_88: {
                        const operand_85 = (state_77).source;
                        const operand_86 = ((state_77).index + @as(u64, 1));
                        const operand_87 = value_7;

                        break :block_88 @as((zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_86, .result = operand_87, .source = operand_85, });
                    };
                };

                state_changed_84 = true;
            }

            break :block_100 (if (state_changed_84) state_77 else operand_83);
        };

        break :block_101 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_146: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_145: {
            const operand_109 = block_108: {
                const operand_103 = value_3;
                const operand_104 = @as(u64, 0);
                const operand_105 = (in).seed;

                break :block_108 block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_106).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_104, .result = operand_105, .source = operand_103, });

                    break :block_107 @as(*const (zx_abi).zx_type_17, operand_106);
                };
            };
            const state_type_111 = struct {
                value: u64,
            };
            const state_type_112 = struct {
                child: state_type_111,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_113 = struct {
                index: u64,
                result: state_type_112,
                source: []const u64,
            };
            const state_type_118 = struct {
                item: u64,
                state: state_type_112,
            };

            var state_102: state_type_113 = state_type_113{ .index = (operand_109).index, .result = state_type_112{ .child = state_type_111{ .value = (((operand_109).result).child).value, }, .count = ((operand_109).result).count, .labels = ((operand_109).result).labels, .last = ((operand_109).result).last, .text = ((operand_109).result).text, .total = ((operand_109).result).total, }, .source = (operand_109).source, };
            var state_changed_110 = false;

            while (((state_102).index < @as(u64, ((state_102).source).len))) {
                state_102 = block_137: {
                    const value_6: u64 = block_136: {
                        const operand_134 = (state_102).source;
                        const operand_135 = (state_102).index;

                        if ((operand_135 >= (operand_134).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_136 (operand_134)[@intCast(operand_135)];
                    };

                    const value_1: state_type_112 = (state_102).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_112 = block_133: {
                        const operand_122 = block_121: {
                            const operand_119 = value_1;
                            const operand_120 = value_2;

                            break :block_121 state_type_118{ .state = operand_119, .item = operand_120, };
                        };

                        const operand_123 = (zx_abi).zx_type_11{ .value = (((operand_122).state).child).value, };
                        const operand_124 = (zx_abi).zx_type_13{ .child = (&operand_123), .count = ((operand_122).state).count, .labels = ((operand_122).state).labels, .last = ((operand_122).state).last, .text = ((operand_122).state).text, .total = ((operand_122).state).total, };
                        const operand_125 = (zx_abi).zx_type_14{ .item = (operand_122).item, .state = (&operand_124), };

                        const operand_132 = block_131: {
                            const operand_126 = (&operand_125);
                            const operand_127 = (try function_0_buffered(allocator, (zx_abi).value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c{ .item = (operand_126).item, .state = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_126).state).child).value, .zx_origin = ((operand_126).state).child, }, .count = ((operand_126).state).count, .labels = ((operand_126).state).labels, .last = ((operand_126).state).last, .text = ((operand_126).state).text, .total = ((operand_126).state).total, .zx_origin = (operand_126).state, }, .zx_origin = operand_126, }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));

                            break :block_131 (if (((operand_127).zx_origin != null)) ((operand_127).zx_origin.?).* else block_130: {
                                break :block_130 (zx_abi).zx_type_13{ .child = (if ((((operand_127).child).zx_origin != null)) ((operand_127).child).zx_origin.? else block_129: {
                                    const operand_128 = (try (allocator).create((zx_abi).zx_type_11));

                                    (operand_128).* = (zx_abi).zx_type_11{ .value = ((operand_127).child).value, };

                                    break :block_129 @as(*const (zx_abi).zx_type_11, operand_128);
                                }), .count = (operand_127).count, .labels = (operand_127).labels, .last = (operand_127).last, .text = (operand_127).text, .total = (operand_127).total, };
                            });
                        };

                        break :block_133 state_type_112{ .child = state_type_111{ .value = ((operand_132).child).value, }, .count = (operand_132).count, .labels = (operand_132).labels, .last = (operand_132).last, .text = (operand_132).text, .total = (operand_132).total, };
                    };

                    break :block_137 block_117: {
                        const operand_114 = (state_102).source;
                        const operand_115 = ((state_102).index + @as(u64, 1));
                        const operand_116 = value_7;

                        break :block_117 state_type_113{ .index = operand_115, .result = operand_116, .source = operand_114, };
                    };
                };

                state_changed_110 = true;
            }

            break :block_145 (if (state_changed_110) block_144: {
                const operand_143 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_143).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_102).index, .result = block_142: {
                    const operand_141 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_141).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_140: {
                        const operand_139 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_139).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_102).result).child).value, });

                        break :block_140 @as(*const (zx_abi).zx_type_11, operand_139);
                    }, .count = ((state_102).result).count, .labels = ((state_102).result).labels, .last = ((state_102).result).last, .text = ((state_102).result).text, .total = ((state_102).result).total, });

                    break :block_142 @as(*const (zx_abi).zx_type_13, operand_141);
                }, .source = (state_102).source, });

                break :block_144 @as(*const (zx_abi).zx_type_17, operand_143);
            } else operand_109);
        };

        break :block_146 (value_8).result;
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

