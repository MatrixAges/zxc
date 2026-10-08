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

    return block_33: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_32: {
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
                state_1 = block_24: {
                    const value_6: u64 = block_23: {
                        const operand_21 = (state_1).source;
                        const operand_22 = (state_1).index;

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_20: {
                        break :block_20 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_19: {
                        const operand_14 = value_1;
                        const operand_15 = ((value_1).count + @as(u64, 1));

                        const operand_16 = (((value_1).total + (value_1).count) + block_17: {
                            break :block_17 value_2;
                        });

                        const operand_18 = (value_1).count;

                        break :block_19 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_14).child, .count = operand_15, .labels = (operand_14).labels, .last = operand_18, .text = (operand_14).text, .total = operand_16, });
                    };

                    break :block_24 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_32 (if (state_changed_9) block_31: {
                break :block_31 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_29).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_27).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_26: {
                            const operand_25 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_25).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_26 @as(*const (zx_abi).zx_type_11, operand_25);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_28 @as(*const (zx_abi).zx_type_13, operand_27);
                    }), .source = (state_1).source, };

                    break :block_30 @as(*const (zx_abi).zx_type_16, operand_29);
                });
            } else operand_8);
        };

        break :block_33 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_59: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_58: {
            const operand_40 = block_39: {
                const operand_35 = block_36: {
                    break :block_36 value_3;
                };

                const operand_37 = @as(u64, 0);
                const operand_38 = (in).seed;

                break :block_39 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_37, .result = operand_38, .source = operand_35, });
            };

            var state_34: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_40;
            var state_changed_41 = false;

            while (((state_34).index < @as(u64, ((state_34).source).len))) {
                state_34 = block_56: {
                    const value_6: u64 = block_55: {
                        const operand_53 = (state_34).source;
                        const operand_54 = (state_34).index;

                        if ((operand_54 >= (operand_53).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_55 (operand_53)[@intCast(operand_54)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_34).result;

                    const value_2: u64 = block_52: {
                        break :block_52 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_51: {
                        const operand_46 = value_1;
                        const operand_47 = ((value_1).count + @as(u64, 1));

                        const operand_48 = (((value_1).total + (value_1).count) + block_49: {
                            break :block_49 value_2;
                        });

                        const operand_50 = (value_1).count;

                        break :block_51 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_46).child, .count = operand_47, .labels = (operand_46).labels, .last = operand_50, .text = (operand_46).text, .total = operand_48, });
                    };

                    break :block_56 block_45: {
                        const operand_42 = (state_34).source;
                        const operand_43 = ((state_34).index + @as(u64, 1));
                        const operand_44 = value_7;

                        break :block_45 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_43, .result = operand_44, .source = operand_42, });
                    };
                };

                state_changed_41 = true;
            }

            break :block_58 (if (state_changed_41) state_34 else operand_40);
        };

        break :block_59 (value_8).result;
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

    return block_85: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_84: {
            const operand_66 = block_65: {
                const operand_61 = block_62: {
                    break :block_62 value_3;
                };

                const operand_63 = @as(u64, 0);
                const operand_64 = (in).seed;

                break :block_65 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_63, .result = operand_64, .source = operand_61, });
            };

            var state_60: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_66;
            var state_changed_67 = false;

            while (((state_60).index < @as(u64, ((state_60).source).len))) {
                state_60 = block_82: {
                    const value_6: u64 = block_81: {
                        const operand_79 = (state_60).source;
                        const operand_80 = (state_60).index;

                        if ((operand_80 >= (operand_79).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_81 (operand_79)[@intCast(operand_80)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_60).result;

                    const value_2: u64 = block_78: {
                        break :block_78 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_77: {
                        const operand_72 = value_1;
                        const operand_73 = ((value_1).count + @as(u64, 1));

                        const operand_74 = (((value_1).total + (value_1).count) + block_75: {
                            break :block_75 value_2;
                        });

                        const operand_76 = (value_1).count;

                        break :block_77 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_72).child, .count = operand_73, .labels = (operand_72).labels, .last = operand_76, .text = (operand_72).text, .total = operand_74, });
                    };

                    break :block_82 block_71: {
                        const operand_68 = (state_60).source;
                        const operand_69 = ((state_60).index + @as(u64, 1));
                        const operand_70 = value_7;

                        break :block_71 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_69, .result = operand_70, .source = operand_68, });
                    };
                };

                state_changed_67 = true;
            }

            break :block_84 (if (state_changed_67) state_60 else operand_66);
        };

        break :block_85 (value_8).result;
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

    return block_118: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_117: {
            const operand_93 = block_92: {
                const operand_87 = value_3;
                const operand_88 = @as(u64, 0);
                const operand_89 = (in).seed;

                break :block_92 block_91: {
                    const operand_90 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_90).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_88, .result = operand_89, .source = operand_87, });

                    break :block_91 @as(*const (zx_abi).zx_type_16, operand_90);
                };
            };

            var state_86: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_93).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_93).result).child).value, .zx_origin = ((operand_93).result).child, }, .count = ((operand_93).result).count, .labels = ((operand_93).result).labels, .last = ((operand_93).result).last, .text = ((operand_93).result).text, .total = ((operand_93).result).total, .zx_origin = (operand_93).result, }, .source = (operand_93).source, .zx_origin = operand_93, };
            var state_changed_94 = false;

            while (((state_86).index < @as(u64, ((state_86).source).len))) {
                state_86 = block_109: {
                    const value_6: u64 = block_108: {
                        const operand_106 = (state_86).source;
                        const operand_107 = (state_86).index;

                        if ((operand_107 >= (operand_106).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_108 (operand_106)[@intCast(operand_107)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_86).result;

                    const value_2: u64 = block_105: {
                        break :block_105 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_104: {
                        const operand_99 = value_1;
                        const operand_100 = ((value_1).count + @as(u64, 1));

                        const operand_101 = (((value_1).total + (value_1).count) + block_102: {
                            break :block_102 value_2;
                        });

                        const operand_103 = (value_1).count;

                        break :block_104 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_99).child, .count = operand_100, .labels = (operand_99).labels, .last = operand_103, .text = (operand_99).text, .total = operand_101, });
                    };

                    break :block_109 block_98: {
                        const operand_95 = (state_86).source;
                        const operand_96 = ((state_86).index + @as(u64, 1));
                        const operand_97 = value_7;

                        break :block_98 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_96, .result = operand_97, .source = operand_95, });
                    };
                };

                state_changed_94 = true;
            }

            break :block_117 (if (state_changed_94) block_116: {
                break :block_116 (if (((state_86).zx_origin != null)) (state_86).zx_origin.? else block_115: {
                    const operand_114 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_114).* = (zx_abi).zx_type_16{ .index = (state_86).index, .result = (if ((((state_86).result).zx_origin != null)) ((state_86).result).zx_origin.? else block_113: {
                        const operand_112 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_112).* = (zx_abi).zx_type_13{ .child = (if (((((state_86).result).child).zx_origin != null)) (((state_86).result).child).zx_origin.? else block_111: {
                            const operand_110 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_110).* = (zx_abi).zx_type_11{ .value = (((state_86).result).child).value, };

                            break :block_111 @as(*const (zx_abi).zx_type_11, operand_110);
                        }), .count = ((state_86).result).count, .labels = ((state_86).result).labels, .last = ((state_86).result).last, .text = ((state_86).result).text, .total = ((state_86).result).total, };

                        break :block_113 @as(*const (zx_abi).zx_type_13, operand_112);
                    }), .source = (state_86).source, };

                    break :block_115 @as(*const (zx_abi).zx_type_16, operand_114);
                });
            } else operand_93);
        };

        break :block_118 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_33: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_32: {
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
                state_1 = block_24: {
                    const value_6: u64 = block_23: {
                        const operand_21 = (state_1).source;
                        const operand_22 = (state_1).index;

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_20: {
                        break :block_20 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_19: {
                        const operand_14 = value_1;
                        const operand_15 = ((value_1).count + @as(u64, 1));

                        const operand_16 = (((value_1).total + (value_1).count) + block_17: {
                            break :block_17 value_2;
                        });

                        const operand_18 = (value_1).count;

                        break :block_19 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_14).child, .count = operand_15, .labels = (operand_14).labels, .last = operand_18, .text = (operand_14).text, .total = operand_16, });
                    };

                    break :block_24 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_32 (if (state_changed_9) block_31: {
                break :block_31 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_29).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_27).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_26: {
                            const operand_25 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_25).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_26 @as(*const (zx_abi).zx_type_11, operand_25);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_28 @as(*const (zx_abi).zx_type_13, operand_27);
                    }), .source = (state_1).source, };

                    break :block_30 @as(*const (zx_abi).zx_type_16, operand_29);
                });
            } else operand_8);
        };

        break :block_33 (value_8).result;
    };
}

