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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
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

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_26: {
                    const value_6: u64 = block_25: {
                        const operand_23 = (state_1).source;
                        const operand_24 = (state_1).index;

                        if ((operand_24 >= (operand_23).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_25 (operand_23)[@intCast(operand_24)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_22: {
                        break :block_22 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_21: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = (((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        });

                        const operand_17 = (value_1).count;
                        const operand_18 = (value_1).labels;
                        const operand_19 = (value_1).text;
                        const operand_20 = (value_1).child;

                        break :block_21 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_17, .labels = operand_18, .text = operand_19, .child = operand_20, });
                    };

                    break :block_26 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
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

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

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

            var state_36: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_42;
            var state_changed_43 = false;

            while (((state_36).index < @as(u64, ((state_36).source).len))) {
                state_36 = block_60: {
                    const value_6: u64 = block_59: {
                        const operand_57 = (state_36).source;
                        const operand_58 = (state_36).index;

                        if ((operand_58 >= (operand_57).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_59 (operand_57)[@intCast(operand_58)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_36).result;

                    const value_2: u64 = block_56: {
                        break :block_56 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_55: {
                        const operand_48 = ((value_1).count + @as(u64, 1));

                        const operand_49 = (((value_1).total + (value_1).count) + block_50: {
                            break :block_50 value_2;
                        });

                        const operand_51 = (value_1).count;
                        const operand_52 = (value_1).labels;
                        const operand_53 = (value_1).text;
                        const operand_54 = (value_1).child;

                        break :block_55 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_48, .total = operand_49, .last = operand_51, .labels = operand_52, .text = operand_53, .child = operand_54, });
                    };

                    break :block_60 block_47: {
                        const operand_44 = (state_36).source;
                        const operand_45 = ((state_36).index + @as(u64, 1));
                        const operand_46 = value_7;

                        break :block_47 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_45, .result = operand_46, .source = operand_44, });
                    };
                };

                state_changed_43 = true;
            }

            break :block_62 (if (state_changed_43) state_36 else operand_42);
        };

        break :block_63 (value_8).result;
    };
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_91: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_90: {
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
                state_64 = block_88: {
                    const value_6: u64 = block_87: {
                        const operand_85 = (state_64).source;
                        const operand_86 = (state_64).index;

                        if ((operand_86 >= (operand_85).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_87 (operand_85)[@intCast(operand_86)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_64).result;

                    const value_2: u64 = block_84: {
                        break :block_84 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_83: {
                        const operand_76 = ((value_1).count + @as(u64, 1));

                        const operand_77 = (((value_1).total + (value_1).count) + block_78: {
                            break :block_78 value_2;
                        });

                        const operand_79 = (value_1).count;
                        const operand_80 = (value_1).labels;
                        const operand_81 = (value_1).text;
                        const operand_82 = (value_1).child;

                        break :block_83 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_76, .total = operand_77, .last = operand_79, .labels = operand_80, .text = operand_81, .child = operand_82, });
                    };

                    break :block_88 block_75: {
                        const operand_72 = (state_64).source;
                        const operand_73 = ((state_64).index + @as(u64, 1));
                        const operand_74 = value_7;

                        break :block_75 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_73, .result = operand_74, .source = operand_72, });
                    };
                };

                state_changed_71 = true;
            }

            break :block_90 (if (state_changed_71) state_64 else operand_70);
        };

        break :block_91 (value_8).result;
    };
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_126: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_125: {
            const operand_99 = block_98: {
                const operand_93 = value_3;
                const operand_94 = @as(u64, 0);
                const operand_95 = (in).seed;

                break :block_98 block_97: {
                    const operand_96 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_96).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_94, .result = operand_95, .source = operand_93, });

                    break :block_97 @as(*const (zx_abi).zx_type_16, operand_96);
                };
            };

            var state_92: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_99).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_99).result).child).value, .zx_origin = ((operand_99).result).child, }, .count = ((operand_99).result).count, .labels = ((operand_99).result).labels, .last = ((operand_99).result).last, .text = ((operand_99).result).text, .total = ((operand_99).result).total, .zx_origin = (operand_99).result, }, .source = (operand_99).source, .zx_origin = operand_99, };
            var state_changed_100 = false;

            while (((state_92).index < @as(u64, ((state_92).source).len))) {
                state_92 = block_117: {
                    const value_6: u64 = block_116: {
                        const operand_114 = (state_92).source;
                        const operand_115 = (state_92).index;

                        if ((operand_115 >= (operand_114).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_116 (operand_114)[@intCast(operand_115)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_92).result;

                    const value_2: u64 = block_113: {
                        break :block_113 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_112: {
                        const operand_105 = ((value_1).count + @as(u64, 1));

                        const operand_106 = (((value_1).total + (value_1).count) + block_107: {
                            break :block_107 value_2;
                        });

                        const operand_108 = (value_1).count;
                        const operand_109 = (value_1).labels;
                        const operand_110 = (value_1).text;
                        const operand_111 = (value_1).child;

                        break :block_112 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_105, .total = operand_106, .last = operand_108, .labels = operand_109, .text = operand_110, .child = operand_111, });
                    };

                    break :block_117 block_104: {
                        const operand_101 = (state_92).source;
                        const operand_102 = ((state_92).index + @as(u64, 1));
                        const operand_103 = value_7;

                        break :block_104 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_102, .result = operand_103, .source = operand_101, });
                    };
                };

                state_changed_100 = true;
            }

            break :block_125 (if (state_changed_100) block_124: {
                break :block_124 (if (((state_92).zx_origin != null)) (state_92).zx_origin.? else block_123: {
                    const operand_122 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_122).* = (zx_abi).zx_type_16{ .index = (state_92).index, .result = (if ((((state_92).result).zx_origin != null)) ((state_92).result).zx_origin.? else block_121: {
                        const operand_120 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_120).* = (zx_abi).zx_type_13{ .child = (if (((((state_92).result).child).zx_origin != null)) (((state_92).result).child).zx_origin.? else block_119: {
                            const operand_118 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_118).* = (zx_abi).zx_type_11{ .value = (((state_92).result).child).value, };

                            break :block_119 @as(*const (zx_abi).zx_type_11, operand_118);
                        }), .count = ((state_92).result).count, .labels = ((state_92).result).labels, .last = ((state_92).result).last, .text = ((state_92).result).text, .total = ((state_92).result).total, };

                        break :block_121 @as(*const (zx_abi).zx_type_13, operand_120);
                    }), .source = (state_92).source, };

                    break :block_123 @as(*const (zx_abi).zx_type_16, operand_122);
                });
            } else operand_99);
        };

        break :block_126 (value_8).result;
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

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_26: {
                    const value_6: u64 = block_25: {
                        const operand_23 = (state_1).source;
                        const operand_24 = (state_1).index;

                        if ((operand_24 >= (operand_23).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_25 (operand_23)[@intCast(operand_24)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_22: {
                        break :block_22 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_21: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = (((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        });

                        const operand_17 = (value_1).count;
                        const operand_18 = (value_1).labels;
                        const operand_19 = (value_1).text;
                        const operand_20 = (value_1).child;

                        break :block_21 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_17, .labels = operand_18, .text = operand_19, .child = operand_20, });
                    };

                    break :block_26 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
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

