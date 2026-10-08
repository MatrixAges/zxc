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

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_72: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_71: {
            const operand_51 = block_50: {
                const operand_45 = block_46: {
                    break :block_46 value_3;
                };

                const operand_47 = @as(u64, 0);

                const operand_48 = block_49: {
                    break :block_49 (try function_0_value(allocator, (in).seed));
                };

                break :block_50 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_47, .result = operand_48, .source = operand_45, });
            };

            var state_44: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_51;
            var state_changed_52 = false;

            while (((state_44).index < @as(u64, ((state_44).source).len))) {
                state_44 = block_69: {
                    const value_6: u64 = block_68: {
                        const operand_66 = (state_44).source;
                        const operand_67 = (state_44).index;

                        if ((operand_67 >= (operand_66).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_68 (operand_66)[@intCast(operand_67)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_44).result;

                    const value_2: u64 = block_65: {
                        break :block_65 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_64: {
                        const operand_57 = ((value_1).count + @as(u64, 1));

                        const operand_58 = (((value_1).total + (value_1).count) + block_59: {
                            break :block_59 value_2;
                        });

                        const operand_60 = (value_1).count;
                        const operand_61 = (value_1).labels;
                        const operand_62 = (value_1).text;
                        const operand_63 = (value_1).child;

                        break :block_64 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_57, .total = operand_58, .last = operand_60, .labels = operand_61, .text = operand_62, .child = operand_63, });
                    };

                    break :block_69 block_56: {
                        const operand_53 = (state_44).source;
                        const operand_54 = ((state_44).index + @as(u64, 1));
                        const operand_55 = value_7;

                        break :block_56 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_54, .result = operand_55, .source = operand_53, });
                    };
                };

                state_changed_52 = true;
            }

            break :block_71 (if (state_changed_52) state_44 else operand_51);
        };

        break :block_72 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_101: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_100: {
            const operand_80 = block_79: {
                const operand_74 = block_75: {
                    break :block_75 value_3;
                };

                const operand_76 = @as(u64, 0);

                const operand_77 = @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, block_78: {
                    break :block_78 (try function_0_buffered(allocator, (in).seed, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                });

                break :block_79 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_76, .result = operand_77, .source = operand_74, });
            };

            var state_73: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_80;
            var state_changed_81 = false;

            while (((state_73).index < @as(u64, ((state_73).source).len))) {
                state_73 = block_98: {
                    const value_6: u64 = block_97: {
                        const operand_95 = (state_73).source;
                        const operand_96 = (state_73).index;

                        if ((operand_96 >= (operand_95).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_97 (operand_95)[@intCast(operand_96)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_73).result;

                    const value_2: u64 = block_94: {
                        break :block_94 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_93: {
                        const operand_86 = ((value_1).count + @as(u64, 1));

                        const operand_87 = (((value_1).total + (value_1).count) + block_88: {
                            break :block_88 value_2;
                        });

                        const operand_89 = (value_1).count;
                        const operand_90 = (value_1).labels;
                        const operand_91 = (value_1).text;
                        const operand_92 = (value_1).child;

                        break :block_93 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_86, .total = operand_87, .last = operand_89, .labels = operand_90, .text = operand_91, .child = operand_92, });
                    };

                    break :block_98 block_85: {
                        const operand_82 = (state_73).source;
                        const operand_83 = ((state_73).index + @as(u64, 1));
                        const operand_84 = value_7;

                        break :block_85 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_83, .result = operand_84, .source = operand_82, });
                    };
                };

                state_changed_81 = true;
            }

            break :block_100 (if (state_changed_81) state_73 else operand_80);
        };

        break :block_101 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_137: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_136: {
            const operand_109 = block_108: {
                const operand_103 = value_3;
                const operand_104 = @as(u64, 0);
                const operand_105 = (try function_0_buffered_pointer(allocator, (in).seed, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));

                break :block_108 block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_106).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_104, .result = operand_105, .source = operand_103, });

                    break :block_107 @as(*const (zx_abi).zx_type_16, operand_106);
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

            var state_102: state_type_113 = state_type_113{ .index = (operand_109).index, .result = state_type_112{ .child = state_type_111{ .value = (((operand_109).result).child).value, }, .count = ((operand_109).result).count, .labels = ((operand_109).result).labels, .last = ((operand_109).result).last, .text = ((operand_109).result).text, .total = ((operand_109).result).total, }, .source = (operand_109).source, };
            var state_changed_110 = false;

            while (((state_102).index < @as(u64, ((state_102).source).len))) {
                state_102 = block_128: {
                    const value_6: u64 = block_127: {
                        const operand_125 = (state_102).source;
                        const operand_126 = (state_102).index;

                        if ((operand_126 >= (operand_125).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_127 (operand_125)[@intCast(operand_126)];
                    };

                    const value_1: state_type_112 = (state_102).result;
                    const value_2: u64 = value_6;

                    const value_7: state_type_112 = block_124: {
                        const operand_118 = ((value_1).count + @as(u64, 1));
                        const operand_119 = (((value_1).total + (value_1).count) + value_2);
                        const operand_120 = (value_1).count;
                        const operand_121 = (value_1).labels;
                        const operand_122 = (value_1).text;
                        const operand_123 = (value_1).child;

                        break :block_124 state_type_112{ .count = operand_118, .total = operand_119, .last = operand_120, .labels = operand_121, .text = operand_122, .child = operand_123, };
                    };

                    break :block_128 block_117: {
                        const operand_114 = (state_102).source;
                        const operand_115 = ((state_102).index + @as(u64, 1));
                        const operand_116 = value_7;

                        break :block_117 state_type_113{ .index = operand_115, .result = operand_116, .source = operand_114, };
                    };
                };

                state_changed_110 = true;
            }

            break :block_136 (if (state_changed_110) block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_134).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_102).index, .result = block_133: {
                    const operand_132 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_132).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_131: {
                        const operand_130 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_130).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_102).result).child).value, });

                        break :block_131 @as(*const (zx_abi).zx_type_11, operand_130);
                    }, .count = ((state_102).result).count, .labels = ((state_102).result).labels, .last = ((state_102).result).last, .text = ((state_102).result).text, .total = ((state_102).result).total, });

                    break :block_133 @as(*const (zx_abi).zx_type_13, operand_132);
                }, .source = (state_102).source, });

                break :block_135 @as(*const (zx_abi).zx_type_16, operand_134);
            } else operand_109);
        };

        break :block_137 (value_8).result;
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

