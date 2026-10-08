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

    return block_43: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_42: {
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
                state_1 = block_34: {
                    const value_6: u64 = block_33: {
                        const operand_31 = (state_1).source;
                        const operand_32 = (state_1).index;

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_30: {
                        break :block_30 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_29: {
                        break :block_29 value_2;
                    } == @as(u64, 0))) value_1 else (if ((@rem(block_22: {
                        break :block_22 value_2;
                    }, @as(u64, 2)) == @as(u64, 0))) block_28: {
                        const operand_23 = value_1;
                        const operand_24 = ((value_1).count + @as(u64, 1));

                        const operand_25 = (((value_1).total + (value_1).count) + block_26: {
                            break :block_26 value_2;
                        });

                        const operand_27 = (value_1).count;

                        break :block_28 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_23).child, .count = operand_24, .labels = (operand_23).labels, .last = operand_27, .text = (operand_23).text, .total = operand_25, });
                    } else block_21: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = (((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        });

                        const operand_17 = (value_1).count;
                        const operand_18 = (value_1).labels;
                        const operand_19 = (value_1).text;
                        const operand_20 = (value_1).child;

                        break :block_21 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_17, .labels = operand_18, .text = operand_19, .child = operand_20, });
                    }));

                    break :block_34 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_42 (if (state_changed_9) block_41: {
                break :block_41 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_40: {
                    const operand_39 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_39).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_38: {
                        const operand_37 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_37).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_36: {
                            const operand_35 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_35).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_36 @as(*const (zx_abi).zx_type_11, operand_35);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_38 @as(*const (zx_abi).zx_type_13, operand_37);
                    }), .source = (state_1).source, };

                    break :block_40 @as(*const (zx_abi).zx_type_16, operand_39);
                });
            } else operand_8);
        };

        break :block_43 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_79: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_78: {
            const operand_50 = block_49: {
                const operand_45 = block_46: {
                    break :block_46 value_3;
                };

                const operand_47 = @as(u64, 0);
                const operand_48 = (in).seed;

                break :block_49 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_47, .result = operand_48, .source = operand_45, });
            };

            var state_44: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_50;
            var state_changed_51 = false;

            while (((state_44).index < @as(u64, ((state_44).source).len))) {
                state_44 = block_76: {
                    const value_6: u64 = block_75: {
                        const operand_73 = (state_44).source;
                        const operand_74 = (state_44).index;

                        if ((operand_74 >= (operand_73).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_75 (operand_73)[@intCast(operand_74)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_44).result;

                    const value_2: u64 = block_72: {
                        break :block_72 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_71: {
                        break :block_71 value_2;
                    } == @as(u64, 0))) value_1 else (if ((@rem(block_64: {
                        break :block_64 value_2;
                    }, @as(u64, 2)) == @as(u64, 0))) block_70: {
                        const operand_65 = value_1;
                        const operand_66 = ((value_1).count + @as(u64, 1));

                        const operand_67 = (((value_1).total + (value_1).count) + block_68: {
                            break :block_68 value_2;
                        });

                        const operand_69 = (value_1).count;

                        break :block_70 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_65).child, .count = operand_66, .labels = (operand_65).labels, .last = operand_69, .text = (operand_65).text, .total = operand_67, });
                    } else block_63: {
                        const operand_56 = ((value_1).count + @as(u64, 1));

                        const operand_57 = (((value_1).total + (value_1).count) + block_58: {
                            break :block_58 value_2;
                        });

                        const operand_59 = (value_1).count;
                        const operand_60 = (value_1).labels;
                        const operand_61 = (value_1).text;
                        const operand_62 = (value_1).child;

                        break :block_63 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_56, .total = operand_57, .last = operand_59, .labels = operand_60, .text = operand_61, .child = operand_62, });
                    }));

                    break :block_76 block_55: {
                        const operand_52 = (state_44).source;
                        const operand_53 = ((state_44).index + @as(u64, 1));
                        const operand_54 = value_7;

                        break :block_55 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_53, .result = operand_54, .source = operand_52, });
                    };
                };

                state_changed_51 = true;
            }

            break :block_78 (if (state_changed_51) state_44 else operand_50);
        };

        break :block_79 (value_8).result;
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

    return block_115: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_114: {
            const operand_86 = block_85: {
                const operand_81 = block_82: {
                    break :block_82 value_3;
                };

                const operand_83 = @as(u64, 0);
                const operand_84 = (in).seed;

                break :block_85 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_83, .result = operand_84, .source = operand_81, });
            };

            var state_80: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_86;
            var state_changed_87 = false;

            while (((state_80).index < @as(u64, ((state_80).source).len))) {
                state_80 = block_112: {
                    const value_6: u64 = block_111: {
                        const operand_109 = (state_80).source;
                        const operand_110 = (state_80).index;

                        if ((operand_110 >= (operand_109).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_111 (operand_109)[@intCast(operand_110)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_80).result;

                    const value_2: u64 = block_108: {
                        break :block_108 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_107: {
                        break :block_107 value_2;
                    } == @as(u64, 0))) value_1 else (if ((@rem(block_100: {
                        break :block_100 value_2;
                    }, @as(u64, 2)) == @as(u64, 0))) block_106: {
                        const operand_101 = value_1;
                        const operand_102 = ((value_1).count + @as(u64, 1));

                        const operand_103 = (((value_1).total + (value_1).count) + block_104: {
                            break :block_104 value_2;
                        });

                        const operand_105 = (value_1).count;

                        break :block_106 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_101).child, .count = operand_102, .labels = (operand_101).labels, .last = operand_105, .text = (operand_101).text, .total = operand_103, });
                    } else block_99: {
                        const operand_92 = ((value_1).count + @as(u64, 1));

                        const operand_93 = (((value_1).total + (value_1).count) + block_94: {
                            break :block_94 value_2;
                        });

                        const operand_95 = (value_1).count;
                        const operand_96 = (value_1).labels;
                        const operand_97 = (value_1).text;
                        const operand_98 = (value_1).child;

                        break :block_99 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_92, .total = operand_93, .last = operand_95, .labels = operand_96, .text = operand_97, .child = operand_98, });
                    }));

                    break :block_112 block_91: {
                        const operand_88 = (state_80).source;
                        const operand_89 = ((state_80).index + @as(u64, 1));
                        const operand_90 = value_7;

                        break :block_91 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_89, .result = operand_90, .source = operand_88, });
                    };
                };

                state_changed_87 = true;
            }

            break :block_114 (if (state_changed_87) state_80 else operand_86);
        };

        break :block_115 (value_8).result;
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

    return block_158: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_157: {
            const operand_123 = block_122: {
                const operand_117 = value_3;
                const operand_118 = @as(u64, 0);
                const operand_119 = (in).seed;

                break :block_122 block_121: {
                    const operand_120 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_120).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_118, .result = operand_119, .source = operand_117, });

                    break :block_121 @as(*const (zx_abi).zx_type_16, operand_120);
                };
            };

            var state_116: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_123).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_123).result).child).value, .zx_origin = ((operand_123).result).child, }, .count = ((operand_123).result).count, .labels = ((operand_123).result).labels, .last = ((operand_123).result).last, .text = ((operand_123).result).text, .total = ((operand_123).result).total, .zx_origin = (operand_123).result, }, .source = (operand_123).source, .zx_origin = operand_123, };
            var state_changed_124 = false;

            while (((state_116).index < @as(u64, ((state_116).source).len))) {
                state_116 = block_149: {
                    const value_6: u64 = block_148: {
                        const operand_146 = (state_116).source;
                        const operand_147 = (state_116).index;

                        if ((operand_147 >= (operand_146).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_148 (operand_146)[@intCast(operand_147)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_116).result;

                    const value_2: u64 = block_145: {
                        break :block_145 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_144: {
                        break :block_144 value_2;
                    } == @as(u64, 0))) value_1 else (if ((@rem(block_137: {
                        break :block_137 value_2;
                    }, @as(u64, 2)) == @as(u64, 0))) block_143: {
                        const operand_138 = value_1;
                        const operand_139 = ((value_1).count + @as(u64, 1));

                        const operand_140 = (((value_1).total + (value_1).count) + block_141: {
                            break :block_141 value_2;
                        });

                        const operand_142 = (value_1).count;

                        break :block_143 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_138).child, .count = operand_139, .labels = (operand_138).labels, .last = operand_142, .text = (operand_138).text, .total = operand_140, });
                    } else block_136: {
                        const operand_129 = ((value_1).count + @as(u64, 1));

                        const operand_130 = (((value_1).total + (value_1).count) + block_131: {
                            break :block_131 value_2;
                        });

                        const operand_132 = (value_1).count;
                        const operand_133 = (value_1).labels;
                        const operand_134 = (value_1).text;
                        const operand_135 = (value_1).child;

                        break :block_136 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_129, .total = operand_130, .last = operand_132, .labels = operand_133, .text = operand_134, .child = operand_135, });
                    }));

                    break :block_149 block_128: {
                        const operand_125 = (state_116).source;
                        const operand_126 = ((state_116).index + @as(u64, 1));
                        const operand_127 = value_7;

                        break :block_128 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_126, .result = operand_127, .source = operand_125, });
                    };
                };

                state_changed_124 = true;
            }

            break :block_157 (if (state_changed_124) block_156: {
                break :block_156 (if (((state_116).zx_origin != null)) (state_116).zx_origin.? else block_155: {
                    const operand_154 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_154).* = (zx_abi).zx_type_16{ .index = (state_116).index, .result = (if ((((state_116).result).zx_origin != null)) ((state_116).result).zx_origin.? else block_153: {
                        const operand_152 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_152).* = (zx_abi).zx_type_13{ .child = (if (((((state_116).result).child).zx_origin != null)) (((state_116).result).child).zx_origin.? else block_151: {
                            const operand_150 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_150).* = (zx_abi).zx_type_11{ .value = (((state_116).result).child).value, };

                            break :block_151 @as(*const (zx_abi).zx_type_11, operand_150);
                        }), .count = ((state_116).result).count, .labels = ((state_116).result).labels, .last = ((state_116).result).last, .text = ((state_116).result).text, .total = ((state_116).result).total, };

                        break :block_153 @as(*const (zx_abi).zx_type_13, operand_152);
                    }), .source = (state_116).source, };

                    break :block_155 @as(*const (zx_abi).zx_type_16, operand_154);
                });
            } else operand_123);
        };

        break :block_158 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_43: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_42: {
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
                state_1 = block_34: {
                    const value_6: u64 = block_33: {
                        const operand_31 = (state_1).source;
                        const operand_32 = (state_1).index;

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_30: {
                        break :block_30 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (if ((block_29: {
                        break :block_29 value_2;
                    } == @as(u64, 0))) value_1 else (if ((@rem(block_22: {
                        break :block_22 value_2;
                    }, @as(u64, 2)) == @as(u64, 0))) block_28: {
                        const operand_23 = value_1;
                        const operand_24 = ((value_1).count + @as(u64, 1));

                        const operand_25 = (((value_1).total + (value_1).count) + block_26: {
                            break :block_26 value_2;
                        });

                        const operand_27 = (value_1).count;

                        break :block_28 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_23).child, .count = operand_24, .labels = (operand_23).labels, .last = operand_27, .text = (operand_23).text, .total = operand_25, });
                    } else block_21: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = (((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        });

                        const operand_17 = (value_1).count;
                        const operand_18 = (value_1).labels;
                        const operand_19 = (value_1).text;
                        const operand_20 = (value_1).child;

                        break :block_21 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_17, .labels = operand_18, .text = operand_19, .child = operand_20, });
                    }));

                    break :block_34 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_42 (if (state_changed_9) block_41: {
                break :block_41 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_40: {
                    const operand_39 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_39).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_38: {
                        const operand_37 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_37).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_36: {
                            const operand_35 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_35).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_36 @as(*const (zx_abi).zx_type_11, operand_35);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_38 @as(*const (zx_abi).zx_type_13, operand_37);
                    }), .source = (state_1).source, };

                    break :block_40 @as(*const (zx_abi).zx_type_16, operand_39);
                });
            } else operand_8);
        };

        break :block_43 (value_8).result;
    };
}

