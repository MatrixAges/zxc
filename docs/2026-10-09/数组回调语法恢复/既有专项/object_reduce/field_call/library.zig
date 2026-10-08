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

fn function_0(allocator: ((std).mem).Allocator, in: u64) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
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

            const state_type_10 = struct {
                value: u64,
            };
            const state_type_11 = struct {
                child: state_type_10,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_12 = struct {
                index: u64,
                result: state_type_11,
                source: []const u64,
            };

            var state_1: state_type_12 = state_type_12{ .index = (operand_8).index, .result = state_type_11{ .child = state_type_10{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
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

                    const value_1: state_type_11 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_11 = block_21: {
                        const operand_17 = value_1;
                        const operand_18 = ((value_1).count + @as(u64, 1));
                        const operand_19 = (((try function_0(allocator, (value_1).total)) + (value_1).count) + value_2);
                        const operand_20 = (value_1).count;

                        break :block_21 state_type_11{ .child = (operand_17).child, .count = operand_18, .labels = (operand_17).labels, .last = operand_20, .text = (operand_17).text, .total = operand_19, };
                    };

                    break :block_25 block_16: {
                        const operand_13 = (state_1).source;
                        const operand_14 = ((state_1).index + @as(u64, 1));
                        const operand_15 = value_7;

                        break :block_16 state_type_12{ .index = operand_14, .result = operand_15, .source = operand_13, };
                    };
                };

                state_changed_9 = true;
            }

            break :block_33 (if (state_changed_9) block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_31).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_27).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_28 @as(*const (zx_abi).zx_type_11, operand_27);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                }, .source = (state_1).source, });

                break :block_32 @as(*const (zx_abi).zx_type_16, operand_31);
            } else operand_8);
        };

        break :block_34 (value_8).result;
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    return block_62: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_61: {
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
                state_35 = block_59: {
                    const value_6: u64 = block_58: {
                        const operand_56 = (state_35).source;
                        const operand_57 = (state_35).index;

                        if ((operand_57 >= (operand_56).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_58 (operand_56)[@intCast(operand_57)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_35).result;

                    const value_2: u64 = block_55: {
                        break :block_55 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_54: {
                        const operand_47 = value_1;
                        const operand_48 = ((value_1).count + @as(u64, 1));

                        const operand_49 = ((block_51: {
                            const operand_50 = (value_1).total;

                            break :block_51 (try function_0(allocator, operand_50));
                        } + (value_1).count) + block_52: {
                            break :block_52 value_2;
                        });

                        const operand_53 = (value_1).count;

                        break :block_54 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_47).child, .count = operand_48, .labels = (operand_47).labels, .last = operand_53, .text = (operand_47).text, .total = operand_49, });
                    };

                    break :block_59 block_46: {
                        const operand_43 = (state_35).source;
                        const operand_44 = ((state_35).index + @as(u64, 1));
                        const operand_45 = value_7;

                        break :block_46 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_44, .result = operand_45, .source = operand_43, });
                    };
                };

                state_changed_42 = true;
            }

            break :block_61 (if (state_changed_42) state_35 else operand_41);
        };

        break :block_62 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_90: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_89: {
            const operand_69 = block_68: {
                const operand_64 = block_65: {
                    break :block_65 value_3;
                };

                const operand_66 = @as(u64, 0);
                const operand_67 = (in).seed;

                break :block_68 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_66, .result = operand_67, .source = operand_64, });
            };

            var state_63: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_69;
            var state_changed_70 = false;

            while (((state_63).index < @as(u64, ((state_63).source).len))) {
                state_63 = block_87: {
                    const value_6: u64 = block_86: {
                        const operand_84 = (state_63).source;
                        const operand_85 = (state_63).index;

                        if ((operand_85 >= (operand_84).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_86 (operand_84)[@intCast(operand_85)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_63).result;

                    const value_2: u64 = block_83: {
                        break :block_83 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_82: {
                        const operand_75 = value_1;
                        const operand_76 = ((value_1).count + @as(u64, 1));

                        const operand_77 = ((block_79: {
                            const operand_78 = (value_1).total;

                            break :block_79 (try function_0(allocator, operand_78));
                        } + (value_1).count) + block_80: {
                            break :block_80 value_2;
                        });

                        const operand_81 = (value_1).count;

                        break :block_82 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_75).child, .count = operand_76, .labels = (operand_75).labels, .last = operand_81, .text = (operand_75).text, .total = operand_77, });
                    };

                    break :block_87 block_74: {
                        const operand_71 = (state_63).source;
                        const operand_72 = ((state_63).index + @as(u64, 1));
                        const operand_73 = value_7;

                        break :block_74 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_72, .result = operand_73, .source = operand_71, });
                    };
                };

                state_changed_70 = true;
            }

            break :block_89 (if (state_changed_70) state_63 else operand_69);
        };

        break :block_90 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_124: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_123: {
            const operand_98 = block_97: {
                const operand_92 = value_3;
                const operand_93 = @as(u64, 0);
                const operand_94 = (in).seed;

                break :block_97 block_96: {
                    const operand_95 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_95).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_93, .result = operand_94, .source = operand_92, });

                    break :block_96 @as(*const (zx_abi).zx_type_16, operand_95);
                };
            };
            const state_type_100 = struct {
                value: u64,
            };
            const state_type_101 = struct {
                child: state_type_100,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_102 = struct {
                index: u64,
                result: state_type_101,
                source: []const u64,
            };

            var state_91: state_type_102 = state_type_102{ .index = (operand_98).index, .result = state_type_101{ .child = state_type_100{ .value = (((operand_98).result).child).value, }, .count = ((operand_98).result).count, .labels = ((operand_98).result).labels, .last = ((operand_98).result).last, .text = ((operand_98).result).text, .total = ((operand_98).result).total, }, .source = (operand_98).source, };
            var state_changed_99 = false;

            while (((state_91).index < @as(u64, ((state_91).source).len))) {
                state_91 = block_115: {
                    const value_6: u64 = block_114: {
                        const operand_112 = (state_91).source;
                        const operand_113 = (state_91).index;

                        if ((operand_113 >= (operand_112).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_114 (operand_112)[@intCast(operand_113)];
                    };

                    const value_1: state_type_101 = (state_91).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_101 = block_111: {
                        const operand_107 = value_1;
                        const operand_108 = ((value_1).count + @as(u64, 1));
                        const operand_109 = (((try function_0(allocator, (value_1).total)) + (value_1).count) + value_2);
                        const operand_110 = (value_1).count;

                        break :block_111 state_type_101{ .child = (operand_107).child, .count = operand_108, .labels = (operand_107).labels, .last = operand_110, .text = (operand_107).text, .total = operand_109, };
                    };

                    break :block_115 block_106: {
                        const operand_103 = (state_91).source;
                        const operand_104 = ((state_91).index + @as(u64, 1));
                        const operand_105 = value_7;

                        break :block_106 state_type_102{ .index = operand_104, .result = operand_105, .source = operand_103, };
                    };
                };

                state_changed_99 = true;
            }

            break :block_123 (if (state_changed_99) block_122: {
                const operand_121 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_121).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_91).index, .result = block_120: {
                    const operand_119 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_119).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_118: {
                        const operand_117 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_117).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_91).result).child).value, });

                        break :block_118 @as(*const (zx_abi).zx_type_11, operand_117);
                    }, .count = ((state_91).result).count, .labels = ((state_91).result).labels, .last = ((state_91).result).last, .text = ((state_91).result).text, .total = ((state_91).result).total, });

                    break :block_120 @as(*const (zx_abi).zx_type_13, operand_119);
                }, .source = (state_91).source, });

                break :block_122 @as(*const (zx_abi).zx_type_16, operand_121);
            } else operand_98);
        };

        break :block_124 (value_8).result;
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

            const state_type_10 = struct {
                value: u64,
            };
            const state_type_11 = struct {
                child: state_type_10,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_12 = struct {
                index: u64,
                result: state_type_11,
                source: []const u64,
            };

            var state_1: state_type_12 = state_type_12{ .index = (operand_8).index, .result = state_type_11{ .child = state_type_10{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
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

                    const value_1: state_type_11 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_11 = block_21: {
                        const operand_17 = value_1;
                        const operand_18 = ((value_1).count + @as(u64, 1));
                        const operand_19 = (((try function_0(allocator, (value_1).total)) + (value_1).count) + value_2);
                        const operand_20 = (value_1).count;

                        break :block_21 state_type_11{ .child = (operand_17).child, .count = operand_18, .labels = (operand_17).labels, .last = operand_20, .text = (operand_17).text, .total = operand_19, };
                    };

                    break :block_25 block_16: {
                        const operand_13 = (state_1).source;
                        const operand_14 = ((state_1).index + @as(u64, 1));
                        const operand_15 = value_7;

                        break :block_16 state_type_12{ .index = operand_14, .result = operand_15, .source = operand_13, };
                    };
                };

                state_changed_9 = true;
            }

            break :block_33 (if (state_changed_9) block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_31).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_27).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_28 @as(*const (zx_abi).zx_type_11, operand_27);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                }, .source = (state_1).source, });

                break :block_32 @as(*const (zx_abi).zx_type_16, operand_31);
            } else operand_8);
        };

        break :block_34 (value_8).result;
    };
}

