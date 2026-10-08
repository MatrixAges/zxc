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

    return block_34: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_33: {
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

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_14: {
                        break :block_14 value_2;
                    } == @as(u64, 0))) value_1 else block_20: {
                        const operand_15 = value_1;
                        const operand_16 = ((value_1).count + @as(u64, 1));

                        const operand_17 = (((value_1).total + (value_1).count) + block_18: {
                            break :block_18 value_2;
                        });

                        const operand_19 = (value_1).count;

                        break :block_20 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_15).child, .count = operand_16, .labels = (operand_15).labels, .last = operand_19, .text = (operand_15).text, .total = operand_17, });
                    });

                    break :block_25 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_33 (if (state_changed_9) block_32: {
                break :block_32 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_31: {
                    const operand_30 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_30).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_29: {
                        const operand_28 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_28).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_27: {
                            const operand_26 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_26).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_27 @as(*const (zx_abi).zx_type_11, operand_26);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_29 @as(*const (zx_abi).zx_type_13, operand_28);
                    }), .source = (state_1).source, };

                    break :block_31 @as(*const (zx_abi).zx_type_16, operand_30);
                });
            } else operand_8);
        };

        break :block_34 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_61: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_60: {
            const operand_41 = block_40: {
                const operand_36 = block_37: {
                    break :block_37 value_3;
                };

                const operand_38 = @as(u64, 0);
                const operand_39 = (in).seed;

                break :block_40 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_38, .result = operand_39, .source = operand_36, });
            };

            var state_35: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_41;
            var state_changed_42 = false;

            while (((state_35).index < @as(u64, ((state_35).source).len))) {
                state_35 = block_58: {
                    const value_6: u64 = block_57: {
                        const operand_55 = (state_35).source;
                        const operand_56 = (state_35).index;

                        if ((operand_56 >= (operand_55).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_57 (operand_55)[@intCast(operand_56)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_35).result;

                    const value_2: u64 = block_54: {
                        break :block_54 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_47: {
                        break :block_47 value_2;
                    } == @as(u64, 0))) value_1 else block_53: {
                        const operand_48 = value_1;
                        const operand_49 = ((value_1).count + @as(u64, 1));

                        const operand_50 = (((value_1).total + (value_1).count) + block_51: {
                            break :block_51 value_2;
                        });

                        const operand_52 = (value_1).count;

                        break :block_53 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_48).child, .count = operand_49, .labels = (operand_48).labels, .last = operand_52, .text = (operand_48).text, .total = operand_50, });
                    });

                    break :block_58 block_46: {
                        const operand_43 = (state_35).source;
                        const operand_44 = ((state_35).index + @as(u64, 1));
                        const operand_45 = value_7;

                        break :block_46 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_44, .result = operand_45, .source = operand_43, });
                    };
                };

                state_changed_42 = true;
            }

            break :block_60 (if (state_changed_42) state_35 else operand_41);
        };

        break :block_61 (value_8).result;
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

    return block_88: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_87: {
            const operand_68 = block_67: {
                const operand_63 = block_64: {
                    break :block_64 value_3;
                };

                const operand_65 = @as(u64, 0);
                const operand_66 = (in).seed;

                break :block_67 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_65, .result = operand_66, .source = operand_63, });
            };

            var state_62: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_68;
            var state_changed_69 = false;

            while (((state_62).index < @as(u64, ((state_62).source).len))) {
                state_62 = block_85: {
                    const value_6: u64 = block_84: {
                        const operand_82 = (state_62).source;
                        const operand_83 = (state_62).index;

                        if ((operand_83 >= (operand_82).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_84 (operand_82)[@intCast(operand_83)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_62).result;

                    const value_2: u64 = block_81: {
                        break :block_81 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_74: {
                        break :block_74 value_2;
                    } == @as(u64, 0))) value_1 else block_80: {
                        const operand_75 = value_1;
                        const operand_76 = ((value_1).count + @as(u64, 1));

                        const operand_77 = (((value_1).total + (value_1).count) + block_78: {
                            break :block_78 value_2;
                        });

                        const operand_79 = (value_1).count;

                        break :block_80 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_75).child, .count = operand_76, .labels = (operand_75).labels, .last = operand_79, .text = (operand_75).text, .total = operand_77, });
                    });

                    break :block_85 block_73: {
                        const operand_70 = (state_62).source;
                        const operand_71 = ((state_62).index + @as(u64, 1));
                        const operand_72 = value_7;

                        break :block_73 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_71, .result = operand_72, .source = operand_70, });
                    };
                };

                state_changed_69 = true;
            }

            break :block_87 (if (state_changed_69) state_62 else operand_68);
        };

        break :block_88 (value_8).result;
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

    return block_122: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_121: {
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
                state_89 = block_113: {
                    const value_6: u64 = block_112: {
                        const operand_110 = (state_89).source;
                        const operand_111 = (state_89).index;

                        if ((operand_111 >= (operand_110).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_112 (operand_110)[@intCast(operand_111)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_89).result;

                    const value_2: u64 = block_109: {
                        break :block_109 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_102: {
                        break :block_102 value_2;
                    } == @as(u64, 0))) value_1 else block_108: {
                        const operand_103 = value_1;
                        const operand_104 = ((value_1).count + @as(u64, 1));

                        const operand_105 = (((value_1).total + (value_1).count) + block_106: {
                            break :block_106 value_2;
                        });

                        const operand_107 = (value_1).count;

                        break :block_108 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_103).child, .count = operand_104, .labels = (operand_103).labels, .last = operand_107, .text = (operand_103).text, .total = operand_105, });
                    });

                    break :block_113 block_101: {
                        const operand_98 = (state_89).source;
                        const operand_99 = ((state_89).index + @as(u64, 1));
                        const operand_100 = value_7;

                        break :block_101 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_99, .result = operand_100, .source = operand_98, });
                    };
                };

                state_changed_97 = true;
            }

            break :block_121 (if (state_changed_97) block_120: {
                break :block_120 (if (((state_89).zx_origin != null)) (state_89).zx_origin.? else block_119: {
                    const operand_118 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_118).* = (zx_abi).zx_type_16{ .index = (state_89).index, .result = (if ((((state_89).result).zx_origin != null)) ((state_89).result).zx_origin.? else block_117: {
                        const operand_116 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_116).* = (zx_abi).zx_type_13{ .child = (if (((((state_89).result).child).zx_origin != null)) (((state_89).result).child).zx_origin.? else block_115: {
                            const operand_114 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_114).* = (zx_abi).zx_type_11{ .value = (((state_89).result).child).value, };

                            break :block_115 @as(*const (zx_abi).zx_type_11, operand_114);
                        }), .count = ((state_89).result).count, .labels = ((state_89).result).labels, .last = ((state_89).result).last, .text = ((state_89).result).text, .total = ((state_89).result).total, };

                        break :block_117 @as(*const (zx_abi).zx_type_13, operand_116);
                    }), .source = (state_89).source, };

                    break :block_119 @as(*const (zx_abi).zx_type_16, operand_118);
                });
            } else operand_96);
        };

        break :block_122 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_34: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_33: {
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

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_14: {
                        break :block_14 value_2;
                    } == @as(u64, 0))) value_1 else block_20: {
                        const operand_15 = value_1;
                        const operand_16 = ((value_1).count + @as(u64, 1));

                        const operand_17 = (((value_1).total + (value_1).count) + block_18: {
                            break :block_18 value_2;
                        });

                        const operand_19 = (value_1).count;

                        break :block_20 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_15).child, .count = operand_16, .labels = (operand_15).labels, .last = operand_19, .text = (operand_15).text, .total = operand_17, });
                    });

                    break :block_25 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_33 (if (state_changed_9) block_32: {
                break :block_32 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_31: {
                    const operand_30 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_30).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_29: {
                        const operand_28 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_28).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_27: {
                            const operand_26 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_26).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_27 @as(*const (zx_abi).zx_type_11, operand_26);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_29 @as(*const (zx_abi).zx_type_13, operand_28);
                    }), .source = (state_1).source, };

                    break :block_31 @as(*const (zx_abi).zx_type_16, operand_30);
                });
            } else operand_8);
        };

        break :block_34 (value_8).result;
    };
}

