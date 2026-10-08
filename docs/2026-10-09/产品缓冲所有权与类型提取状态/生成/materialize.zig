const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
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
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .field_names = zx_shape_14, .field_types = zx_shape_13, .first = zx_shape_13, .kinds = zx_shape_12, .labels = zx_shape_14, .names = zx_shape_14, .second = zx_shape_13, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .base = zx_shape_15, .delta = zx_shape_15, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .names = zx_shape_14, .types = zx_shape_13, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .fields = zx_shape_18, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .second = zx_shape_4, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .id = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .kinds = zx_shape_12, .members = zx_shape_14, .owners = zx_shape_14, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .base = zx_shape_23, .delta = zx_shape_23, }, };
const zx_shape_25 = .{ .kind = .scalar, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_25, }, };
const zx_shape_27 = .{ .kind = .scalar, };
const zx_shape_28 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .origins = zx_shape_28, .status = zx_shape_27, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .maximum_count = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .plan = zx_shape_29, .table = zx_shape_15, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .member = zx_shape_5, .plan = zx_shape_29, .source = zx_shape_15, .table = zx_shape_15, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .origins = zx_shape_23, .plan = zx_shape_29, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .origins = zx_shape_23, .plan = zx_shape_29, .source = zx_shape_23, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .origins = zx_shape_23, .table = zx_shape_15, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .origins = zx_shape_23, .plan = zx_shape_29, .table = zx_shape_15, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_39, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_39, .@"1" = zx_shape_15, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_39, .@"1" = zx_shape_15, .@"2" = zx_shape_23, }, };
pub const input_shape = zx_shape_39;
pub const output_shape = zx_shape_38;
pub const Input = *const (zx_abi).zx_type_39;
pub const Output = *const (zx_abi).zx_type_38;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u8) error{ }!u64 {
    const native_result = (zx_native_0).widenByte(in);

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_162: {
        const operand_144 = block_145: {
            break :block_145 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_146 = block_147: {
            break :block_147 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_148 = block_149: {
            break :block_149 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_150 = block_151: {
            break :block_151 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_152 = block_153: {
            break :block_153 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_154 = block_155: {
            break :block_155 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_156 = block_157: {
            break :block_157 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_158 = block_159: {
            break :block_159 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_162 block_161: {
            const operand_160 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_160).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_144, .first = operand_146, .second = operand_148, .labels = operand_150, .children = operand_152, .field_types = operand_154, .field_names = operand_156, .names = operand_158, });

            break :block_161 @as(*const (zx_abi).zx_type_15, operand_160);
        };
    };

    const value_55: *const (zx_abi).zx_type_32 = block_143: {
        const operand_10 = block_9: {
            const operand_2 = (in).table;
            const operand_3 = (in).plan;
            const operand_4 = value_1;
            const operand_5 = @as(u64, 0);
            const operand_6 = @as(u64, 0);

            break :block_9 block_8: {
                const operand_7 = (try (allocator).create((zx_abi).zx_type_32));

                (operand_7).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .source = operand_2, .plan = operand_3, .table = operand_4, .index = operand_5, .member = operand_6, });

                break :block_8 @as(*const (zx_abi).zx_type_32, operand_7);
            };
        };

        var state_capacity_12: (std).ArrayList(u32) = .empty;
        var state_capacity_started_13 = false;

        defer (state_capacity_12).deinit(allocator);

        var state_capacity_14: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_15 = false;

        defer (state_capacity_14).deinit(allocator);

        var state_capacity_16: (std).ArrayList(u32) = .empty;
        var state_capacity_started_17 = false;

        defer (state_capacity_16).deinit(allocator);

        var state_capacity_18: (std).ArrayList(u32) = .empty;
        var state_capacity_started_19 = false;

        defer (state_capacity_18).deinit(allocator);

        var state_capacity_20: (std).ArrayList(u8) = .empty;
        var state_capacity_started_21 = false;

        defer (state_capacity_20).deinit(allocator);

        var state_capacity_22: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_23 = false;

        defer (state_capacity_22).deinit(allocator);

        var state_capacity_24: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_25 = false;

        defer (state_capacity_24).deinit(allocator);

        var state_capacity_26: (std).ArrayList(u32) = .empty;
        var state_capacity_started_27 = false;

        defer (state_capacity_26).deinit(allocator);

        const state_type_28 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_29 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_30 = struct {
            index: u64,
            member: u64,
            plan: state_type_28,
            source: state_type_29,
            table: state_type_29,
        };

        const state_type_35 = struct { []const u32, void, };
        const state_type_48 = struct { []const []const u8, void, };
        const state_type_98 = struct { []const u8, void, };
        var state_1: state_type_30 = state_type_30{ .index = (operand_10).index, .member = (operand_10).member, .plan = state_type_28{ .count = ((operand_10).plan).count, .mapping = ((operand_10).plan).mapping, .order = ((operand_10).plan).order, .origins = ((operand_10).plan).origins, .status = ((operand_10).plan).status, }, .source = state_type_29{ .children = ((operand_10).source).children, .field_names = ((operand_10).source).field_names, .field_types = ((operand_10).source).field_types, .first = ((operand_10).source).first, .kinds = ((operand_10).source).kinds, .labels = ((operand_10).source).labels, .names = ((operand_10).source).names, .second = ((operand_10).source).second, }, .table = state_type_29{ .children = ((operand_10).table).children, .field_names = ((operand_10).table).field_names, .field_types = ((operand_10).table).field_types, .first = ((operand_10).table).first, .kinds = ((operand_10).table).kinds, .labels = ((operand_10).table).labels, .names = ((operand_10).table).names, .second = ((operand_10).table).second, }, };
        var state_changed_11 = false;

        while (((state_1).index < ((state_1).plan).count)) {
            state_1 = block_125: {
                const value_4: u64 = (try function_0(allocator, block_124: {
                    const operand_122 = ((state_1).plan).order;
                    const operand_123 = (state_1).index;

                    if ((operand_123 >= (operand_122).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_124 (operand_122)[@intCast(operand_123)];
                }));
                const value_5: u8 = block_121: {
                    const operand_119 = ((state_1).source).kinds;
                    const operand_120 = value_4;

                    if ((operand_120 >= (operand_119).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_121 (operand_119)[@intCast(operand_120)];
                };

                const value_6: (zx_abi).zx_type_11 = (try function_3(allocator, value_5));

                const value_7: u32 = block_118: {
                    const operand_116 = ((state_1).source).first;
                    const operand_117 = value_4;

                    if ((operand_117 >= (operand_116).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_118 (operand_116)[@intCast(operand_117)];
                };
                const value_8: u32 = block_115: {
                    const operand_113 = ((state_1).source).second;
                    const operand_114 = value_4;

                    if ((operand_114 >= (operand_113).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_115 (operand_113)[@intCast(operand_114)];
                };

                const value_9: bool = ((((value_6 == @as((zx_abi).zx_type_11, .Tuple)) or (value_6 == @as((zx_abi).zx_type_11, .Object))) or (value_6 == @as((zx_abi).zx_type_11, .ErrorSet))) or (value_6 == @as((zx_abi).zx_type_11, .Enumeration)));
                const value_10: bool = (((value_6 == @as((zx_abi).zx_type_11, .Optional)) or (value_6 == @as((zx_abi).zx_type_11, .List))) or (value_6 == @as((zx_abi).zx_type_11, .Task)));

                const value_11: u64 = block_112: {
                    const operand_111 = value_6;

                    break :block_112 (if ((operand_111 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, (((state_1).table).children).len) else (if ((operand_111 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((state_1).table).field_types).len) else @as(u64, (((state_1).table).names).len)));
                };
                const value_12: u32 = (if (value_10) (try function_2(allocator, (block_110: {
                    const operand_108 = ((state_1).plan).mapping;
                    const operand_109 = (try function_0(allocator, value_7));

                    if ((operand_109 >= (operand_108).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_110 (operand_108)[@intCast(operand_109)];
                } - @as(u64, 1)))) else value_7);

                const value_13: u32 = (if (value_9) (try function_2(allocator, value_11)) else value_12);

                const value_14: u32 = (if ((value_6 == @as((zx_abi).zx_type_11, .Task))) (try function_2(allocator, (block_107: {
                    const operand_105 = ((state_1).plan).mapping;
                    const operand_106 = (try function_0(allocator, value_8));

                    if ((operand_106 >= (operand_105).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_107 (operand_105)[@intCast(operand_106)];
                } - @as(u64, 1)))) else value_8);

                const value_27: state_type_30 = (if (((state_1).member == @as(u64, 0))) block_104: {
                    const value_15: state_type_30 = state_1;
                    const value_16: state_type_29 = (value_15).table;

                    const value_17: state_type_30 = block_103: {
                        break :block_103 state_type_30{ .index = (value_15).index, .member = (value_15).member, .plan = (value_15).plan, .source = (value_15).source, .table = block_102: {
                            break :block_102 state_type_29{ .children = (value_16).children, .field_names = (value_16).field_names, .field_types = (value_16).field_types, .first = (value_16).first, .kinds = (block_101: {
                                const operand_99 = ((state_1).table).kinds;
                                const operand_100 = value_5;

                                _ = (try ((std).math).add(usize, (operand_99).len, 1));

                                if ((!state_capacity_started_21)) {
                                    (try (state_capacity_20).appendSlice(allocator, operand_99));

                                    state_capacity_started_21 = true;
                                } else {
                                    ((state_capacity_20).items).len = (operand_99).len;
                                }

                                (try (state_capacity_20).append(allocator, operand_100));

                                break :block_101 @as(state_type_98, .{ (state_capacity_20).items, {}, });
                            }).@"0", .labels = (value_16).labels, .names = (value_16).names, .second = (value_16).second, };
                        }, };
                    };
                    const value_18: state_type_30 = value_17;
                    const value_19: state_type_29 = (value_18).table;

                    const value_20: state_type_30 = block_97: {
                        break :block_97 state_type_30{ .index = (value_18).index, .member = (value_18).member, .plan = (value_18).plan, .source = (value_18).source, .table = block_96: {
                            break :block_96 state_type_29{ .children = (value_19).children, .field_names = (value_19).field_names, .field_types = (value_19).field_types, .first = (block_95: {
                                const operand_93 = ((value_17).table).first;
                                const operand_94 = value_13;

                                _ = (try ((std).math).add(usize, (operand_93).len, 1));

                                if ((!state_capacity_started_19)) {
                                    (try (state_capacity_18).appendSlice(allocator, operand_93));

                                    state_capacity_started_19 = true;
                                } else {
                                    ((state_capacity_18).items).len = (operand_93).len;
                                }

                                (try (state_capacity_18).append(allocator, operand_94));

                                break :block_95 @as(state_type_35, .{ (state_capacity_18).items, {}, });
                            }).@"0", .kinds = (value_19).kinds, .labels = (value_19).labels, .names = (value_19).names, .second = (value_19).second, };
                        }, };
                    };
                    const value_21: state_type_30 = value_20;
                    const value_22: state_type_29 = (value_21).table;

                    const value_23: state_type_30 = block_92: {
                        break :block_92 state_type_30{ .index = (value_21).index, .member = (value_21).member, .plan = (value_21).plan, .source = (value_21).source, .table = block_91: {
                            break :block_91 state_type_29{ .children = (value_22).children, .field_names = (value_22).field_names, .field_types = (value_22).field_types, .first = (value_22).first, .kinds = (value_22).kinds, .labels = (value_22).labels, .names = (value_22).names, .second = (block_90: {
                                const operand_88 = ((value_20).table).second;
                                const operand_89 = value_14;

                                _ = (try ((std).math).add(usize, (operand_88).len, 1));

                                if ((!state_capacity_started_27)) {
                                    (try (state_capacity_26).appendSlice(allocator, operand_88));

                                    state_capacity_started_27 = true;
                                } else {
                                    ((state_capacity_26).items).len = (operand_88).len;
                                }

                                (try (state_capacity_26).append(allocator, operand_89));

                                break :block_90 @as(state_type_35, .{ (state_capacity_26).items, {}, });
                            }).@"0", };
                        }, };
                    };
                    const value_24: state_type_30 = value_23;
                    const value_25: state_type_29 = (value_24).table;
                    const value_26: state_type_30 = block_87: {
                        break :block_87 state_type_30{ .index = (value_24).index, .member = (value_24).member, .plan = (value_24).plan, .source = (value_24).source, .table = block_86: {
                            break :block_86 state_type_29{ .children = (value_25).children, .field_names = (value_25).field_names, .field_types = (value_25).field_types, .first = (value_25).first, .kinds = (value_25).kinds, .labels = (block_85: {
                                const operand_80 = ((value_23).table).labels;

                                const operand_84 = block_83: {
                                    const operand_81 = ((value_23).source).labels;
                                    const operand_82 = value_4;

                                    if ((operand_82 >= (operand_81).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_83 (operand_81)[@intCast(operand_82)];
                                };

                                _ = (try ((std).math).add(usize, (operand_80).len, 1));

                                if ((!state_capacity_started_23)) {
                                    (try (state_capacity_22).appendSlice(allocator, operand_80));

                                    state_capacity_started_23 = true;
                                } else {
                                    ((state_capacity_22).items).len = (operand_80).len;
                                }

                                (try (state_capacity_22).append(allocator, operand_84));

                                break :block_85 @as(state_type_48, .{ (state_capacity_22).items, {}, });
                            }).@"0", .names = (value_25).names, .second = (value_25).second, };
                        }, };
                    };

                    break :block_104 value_26;
                } else state_1);

                const value_48: state_type_30 = (if ((value_9 and ((value_27).member < (try function_0(allocator, value_8))))) block_79: {
                    const value_28: u64 = ((try function_0(allocator, value_7)) + (value_27).member);

                    const value_44: state_type_30 = (if ((value_6 == @as((zx_abi).zx_type_11, .Tuple))) block_47: {
                        const value_29: u64 = (try function_0(allocator, block_46: {
                            const operand_44 = ((value_27).source).children;
                            const operand_45 = value_28;

                            if ((operand_45 >= (operand_44).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_46 (operand_44)[@intCast(operand_45)];
                        }));

                        const value_30: state_type_30 = value_27;
                        const value_31: state_type_29 = (value_30).table;
                        const value_32: state_type_30 = block_43: {
                            break :block_43 state_type_30{ .index = (value_30).index, .member = (value_30).member, .plan = (value_30).plan, .source = (value_30).source, .table = block_42: {
                                break :block_42 state_type_29{ .children = (block_41: {
                                    const operand_36 = ((value_27).table).children;

                                    const operand_40 = (try function_2(allocator, (block_39: {
                                        const operand_37 = ((value_27).plan).mapping;
                                        const operand_38 = value_29;

                                        if ((operand_38 >= (operand_37).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_39 (operand_37)[@intCast(operand_38)];
                                    } - @as(u64, 1))));

                                    _ = (try ((std).math).add(usize, (operand_36).len, 1));

                                    if ((!state_capacity_started_13)) {
                                        (try (state_capacity_12).appendSlice(allocator, operand_36));

                                        state_capacity_started_13 = true;
                                    } else {
                                        ((state_capacity_12).items).len = (operand_36).len;
                                    }

                                    (try (state_capacity_12).append(allocator, operand_40));

                                    break :block_41 @as(state_type_35, .{ (state_capacity_12).items, {}, });
                                }).@"0", .field_names = (value_31).field_names, .field_types = (value_31).field_types, .first = (value_31).first, .kinds = (value_31).kinds, .labels = (value_31).labels, .names = (value_31).names, .second = (value_31).second, };
                            }, };
                        };

                        break :block_47 value_32;
                    } else block_78: {
                        const value_43: state_type_30 = (if ((value_6 == @as((zx_abi).zx_type_11, .Object))) block_68: {
                            const value_33: u64 = (try function_0(allocator, block_67: {
                                const operand_65 = ((value_27).source).field_types;
                                const operand_66 = value_28;

                                if ((operand_66 >= (operand_65).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_67 (operand_65)[@intCast(operand_66)];
                            }));

                            const value_34: state_type_30 = value_27;
                            const value_35: state_type_29 = (value_34).table;
                            const value_36: state_type_30 = block_64: {
                                break :block_64 state_type_30{ .index = (value_34).index, .member = (value_34).member, .plan = (value_34).plan, .source = (value_34).source, .table = block_63: {
                                    break :block_63 state_type_29{ .children = (value_35).children, .field_names = (value_35).field_names, .field_types = (block_62: {
                                        const operand_57 = ((value_27).table).field_types;

                                        const operand_61 = (try function_2(allocator, (block_60: {
                                            const operand_58 = ((value_27).plan).mapping;
                                            const operand_59 = value_33;

                                            if ((operand_59 >= (operand_58).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_60 (operand_58)[@intCast(operand_59)];
                                        } - @as(u64, 1))));

                                        _ = (try ((std).math).add(usize, (operand_57).len, 1));

                                        if ((!state_capacity_started_17)) {
                                            (try (state_capacity_16).appendSlice(allocator, operand_57));
                                            state_capacity_started_17 = true;
                                        } else {
                                            ((state_capacity_16).items).len = (operand_57).len;
                                        }

                                        (try (state_capacity_16).append(allocator, operand_61));

                                        break :block_62 @as(state_type_35, .{ (state_capacity_16).items, {}, });
                                    }).@"0", .first = (value_35).first, .kinds = (value_35).kinds, .labels = (value_35).labels, .names = (value_35).names, .second = (value_35).second, };
                                }, };
                            };
                            const value_37: state_type_30 = value_36;
                            const value_38: state_type_29 = (value_37).table;
                            const value_39: state_type_30 = block_56: {
                                break :block_56 state_type_30{ .index = (value_37).index, .member = (value_37).member, .plan = (value_37).plan, .source = (value_37).source, .table = block_55: {
                                    break :block_55 state_type_29{ .children = (value_38).children, .field_names = (block_54: {
                                        const operand_49 = ((value_36).table).field_names;

                                        const operand_53 = block_52: {
                                            const operand_50 = ((value_36).source).field_names;
                                            const operand_51 = value_28;

                                            if ((operand_51 >= (operand_50).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_52 (operand_50)[@intCast(operand_51)];
                                        };

                                        _ = (try ((std).math).add(usize, (operand_49).len, 1));

                                        if ((!state_capacity_started_15)) {
                                            (try (state_capacity_14).appendSlice(allocator, operand_49));
                                            state_capacity_started_15 = true;
                                        } else {
                                            ((state_capacity_14).items).len = (operand_49).len;
                                        }

                                        (try (state_capacity_14).append(allocator, operand_53));

                                        break :block_54 @as(state_type_48, .{ (state_capacity_14).items, {}, });
                                    }).@"0", .field_types = (value_38).field_types, .first = (value_38).first, .kinds = (value_38).kinds, .labels = (value_38).labels, .names = (value_38).names, .second = (value_38).second, };
                                }, };
                            };

                            break :block_68 value_39;
                        } else block_77: {
                            const value_40: state_type_30 = value_27;
                            const value_41: state_type_29 = (value_40).table;
                            const value_42: state_type_30 = block_76: {
                                break :block_76 state_type_30{ .index = (value_40).index, .member = (value_40).member, .plan = (value_40).plan, .source = (value_40).source, .table = block_75: {
                                    break :block_75 state_type_29{ .children = (value_41).children, .field_names = (value_41).field_names, .field_types = (value_41).field_types, .first = (value_41).first, .kinds = (value_41).kinds, .labels = (value_41).labels, .names = (block_74: {
                                        const operand_69 = ((value_27).table).names;

                                        const operand_73 = block_72: {
                                            const operand_70 = ((value_27).source).names;
                                            const operand_71 = value_28;

                                            if ((operand_71 >= (operand_70).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_72 (operand_70)[@intCast(operand_71)];
                                        };

                                        _ = (try ((std).math).add(usize, (operand_69).len, 1));

                                        if ((!state_capacity_started_25)) {
                                            (try (state_capacity_24).appendSlice(allocator, operand_69));

                                            state_capacity_started_25 = true;
                                        } else {
                                            ((state_capacity_24).items).len = (operand_69).len;
                                        }

                                        (try (state_capacity_24).append(allocator, operand_73));

                                        break :block_74 @as(state_type_48, .{ (state_capacity_24).items, {}, });
                                    }).@"0", .second = (value_41).second, };
                                }, };
                            };

                            break :block_77 value_42;
                        });

                        break :block_78 value_43;
                    });

                    const value_45: state_type_30 = value_44;
                    const value_46: u64 = (value_45).member;

                    const value_47: state_type_30 = block_34: {
                        break :block_34 state_type_30{ .index = (value_45).index, .member = (value_46 + @as(u64, 1)), .plan = (value_45).plan, .source = (value_45).source, .table = (value_45).table, };
                    };

                    break :block_79 value_47;
                } else value_27);

                const value_54: state_type_30 = (if (((!value_9) or ((value_48).member >= (try function_0(allocator, value_8))))) block_33: {
                    const value_49: state_type_30 = value_48;
                    const value_50: u64 = (value_49).index;

                    const value_51: state_type_30 = block_32: {
                        break :block_32 state_type_30{ .index = (value_50 + @as(u64, 1)), .member = (value_49).member, .plan = (value_49).plan, .source = (value_49).source, .table = (value_49).table, };
                    };
                    const value_52: state_type_30 = value_51;

                    const value_53: state_type_30 = block_31: {
                        break :block_31 state_type_30{ .index = (value_52).index, .member = @as(u64, 0), .plan = (value_52).plan, .source = (value_52).source, .table = (value_52).table, };
                    };

                    break :block_33 value_53;
                } else value_48);

                break :block_125 value_54;
            };

            state_changed_11 = true;
        }

        var state_owned_126: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_126);

        if (state_capacity_started_13) {
            ((state_capacity_12).items).len = (((state_1).table).children).len;
            state_owned_126 = (try (state_capacity_12).toOwnedSlice(allocator));
        }

        if (state_capacity_started_13) {
            ((state_1).table).children = state_owned_126;
        }

        var state_owned_127: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_127);

        if (state_capacity_started_15) {
            ((state_capacity_14).items).len = (((state_1).table).field_names).len;
            state_owned_127 = (try (state_capacity_14).toOwnedSlice(allocator));
        }

        if (state_capacity_started_15) {
            ((state_1).table).field_names = state_owned_127;
        }

        var state_owned_128: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_128);

        if (state_capacity_started_17) {
            ((state_capacity_16).items).len = (((state_1).table).field_types).len;
            state_owned_128 = (try (state_capacity_16).toOwnedSlice(allocator));
        }

        if (state_capacity_started_17) {
            ((state_1).table).field_types = state_owned_128;
        }

        var state_owned_129: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_129);

        if (state_capacity_started_19) {
            ((state_capacity_18).items).len = (((state_1).table).first).len;
            state_owned_129 = (try (state_capacity_18).toOwnedSlice(allocator));
        }

        if (state_capacity_started_19) {
            ((state_1).table).first = state_owned_129;
        }

        var state_owned_130: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_130);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = (((state_1).table).kinds).len;
            state_owned_130 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            ((state_1).table).kinds = state_owned_130;
        }

        var state_owned_131: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_131);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = (((state_1).table).labels).len;
            state_owned_131 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            ((state_1).table).labels = state_owned_131;
        }

        var state_owned_132: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_132);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = (((state_1).table).names).len;
            state_owned_132 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            ((state_1).table).names = state_owned_132;
        }

        var state_owned_133: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_133);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = (((state_1).table).second).len;
            state_owned_133 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            ((state_1).table).second = state_owned_133;
        }

        break :block_143 (if (state_changed_11) block_142: {
            const operand_141 = (try (allocator).create((zx_abi).zx_type_32));

            (operand_141).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .index = (state_1).index, .member = (state_1).member, .plan = block_136: {
                const operand_135 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_135).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_136 @as(*const (zx_abi).zx_type_29, operand_135);
            }, .source = block_138: {
                const operand_137 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_137).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).source).children, .field_names = ((state_1).source).field_names, .field_types = ((state_1).source).field_types, .first = ((state_1).source).first, .kinds = ((state_1).source).kinds, .labels = ((state_1).source).labels, .names = ((state_1).source).names, .second = ((state_1).source).second, });

                break :block_138 @as(*const (zx_abi).zx_type_15, operand_137);
            }, .table = block_140: {
                const operand_139 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_139).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).table).children, .field_names = ((state_1).table).field_names, .field_types = ((state_1).table).field_types, .first = ((state_1).table).first, .kinds = ((state_1).table).kinds, .labels = ((state_1).table).labels, .names = ((state_1).table).names, .second = ((state_1).table).second, });

                break :block_140 @as(*const (zx_abi).zx_type_15, operand_139);
            }, });

            break :block_142 @as(*const (zx_abi).zx_type_32, operand_141);
        } else operand_10);
    };

    return (value_55).table;
}

fn function_4_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_15 = block_464: {
        const operand_448 = block_449: {
            break :block_449 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_450 = block_451: {
            break :block_451 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_452 = block_453: {
            break :block_453 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_454 = block_455: {
            break :block_455 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_456 = block_457: {
            break :block_457 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_458 = block_459: {
            break :block_459 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_460 = block_461: {
            break :block_461 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_462 = block_463: {
            break :block_463 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_464 (zx_abi).zx_type_15{ .kinds = operand_448, .first = operand_450, .second = operand_452, .labels = operand_454, .children = operand_456, .field_types = operand_458, .field_names = operand_460, .names = operand_462, };
    };

    const value_55: (zx_abi).zx_type_32 = block_447: {
        const operand_170 = block_169: {
            const operand_164 = (in).table;
            const operand_165 = (in).plan;
            const operand_166 = (&value_1);
            const operand_167 = @as(u64, 0);
            const operand_168 = @as(u64, 0);

            break :block_169 (zx_abi).zx_type_32{ .source = operand_164, .plan = operand_165, .table = operand_166, .index = operand_167, .member = operand_168, };
        };

        var state_capacity_171: (std).ArrayList(u32) = .empty;
        var state_capacity_started_172 = false;

        defer (state_capacity_171).deinit(allocator);

        var state_capacity_173: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_174 = false;

        defer (state_capacity_173).deinit(allocator);

        var state_capacity_175: (std).ArrayList(u32) = .empty;
        var state_capacity_started_176 = false;

        defer (state_capacity_175).deinit(allocator);

        var state_capacity_177: (std).ArrayList(u32) = .empty;
        var state_capacity_started_178 = false;

        defer (state_capacity_177).deinit(allocator);

        var state_capacity_179: (std).ArrayList(u8) = .empty;
        var state_capacity_started_180 = false;

        defer (state_capacity_179).deinit(allocator);

        var state_capacity_181: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_182 = false;

        defer (state_capacity_181).deinit(allocator);

        var state_capacity_183: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_184 = false;

        defer (state_capacity_183).deinit(allocator);

        var state_capacity_185: (std).ArrayList(u32) = .empty;
        var state_capacity_started_186 = false;

        defer (state_capacity_185).deinit(allocator);

        var state_163: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (operand_170).index, .member = (operand_170).member, .plan = (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .count = ((operand_170).plan).count, .mapping = ((operand_170).plan).mapping, .order = ((operand_170).plan).order, .origins = ((operand_170).plan).origins, .status = ((operand_170).plan).status, .zx_origin = (operand_170).plan, }, .source = (operand_170).source, .table = (operand_170).table, .zx_origin = (&operand_170), };

        while (((state_163).index < ((state_163).plan).count)) {
            state_163 = block_418: {
                const value_4: u64 = block_417: {
                    const operand_416 = block_415: {
                        const operand_413 = ((state_163).plan).order;
                        const operand_414 = (state_163).index;

                        if ((operand_414 >= (operand_413).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_415 (operand_413)[@intCast(operand_414)];
                    };

                    break :block_417 (try function_0(allocator, operand_416));
                };
                const value_5: u8 = block_412: {
                    const operand_410 = ((state_163).source).kinds;

                    const operand_411 = block_409: {
                        break :block_409 value_4;
                    };

                    if ((operand_411 >= (operand_410).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_412 (operand_410)[@intCast(operand_411)];
                };

                const value_6: (zx_abi).zx_type_11 = block_408: {
                    const operand_407 = block_406: {
                        break :block_406 value_5;
                    };

                    break :block_408 (try function_3(allocator, operand_407));
                };
                const value_7: u32 = block_405: {
                    const operand_403 = ((state_163).source).first;

                    const operand_404 = block_402: {
                        break :block_402 value_4;
                    };

                    if ((operand_404 >= (operand_403).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_405 (operand_403)[@intCast(operand_404)];
                };
                const value_8: u32 = block_401: {
                    const operand_399 = ((state_163).source).second;

                    const operand_400 = block_398: {
                        break :block_398 value_4;
                    };

                    if ((operand_400 >= (operand_399).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_401 (operand_399)[@intCast(operand_400)];
                };

                const value_9: bool = ((((block_394: {
                    break :block_394 value_6;
                } == @as((zx_abi).zx_type_11, .Tuple)) or (block_395: {
                    break :block_395 value_6;
                } == @as((zx_abi).zx_type_11, .Object))) or (block_396: {
                    break :block_396 value_6;
                } == @as((zx_abi).zx_type_11, .ErrorSet))) or (block_397: {
                    break :block_397 value_6;
                } == @as((zx_abi).zx_type_11, .Enumeration)));

                const value_10: bool = (((block_391: {
                    break :block_391 value_6;
                } == @as((zx_abi).zx_type_11, .Optional)) or (block_392: {
                    break :block_392 value_6;
                } == @as((zx_abi).zx_type_11, .List))) or (block_393: {
                    break :block_393 value_6;
                } == @as((zx_abi).zx_type_11, .Task)));

                const value_11: u64 = block_390: {
                    const operand_389 = block_388: {
                        break :block_388 value_6;
                    };

                    break :block_390 (if ((operand_389 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, (((state_163).table).children).len) else (if ((operand_389 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((state_163).table).field_types).len) else @as(u64, (((state_163).table).names).len)));
                };
                const value_12: u32 = (if (block_378: {
                    break :block_378 value_10;
                }) block_386: {
                    const operand_385 = (block_384: {
                        const operand_382 = ((state_163).plan).mapping;

                        const operand_383 = block_381: {
                            const operand_380 = block_379: {
                                break :block_379 value_7;
                            };

                            break :block_381 (try function_0(allocator, operand_380));
                        };

                        if ((operand_383 >= (operand_382).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_384 (operand_382)[@intCast(operand_383)];
                    } - @as(u64, 1));

                    break :block_386 (try function_2(allocator, operand_385));
                } else block_387: {
                    break :block_387 value_7;
                });

                const value_13: u32 = (if (block_373: {
                    break :block_373 value_9;
                }) block_376: {
                    const operand_375 = block_374: {
                        break :block_374 value_11;
                    };

                    break :block_376 (try function_2(allocator, operand_375));
                } else block_377: {
                    break :block_377 value_12;
                });

                const value_14: u32 = (if ((block_363: {
                    break :block_363 value_6;
                } == @as((zx_abi).zx_type_11, .Task))) block_371: {
                    const operand_370 = (block_369: {
                        const operand_367 = ((state_163).plan).mapping;

                        const operand_368 = block_366: {
                            const operand_365 = block_364: {
                                break :block_364 value_8;
                            };

                            break :block_366 (try function_0(allocator, operand_365));
                        };

                        if ((operand_368 >= (operand_367).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_369 (operand_367)[@intCast(operand_368)];
                    } - @as(u64, 1));

                    break :block_371 (try function_2(allocator, operand_370));
                } else block_372: {
                    break :block_372 value_8;
                });

                const value_27: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (if (((state_163).member == @as(u64, 0))) block_362: {
                    const value_15: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = state_163;
                    const value_16: (zx_abi).zx_type_15 = ((value_15).table).*;

                    const value_17: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_361: {
                        break :block_361 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_15).index, .member = (value_15).member, .plan = (value_15).plan, .source = (value_15).source, .table = block_360: {
                            break :block_360 block_359: {
                                const operand_358 = (try (allocator).create((zx_abi).zx_type_15));

                                (operand_358).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_347: {
                                    break :block_347 (&value_16);
                                }).children, .field_names = (block_348: {
                                    break :block_348 (&value_16);
                                }).field_names, .field_types = (block_349: {
                                    break :block_349 (&value_16);
                                }).field_types, .first = (block_350: {
                                    break :block_350 (&value_16);
                                }).first, .kinds = (block_354: {
                                    const operand_351 = ((state_163).table).kinds;

                                    const operand_353 = block_352: {
                                        break :block_352 value_5;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_351).len, 1));

                                    if ((!state_capacity_started_180)) {
                                        (try (state_capacity_179).appendSlice(allocator, operand_351));

                                        state_capacity_started_180 = true;
                                    } else {
                                        ((state_capacity_179).items).len = (operand_351).len;
                                    }

                                    (try (state_capacity_179).append(allocator, operand_353));

                                    break :block_354 @as((zx_abi).value_zx_type_33_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_179).items, {}, null, });
                                }).@"0", .labels = (block_355: {
                                    break :block_355 (&value_16);
                                }).labels, .names = (block_356: {
                                    break :block_356 (&value_16);
                                }).names, .second = (block_357: {
                                    break :block_357 (&value_16);
                                }).second, });

                                break :block_359 @as(*const (zx_abi).zx_type_15, operand_358);
                            };
                        }, });
                    };
                    const value_18: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_17;
                    const value_19: (zx_abi).zx_type_15 = ((value_18).table).*;

                    const value_20: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_346: {
                        break :block_346 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_18).index, .member = (value_18).member, .plan = (value_18).plan, .source = (value_18).source, .table = block_345: {
                            break :block_345 block_344: {
                                const operand_343 = (try (allocator).create((zx_abi).zx_type_15));

                                (operand_343).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_332: {
                                    break :block_332 (&value_19);
                                }).children, .field_names = (block_333: {
                                    break :block_333 (&value_19);
                                }).field_names, .field_types = (block_334: {
                                    break :block_334 (&value_19);
                                }).field_types, .first = (block_338: {
                                    const operand_335 = ((value_17).table).first;

                                    const operand_337 = block_336: {
                                        break :block_336 value_13;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_335).len, 1));

                                    if ((!state_capacity_started_178)) {
                                        (try (state_capacity_177).appendSlice(allocator, operand_335));

                                        state_capacity_started_178 = true;
                                    } else {
                                        ((state_capacity_177).items).len = (operand_335).len;
                                    }

                                    (try (state_capacity_177).append(allocator, operand_337));

                                    break :block_338 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_177).items, {}, null, });
                                }).@"0", .kinds = (block_339: {
                                    break :block_339 (&value_19);
                                }).kinds, .labels = (block_340: {
                                    break :block_340 (&value_19);
                                }).labels, .names = (block_341: {
                                    break :block_341 (&value_19);
                                }).names, .second = (block_342: {
                                    break :block_342 (&value_19);
                                }).second, });

                                break :block_344 @as(*const (zx_abi).zx_type_15, operand_343);
                            };
                        }, });
                    };
                    const value_21: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_20;
                    const value_22: (zx_abi).zx_type_15 = ((value_21).table).*;

                    const value_23: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_331: {
                        break :block_331 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_21).index, .member = (value_21).member, .plan = (value_21).plan, .source = (value_21).source, .table = block_330: {
                            break :block_330 block_329: {
                                const operand_328 = (try (allocator).create((zx_abi).zx_type_15));

                                (operand_328).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_317: {
                                    break :block_317 (&value_22);
                                }).children, .field_names = (block_318: {
                                    break :block_318 (&value_22);
                                }).field_names, .field_types = (block_319: {
                                    break :block_319 (&value_22);
                                }).field_types, .first = (block_320: {
                                    break :block_320 (&value_22);
                                }).first, .kinds = (block_321: {
                                    break :block_321 (&value_22);
                                }).kinds, .labels = (block_322: {
                                    break :block_322 (&value_22);
                                }).labels, .names = (block_323: {
                                    break :block_323 (&value_22);
                                }).names, .second = (block_327: {
                                    const operand_324 = ((value_20).table).second;

                                    const operand_326 = block_325: {
                                        break :block_325 value_14;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_324).len, 1));

                                    if ((!state_capacity_started_186)) {
                                        (try (state_capacity_185).appendSlice(allocator, operand_324));

                                        state_capacity_started_186 = true;
                                    } else {
                                        ((state_capacity_185).items).len = (operand_324).len;
                                    }

                                    (try (state_capacity_185).append(allocator, operand_326));

                                    break :block_327 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_185).items, {}, null, });
                                }).@"0", });

                                break :block_329 @as(*const (zx_abi).zx_type_15, operand_328);
                            };
                        }, });
                    };
                    const value_24: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_23;
                    const value_25: (zx_abi).zx_type_15 = ((value_24).table).*;

                    const value_26: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_316: {
                        break :block_316 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_24).index, .member = (value_24).member, .plan = (value_24).plan, .source = (value_24).source, .table = block_315: {
                            break :block_315 block_314: {
                                const operand_313 = (try (allocator).create((zx_abi).zx_type_15));

                                (operand_313).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_299: {
                                    break :block_299 (&value_25);
                                }).children, .field_names = (block_300: {
                                    break :block_300 (&value_25);
                                }).field_names, .field_types = (block_301: {
                                    break :block_301 (&value_25);
                                }).field_types, .first = (block_302: {
                                    break :block_302 (&value_25);
                                }).first, .kinds = (block_303: {
                                    break :block_303 (&value_25);
                                }).kinds, .labels = (block_310: {
                                    const operand_304 = ((value_23).table).labels;

                                    const operand_309 = block_308: {
                                        const operand_306 = ((value_23).source).labels;

                                        const operand_307 = block_305: {
                                            break :block_305 value_4;
                                        };

                                        if ((operand_307 >= (operand_306).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_308 (operand_306)[@intCast(operand_307)];
                                    };

                                    _ = (try ((std).math).add(usize, (operand_304).len, 1));

                                    if ((!state_capacity_started_182)) {
                                        (try (state_capacity_181).appendSlice(allocator, operand_304));

                                        state_capacity_started_182 = true;
                                    } else {
                                        ((state_capacity_181).items).len = (operand_304).len;
                                    }

                                    (try (state_capacity_181).append(allocator, operand_309));
                                    break :block_310 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_181).items, {}, null, });
                                }).@"0", .names = (block_311: {
                                    break :block_311 (&value_25);
                                }).names, .second = (block_312: {
                                    break :block_312 (&value_25);
                                }).second, });

                                break :block_314 @as(*const (zx_abi).zx_type_15, operand_313);
                            };
                        }, });
                    };

                    break :block_362 value_26;
                } else state_163);

                const value_48: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (if ((block_195: {
                    break :block_195 value_9;
                } and ((value_27).member < block_198: {
                    const operand_197 = block_196: {
                        break :block_196 value_8;
                    };

                    break :block_198 (try function_0(allocator, operand_197));
                }))) block_298: {
                    const value_28: u64 = (block_297: {
                        const operand_296 = block_295: {
                            break :block_295 value_7;
                        };

                        break :block_297 (try function_0(allocator, operand_296));
                    } + (value_27).member);

                    const value_44: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (if ((block_201: {
                        break :block_201 value_6;
                    } == @as((zx_abi).zx_type_11, .Tuple))) block_228: {
                        const value_29: u64 = block_227: {
                            const operand_226 = block_225: {
                                const operand_223 = ((value_27).source).children;

                                const operand_224 = block_222: {
                                    break :block_222 value_28;
                                };

                                if ((operand_224 >= (operand_223).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_225 (operand_223)[@intCast(operand_224)];
                            };

                            break :block_227 (try function_0(allocator, operand_226));
                        };

                        const value_30: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_27;
                        const value_31: (zx_abi).zx_type_15 = ((value_30).table).*;

                        const value_32: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_221: {
                            break :block_221 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_30).index, .member = (value_30).member, .plan = (value_30).plan, .source = (value_30).source, .table = block_220: {
                                break :block_220 block_219: {
                                    const operand_218 = (try (allocator).create((zx_abi).zx_type_15));

                                    (operand_218).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_210: {
                                        const operand_202 = ((value_27).table).children;

                                        const operand_209 = block_208: {
                                            const operand_207 = (block_206: {
                                                const operand_204 = ((value_27).plan).mapping;
                                                const operand_205 = block_203: {
                                                    break :block_203 value_29;
                                                };

                                                if ((operand_205 >= (operand_204).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_206 (operand_204)[@intCast(operand_205)];
                                            } - @as(u64, 1));

                                            break :block_208 (try function_2(allocator, operand_207));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_202).len, 1));

                                        if ((!state_capacity_started_172)) {
                                            (try (state_capacity_171).appendSlice(allocator, operand_202));

                                            state_capacity_started_172 = true;
                                        } else {
                                            ((state_capacity_171).items).len = (operand_202).len;
                                        }

                                        (try (state_capacity_171).append(allocator, operand_209));

                                        break :block_210 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_171).items, {}, null, });
                                    }).@"0", .field_names = (block_211: {
                                        break :block_211 (&value_31);
                                    }).field_names, .field_types = (block_212: {
                                        break :block_212 (&value_31);
                                    }).field_types, .first = (block_213: {
                                        break :block_213 (&value_31);
                                    }).first, .kinds = (block_214: {
                                        break :block_214 (&value_31);
                                    }).kinds, .labels = (block_215: {
                                        break :block_215 (&value_31);
                                    }).labels, .names = (block_216: {
                                        break :block_216 (&value_31);
                                    }).names, .second = (block_217: {
                                        break :block_217 (&value_31);
                                    }).second, });

                                    break :block_219 @as(*const (zx_abi).zx_type_15, operand_218);
                                };
                            }, });
                        };

                        break :block_228 value_32;
                    } else block_294: {
                        const value_43: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (if ((block_229: {
                            break :block_229 value_6;
                        } == @as((zx_abi).zx_type_11, .Object))) block_274: {
                            const value_33: u64 = block_273: {
                                const operand_272 = block_271: {
                                    const operand_269 = ((value_27).source).field_types;

                                    const operand_270 = block_268: {
                                        break :block_268 value_28;
                                    };

                                    if ((operand_270 >= (operand_269).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_271 (operand_269)[@intCast(operand_270)];
                                };

                                break :block_273 (try function_0(allocator, operand_272));
                            };

                            const value_34: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_27;
                            const value_35: (zx_abi).zx_type_15 = ((value_34).table).*;

                            const value_36: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_267: {
                                break :block_267 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_34).index, .member = (value_34).member, .plan = (value_34).plan, .source = (value_34).source, .table = block_266: {
                                    break :block_266 block_265: {
                                        const operand_264 = (try (allocator).create((zx_abi).zx_type_15));

                                        (operand_264).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_248: {
                                            break :block_248 (&value_35);
                                        }).children, .field_names = (block_249: {
                                            break :block_249 (&value_35);
                                        }).field_names, .field_types = (block_258: {
                                            const operand_250 = ((value_27).table).field_types;

                                            const operand_257 = block_256: {
                                                const operand_255 = (block_254: {
                                                    const operand_252 = ((value_27).plan).mapping;
                                                    const operand_253 = block_251: {
                                                        break :block_251 value_33;
                                                    };

                                                    if ((operand_253 >= (operand_252).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    break :block_254 (operand_252)[@intCast(operand_253)];
                                                } - @as(u64, 1));

                                                break :block_256 (try function_2(allocator, operand_255));
                                            };

                                            _ = (try ((std).math).add(usize, (operand_250).len, 1));

                                            if ((!state_capacity_started_176)) {
                                                (try (state_capacity_175).appendSlice(allocator, operand_250));

                                                state_capacity_started_176 = true;
                                            } else {
                                                ((state_capacity_175).items).len = (operand_250).len;
                                            }

                                            (try (state_capacity_175).append(allocator, operand_257));

                                            break :block_258 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_175).items, {}, null, });
                                        }).@"0", .first = (block_259: {
                                            break :block_259 (&value_35);
                                        }).first, .kinds = (block_260: {
                                            break :block_260 (&value_35);
                                        }).kinds, .labels = (block_261: {
                                            break :block_261 (&value_35);
                                        }).labels, .names = (block_262: {
                                            break :block_262 (&value_35);
                                        }).names, .second = (block_263: {
                                            break :block_263 (&value_35);
                                        }).second, });

                                        break :block_265 @as(*const (zx_abi).zx_type_15, operand_264);
                                    };
                                }, });
                            };
                            const value_37: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_36;
                            const value_38: (zx_abi).zx_type_15 = ((value_37).table).*;

                            const value_39: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_247: {
                                break :block_247 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_37).index, .member = (value_37).member, .plan = (value_37).plan, .source = (value_37).source, .table = block_246: {
                                    break :block_246 block_245: {
                                        const operand_244 = (try (allocator).create((zx_abi).zx_type_15));

                                        (operand_244).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_230: {
                                            break :block_230 (&value_38);
                                        }).children, .field_names = (block_237: {
                                            const operand_231 = ((value_36).table).field_names;

                                            const operand_236 = block_235: {
                                                const operand_233 = ((value_36).source).field_names;

                                                const operand_234 = block_232: {
                                                    break :block_232 value_28;
                                                };

                                                if ((operand_234 >= (operand_233).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_235 (operand_233)[@intCast(operand_234)];
                                            };

                                            _ = (try ((std).math).add(usize, (operand_231).len, 1));

                                            if ((!state_capacity_started_174)) {
                                                (try (state_capacity_173).appendSlice(allocator, operand_231));
                                                state_capacity_started_174 = true;
                                            } else {
                                                ((state_capacity_173).items).len = (operand_231).len;
                                            }

                                            (try (state_capacity_173).append(allocator, operand_236));

                                            break :block_237 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_173).items, {}, null, });
                                        }).@"0", .field_types = (block_238: {
                                            break :block_238 (&value_38);
                                        }).field_types, .first = (block_239: {
                                            break :block_239 (&value_38);
                                        }).first, .kinds = (block_240: {
                                            break :block_240 (&value_38);
                                        }).kinds, .labels = (block_241: {
                                            break :block_241 (&value_38);
                                        }).labels, .names = (block_242: {
                                            break :block_242 (&value_38);
                                        }).names, .second = (block_243: {
                                            break :block_243 (&value_38);
                                        }).second, });

                                        break :block_245 @as(*const (zx_abi).zx_type_15, operand_244);
                                    };
                                }, });
                            };

                            break :block_274 value_39;
                        } else block_293: {
                            const value_40: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_27;
                            const value_41: (zx_abi).zx_type_15 = ((value_40).table).*;

                            const value_42: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_292: {
                                break :block_292 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_40).index, .member = (value_40).member, .plan = (value_40).plan, .source = (value_40).source, .table = block_291: {
                                    break :block_291 block_290: {
                                        const operand_289 = (try (allocator).create((zx_abi).zx_type_15));

                                        (operand_289).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (block_275: {
                                            break :block_275 (&value_41);
                                        }).children, .field_names = (block_276: {
                                            break :block_276 (&value_41);
                                        }).field_names, .field_types = (block_277: {
                                            break :block_277 (&value_41);
                                        }).field_types, .first = (block_278: {
                                            break :block_278 (&value_41);
                                        }).first, .kinds = (block_279: {
                                            break :block_279 (&value_41);
                                        }).kinds, .labels = (block_280: {
                                            break :block_280 (&value_41);
                                        }).labels, .names = (block_287: {
                                            const operand_281 = ((value_27).table).names;

                                            const operand_286 = block_285: {
                                                const operand_283 = ((value_27).source).names;
                                                const operand_284 = block_282: {
                                                    break :block_282 value_28;
                                                };

                                                if ((operand_284 >= (operand_283).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_285 (operand_283)[@intCast(operand_284)];
                                            };

                                            _ = (try ((std).math).add(usize, (operand_281).len, 1));

                                            if ((!state_capacity_started_184)) {
                                                (try (state_capacity_183).appendSlice(allocator, operand_281));
                                                state_capacity_started_184 = true;
                                            } else {
                                                ((state_capacity_183).items).len = (operand_281).len;
                                            }

                                            (try (state_capacity_183).append(allocator, operand_286));

                                            break :block_287 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_183).items, {}, null, });
                                        }).@"0", .second = (block_288: {
                                            break :block_288 (&value_41);
                                        }).second, });

                                        break :block_290 @as(*const (zx_abi).zx_type_15, operand_289);
                                    };
                                }, });
                            };

                            break :block_293 value_42;
                        });

                        break :block_294 value_43;
                    });

                    const value_45: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_44;
                    const value_46: u64 = (value_45).member;

                    const value_47: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_200: {
                        break :block_200 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_45).index, .member = (block_199: {
                            break :block_199 value_46;
                        } + @as(u64, 1)), .plan = (value_45).plan, .source = (value_45).source, .table = (value_45).table, });
                    };

                    break :block_298 value_47;
                } else value_27);

                const value_54: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = (if (((!block_187: {
                    break :block_187 value_9;
                }) or ((value_48).member >= block_190: {
                    const operand_189 = block_188: {
                        break :block_188 value_8;
                    };

                    break :block_190 (try function_0(allocator, operand_189));
                }))) block_194: {
                    const value_49: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_48;
                    const value_50: u64 = (value_49).index;

                    const value_51: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_193: {
                        break :block_193 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (block_192: {
                            break :block_192 value_50;
                        } + @as(u64, 1)), .member = (value_49).member, .plan = (value_49).plan, .source = (value_49).source, .table = (value_49).table, });
                    };

                    const value_52: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = value_51;

                    const value_53: (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = block_191: {
                        break :block_191 @as((zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235, (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (value_52).index, .member = @as(u64, 0), .plan = (value_52).plan, .source = (value_52).source, .table = (value_52).table, });
                    };

                    break :block_194 value_53;
                } else value_48);

                break :block_418 value_54;
            };
        }

        var state_owned_419: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_419);

        if (state_capacity_started_172) {
            ((state_capacity_171).items).len = (((state_163).table).children).len;
            state_owned_419 = (try (state_capacity_171).toOwnedSlice(allocator));
        }

        if (state_capacity_started_172) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_421: {
                const operand_420 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_420).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_419, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_421 @as(*const (zx_abi).zx_type_15, operand_420);
            }, };
        }

        var state_owned_422: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_422);

        if (state_capacity_started_174) {
            ((state_capacity_173).items).len = (((state_163).table).field_names).len;
            state_owned_422 = (try (state_capacity_173).toOwnedSlice(allocator));
        }

        if (state_capacity_started_174) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_424: {
                const operand_423 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_423).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = state_owned_422, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_424 @as(*const (zx_abi).zx_type_15, operand_423);
            }, };
        }

        var state_owned_425: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_425);

        if (state_capacity_started_176) {
            ((state_capacity_175).items).len = (((state_163).table).field_types).len;
            state_owned_425 = (try (state_capacity_175).toOwnedSlice(allocator));
        }

        if (state_capacity_started_176) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_427: {
                const operand_426 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_426).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = state_owned_425, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_427 @as(*const (zx_abi).zx_type_15, operand_426);
            }, };
        }

        var state_owned_428: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_428);

        if (state_capacity_started_178) {
            ((state_capacity_177).items).len = (((state_163).table).first).len;
            state_owned_428 = (try (state_capacity_177).toOwnedSlice(allocator));
        }

        if (state_capacity_started_178) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_430: {
                const operand_429 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_429).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = state_owned_428, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_430 @as(*const (zx_abi).zx_type_15, operand_429);
            }, };
        }

        var state_owned_431: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_431);

        if (state_capacity_started_180) {
            ((state_capacity_179).items).len = (((state_163).table).kinds).len;
            state_owned_431 = (try (state_capacity_179).toOwnedSlice(allocator));
        }

        if (state_capacity_started_180) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_433: {
                const operand_432 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_432).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = state_owned_431, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_433 @as(*const (zx_abi).zx_type_15, operand_432);
            }, };
        }

        var state_owned_434: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_434);

        if (state_capacity_started_182) {
            ((state_capacity_181).items).len = (((state_163).table).labels).len;
            state_owned_434 = (try (state_capacity_181).toOwnedSlice(allocator));
        }

        if (state_capacity_started_182) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_436: {
                const operand_435 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_435).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = state_owned_434, .names = ((state_163).table).names, .second = ((state_163).table).second, });

                break :block_436 @as(*const (zx_abi).zx_type_15, operand_435);
            }, };
        }

        var state_owned_437: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_437);

        if (state_capacity_started_184) {
            ((state_capacity_183).items).len = (((state_163).table).names).len;
            state_owned_437 = (try (state_capacity_183).toOwnedSlice(allocator));
        }

        if (state_capacity_started_184) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_439: {
                const operand_438 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_438).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = state_owned_437, .second = ((state_163).table).second, });

                break :block_439 @as(*const (zx_abi).zx_type_15, operand_438);
            }, };
        }

        var state_owned_440: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_440);

        if (state_capacity_started_186) {
            ((state_capacity_185).items).len = (((state_163).table).second).len;
            state_owned_440 = (try (state_capacity_185).toOwnedSlice(allocator));
        }

        if (state_capacity_started_186) {
            state_163 = (zx_abi).value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235{ .index = (state_163).index, .member = (state_163).member, .plan = (state_163).plan, .source = (state_163).source, .table = block_442: {
                const operand_441 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_441).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_163).table).children, .field_names = ((state_163).table).field_names, .field_types = ((state_163).table).field_types, .first = ((state_163).table).first, .kinds = ((state_163).table).kinds, .labels = ((state_163).table).labels, .names = ((state_163).table).names, .second = state_owned_440, });

                break :block_442 @as(*const (zx_abi).zx_type_15, operand_441);
            }, };
        }

        break :block_447 block_446: {
            break :block_446 (if (((state_163).zx_origin != null)) ((state_163).zx_origin.?).* else block_445: {
                break :block_445 (zx_abi).zx_type_32{ .index = (state_163).index, .member = (state_163).member, .plan = (if ((((state_163).plan).zx_origin != null)) ((state_163).plan).zx_origin.? else block_444: {
                    const operand_443 = (try (allocator).create((zx_abi).zx_type_29));

                    (operand_443).* = (zx_abi).zx_type_29{ .count = ((state_163).plan).count, .mapping = ((state_163).plan).mapping, .order = ((state_163).plan).order, .origins = ((state_163).plan).origins, .status = ((state_163).plan).status, };

                    break :block_444 @as(*const (zx_abi).zx_type_29, operand_443);
                }), .source = (state_163).source, .table = (state_163).table, };
            });
        };
    };

    return (((&value_55)).table).*;
}

fn function_5(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: u8) error{ }!u64 {
    const native_result = (zx_native_0).widenByte(in);

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_23 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_23 = block_84: {
        const operand_74 = block_75: {
            break :block_75 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_76 = block_77: {
            break :block_77 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_78 = block_79: {
            break :block_79 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_80 = block_81: {
            break :block_81 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_84 block_83: {
            const operand_82 = (try (allocator).create((zx_abi).zx_type_23));

            (operand_82).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = operand_74, .kinds = operand_76, .owners = operand_78, .members = operand_80, });

            break :block_83 @as(*const (zx_abi).zx_type_23, operand_82);
        };
    };

    const value_22: *const (zx_abi).zx_type_37 = block_73: {
        const operand_9 = block_8: {
            const operand_2 = (in).origins;
            const operand_3 = (in).plan;
            const operand_4 = value_1;
            const operand_5 = @as(u64, 0);

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_37));
                (operand_6).* = @as((zx_abi).zx_type_37, (zx_abi).zx_type_37{ .source = operand_2, .plan = operand_3, .origins = operand_4, .index = operand_5, });

                break :block_7 @as(*const (zx_abi).zx_type_37, operand_6);
            };
        };

        var state_capacity_11: (std).ArrayList(u32) = .empty;
        var state_capacity_started_12 = false;

        defer (state_capacity_11).deinit(allocator);

        var state_capacity_13: (std).ArrayList(u8) = .empty;
        var state_capacity_started_14 = false;

        defer (state_capacity_13).deinit(allocator);

        var state_capacity_15: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_16 = false;

        defer (state_capacity_15).deinit(allocator);

        var state_capacity_17: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_18 = false;

        defer (state_capacity_17).deinit(allocator);

        const state_type_19 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_20 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_21 = struct {
            index: u64,
            origins: state_type_19,
            plan: state_type_20,
            source: state_type_19,
        };

        const state_type_23 = struct { []const []const u8, void, };
        const state_type_40 = struct { []const u8, void, };
        const state_type_49 = struct { []const u32, void, };
        var state_1: state_type_21 = state_type_21{ .index = (operand_9).index, .origins = state_type_19{ .ids = ((operand_9).origins).ids, .kinds = ((operand_9).origins).kinds, .members = ((operand_9).origins).members, .owners = ((operand_9).origins).owners, }, .plan = state_type_20{ .count = ((operand_9).plan).count, .mapping = ((operand_9).plan).mapping, .order = ((operand_9).plan).order, .origins = ((operand_9).plan).origins, .status = ((operand_9).plan).status, }, .source = state_type_19{ .ids = ((operand_9).source).ids, .kinds = ((operand_9).source).kinds, .members = ((operand_9).source).members, .owners = ((operand_9).source).owners, }, };
        var state_changed_10 = false;

        while (((state_1).index < ((state_1).plan).count)) {
            state_1 = block_59: {
                const value_4: u64 = block_58: {
                    const operand_56 = ((state_1).plan).origins;
                    const operand_57 = (state_1).index;

                    if ((operand_57 >= (operand_56).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_58 (operand_56)[@intCast(operand_57)];
                };
                const value_18: state_type_21 = (if ((value_4 != @as(u64, 0))) block_55: {
                    const value_5: u64 = (value_4 - @as(u64, 1));
                    const value_6: state_type_21 = state_1;
                    const value_7: state_type_19 = (value_6).origins;

                    const value_8: state_type_21 = block_54: {
                        break :block_54 state_type_21{ .index = (value_6).index, .origins = block_53: {
                            break :block_53 state_type_19{ .ids = (block_52: {
                                const operand_50 = ((state_1).origins).ids;
                                const operand_51 = (try function_7(allocator, (state_1).index));

                                _ = (try ((std).math).add(usize, (operand_50).len, 1));

                                if ((!state_capacity_started_12)) {
                                    (try (state_capacity_11).appendSlice(allocator, operand_50));

                                    state_capacity_started_12 = true;
                                } else {
                                    ((state_capacity_11).items).len = (operand_50).len;
                                }

                                (try (state_capacity_11).append(allocator, operand_51));

                                break :block_52 @as(state_type_49, .{ (state_capacity_11).items, {}, });
                            }).@"0", .kinds = (value_7).kinds, .members = (value_7).members, .owners = (value_7).owners, };
                        }, .plan = (value_6).plan, .source = (value_6).source, };
                    };
                    const value_9: state_type_21 = value_8;
                    const value_10: state_type_19 = (value_9).origins;

                    const value_11: state_type_21 = block_48: {
                        break :block_48 state_type_21{ .index = (value_9).index, .origins = block_47: {
                            break :block_47 state_type_19{ .ids = (value_10).ids, .kinds = (block_46: {
                                const operand_41 = ((value_8).origins).kinds;
                                const operand_45 = block_44: {
                                    const operand_42 = ((value_8).source).kinds;
                                    const operand_43 = value_5;

                                    if ((operand_43 >= (operand_42).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_44 (operand_42)[@intCast(operand_43)];
                                };

                                _ = (try ((std).math).add(usize, (operand_41).len, 1));

                                if ((!state_capacity_started_14)) {
                                    (try (state_capacity_13).appendSlice(allocator, operand_41));

                                    state_capacity_started_14 = true;
                                } else {
                                    ((state_capacity_13).items).len = (operand_41).len;
                                }

                                (try (state_capacity_13).append(allocator, operand_45));

                                break :block_46 @as(state_type_40, .{ (state_capacity_13).items, {}, });
                            }).@"0", .members = (value_10).members, .owners = (value_10).owners, };
                        }, .plan = (value_9).plan, .source = (value_9).source, };
                    };
                    const value_12: state_type_21 = value_11;
                    const value_13: state_type_19 = (value_12).origins;

                    const value_14: state_type_21 = block_39: {
                        break :block_39 state_type_21{ .index = (value_12).index, .origins = block_38: {
                            break :block_38 state_type_19{ .ids = (value_13).ids, .kinds = (value_13).kinds, .members = (value_13).members, .owners = (block_37: {
                                const operand_32 = ((value_11).origins).owners;

                                const operand_36 = block_35: {
                                    const operand_33 = ((value_11).source).owners;
                                    const operand_34 = value_5;

                                    if ((operand_34 >= (operand_33).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_35 (operand_33)[@intCast(operand_34)];
                                };

                                _ = (try ((std).math).add(usize, (operand_32).len, 1));

                                if ((!state_capacity_started_18)) {
                                    (try (state_capacity_17).appendSlice(allocator, operand_32));

                                    state_capacity_started_18 = true;
                                } else {
                                    ((state_capacity_17).items).len = (operand_32).len;
                                }

                                (try (state_capacity_17).append(allocator, operand_36));

                                break :block_37 @as(state_type_23, .{ (state_capacity_17).items, {}, });
                            }).@"0", };
                        }, .plan = (value_12).plan, .source = (value_12).source, };
                    };
                    const value_15: state_type_21 = value_14;
                    const value_16: state_type_19 = (value_15).origins;
                    const value_17: state_type_21 = block_31: {
                        break :block_31 state_type_21{ .index = (value_15).index, .origins = block_30: {
                            break :block_30 state_type_19{ .ids = (value_16).ids, .kinds = (value_16).kinds, .members = (block_29: {
                                const operand_24 = ((value_14).origins).members;

                                const operand_28 = block_27: {
                                    const operand_25 = ((value_14).source).members;
                                    const operand_26 = value_5;

                                    if ((operand_26 >= (operand_25).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_27 (operand_25)[@intCast(operand_26)];
                                };

                                _ = (try ((std).math).add(usize, (operand_24).len, 1));

                                if ((!state_capacity_started_16)) {
                                    (try (state_capacity_15).appendSlice(allocator, operand_24));
                                    state_capacity_started_16 = true;
                                } else {
                                    ((state_capacity_15).items).len = (operand_24).len;
                                }

                                (try (state_capacity_15).append(allocator, operand_28));

                                break :block_29 @as(state_type_23, .{ (state_capacity_15).items, {}, });
                            }).@"0", .owners = (value_16).owners, };
                        }, .plan = (value_15).plan, .source = (value_15).source, };
                    };

                    break :block_55 value_17;
                } else state_1);

                const value_19: state_type_21 = value_18;
                const value_20: u64 = (value_19).index;

                const value_21: state_type_21 = block_22: {
                    break :block_22 state_type_21{ .index = (value_20 + @as(u64, 1)), .origins = (value_19).origins, .plan = (value_19).plan, .source = (value_19).source, };
                };

                break :block_59 value_21;
            };

            state_changed_10 = true;
        }

        var state_owned_60: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_60);

        if (state_capacity_started_12) {
            ((state_capacity_11).items).len = (((state_1).origins).ids).len;
            state_owned_60 = (try (state_capacity_11).toOwnedSlice(allocator));
        }

        if (state_capacity_started_12) {
            ((state_1).origins).ids = state_owned_60;
        }

        var state_owned_61: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_61);

        if (state_capacity_started_14) {
            ((state_capacity_13).items).len = (((state_1).origins).kinds).len;
            state_owned_61 = (try (state_capacity_13).toOwnedSlice(allocator));
        }

        if (state_capacity_started_14) {
            ((state_1).origins).kinds = state_owned_61;
        }

        var state_owned_62: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_62);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).origins).members).len;
            state_owned_62 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            ((state_1).origins).members = state_owned_62;
        }

        var state_owned_63: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_63);

        if (state_capacity_started_18) {
            ((state_capacity_17).items).len = (((state_1).origins).owners).len;
            state_owned_63 = (try (state_capacity_17).toOwnedSlice(allocator));
        }

        if (state_capacity_started_18) {
            ((state_1).origins).owners = state_owned_63;
        }

        break :block_73 (if (state_changed_10) block_72: {
            const operand_71 = (try (allocator).create((zx_abi).zx_type_37));

            (operand_71).* = @as((zx_abi).zx_type_37, (zx_abi).zx_type_37{ .index = (state_1).index, .origins = block_66: {
                const operand_65 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_65).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = ((state_1).origins).ids, .kinds = ((state_1).origins).kinds, .members = ((state_1).origins).members, .owners = ((state_1).origins).owners, });

                break :block_66 @as(*const (zx_abi).zx_type_23, operand_65);
            }, .plan = block_68: {
                const operand_67 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_67).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_68 @as(*const (zx_abi).zx_type_29, operand_67);
            }, .source = block_70: {
                const operand_69 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_69).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = ((state_1).source).ids, .kinds = ((state_1).source).kinds, .members = ((state_1).source).members, .owners = ((state_1).source).owners, });

                break :block_70 @as(*const (zx_abi).zx_type_23, operand_69);
            }, });

            break :block_72 @as(*const (zx_abi).zx_type_37, operand_71);
        } else operand_9);
    };

    return (value_22).origins;
}

fn function_8_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_23 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_23 = block_188: {
        const operand_180 = block_181: {
            break :block_181 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_182 = block_183: {
            break :block_183 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_184 = block_185: {
            break :block_185 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_186 = block_187: {
            break :block_187 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_188 (zx_abi).zx_type_23{ .ids = operand_180, .kinds = operand_182, .owners = operand_184, .members = operand_186, };
    };

    const value_22: (zx_abi).zx_type_37 = block_179: {
        const operand_91 = block_90: {
            const operand_86 = (in).origins;
            const operand_87 = (in).plan;
            const operand_88 = (&value_1);
            const operand_89 = @as(u64, 0);

            break :block_90 (zx_abi).zx_type_37{ .source = operand_86, .plan = operand_87, .origins = operand_88, .index = operand_89, };
        };

        var state_capacity_92: (std).ArrayList(u32) = .empty;
        var state_capacity_started_93 = false;

        defer (state_capacity_92).deinit(allocator);

        var state_capacity_94: (std).ArrayList(u8) = .empty;
        var state_capacity_started_95 = false;

        defer (state_capacity_94).deinit(allocator);

        var state_capacity_96: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_97 = false;

        defer (state_capacity_96).deinit(allocator);

        var state_capacity_98: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_99 = false;

        defer (state_capacity_98).deinit(allocator);

        var state_85: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (operand_91).index, .origins = (operand_91).origins, .plan = (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .count = ((operand_91).plan).count, .mapping = ((operand_91).plan).mapping, .order = ((operand_91).plan).order, .origins = ((operand_91).plan).origins, .status = ((operand_91).plan).status, .zx_origin = (operand_91).plan, }, .source = (operand_91).source, .zx_origin = (&operand_91), };

        while (((state_85).index < ((state_85).plan).count)) {
            state_85 = block_162: {
                const value_4: u64 = block_161: {
                    const operand_159 = ((state_85).plan).origins;
                    const operand_160 = (state_85).index;

                    if ((operand_160 >= (operand_159).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_161 (operand_159)[@intCast(operand_160)];
                };

                const value_18: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = (if ((block_102: {
                    break :block_102 value_4;
                } != @as(u64, 0))) block_158: {
                    const value_5: u64 = (block_157: {
                        break :block_157 value_4;
                    } - @as(u64, 1));

                    const value_6: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = state_85;
                    const value_7: (zx_abi).zx_type_23 = ((value_6).origins).*;

                    const value_8: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = block_156: {
                        break :block_156 @as((zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c, (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (value_6).index, .origins = block_155: {
                            break :block_155 block_154: {
                                const operand_153 = (try (allocator).create((zx_abi).zx_type_23));

                                (operand_153).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (block_149: {
                                    const operand_145 = ((state_85).origins).ids;

                                    const operand_148 = block_147: {
                                        const operand_146 = (state_85).index;

                                        break :block_147 (try function_7(allocator, operand_146));
                                    };

                                    _ = (try ((std).math).add(usize, (operand_145).len, 1));

                                    if ((!state_capacity_started_93)) {
                                        (try (state_capacity_92).appendSlice(allocator, operand_145));

                                        state_capacity_started_93 = true;
                                    } else {
                                        ((state_capacity_92).items).len = (operand_145).len;
                                    }

                                    (try (state_capacity_92).append(allocator, operand_148));

                                    break :block_149 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_92).items, {}, null, });
                                }).@"0", .kinds = (block_150: {
                                    break :block_150 (&value_7);
                                }).kinds, .members = (block_151: {
                                    break :block_151 (&value_7);
                                }).members, .owners = (block_152: {
                                    break :block_152 (&value_7);
                                }).owners, });

                                break :block_154 @as(*const (zx_abi).zx_type_23, operand_153);
                            };
                        }, .plan = (value_6).plan, .source = (value_6).source, });
                    };
                    const value_9: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = value_8;
                    const value_10: (zx_abi).zx_type_23 = ((value_9).origins).*;

                    const value_11: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = block_144: {
                        break :block_144 @as((zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c, (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (value_9).index, .origins = block_143: {
                            break :block_143 block_142: {
                                const operand_141 = (try (allocator).create((zx_abi).zx_type_23));

                                (operand_141).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (block_131: {
                                    break :block_131 (&value_10);
                                }).ids, .kinds = (block_138: {
                                    const operand_132 = ((value_8).origins).kinds;

                                    const operand_137 = block_136: {
                                        const operand_134 = ((value_8).source).kinds;
                                        const operand_135 = block_133: {
                                            break :block_133 value_5;
                                        };

                                        if ((operand_135 >= (operand_134).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_136 (operand_134)[@intCast(operand_135)];
                                    };

                                    _ = (try ((std).math).add(usize, (operand_132).len, 1));

                                    if ((!state_capacity_started_95)) {
                                        (try (state_capacity_94).appendSlice(allocator, operand_132));

                                        state_capacity_started_95 = true;
                                    } else {
                                        ((state_capacity_94).items).len = (operand_132).len;
                                    }

                                    (try (state_capacity_94).append(allocator, operand_137));

                                    break :block_138 @as((zx_abi).value_zx_type_33_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_94).items, {}, null, });
                                }).@"0", .members = (block_139: {
                                    break :block_139 (&value_10);
                                }).members, .owners = (block_140: {
                                    break :block_140 (&value_10);
                                }).owners, });

                                break :block_142 @as(*const (zx_abi).zx_type_23, operand_141);
                            };
                        }, .plan = (value_9).plan, .source = (value_9).source, });
                    };

                    const value_12: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = value_11;
                    const value_13: (zx_abi).zx_type_23 = ((value_12).origins).*;

                    const value_14: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = block_130: {
                        break :block_130 @as((zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c, (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (value_12).index, .origins = block_129: {
                            break :block_129 block_128: {
                                const operand_127 = (try (allocator).create((zx_abi).zx_type_23));

                                (operand_127).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (block_117: {
                                    break :block_117 (&value_13);
                                }).ids, .kinds = (block_118: {
                                    break :block_118 (&value_13);
                                }).kinds, .members = (block_119: {
                                    break :block_119 (&value_13);
                                }).members, .owners = (block_126: {
                                    const operand_120 = ((value_11).origins).owners;

                                    const operand_125 = block_124: {
                                        const operand_122 = ((value_11).source).owners;

                                        const operand_123 = block_121: {
                                            break :block_121 value_5;
                                        };

                                        if ((operand_123 >= (operand_122).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_124 (operand_122)[@intCast(operand_123)];
                                    };

                                    _ = (try ((std).math).add(usize, (operand_120).len, 1));

                                    if ((!state_capacity_started_99)) {
                                        (try (state_capacity_98).appendSlice(allocator, operand_120));

                                        state_capacity_started_99 = true;
                                    } else {
                                        ((state_capacity_98).items).len = (operand_120).len;
                                    }

                                    (try (state_capacity_98).append(allocator, operand_125));

                                    break :block_126 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_98).items, {}, null, });
                                }).@"0", });

                                break :block_128 @as(*const (zx_abi).zx_type_23, operand_127);
                            };
                        }, .plan = (value_12).plan, .source = (value_12).source, });
                    };

                    const value_15: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = value_14;
                    const value_16: (zx_abi).zx_type_23 = ((value_15).origins).*;

                    const value_17: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = block_116: {
                        break :block_116 @as((zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c, (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (value_15).index, .origins = block_115: {
                            break :block_115 block_114: {
                                const operand_113 = (try (allocator).create((zx_abi).zx_type_23));

                                (operand_113).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (block_103: {
                                    break :block_103 (&value_16);
                                }).ids, .kinds = (block_104: {
                                    break :block_104 (&value_16);
                                }).kinds, .members = (block_111: {
                                    const operand_105 = ((value_14).origins).members;

                                    const operand_110 = block_109: {
                                        const operand_107 = ((value_14).source).members;
                                        const operand_108 = block_106: {
                                            break :block_106 value_5;
                                        };

                                        if ((operand_108 >= (operand_107).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_109 (operand_107)[@intCast(operand_108)];
                                    };

                                    _ = (try ((std).math).add(usize, (operand_105).len, 1));

                                    if ((!state_capacity_started_97)) {
                                        (try (state_capacity_96).appendSlice(allocator, operand_105));

                                        state_capacity_started_97 = true;
                                    } else {
                                        ((state_capacity_96).items).len = (operand_105).len;
                                    }

                                    (try (state_capacity_96).append(allocator, operand_110));

                                    break :block_111 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_96).items, {}, null, });
                                }).@"0", .owners = (block_112: {
                                    break :block_112 (&value_16);
                                }).owners, });

                                break :block_114 @as(*const (zx_abi).zx_type_23, operand_113);
                            };
                        }, .plan = (value_15).plan, .source = (value_15).source, });
                    };

                    break :block_158 value_17;
                } else state_85);

                const value_19: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = value_18;
                const value_20: u64 = (value_19).index;

                const value_21: (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = block_101: {
                    break :block_101 @as((zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c, (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (block_100: {
                        break :block_100 value_20;
                    } + @as(u64, 1)), .origins = (value_19).origins, .plan = (value_19).plan, .source = (value_19).source, });
                };

                break :block_162 value_21;
            };
        }

        var state_owned_163: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_163);

        if (state_capacity_started_93) {
            ((state_capacity_92).items).len = (((state_85).origins).ids).len;
            state_owned_163 = (try (state_capacity_92).toOwnedSlice(allocator));
        }

        if (state_capacity_started_93) {
            state_85 = (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (state_85).index, .origins = block_165: {
                const operand_164 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_164).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = state_owned_163, .kinds = ((state_85).origins).kinds, .members = ((state_85).origins).members, .owners = ((state_85).origins).owners, });

                break :block_165 @as(*const (zx_abi).zx_type_23, operand_164);
            }, .plan = (state_85).plan, .source = (state_85).source, };
        }

        var state_owned_166: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_166);

        if (state_capacity_started_95) {
            ((state_capacity_94).items).len = (((state_85).origins).kinds).len;
            state_owned_166 = (try (state_capacity_94).toOwnedSlice(allocator));
        }

        if (state_capacity_started_95) {
            state_85 = (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (state_85).index, .origins = block_168: {
                const operand_167 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_167).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = ((state_85).origins).ids, .kinds = state_owned_166, .members = ((state_85).origins).members, .owners = ((state_85).origins).owners, });

                break :block_168 @as(*const (zx_abi).zx_type_23, operand_167);
            }, .plan = (state_85).plan, .source = (state_85).source, };
        }

        var state_owned_169: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_169);

        if (state_capacity_started_97) {
            ((state_capacity_96).items).len = (((state_85).origins).members).len;
            state_owned_169 = (try (state_capacity_96).toOwnedSlice(allocator));
        }

        if (state_capacity_started_97) {
            state_85 = (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (state_85).index, .origins = block_171: {
                const operand_170 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_170).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = ((state_85).origins).ids, .kinds = ((state_85).origins).kinds, .members = state_owned_169, .owners = ((state_85).origins).owners, });

                break :block_171 @as(*const (zx_abi).zx_type_23, operand_170);
            }, .plan = (state_85).plan, .source = (state_85).source, };
        }

        var state_owned_172: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_172);

        if (state_capacity_started_99) {
            ((state_capacity_98).items).len = (((state_85).origins).owners).len;
            state_owned_172 = (try (state_capacity_98).toOwnedSlice(allocator));
        }

        if (state_capacity_started_99) {
            state_85 = (zx_abi).value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c{ .index = (state_85).index, .origins = block_174: {
                const operand_173 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_173).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = ((state_85).origins).ids, .kinds = ((state_85).origins).kinds, .members = ((state_85).origins).members, .owners = state_owned_172, });

                break :block_174 @as(*const (zx_abi).zx_type_23, operand_173);
            }, .plan = (state_85).plan, .source = (state_85).source, };
        }

        break :block_179 block_178: {
            break :block_178 (if (((state_85).zx_origin != null)) ((state_85).zx_origin.?).* else block_177: {
                break :block_177 (zx_abi).zx_type_37{ .index = (state_85).index, .origins = (state_85).origins, .plan = (if ((((state_85).plan).zx_origin != null)) ((state_85).plan).zx_origin.? else block_176: {
                    const operand_175 = (try (allocator).create((zx_abi).zx_type_29));

                    (operand_175).* = (zx_abi).zx_type_29{ .count = ((state_85).plan).count, .mapping = ((state_85).plan).mapping, .order = ((state_85).plan).order, .origins = ((state_85).plan).origins, .status = ((state_85).plan).status, };

                    break :block_176 @as(*const (zx_abi).zx_type_29, operand_175);
                }), .source = (state_85).source, };
            });
        };
    };

    return (((&value_22)).origins).*;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_39) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_38 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = (try function_4(allocator, block_15: {
        const operand_11 = (in).table;
        const operand_12 = (in).plan;

        break :block_15 block_14: {
            const operand_13 = (try (allocator).create((zx_abi).zx_type_31));

            (operand_13).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .table = operand_11, .plan = operand_12, });

            break :block_14 @as(*const (zx_abi).zx_type_31, operand_13);
        };
    }));

    const value_2: *const (zx_abi).zx_type_23 = (try function_8(allocator, block_10: {
        const operand_6 = (in).origins;
        const operand_7 = (in).plan;

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create((zx_abi).zx_type_36));

            (operand_8).* = @as((zx_abi).zx_type_36, (zx_abi).zx_type_36{ .origins = operand_6, .plan = operand_7, });

            break :block_9 @as(*const (zx_abi).zx_type_36, operand_8);
        };
    }));

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_2;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_38));

            (operand_3).* = @as((zx_abi).zx_type_38, (zx_abi).zx_type_38{ .table = operand_1, .origins = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_38, operand_3);
        };
    };
}

