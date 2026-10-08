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

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_42: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_41: {
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

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_15).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_15).result).child).value, .zx_origin = ((operand_15).result).child, }, .count = ((operand_15).result).count, .labels = ((operand_15).result).labels, .last = ((operand_15).result).last, .text = ((operand_15).result).text, .total = ((operand_15).result).total, .zx_origin = (operand_15).result, }, .source = (operand_15).source, .zx_origin = operand_15, };
            var state_changed_16 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_33: {
                    const value_6: u64 = block_32: {
                        const operand_30 = (state_1).source;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_29: {
                        break :block_29 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_28: {
                        const operand_21 = ((value_1).count + @as(u64, 1));

                        const operand_22 = (((value_1).total + (value_1).count) + block_23: {
                            break :block_23 value_2;
                        });

                        const operand_24 = (value_1).count;
                        const operand_25 = (value_1).labels;
                        const operand_26 = (value_1).text;
                        const operand_27 = (value_1).child;

                        break :block_28 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_21, .total = operand_22, .last = operand_24, .labels = operand_25, .text = operand_26, .child = operand_27, });
                    };

                    break :block_33 block_20: {
                        const operand_17 = (state_1).source;
                        const operand_18 = ((state_1).index + @as(u64, 1));
                        const operand_19 = value_7;

                        break :block_20 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_18, .result = operand_19, .source = operand_17, });
                    };
                };

                state_changed_16 = true;
            }

            break :block_41 (if (state_changed_16) block_40: {
                break :block_40 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_39: {
                    const operand_38 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_38).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_37: {
                        const operand_36 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_36).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_35: {
                            const operand_34 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_34).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_35 @as(*const (zx_abi).zx_type_11, operand_34);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_37 @as(*const (zx_abi).zx_type_13, operand_36);
                    }), .source = (state_1).source, };

                    break :block_39 @as(*const (zx_abi).zx_type_16, operand_38);
                });
            } else operand_15);
        };

        break :block_42 (value_8).result;
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_71: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_70: {
            const operand_50 = block_49: {
                const operand_44 = block_45: {
                    break :block_45 value_3;
                };

                const operand_46 = @as(u64, 0);

                const operand_47 = block_48: {
                    break :block_48 (try function_0_value(allocator, (in).seed));
                };

                break :block_49 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_46, .result = operand_47, .source = operand_44, });
            };

            var state_43: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_50;
            var state_changed_51 = false;

            while (((state_43).index < @as(u64, ((state_43).source).len))) {
                state_43 = block_68: {
                    const value_6: u64 = block_67: {
                        const operand_65 = (state_43).source;
                        const operand_66 = (state_43).index;

                        if ((operand_66 >= (operand_65).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_67 (operand_65)[@intCast(operand_66)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_43).result;

                    const value_2: u64 = block_64: {
                        break :block_64 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_63: {
                        const operand_56 = ((value_1).count + @as(u64, 1));

                        const operand_57 = (((value_1).total + (value_1).count) + block_58: {
                            break :block_58 value_2;
                        });

                        const operand_59 = (value_1).count;
                        const operand_60 = (value_1).labels;
                        const operand_61 = (value_1).text;
                        const operand_62 = (value_1).child;

                        break :block_63 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_56, .total = operand_57, .last = operand_59, .labels = operand_60, .text = operand_61, .child = operand_62, });
                    };

                    break :block_68 block_55: {
                        const operand_52 = (state_43).source;
                        const operand_53 = ((state_43).index + @as(u64, 1));
                        const operand_54 = value_7;

                        break :block_55 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_53, .result = operand_54, .source = operand_52, });
                    };
                };

                state_changed_51 = true;
            }

            break :block_70 (if (state_changed_51) state_43 else operand_50);
        };

        break :block_71 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_100: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_99: {
            const operand_79 = block_78: {
                const operand_73 = block_74: {
                    break :block_74 value_3;
                };

                const operand_75 = @as(u64, 0);

                const operand_76 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_77: {
                    break :block_77 (try function_0_buffered(allocator, (in).seed, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                });

                break :block_78 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_75, .result = operand_76, .source = operand_73, });
            };

            var state_72: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_79;
            var state_changed_80 = false;

            while (((state_72).index < @as(u64, ((state_72).source).len))) {
                state_72 = block_97: {
                    const value_6: u64 = block_96: {
                        const operand_94 = (state_72).source;
                        const operand_95 = (state_72).index;

                        if ((operand_95 >= (operand_94).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_96 (operand_94)[@intCast(operand_95)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_72).result;

                    const value_2: u64 = block_93: {
                        break :block_93 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_92: {
                        const operand_85 = ((value_1).count + @as(u64, 1));

                        const operand_86 = (((value_1).total + (value_1).count) + block_87: {
                            break :block_87 value_2;
                        });

                        const operand_88 = (value_1).count;
                        const operand_89 = (value_1).labels;
                        const operand_90 = (value_1).text;
                        const operand_91 = (value_1).child;

                        break :block_92 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_85, .total = operand_86, .last = operand_88, .labels = operand_89, .text = operand_90, .child = operand_91, });
                    };

                    break :block_97 block_84: {
                        const operand_81 = (state_72).source;
                        const operand_82 = ((state_72).index + @as(u64, 1));
                        const operand_83 = value_7;

                        break :block_84 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_82, .result = operand_83, .source = operand_81, });
                    };
                };

                state_changed_80 = true;
            }

            break :block_99 (if (state_changed_80) state_72 else operand_79);
        };

        break :block_100 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_135: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_134: {
            const operand_108 = block_107: {
                const operand_102 = value_3;
                const operand_103 = @as(u64, 0);
                const operand_104 = (try function_0_buffered_pointer(allocator, (in).seed, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));

                break :block_107 block_106: {
                    const operand_105 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_105).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_103, .result = operand_104, .source = operand_102, });

                    break :block_106 @as(*const (zx_abi).zx_type_16, operand_105);
                };
            };

            var state_101: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_108).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_108).result).child).value, .zx_origin = ((operand_108).result).child, }, .count = ((operand_108).result).count, .labels = ((operand_108).result).labels, .last = ((operand_108).result).last, .text = ((operand_108).result).text, .total = ((operand_108).result).total, .zx_origin = (operand_108).result, }, .source = (operand_108).source, .zx_origin = operand_108, };
            var state_changed_109 = false;

            while (((state_101).index < @as(u64, ((state_101).source).len))) {
                state_101 = block_126: {
                    const value_6: u64 = block_125: {
                        const operand_123 = (state_101).source;
                        const operand_124 = (state_101).index;

                        if ((operand_124 >= (operand_123).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_125 (operand_123)[@intCast(operand_124)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_101).result;

                    const value_2: u64 = block_122: {
                        break :block_122 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_121: {
                        const operand_114 = ((value_1).count + @as(u64, 1));

                        const operand_115 = (((value_1).total + (value_1).count) + block_116: {
                            break :block_116 value_2;
                        });

                        const operand_117 = (value_1).count;
                        const operand_118 = (value_1).labels;
                        const operand_119 = (value_1).text;
                        const operand_120 = (value_1).child;

                        break :block_121 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_114, .total = operand_115, .last = operand_117, .labels = operand_118, .text = operand_119, .child = operand_120, });
                    };

                    break :block_126 block_113: {
                        const operand_110 = (state_101).source;
                        const operand_111 = ((state_101).index + @as(u64, 1));
                        const operand_112 = value_7;

                        break :block_113 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_111, .result = operand_112, .source = operand_110, });
                    };
                };

                state_changed_109 = true;
            }

            break :block_134 (if (state_changed_109) block_133: {
                break :block_133 (if (((state_101).zx_origin != null)) (state_101).zx_origin.? else block_132: {
                    const operand_131 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_131).* = (zx_abi).zx_type_16{ .index = (state_101).index, .result = (if ((((state_101).result).zx_origin != null)) ((state_101).result).zx_origin.? else block_130: {
                        const operand_129 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_129).* = (zx_abi).zx_type_13{ .child = (if (((((state_101).result).child).zx_origin != null)) (((state_101).result).child).zx_origin.? else block_128: {
                            const operand_127 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_127).* = (zx_abi).zx_type_11{ .value = (((state_101).result).child).value, };

                            break :block_128 @as(*const (zx_abi).zx_type_11, operand_127);
                        }), .count = ((state_101).result).count, .labels = ((state_101).result).labels, .last = ((state_101).result).last, .text = ((state_101).result).text, .total = ((state_101).result).total, };

                        break :block_130 @as(*const (zx_abi).zx_type_13, operand_129);
                    }), .source = (state_101).source, };

                    break :block_132 @as(*const (zx_abi).zx_type_16, operand_131);
                });
            } else operand_108);
        };

        break :block_135 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_42: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_41: {
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

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_15).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_15).result).child).value, .zx_origin = ((operand_15).result).child, }, .count = ((operand_15).result).count, .labels = ((operand_15).result).labels, .last = ((operand_15).result).last, .text = ((operand_15).result).text, .total = ((operand_15).result).total, .zx_origin = (operand_15).result, }, .source = (operand_15).source, .zx_origin = operand_15, };
            var state_changed_16 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_33: {
                    const value_6: u64 = block_32: {
                        const operand_30 = (state_1).source;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_29: {
                        break :block_29 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_28: {
                        const operand_21 = ((value_1).count + @as(u64, 1));

                        const operand_22 = (((value_1).total + (value_1).count) + block_23: {
                            break :block_23 value_2;
                        });

                        const operand_24 = (value_1).count;
                        const operand_25 = (value_1).labels;
                        const operand_26 = (value_1).text;
                        const operand_27 = (value_1).child;

                        break :block_28 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_21, .total = operand_22, .last = operand_24, .labels = operand_25, .text = operand_26, .child = operand_27, });
                    };

                    break :block_33 block_20: {
                        const operand_17 = (state_1).source;
                        const operand_18 = ((state_1).index + @as(u64, 1));
                        const operand_19 = value_7;

                        break :block_20 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_18, .result = operand_19, .source = operand_17, });
                    };
                };

                state_changed_16 = true;
            }

            break :block_41 (if (state_changed_16) block_40: {
                break :block_40 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_39: {
                    const operand_38 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_38).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_37: {
                        const operand_36 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_36).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_35: {
                            const operand_34 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_34).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_35 @as(*const (zx_abi).zx_type_11, operand_34);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_37 @as(*const (zx_abi).zx_type_13, operand_36);
                    }), .source = (state_1).source, };

                    break :block_39 @as(*const (zx_abi).zx_type_16, operand_38);
                });
            } else operand_15);
        };

        break :block_42 (value_8).result;
    };
}

