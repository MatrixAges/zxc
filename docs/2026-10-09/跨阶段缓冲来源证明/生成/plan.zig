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
const zx_shape_30 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .maximum_count = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .roots = zx_shape_30, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .kinds = zx_shape_12, .scalar_count = zx_shape_5, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .scalar_count = zx_shape_5, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .ids = zx_shape_28, .ready = zx_shape_30, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .pending = zx_shape_34, .table = zx_shape_15, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_0, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_0, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .pending = zx_shape_34, .remaining = zx_shape_5, .values = zx_shape_13, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .id = zx_shape_5, .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, .result = zx_shape_5, .valid = zx_shape_1, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .pending = zx_shape_34, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_43 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_43, }, };
const zx_shape_45 = .{ .kind = .optional, .child = zx_shape_1, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_45, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .maximum_count = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .child_end = zx_shape_5, .field_end = zx_shape_5, .index = zx_shape_5, .name_end = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_51 = .{ .kind = .scalar, };
const zx_shape_52 = .{ .kind = .object, .fields = .{ .kind = zx_shape_51, .name = zx_shape_10, }, };
const zx_shape_53 = .{ .kind = .object, .fields = .{ .after_underscore = zx_shape_1, .index = zx_shape_5, .kind = zx_shape_51, .name = zx_shape_10, .valid = zx_shape_1, }, };
const zx_shape_54 = .{ .kind = .object, .fields = .{ .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .ascending = zx_shape_1, .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_56 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .object = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_57 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .object = zx_shape_1, .owner = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, .values = zx_shape_13, }, };
const zx_shape_58 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .values = zx_shape_14, }, };
const zx_shape_59 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .valid = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_60 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .member = zx_shape_10, .unique = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_64 = .{ .kind = .optional, .child = zx_shape_29, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, }, };
const zx_shape_66 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, .@"1" = zx_shape_29, }, };
const zx_shape_67 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, .@"1" = zx_shape_29, .@"2" = zx_shape_29, }, };
const zx_shape_68 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_49, }, };
const zx_shape_69 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_49, .@"1" = zx_shape_1, }, };
const zx_shape_70 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_49, .@"1" = zx_shape_1, .@"2" = zx_shape_1, }, };
const zx_shape_71 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, .@"1" = zx_shape_1, }, };
const zx_shape_72 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, .@"1" = zx_shape_1, .@"2" = zx_shape_1, }, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_31, .@"1" = zx_shape_1, .@"2" = zx_shape_1, .@"3" = zx_shape_29, }, };
pub const input_shape = zx_shape_31;
pub const output_shape = zx_shape_64;
pub const Input = *const (zx_abi).zx_type_31;
pub const Output = ?*const (zx_abi).zx_type_29;

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

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_49) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, (((in).table).kinds).len);

    if (((((((((value_1 > (in).maximum_count) or (@as(u64, (((in).table).first).len) != value_1)) or (@as(u64, (((in).table).second).len) != value_1)) or (@as(u64, (((in).table).labels).len) != value_1)) or (@as(u64, (((in).table).field_names).len) != @as(u64, (((in).table).field_types).len))) or (@as(u64, (((in).table).children).len) > (in).maximum_count)) or (@as(u64, (((in).table).field_types).len) > (in).maximum_count)) or (@as(u64, (((in).table).names).len) > (in).maximum_count))) {
        return false;
    }

    const value_44: (zx_abi).zx_type_50 = block_98: {
        const operand_10 = block_9: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = @as(u64, 0);
            const operand_5 = @as(u64, 0);
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_50{ .table = operand_2, .scalar_count = operand_3, .index = operand_4, .child_end = operand_5, .field_end = operand_6, .name_end = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (operand_10).child_end, .field_end = (operand_10).field_end, .index = (operand_10).index, .name_end = (operand_10).name_end, .scalar_count = (operand_10).scalar_count, .table = (operand_10).table, .valid = (operand_10).valid, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).table).kinds).len)))) {
            state_1 = block_95: {
                const value_4: u8 = block_94: {
                    const operand_92 = ((state_1).table).kinds;
                    const operand_93 = (state_1).index;

                    if ((operand_93 >= (operand_92).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_94 (operand_92)[@intCast(operand_93)];
                };
                const value_5: u64 = block_91: {
                    const operand_90 = block_89: {
                        const operand_87 = ((state_1).table).first;
                        const operand_88 = (state_1).index;

                        if ((operand_88 >= (operand_87).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_89 (operand_87)[@intCast(operand_88)];
                    };

                    break :block_91 (try function_0(allocator, operand_90));
                };
                const value_6: u64 = block_86: {
                    const operand_85 = block_84: {
                        const operand_82 = ((state_1).table).second;
                        const operand_83 = (state_1).index;

                        if ((operand_83 >= (operand_82).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_84 (operand_82)[@intCast(operand_83)];
                    };

                    break :block_86 (try function_0(allocator, operand_85));
                };

                const value_7: (zx_abi).zx_type_11 = block_81: {
                    const operand_80 = block_79: {
                        break :block_79 value_4;
                    };

                    break :block_81 (try function_3(allocator, operand_80));
                };

                const value_40: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_13: {
                    break :block_13 value_4;
                } > @as(u8, 8)) or (((block_14: {
                    break :block_14 value_7;
                } != @as((zx_abi).zx_type_11, .Enumeration)) and (block_15: {
                    break :block_15 value_7;
                } != @as((zx_abi).zx_type_11, .NativeReference))) and (!block_21: {
                    const operand_19 = block_18: {
                        const operand_16 = ((state_1).table).labels;
                        const operand_17 = (state_1).index;

                        if ((operand_17 >= (operand_16).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_18 (operand_16)[@intCast(operand_17)];
                    };

                    const operand_20 = @as([]const u8, "");

                    break :block_21 ((std).mem).eql(u8, operand_19, operand_20);
                })))) block_23: {
                    const value_8: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                    const value_9: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_22: {
                        break :block_22 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_8).child_end, .field_end = (value_8).field_end, .index = (value_8).index, .name_end = (value_8).name_end, .scalar_count = (value_8).scalar_count, .table = (value_8).table, .valid = false, });
                    };

                    break :block_23 value_9;
                } else block_78: {
                    const value_39: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_24: {
                        break :block_24 value_7;
                    } == @as((zx_abi).zx_type_11, .Object))) block_34: {
                        const value_10: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        const value_11: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_33: {
                            break :block_33 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_10).child_end, .field_end = (value_10).field_end, .index = (value_10).index, .name_end = (value_10).name_end, .scalar_count = (value_10).scalar_count, .table = (value_10).table, .valid = (((block_29: {
                                break :block_29 value_5;
                            } == (state_1).field_end) and (block_30: {
                                break :block_30 value_5;
                            } <= @as(u64, (((state_1).table).field_types).len))) and (block_31: {
                                break :block_31 value_6;
                            } <= (@as(u64, (((state_1).table).field_types).len) - block_32: {
                                break :block_32 value_5;
                            }))), });
                        };

                        const value_15: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_11).valid) block_28: {
                            const value_12: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_11;
                            const value_13: u64 = (value_12).field_end;

                            const value_14: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_27: {
                                break :block_27 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_12).child_end, .field_end = (block_25: {
                                    break :block_25 value_13;
                                } + block_26: {
                                    break :block_26 value_6;
                                }), .index = (value_12).index, .name_end = (value_12).name_end, .scalar_count = (value_12).scalar_count, .table = (value_12).table, .valid = (value_12).valid, });
                            };

                            break :block_28 value_14;
                        } else value_11);

                        break :block_34 value_15;
                    } else block_77: {
                        const value_38: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_35: {
                            break :block_35 value_7;
                        } == @as((zx_abi).zx_type_11, .Tuple))) block_45: {
                            const value_16: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                            const value_17: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_44: {
                                break :block_44 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_16).child_end, .field_end = (value_16).field_end, .index = (value_16).index, .name_end = (value_16).name_end, .scalar_count = (value_16).scalar_count, .table = (value_16).table, .valid = (((block_40: {
                                    break :block_40 value_5;
                                } == (state_1).child_end) and (block_41: {
                                    break :block_41 value_5;
                                } <= @as(u64, (((state_1).table).children).len))) and (block_42: {
                                    break :block_42 value_6;
                                } <= (@as(u64, (((state_1).table).children).len) - block_43: {
                                    break :block_43 value_5;
                                }))), });
                            };
                            const value_21: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_17).valid) block_39: {
                                const value_18: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_17;
                                const value_19: u64 = (value_18).child_end;

                                const value_20: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_38: {
                                    break :block_38 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (block_36: {
                                        break :block_36 value_19;
                                    } + block_37: {
                                        break :block_37 value_6;
                                    }), .field_end = (value_18).field_end, .index = (value_18).index, .name_end = (value_18).name_end, .scalar_count = (value_18).scalar_count, .table = (value_18).table, .valid = (value_18).valid, });
                                };

                                break :block_39 value_20;
                            } else value_17);

                            break :block_45 value_21;
                        } else block_76: {
                            const value_37: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_46: {
                                break :block_46 value_7;
                            } == @as((zx_abi).zx_type_11, .Enumeration)) or (block_47: {
                                break :block_47 value_7;
                            } == @as((zx_abi).zx_type_11, .ErrorSet)))) block_57: {
                                const value_22: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                                const value_23: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_56: {
                                    break :block_56 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_22).child_end, .field_end = (value_22).field_end, .index = (value_22).index, .name_end = (value_22).name_end, .scalar_count = (value_22).scalar_count, .table = (value_22).table, .valid = (((block_52: {
                                        break :block_52 value_5;
                                    } == (state_1).name_end) and (block_53: {
                                        break :block_53 value_5;
                                    } <= @as(u64, (((state_1).table).names).len))) and (block_54: {
                                        break :block_54 value_6;
                                    } <= (@as(u64, (((state_1).table).names).len) - block_55: {
                                        break :block_55 value_5;
                                    }))), });
                                };
                                const value_27: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_23).valid) block_51: {
                                    const value_24: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_23;
                                    const value_25: u64 = (value_24).name_end;

                                    const value_26: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_50: {
                                        break :block_50 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_24).child_end, .field_end = (value_24).field_end, .index = (value_24).index, .name_end = (block_48: {
                                            break :block_48 value_25;
                                        } + block_49: {
                                            break :block_49 value_6;
                                        }), .scalar_count = (value_24).scalar_count, .table = (value_24).table, .valid = (value_24).valid, });
                                    };

                                    break :block_51 value_26;
                                } else value_23);

                                break :block_57 value_27;
                            } else block_75: {
                                const value_36: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_58: {
                                    break :block_58 value_7;
                                } == @as((zx_abi).zx_type_11, .Scalar))) block_62: {
                                    const value_28: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                                    const value_29: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_61: {
                                        break :block_61 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_28).child_end, .field_end = (value_28).field_end, .index = (value_28).index, .name_end = (value_28).name_end, .scalar_count = (value_28).scalar_count, .table = (value_28).table, .valid = ((block_59: {
                                            break :block_59 value_5;
                                        } < (state_1).scalar_count) and (block_60: {
                                            break :block_60 value_6;
                                        } == @as(u64, 0))), });
                                    };

                                    break :block_62 value_29;
                                } else block_74: {
                                    const value_35: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_63: {
                                        break :block_63 value_7;
                                    } == @as((zx_abi).zx_type_11, .Optional)) or (block_64: {
                                        break :block_64 value_7;
                                    } == @as((zx_abi).zx_type_11, .List)))) block_67: {
                                        const value_30: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                                        const value_31: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_66: {
                                            break :block_66 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_30).child_end, .field_end = (value_30).field_end, .index = (value_30).index, .name_end = (value_30).name_end, .scalar_count = (value_30).scalar_count, .table = (value_30).table, .valid = (block_65: {
                                                break :block_65 value_6;
                                            } == @as(u64, 0)), });
                                        };

                                        break :block_67 value_31;
                                    } else block_73: {
                                        const value_34: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_68: {
                                            break :block_68 value_7;
                                        } == @as((zx_abi).zx_type_11, .NativeReference))) block_72: {
                                            const value_32: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                                            const value_33: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_71: {
                                                break :block_71 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_32).child_end, .field_end = (value_32).field_end, .index = (value_32).index, .name_end = (value_32).name_end, .scalar_count = (value_32).scalar_count, .table = (value_32).table, .valid = ((block_69: {
                                                    break :block_69 value_5;
                                                } == @as(u64, 0)) and (block_70: {
                                                    break :block_70 value_6;
                                                } == @as(u64, 0))), });
                                            };

                                            break :block_72 value_33;
                                        } else state_1);

                                        break :block_73 value_34;
                                    });

                                    break :block_74 value_35;
                                });

                                break :block_75 value_36;
                            });

                            break :block_76 value_37;
                        });

                        break :block_77 value_38;
                    });

                    break :block_78 value_39;
                });

                const value_41: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_40;
                const value_42: u64 = (value_41).index;

                const value_43: (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_50_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_41).child_end, .field_end = (value_41).field_end, .index = (block_11: {
                        break :block_11 value_42;
                    } + @as(u64, 1)), .name_end = (value_41).name_end, .scalar_count = (value_41).scalar_count, .table = (value_41).table, .valid = (value_41).valid, });
                };

                break :block_95 value_43;
            };
        }

        break :block_98 block_97: {
            break :block_97 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_96: {
                break :block_96 (zx_abi).zx_type_50{ .child_end = (state_1).child_end, .field_end = (state_1).field_end, .index = (state_1).index, .name_end = (state_1).name_end, .scalar_count = (state_1).scalar_count, .table = (state_1).table, .valid = (state_1).valid, };
            });
        };
    };

    return (((((&value_44)).valid and (((&value_44)).child_end == @as(u64, (((in).table).children).len))) and (((&value_44)).field_end == @as(u64, (((in).table).field_types).len))) and (((&value_44)).name_end == @as(u64, (((in).table).names).len)));
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

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_52) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    if ((@as(u64, ((in).name).len) == @as(u64, 0))) {
        return false;
    }

    const value_1: u8 = block_37: {
        const operand_35 = (in).name;
        const operand_36 = @as(u64, 0);

        if ((operand_36 >= (operand_35).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_37 (operand_35)[@intCast(operand_36)];
    };

    const value_2: bool = (if (((in).kind == @as((zx_abi).zx_type_51, .TypeDecl))) ((value_1 >= @as(u8, 65)) and (value_1 <= @as(u8, 90))) else ((value_1 >= @as(u8, 97)) and (value_1 <= @as(u8, 122))));

    if ((!value_2)) {
        return false;
    }

    const value_21: (zx_abi).zx_type_53 = block_34: {
        const operand_8 = block_7: {
            const operand_2 = (in).name;
            const operand_3 = (in).kind;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;
            const operand_6 = true;

            break :block_7 (zx_abi).zx_type_53{ .name = operand_2, .kind = operand_3, .index = operand_4, .after_underscore = operand_5, .valid = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (operand_8).after_underscore, .index = (operand_8).index, .kind = (operand_8).kind, .name = (operand_8).name, .valid = (operand_8).valid, .zx_origin = (&operand_8), };

        while (((state_1).valid and ((state_1).index < @as(u64, ((state_1).name).len)))) {
            state_1 = block_31: {
                const value_5: u8 = block_30: {
                    const operand_28 = (state_1).name;
                    const operand_29 = (state_1).index;

                    if ((operand_29 >= (operand_28).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_30 (operand_28)[@intCast(operand_29)];
                };

                const value_6: bool = ((block_26: {
                    break :block_26 value_5;
                } >= @as(u8, 65)) and (block_27: {
                    break :block_27 value_5;
                } <= @as(u8, 90)));

                const value_7: bool = ((block_24: {
                    break :block_24 value_5;
                } >= @as(u8, 97)) and (block_25: {
                    break :block_25 value_5;
                } <= @as(u8, 122)));

                const value_8: bool = ((block_22: {
                    break :block_22 value_5;
                } >= @as(u8, 48)) and (block_23: {
                    break :block_23 value_5;
                } <= @as(u8, 57)));

                const value_17: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((((state_1).kind == @as((zx_abi).zx_type_51, .Value)) and (block_11: {
                    break :block_11 value_5;
                } == @as(u8, 95)))) block_14: {
                    const value_9: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                    const value_10: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_13: {
                        break :block_13 @as((zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_9).after_underscore, .index = (value_9).index, .kind = (value_9).kind, .name = (value_9).name, .valid = (!(state_1).after_underscore), });
                    };

                    const value_11: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_10;

                    const value_12: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_12: {
                        break :block_12 @as((zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = true, .index = (value_11).index, .kind = (value_11).kind, .name = (value_11).name, .valid = (value_11).valid, });
                    };

                    break :block_14 value_12;
                } else block_21: {
                    const value_13: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                    const value_14: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_20: {
                        break :block_20 @as((zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_13).after_underscore, .index = (value_13).index, .kind = (value_13).kind, .name = (value_13).name, .valid = (((block_16: {
                            break :block_16 value_6;
                        } or block_17: {
                            break :block_17 value_7;
                        }) or block_18: {
                            break :block_18 value_8;
                        }) and (((state_1).kind != @as((zx_abi).zx_type_51, .Value)) or (!block_19: {
                            break :block_19 value_6;
                        }))), });
                    };

                    const value_15: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;

                    const value_16: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_15: {
                        break :block_15 @as((zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = false, .index = (value_15).index, .kind = (value_15).kind, .name = (value_15).name, .valid = (value_15).valid, });
                    };

                    break :block_21 value_16;
                });

                const value_18: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_18).after_underscore, .index = (block_9: {
                        break :block_9 value_19;
                    } + @as(u64, 1)), .kind = (value_18).kind, .name = (value_18).name, .valid = (value_18).valid, });
                };

                break :block_31 value_20;
            };
        }

        break :block_34 block_33: {
            break :block_33 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_32: {
                break :block_32 (zx_abi).zx_type_53{ .after_underscore = (state_1).after_underscore, .index = (state_1).index, .kind = (state_1).kind, .name = (state_1).name, .valid = (state_1).valid, };
            });
        };
    };

    return (((&value_21)).valid and (!((&value_21)).after_underscore));
}

fn function_9(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_54) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_12: (zx_abi).zx_type_55 = block_26: {
        const operand_8 = block_7: {
            const operand_2 = (in).left;
            const operand_3 = (in).right;
            const operand_4 = @as(u64, 0);
            const operand_5 = true;
            const operand_6 = false;

            break :block_7 (zx_abi).zx_type_55{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, .ascending = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (operand_8).ascending, .equal = (operand_8).equal, .index = (operand_8).index, .left = (operand_8).left, .right = (operand_8).right, .zx_origin = (&operand_8), };

        while ((((state_1).equal and ((state_1).index < @as(u64, ((state_1).left).len))) and ((state_1).index < @as(u64, ((state_1).right).len)))) {
            state_1 = block_23: {
                const value_3: u8 = block_22: {
                    const operand_20 = (state_1).left;
                    const operand_21 = (state_1).index;

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };
                const value_4: u8 = block_19: {
                    const operand_17 = (state_1).right;
                    const operand_18 = (state_1).index;

                    if ((operand_18 >= (operand_17).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_19 (operand_17)[@intCast(operand_18)];
                };

                const value_5: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                const value_6: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (value_5).ascending, .equal = (block_14: {
                        break :block_14 value_3;
                    } == block_15: {
                        break :block_15 value_4;
                    }), .index = (value_5).index, .left = (value_5).left, .right = (value_5).right, });
                };

                const value_7: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_6;

                const value_8: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (block_11: {
                        break :block_11 value_3;
                    } < block_12: {
                        break :block_12 value_4;
                    }), .equal = (value_7).equal, .index = (value_7).index, .left = (value_7).left, .right = (value_7).right, });
                };
                const value_9: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_55_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (value_9).ascending, .equal = (value_9).equal, .index = (block_9: {
                        break :block_9 value_10;
                    } + @as(u64, 1)), .left = (value_9).left, .right = (value_9).right, });
                };

                break :block_23 value_11;
            };
        }

        break :block_26 block_25: {
            break :block_25 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_24: {
                break :block_24 (zx_abi).zx_type_55{ .ascending = (state_1).ascending, .equal = (state_1).equal, .index = (state_1).index, .left = (state_1).left, .right = (state_1).right, };
            });
        };
    };

    return (if (((&value_12)).equal) (@as(u64, ((in).left).len) < @as(u64, ((in).right).len)) else ((&value_12)).ascending);
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_56) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: []const u32 = (if ((in).object) ((in).table).field_types else ((in).table).children);

    return block_51: {
        const operand_11 = block_10: {
            const operand_2 = (in).table;
            const operand_3 = value_1;
            const operand_4 = (in).index;
            const operand_5 = (in).first;
            const operand_6 = (in).count;
            const operand_7 = (in).object;
            const operand_8 = @as(u64, 0);
            const operand_9 = true;

            break :block_10 (zx_abi).zx_type_57{ .table = operand_2, .values = operand_3, .owner = operand_4, .first = operand_5, .count = operand_6, .object = operand_7, .index = operand_8, .valid = operand_9, };
        };

        var state_1: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (operand_11).count, .first = (operand_11).first, .index = (operand_11).index, .object = (operand_11).object, .owner = (operand_11).owner, .table = (operand_11).table, .valid = (operand_11).valid, .values = (operand_11).values, .zx_origin = (&operand_11), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_50: {
                const value_4: u64 = ((state_1).first + (state_1).index);

                const value_5: u64 = block_49: {
                    const operand_48 = block_47: {
                        const operand_45 = (state_1).values;

                        const operand_46 = block_44: {
                            break :block_44 value_4;
                        };

                        if ((operand_46 >= (operand_45).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_47 (operand_45)[@intCast(operand_46)];
                    };

                    break :block_49 (try function_5(allocator, operand_48));
                };

                const value_6: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = state_1;

                const value_7: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_43: {
                    break :block_43 @as((zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_6).count, .first = (value_6).first, .index = (value_6).index, .object = (value_6).object, .owner = (value_6).owner, .table = (value_6).table, .valid = ((block_36: {
                        break :block_36 value_5;
                    } < (state_1).owner) and (block_42: {
                        const operand_41 = block_40: {
                            const operand_38 = ((state_1).table).kinds;

                            const operand_39 = block_37: {
                                break :block_37 value_5;
                            };

                            if ((operand_39 >= (operand_38).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_40 (operand_38)[@intCast(operand_39)];
                        };

                        break :block_42 (try function_9(allocator, operand_41));
                    } != @as((zx_abi).zx_type_11, .Task))), .values = (value_6).values, });
                };

                const value_10: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if (((value_7).valid and (value_7).object)) block_35: {
                    const value_8: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = value_7;

                    const value_9: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_34: {
                        break :block_34 @as((zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_8).count, .first = (value_8).first, .index = (value_8).index, .object = (value_8).object, .owner = (value_8).owner, .table = (value_8).table, .valid = (((block_14: {
                            break :block_14 value_5;
                        } != @as(u64, 0)) and (!block_21: {
                            const operand_19 = block_18: {
                                const operand_16 = ((value_7).table).field_names;

                                const operand_17 = block_15: {
                                    break :block_15 value_4;
                                };

                                if ((operand_17 >= (operand_16).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_18 (operand_16)[@intCast(operand_17)];
                            };
                            const operand_20 = @as([]const u8, "");

                            break :block_21 ((std).mem).eql(u8, operand_19, operand_20);
                        })) and (((value_7).index == @as(u64, 0)) or block_33: {
                            const operand_26 = block_25: {
                                const operand_23 = ((value_7).table).field_names;

                                const operand_24 = (block_22: {
                                    break :block_22 value_4;
                                } - @as(u64, 1));

                                if ((operand_24 >= (operand_23).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_25 (operand_23)[@intCast(operand_24)];
                            };
                            const operand_31 = block_30: {
                                const operand_28 = ((value_7).table).field_names;

                                const operand_29 = block_27: {
                                    break :block_27 value_4;
                                };

                                if ((operand_29 >= (operand_28).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_30 (operand_28)[@intCast(operand_29)];
                            };

                            const operand_32 = (zx_abi).zx_type_54{ .left = operand_26, .right = operand_31, };

                            break :block_33 (try function_10(allocator, (&operand_32)));
                        })), .values = (value_8).values, });
                    };

                    break :block_35 value_9;
                } else value_7);

                const value_11: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = value_10;
                const value_12: u64 = (value_11).index;

                const value_13: (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_57_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_11).count, .first = (value_11).first, .index = (block_12: {
                        break :block_12 value_12;
                    } + @as(u64, 1)), .object = (value_11).object, .owner = (value_11).owner, .table = (value_11).table, .valid = (value_11).valid, .values = (value_11).values, });
                };

                break :block_50 value_13;
            };
        }

        break :block_51 (state_1).valid;
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_58) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    return block_65: {
        const operand_9 = block_8: {
            const operand_2 = (in).values;
            const operand_3 = (in).first;
            const operand_4 = (in).count;
            const operand_5 = (in).errors;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_59{ .values = operand_2, .first = operand_3, .count = operand_4, .errors = operand_5, .index = operand_6, .valid = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (operand_9).count, .errors = (operand_9).errors, .first = (operand_9).first, .index = (operand_9).index, .valid = (operand_9).valid, .values = (operand_9).values, .zx_origin = (&operand_9), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_64: {
                const value_3: u64 = ((state_1).first + (state_1).index);

                const value_4: []const u8 = block_63: {
                    const operand_61 = (state_1).values;

                    const operand_62 = block_60: {
                        break :block_60 value_3;
                    };

                    if ((operand_62 >= (operand_61).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_63 (operand_61)[@intCast(operand_62)];
                };
                const value_20: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((state_1).errors) block_27: {
                    const value_5: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                    const value_6: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_26: {
                        break :block_26 @as((zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_5).count, .errors = (value_5).errors, .first = (value_5).first, .index = (value_5).index, .valid = (block_16: {
                            const operand_13 = block_12: {
                                break :block_12 value_4;
                            };

                            const operand_14 = @as((zx_abi).zx_type_51, .TypeDecl);
                            const operand_15 = (zx_abi).zx_type_52{ .name = operand_13, .kind = operand_14, };

                            break :block_16 (try function_8(allocator, (&operand_15)));
                        } and (((state_1).index == @as(u64, 0)) or block_25: {
                            const operand_21 = block_20: {
                                const operand_18 = (state_1).values;

                                const operand_19 = (block_17: {
                                    break :block_17 value_3;
                                } - @as(u64, 1));

                                if ((operand_19 >= (operand_18).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_20 (operand_18)[@intCast(operand_19)];
                            };
                            const operand_23 = block_22: {
                                break :block_22 value_4;
                            };

                            const operand_24 = (zx_abi).zx_type_54{ .left = operand_21, .right = operand_23, };

                            break :block_25 (try function_10(allocator, (&operand_24)));
                        })), .values = (value_5).values, });
                    };

                    break :block_27 value_6;
                } else block_59: {
                    const value_19: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_31: {
                        const operand_29 = block_28: {
                            break :block_28 value_4;
                        };
                        const operand_30 = @as([]const u8, "");

                        break :block_31 ((std).mem).eql(u8, operand_29, operand_30);
                    }) block_33: {
                        const value_7: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                        const value_8: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_32: {
                            break :block_32 @as((zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_7).count, .errors = (value_7).errors, .first = (value_7).first, .index = (value_7).index, .valid = false, .values = (value_7).values, });
                        };

                        break :block_33 value_8;
                    } else block_58: {
                        const value_16: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_57: {
                            const operand_44 = block_43: {
                                const operand_36 = (state_1).values;
                                const operand_37 = (state_1).first;
                                const operand_38 = (state_1).index;
                                const operand_39 = block_40: {
                                    break :block_40 value_4;
                                };
                                const operand_41 = @as(u64, 0);
                                const operand_42 = true;

                                break :block_43 @as((zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .values = operand_36, .first = operand_37, .count = operand_38, .member = operand_39, .index = operand_41, .unique = operand_42, });
                            };
                            var state_35: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_44;
                            var state_changed_45 = false;

                            while (((state_35).unique and ((state_35).index < (state_35).count))) {
                                state_35 = block_55: {
                                    const value_11: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_35;

                                    const value_12: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_54: {
                                        break :block_54 @as((zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_11).count, .first = (value_11).first, .index = (value_11).index, .member = (value_11).member, .unique = (!block_53: {
                                            const operand_51 = block_50: {
                                                const operand_48 = (state_35).values;
                                                const operand_49 = ((state_35).first + (state_35).index);

                                                if ((operand_49 >= (operand_48).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_50 (operand_48)[@intCast(operand_49)];
                                            };
                                            const operand_52 = (state_35).member;

                                            break :block_53 ((std).mem).eql(u8, operand_51, operand_52);
                                        }), .values = (value_11).values, });
                                    };
                                    const value_13: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_12;
                                    const value_14: u64 = (value_13).index;

                                    const value_15: (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_47: {
                                        break :block_47 @as((zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_60_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_13).count, .first = (value_13).first, .index = (block_46: {
                                            break :block_46 value_14;
                                        } + @as(u64, 1)), .member = (value_13).member, .unique = (value_13).unique, .values = (value_13).values, });
                                    };

                                    break :block_55 value_15;
                                };

                                state_changed_45 = true;
                            }

                            break :block_57 (if (state_changed_45) state_35 else operand_44);
                        };

                        const value_17: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                        const value_18: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_34: {
                            break :block_34 @as((zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_17).count, .errors = (value_17).errors, .first = (value_17).first, .index = (value_17).index, .valid = (value_16).unique, .values = (value_17).values, });
                        };

                        break :block_58 value_18;
                    });

                    break :block_59 value_19;
                });

                const value_21: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_20;
                const value_22: u64 = (value_21).index;

                const value_23: (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_11: {
                    break :block_11 @as((zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_59_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_21).count, .errors = (value_21).errors, .first = (value_21).first, .index = (block_10: {
                        break :block_10 value_22;
                    } + @as(u64, 1)), .valid = (value_21).valid, .values = (value_21).values, });
                };

                break :block_64 value_23;
            };
        }

        break :block_65 (state_1).valid;
    };
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_61) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_11 = (try function_9(allocator, block_44: {
        const operand_42 = ((in).table).kinds;
        const operand_43 = (in).index;

        if ((operand_43 >= (operand_42).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_44 (operand_42)[@intCast(operand_43)];
    }));

    const value_2: u64 = (try function_5(allocator, block_41: {
        const operand_39 = ((in).table).first;
        const operand_40 = (in).index;

        if ((operand_40 >= (operand_39).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_41 (operand_39)[@intCast(operand_40)];
    }));

    const value_3: u64 = (try function_5(allocator, block_38: {
        const operand_36 = ((in).table).second;
        const operand_37 = (in).index;

        if ((operand_37 >= (operand_36).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_38 (operand_36)[@intCast(operand_37)];
    }));

    if (((in).index < (in).scalar_count)) {
        return ((value_1 == @as((zx_abi).zx_type_11, .Scalar)) and (value_2 == (in).index));
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .Scalar))) {
        return false;
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .NativeReference))) {
        return block_35: {
            const operand_32 = block_31: {
                const operand_29 = ((in).table).labels;
                const operand_30 = (in).index;

                if ((operand_30 >= (operand_29).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_31 (operand_29)[@intCast(operand_30)];
            };

            const operand_33 = @as((zx_abi).zx_type_51, .TypeDecl);
            const operand_34 = (zx_abi).zx_type_52{ .name = operand_32, .kind = operand_33, };

            break :block_35 (try function_8(allocator, (&operand_34)));
        };
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .Task))) {
        return ((((value_2 < (in).index) and (value_3 < (in).index)) and ((try function_9(allocator, block_25: {
            const operand_23 = ((in).table).kinds;
            const operand_24 = value_2;

            if ((operand_24 >= (operand_23).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_25 (operand_23)[@intCast(operand_24)];
        })) != @as((zx_abi).zx_type_11, .Task))) and ((try function_9(allocator, block_28: {
            const operand_26 = ((in).table).kinds;
            const operand_27 = value_3;

            if ((operand_27 >= (operand_26).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_28 (operand_26)[@intCast(operand_27)];
        })) == @as((zx_abi).zx_type_11, .ErrorSet)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Optional)) or (value_1 == @as((zx_abi).zx_type_11, .List)))) {
        return (((value_2 < (in).index) and ((value_1 != @as((zx_abi).zx_type_11, .List)) or (value_2 != @as(u64, 0)))) and ((try function_9(allocator, block_22: {
            const operand_20 = ((in).table).kinds;
            const operand_21 = value_2;

            if ((operand_21 >= (operand_20).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_22 (operand_20)[@intCast(operand_21)];
        })) != @as((zx_abi).zx_type_11, .Task)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Tuple)) or (value_1 == @as((zx_abi).zx_type_11, .Object)))) {
        return block_19: {
            const operand_13 = (in).table;
            const operand_14 = (in).index;
            const operand_15 = value_2;
            const operand_16 = value_3;
            const operand_17 = (value_1 == @as((zx_abi).zx_type_11, .Object));
            const operand_18 = (zx_abi).zx_type_56{ .table = operand_13, .index = operand_14, .first = operand_15, .count = operand_16, .object = operand_17, };

            break :block_19 (try function_11(allocator, (&operand_18)));
        };
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Enumeration)) and (block_12: {
        const operand_10 = block_9: {
            const operand_7 = ((in).table).labels;
            const operand_8 = (in).index;

            if ((operand_8 >= (operand_7).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_9 (operand_7)[@intCast(operand_8)];
        };

        const operand_11 = @as([]const u8, "");

        break :block_12 ((std).mem).eql(u8, operand_10, operand_11);
    } or (value_3 == @as(u64, 0))))) {
        return false;
    }

    return block_6: {
        const operand_1 = ((in).table).names;
        const operand_2 = value_2;
        const operand_3 = value_3;
        const operand_4 = (value_1 == @as((zx_abi).zx_type_11, .ErrorSet));
        const operand_5 = (zx_abi).zx_type_58{ .values = operand_1, .first = operand_2, .count = operand_3, .errors = operand_4, };

        break :block_6 (try function_12(allocator, (&operand_5)));
    };
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_62) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    if ((@as(u64, (((in).table).kinds).len) < (in).scalar_count)) {
        return false;
    }

    return block_17: {
        const operand_7 = block_6: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_63{ .table = operand_2, .scalar_count = operand_3, .index = operand_4, .valid = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_7).index, .scalar_count = (operand_7).scalar_count, .table = (operand_7).table, .valid = (operand_7).valid, .zx_origin = (&operand_7), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).table).kinds).len)))) {
            state_1 = block_16: {
                const value_3: (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                const value_4: (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_15: {
                    break :block_15 @as((zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_3).index, .scalar_count = (value_3).scalar_count, .table = (value_3).table, .valid = block_14: {
                        const operand_10 = (state_1).table;
                        const operand_11 = (state_1).index;
                        const operand_12 = (state_1).scalar_count;
                        const operand_13 = (zx_abi).zx_type_61{ .table = operand_10, .index = operand_11, .scalar_count = operand_12, };

                        break :block_14 (try function_13(allocator, (&operand_13)));
                    }, });
                };

                const value_5: (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_9: {
                    break :block_9 @as((zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_63_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_8: {
                        break :block_8 value_6;
                    } + @as(u64, 1)), .scalar_count = (value_5).scalar_count, .table = (value_5).table, .valid = (value_5).valid, });
                };

                break :block_16 value_7;
            };
        }

        break :block_17 (state_1).valid;
    };
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_49) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: bool = block_10: {
        const operand_6 = (in).table;
        const operand_7 = (in).scalar_count;
        const operand_8 = (in).maximum_count;
        const operand_9 = (zx_abi).zx_type_49{ .table = operand_6, .scalar_count = operand_7, .maximum_count = operand_8, };

        break :block_10 (try function_4(allocator, (&operand_9)));
    };

    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: bool = block_5: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = (zx_abi).zx_type_62{ .table = operand_2, .scalar_count = operand_3, };

            break :block_5 (try function_14(allocator, (&operand_4)));
        };

        return value_2;
    } else {
        return false;
    }
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = @as(u64, (((in).origins).ids).len);

    return (((((((in).scalar_count <= @as(u64, (((in).table).kinds).len)) and (@as(u64, ((in).roots).len) == @as(u64, (((in).table).kinds).len))) and (@as(u64, (((in).origins).kinds).len) == value_1)) and (@as(u64, (((in).origins).owners).len) == value_1)) and (@as(u64, (((in).origins).members).len) == value_1)) and (@as(u64, ((in).names).len) == value_1));
}

fn function_17(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_18(allocator: ((std).mem).Allocator, in: u8) error{ }!u64 {
    const native_result = (zx_native_0).widenByte(in);

    _ = allocator;

    return native_result;
}

fn function_19(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_20(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_32) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_52: {
        const operand_49 = (in).kinds;
        const operand_50 = (try (allocator).alloc(u64, (operand_49).len));

        for (operand_49, 0..) |_, index_51| {
            (operand_50)[index_51] = @as(u64, 0);
        }

        break :block_52 operand_50;
    };

    const value_4: []const u32 = block_48: {
        const operand_45 = (in).kinds;
        const operand_46 = (try (allocator).alloc(u32, (operand_45).len));

        for (operand_45, 0..) |_, index_47| {
            (operand_46)[index_47] = (try function_19(allocator, @as(u64, 0)));
        }

        break :block_48 operand_46;
    };

    const value_6: []const u64 = block_44: {
        const operand_41 = (in).kinds;
        const operand_42 = (try (allocator).alloc(u64, (operand_41).len));

        for (operand_41, 0..) |_, index_43| {
            (operand_42)[index_43] = @as(u64, 0);
        }

        break :block_44 operand_42;
    };

    const value_20: *const (zx_abi).zx_type_33 = block_40: {
        const operand_17 = block_16: {
            const operand_10 = value_2;
            const operand_11 = value_4;
            const operand_12 = @as(u64, 0);
            const operand_13 = (in).scalar_count;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_33));

                (operand_14).* = @as((zx_abi).zx_type_33, (zx_abi).zx_type_33{ .mapping = operand_10, .order = operand_11, .index = operand_12, .scalar_count = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_33, operand_14);
            };
        };

        var state_items_19: []u64 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_9: (zx_abi).zx_type_33 = (operand_17).*;
        var state_changed_18 = false;

        while ((((&state_9)).index < ((&state_9)).scalar_count)) {
            state_9 = block_36: {
                const value_9: (zx_abi).zx_type_33 = ((&state_9)).*;
                const value_10: []const u64 = ((&value_9)).mapping;
                const value_11: u64 = ((&state_9)).index;

                const value_12: (zx_abi).zx_type_33 = block_35: {
                    break :block_35 (zx_abi).zx_type_33{ .index = ((&value_9)).index, .mapping = block_34: {
                        const operand_30 = value_10;
                        const operand_31 = value_11;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_32 = (((&state_9)).index + @as(u64, 1));

                        break :block_34 block_33: {
                            if ((!state_items_started_20)) {
                                state_items_19 = @constCast(operand_30);
                                state_items_started_20 = true;
                            }

                            (state_items_19)[@intCast(operand_31)] = operand_32;

                            break :block_33 state_items_19;
                        };
                    }, .order = ((&value_9)).order, .scalar_count = ((&value_9)).scalar_count, };
                };

                const value_13: (zx_abi).zx_type_33 = ((&value_12)).*;
                const value_14: []const u32 = ((&value_13)).order;
                const value_15: u64 = ((&value_12)).index;

                const value_16: (zx_abi).zx_type_33 = block_29: {
                    break :block_29 (zx_abi).zx_type_33{ .index = ((&value_13)).index, .mapping = ((&value_13)).mapping, .order = block_28: {
                        const operand_24 = value_14;
                        const operand_25 = value_15;

                        if ((operand_25 >= (operand_24).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_26 = (try function_19(allocator, ((&value_12)).index));

                        break :block_28 block_27: {
                            if ((!state_items_started_22)) {
                                state_items_21 = @constCast(operand_24);
                                state_items_started_22 = true;
                            }

                            (state_items_21)[@intCast(operand_25)] = operand_26;

                            break :block_27 state_items_21;
                        };
                    }, .scalar_count = ((&value_13)).scalar_count, };
                };

                const value_17: (zx_abi).zx_type_33 = ((&value_16)).*;
                const value_18: u64 = ((&value_17)).index;

                const value_19: (zx_abi).zx_type_33 = block_23: {
                    break :block_23 (zx_abi).zx_type_33{ .index = (value_18 + @as(u64, 1)), .mapping = ((&value_17)).mapping, .order = ((&value_17)).order, .scalar_count = ((&value_17)).scalar_count, };
                };

                break :block_36 ((&value_19)).*;
            };

            state_changed_18 = true;
        }

        break :block_40 (if (state_changed_18) block_39: {
            const operand_38 = (try (allocator).create((zx_abi).zx_type_33));

            (operand_38).* = @as((zx_abi).zx_type_33, state_9);

            break :block_39 @as(*const (zx_abi).zx_type_33, operand_38);
        } else operand_17);
    };

    return block_8: {
        const operand_1 = (value_20).mapping;
        const operand_2 = (value_20).order;
        const operand_3 = value_6;
        const operand_4 = (in).scalar_count;
        const operand_5 = @as((zx_abi).zx_type_27, .Ready);

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_29));

            (operand_6).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .mapping = operand_1, .order = operand_2, .origins = operand_3, .count = operand_4, .status = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_29, operand_6);
        };
    };
}

fn function_20_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_32) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_105: {
        const operand_102 = (in).kinds;
        const operand_103 = (try (allocator).alloc(u64, (operand_102).len));

        for (operand_102, 0..) |_, index_104| {
            (operand_103)[index_104] = @as(u64, 0);
        }

        break :block_105 operand_103;
    };

    const value_4: []const u32 = block_101: {
        const operand_98 = (in).kinds;
        const operand_99 = (try (allocator).alloc(u32, (operand_98).len));

        for (operand_98, 0..) |_, index_100| {
            (operand_99)[index_100] = (try function_19(allocator, @as(u64, 0)));
        }

        break :block_101 operand_99;
    };

    const value_6: []const u64 = block_97: {
        const operand_94 = (in).kinds;
        const operand_95 = (try (allocator).alloc(u64, (operand_94).len));

        for (operand_94, 0..) |_, index_96| {
            (operand_95)[index_96] = @as(u64, 0);
        }

        break :block_97 operand_95;
    };

    const value_20: (zx_abi).zx_type_33 = block_93: {
        const operand_65 = block_64: {
            const operand_60 = value_2;
            const operand_61 = value_4;
            const operand_62 = @as(u64, 0);
            const operand_63 = (in).scalar_count;

            break :block_64 (zx_abi).zx_type_33{ .mapping = operand_60, .order = operand_61, .index = operand_62, .scalar_count = operand_63, };
        };

        var state_items_66: []u64 = undefined;
        var state_items_started_67 = false;
        var state_items_68: []u32 = undefined;
        var state_items_started_69 = false;
        var state_59: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_65).index, .mapping = (operand_65).mapping, .order = (operand_65).order, .scalar_count = (operand_65).scalar_count, .zx_origin = (&operand_65), };

        while (((state_59).index < (state_59).scalar_count)) {
            state_59 = block_90: {
                const value_9: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_59;
                const value_10: []const u64 = (value_9).mapping;
                const value_11: u64 = (state_59).index;

                const value_12: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_89: {
                    break :block_89 @as((zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_9).index, .mapping = block_88: {
                        const operand_83 = block_82: {
                            break :block_82 value_10;
                        };
                        const operand_85 = block_84: {
                            break :block_84 value_11;
                        };

                        if ((operand_85 >= (operand_83).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_86 = ((state_59).index + @as(u64, 1));

                        break :block_88 block_87: {
                            if ((!state_items_started_67)) {
                                state_items_66 = @constCast(operand_83);
                                state_items_started_67 = true;
                            }

                            (state_items_66)[@intCast(operand_85)] = operand_86;

                            break :block_87 state_items_66;
                        };
                    }, .order = (value_9).order, .scalar_count = (value_9).scalar_count, });
                };

                const value_13: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_12;
                const value_14: []const u32 = (value_13).order;
                const value_15: u64 = (value_12).index;

                const value_16: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_81: {
                    break :block_81 @as((zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_13).index, .mapping = (value_13).mapping, .order = block_80: {
                        const operand_73 = block_72: {
                            break :block_72 value_14;
                        };
                        const operand_75 = block_74: {
                            break :block_74 value_15;
                        };

                        if ((operand_75 >= (operand_73).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_78 = block_77: {
                            const operand_76 = (value_12).index;

                            break :block_77 (try function_19(allocator, operand_76));
                        };

                        break :block_80 block_79: {
                            if ((!state_items_started_69)) {
                                state_items_68 = @constCast(operand_73);
                                state_items_started_69 = true;
                            }

                            (state_items_68)[@intCast(operand_75)] = operand_78;

                            break :block_79 state_items_68;
                        };
                    }, .scalar_count = (value_13).scalar_count, });
                };
                const value_17: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_16;
                const value_18: u64 = (value_17).index;

                const value_19: (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_71: {
                    break :block_71 @as((zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_70: {
                        break :block_70 value_18;
                    } + @as(u64, 1)), .mapping = (value_17).mapping, .order = (value_17).order, .scalar_count = (value_17).scalar_count, });
                };

                break :block_90 value_19;
            };
        }

        break :block_93 block_92: {
            break :block_92 (if (((state_59).zx_origin != null)) ((state_59).zx_origin.?).* else block_91: {
                break :block_91 (zx_abi).zx_type_33{ .index = (state_59).index, .mapping = (state_59).mapping, .order = (state_59).order, .scalar_count = (state_59).scalar_count, };
            });
        };
    };

    return block_58: {
        const operand_53 = ((&value_20)).mapping;
        const operand_54 = ((&value_20)).order;
        const operand_55 = value_6;
        const operand_56 = (in).scalar_count;
        const operand_57 = @as((zx_abi).zx_type_27, .Ready);

        break :block_58 (zx_abi).zx_type_29{ .mapping = operand_53, .order = operand_54, .origins = operand_55, .count = operand_56, .status = operand_57, };
    };
}

fn function_21(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: u8) error{ }!u64 {
    const native_result = (zx_native_0).widenByte(in);

    _ = allocator;

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_24(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_25(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_34 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_34 = (in).pending;

    const value_2: (zx_abi).zx_type_11 = (try function_24(allocator, block_93: {
        const operand_91 = ((in).table).kinds;
        const operand_92 = (in).index;

        if ((operand_92 >= (operand_91).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_93 (operand_91)[@intCast(operand_92)];
    }));

    if ((value_2 == @as((zx_abi).zx_type_11, .Task))) {
        return block_27: {
            const operand_1 = (block_15: {
                const operand_9 = (block_8: {
                    const operand_2 = (value_1).ids;

                    const operand_6 = (try function_21(allocator, block_5: {
                        const operand_3 = ((in).table).first;
                        const operand_4 = (in).index;

                        if ((operand_4 >= (operand_3).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_5 (operand_3)[@intCast(operand_4)];
                    }));

                    const operand_7 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_2).len, 1))));

                    @memcpy((operand_7)[0..(operand_2).len], operand_2);

                    (operand_7)[(operand_2).len] = operand_6;

                    break :block_8 @as((zx_abi).zx_type_36, .{ operand_7, {}, });
                }).@"0";
                const operand_13 = (try function_21(allocator, block_12: {
                    const operand_10 = ((in).table).second;
                    const operand_11 = (in).index;

                    if ((operand_11 >= (operand_10).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_12 (operand_10)[@intCast(operand_11)];
                }));

                const operand_14 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_9).len, 1))));

                @memcpy((operand_14)[0..(operand_9).len], operand_9);

                (operand_14)[(operand_9).len] = operand_13;

                break :block_15 @as((zx_abi).zx_type_36, .{ operand_14, {}, });
            }).@"0";
            const operand_16 = (block_24: {
                const operand_21 = (block_20: {
                    const operand_17 = (value_1).ready;
                    const operand_18 = false;
                    const operand_19 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_17).len, 1))));

                    @memcpy((operand_19)[0..(operand_17).len], operand_17);

                    (operand_19)[(operand_17).len] = operand_18;

                    break :block_20 @as((zx_abi).zx_type_37, .{ operand_19, {}, });
                }).@"0";

                const operand_22 = false;
                const operand_23 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_21).len, 1))));

                @memcpy((operand_23)[0..(operand_21).len], operand_21);

                (operand_23)[(operand_21).len] = operand_22;

                break :block_24 @as((zx_abi).zx_type_37, .{ operand_23, {}, });
            }).@"0";

            break :block_27 block_26: {
                const operand_25 = (try (allocator).create((zx_abi).zx_type_34));

                (operand_25).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_1, .ready = operand_16, });

                break :block_26 @as(*const (zx_abi).zx_type_34, operand_25);
            };
        };
    } else {
        if (((value_2 == @as((zx_abi).zx_type_11, .Optional)) or (value_2 == @as((zx_abi).zx_type_11, .List)))) {
            return block_43: {
                const operand_28 = (block_35: {
                    const operand_29 = (value_1).ids;

                    const operand_33 = (try function_21(allocator, block_32: {
                        const operand_30 = ((in).table).first;
                        const operand_31 = (in).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    }));

                    const operand_34 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_29).len, 1))));

                    @memcpy((operand_34)[0..(operand_29).len], operand_29);

                    (operand_34)[(operand_29).len] = operand_33;

                    break :block_35 @as((zx_abi).zx_type_36, .{ operand_34, {}, });
                }).@"0";
                const operand_36 = (block_40: {
                    const operand_37 = (value_1).ready;
                    const operand_38 = false;
                    const operand_39 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_37).len, 1))));

                    @memcpy((operand_39)[0..(operand_37).len], operand_37);

                    (operand_39)[(operand_37).len] = operand_38;

                    break :block_40 @as((zx_abi).zx_type_37, .{ operand_39, {}, });
                }).@"0";

                break :block_43 block_42: {
                    const operand_41 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_41).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_28, .ready = operand_36, });

                    break :block_42 @as(*const (zx_abi).zx_type_34, operand_41);
                };
            };
        } else {
            if (((value_2 == @as((zx_abi).zx_type_11, .Tuple)) or (value_2 == @as((zx_abi).zx_type_11, .Object)))) {
                const value_3: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: *const (zx_abi).zx_type_38 = block_90: {
                    const operand_58 = block_57: {
                        const operand_45 = value_3;
                        const operand_46 = (try function_21(allocator, block_49: {
                            const operand_47 = ((in).table).first;
                            const operand_48 = (in).index;

                            if ((operand_48 >= (operand_47).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_49 (operand_47)[@intCast(operand_48)];
                        }));
                        const operand_50 = (try function_21(allocator, block_53: {
                            const operand_51 = ((in).table).second;
                            const operand_52 = (in).index;

                            if ((operand_52 >= (operand_51).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_53 (operand_51)[@intCast(operand_52)];
                        }));

                        const operand_54 = value_1;

                        break :block_57 block_56: {
                            const operand_55 = (try (allocator).create((zx_abi).zx_type_38));

                            (operand_55).* = @as((zx_abi).zx_type_38, (zx_abi).zx_type_38{ .values = operand_45, .first = operand_46, .remaining = operand_50, .pending = operand_54, });

                            break :block_56 @as(*const (zx_abi).zx_type_38, operand_55);
                        };
                    };

                    var state_capacity_60: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_61 = false;

                    defer (state_capacity_60).deinit(allocator);

                    var state_capacity_62: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_63 = false;

                    defer (state_capacity_62).deinit(allocator);

                    const state_type_64 = struct {
                        ids: []const u64,
                        ready: []const bool,
                    };
                    const state_type_65 = struct {
                        first: u64,
                        pending: state_type_64,
                        remaining: u64,
                        values: []const u32,
                    };

                    const state_type_66 = struct { []const bool, void, };
                    const state_type_72 = struct { []const u64, void, };
                    var state_44: state_type_65 = state_type_65{ .first = (operand_58).first, .pending = state_type_64{ .ids = ((operand_58).pending).ids, .ready = ((operand_58).pending).ready, }, .remaining = (operand_58).remaining, .values = (operand_58).values, };
                    var state_changed_59 = false;

                    while (((state_44).remaining > @as(u64, 0))) {
                        state_44 = block_82: {
                            const value_6: state_type_65 = state_44;
                            const value_7: u64 = (value_6).remaining;
                            const value_8: state_type_65 = block_81: {
                                break :block_81 state_type_65{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (value_7 - @as(u64, 1)), .values = (value_6).values, };
                            };
                            const value_9: state_type_65 = value_8;
                            const value_10: state_type_64 = (value_9).pending;
                            const value_11: state_type_65 = block_80: {
                                break :block_80 state_type_65{ .first = (value_9).first, .pending = block_79: {
                                    break :block_79 state_type_64{ .ids = (block_78: {
                                        const operand_73 = ((value_8).pending).ids;

                                        const operand_77 = (try function_21(allocator, block_76: {
                                            const operand_74 = (value_8).values;
                                            const operand_75 = ((value_8).first + (value_8).remaining);

                                            if ((operand_75 >= (operand_74).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_76 (operand_74)[@intCast(operand_75)];
                                        }));

                                        _ = (try ((std).math).add(usize, (operand_73).len, 1));

                                        if ((!state_capacity_started_61)) {
                                            (try (state_capacity_60).appendSlice(allocator, operand_73));

                                            state_capacity_started_61 = true;
                                        } else {
                                            ((state_capacity_60).items).len = (operand_73).len;
                                        }

                                        (try (state_capacity_60).append(allocator, operand_77));

                                        break :block_78 @as(state_type_72, .{ (state_capacity_60).items, {}, });
                                    }).@"0", .ready = (value_10).ready, };
                                }, .remaining = (value_9).remaining, .values = (value_9).values, };
                            };
                            const value_12: state_type_65 = value_11;
                            const value_13: state_type_64 = (value_12).pending;

                            const value_14: state_type_65 = block_71: {
                                break :block_71 state_type_65{ .first = (value_12).first, .pending = block_70: {
                                    break :block_70 state_type_64{ .ids = (value_13).ids, .ready = (block_69: {
                                        const operand_67 = ((value_11).pending).ready;
                                        const operand_68 = false;

                                        _ = (try ((std).math).add(usize, (operand_67).len, 1));

                                        if ((!state_capacity_started_63)) {
                                            (try (state_capacity_62).appendSlice(allocator, operand_67));
                                            state_capacity_started_63 = true;
                                        } else {
                                            ((state_capacity_62).items).len = (operand_67).len;
                                        }

                                        (try (state_capacity_62).append(allocator, operand_68));

                                        break :block_69 @as(state_type_66, .{ (state_capacity_62).items, {}, });
                                    }).@"0", };
                                }, .remaining = (value_12).remaining, .values = (value_12).values, };
                            };

                            break :block_82 value_14;
                        };

                        state_changed_59 = true;
                    }

                    var state_owned_83: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_83);

                    if (state_capacity_started_61) {
                        ((state_capacity_60).items).len = (((state_44).pending).ids).len;
                        state_owned_83 = (try (state_capacity_60).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_61) {
                        ((state_44).pending).ids = state_owned_83;
                    }

                    var state_owned_84: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_84);

                    if (state_capacity_started_63) {
                        ((state_capacity_62).items).len = (((state_44).pending).ready).len;
                        state_owned_84 = (try (state_capacity_62).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_63) {
                        ((state_44).pending).ready = state_owned_84;
                    }

                    break :block_90 (if (state_changed_59) block_89: {
                        const operand_88 = (try (allocator).create((zx_abi).zx_type_38));

                        (operand_88).* = @as((zx_abi).zx_type_38, (zx_abi).zx_type_38{ .first = (state_44).first, .pending = block_87: {
                            const operand_86 = (try (allocator).create((zx_abi).zx_type_34));

                            (operand_86).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = ((state_44).pending).ids, .ready = ((state_44).pending).ready, });

                            break :block_87 @as(*const (zx_abi).zx_type_34, operand_86);
                        }, .remaining = (state_44).remaining, .values = (state_44).values, });

                        break :block_89 @as(*const (zx_abi).zx_type_38, operand_88);
                    } else operand_58);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

fn function_25_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (in).pending;

    const value_2: (zx_abi).zx_type_11 = block_194: {
        const operand_193 = block_192: {
            const operand_190 = ((in).table).kinds;
            const operand_191 = (in).index;

            if ((operand_191 >= (operand_190).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_192 (operand_190)[@intCast(operand_191)];
        };

        break :block_194 (try function_24(allocator, operand_193));
    };

    if ((block_94: {
        break :block_94 value_2;
    } == @as((zx_abi).zx_type_11, .Task))) {
        return block_123: {
            const operand_95 = (block_113: {
                const operand_105 = (block_104: {
                    const operand_96 = (value_1).ids;

                    const operand_102 = block_101: {
                        const operand_100 = block_99: {
                            const operand_97 = ((in).table).first;
                            const operand_98 = (in).index;

                            if ((operand_98 >= (operand_97).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_99 (operand_97)[@intCast(operand_98)];
                        };

                        break :block_101 (try function_21(allocator, operand_100));
                    };

                    const operand_103 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_96).len, 1))));

                    @memcpy((operand_103)[0..(operand_96).len], operand_96);

                    (operand_103)[(operand_96).len] = operand_102;

                    break :block_104 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_103, {}, null, });
                }).@"0";
                const operand_111 = block_110: {
                    const operand_109 = block_108: {
                        const operand_106 = ((in).table).second;
                        const operand_107 = (in).index;

                        if ((operand_107 >= (operand_106).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_108 (operand_106)[@intCast(operand_107)];
                    };

                    break :block_110 (try function_21(allocator, operand_109));
                };

                const operand_112 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_105).len, 1))));

                @memcpy((operand_112)[0..(operand_105).len], operand_105);

                (operand_112)[(operand_105).len] = operand_111;

                break :block_113 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_112, {}, null, });
            }).@"0";

            const operand_114 = (block_122: {
                const operand_119 = (block_118: {
                    const operand_115 = (value_1).ready;
                    const operand_116 = false;
                    const operand_117 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_115).len, 1))));

                    @memcpy((operand_117)[0..(operand_115).len], operand_115);

                    (operand_117)[(operand_115).len] = operand_116;

                    break :block_118 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_117, {}, null, });
                }).@"0";
                const operand_120 = false;
                const operand_121 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_119).len, 1))));

                @memcpy((operand_121)[0..(operand_119).len], operand_119);

                (operand_121)[(operand_119).len] = operand_120;

                break :block_122 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_121, {}, null, });
            }).@"0";

            break :block_123 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_95, .ready = operand_114, });
        };
    } else {
        if (((block_124: {
            break :block_124 value_2;
        } == @as((zx_abi).zx_type_11, .Optional)) or (block_125: {
            break :block_125 value_2;
        } == @as((zx_abi).zx_type_11, .List)))) {
            return block_141: {
                const operand_126 = (block_135: {
                    const operand_127 = (value_1).ids;

                    const operand_133 = block_132: {
                        const operand_131 = block_130: {
                            const operand_128 = ((in).table).first;
                            const operand_129 = (in).index;

                            if ((operand_129 >= (operand_128).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_130 (operand_128)[@intCast(operand_129)];
                        };

                        break :block_132 (try function_21(allocator, operand_131));
                    };

                    const operand_134 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_127).len, 1))));

                    @memcpy((operand_134)[0..(operand_127).len], operand_127);

                    (operand_134)[(operand_127).len] = operand_133;

                    break :block_135 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_134, {}, null, });
                }).@"0";

                const operand_136 = (block_140: {
                    const operand_137 = (value_1).ready;
                    const operand_138 = false;
                    const operand_139 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_137).len, 1))));

                    @memcpy((operand_139)[0..(operand_137).len], operand_137);

                    (operand_139)[(operand_137).len] = operand_138;

                    break :block_140 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_139, {}, null, });
                }).@"0";

                break :block_141 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_126, .ready = operand_136, });
            };
        } else {
            if (((block_142: {
                break :block_142 value_2;
            } == @as((zx_abi).zx_type_11, .Tuple)) or (block_143: {
                break :block_143 value_2;
            } == @as((zx_abi).zx_type_11, .Object)))) {
                const value_3: []const u32 = (if ((block_189: {
                    break :block_189 value_2;
                } == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_188: {
                    const operand_161 = block_160: {
                        const operand_145 = block_146: {
                            break :block_146 value_3;
                        };
                        const operand_147 = block_152: {
                            const operand_151 = block_150: {
                                const operand_148 = ((in).table).first;
                                const operand_149 = (in).index;

                                if ((operand_149 >= (operand_148).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_150 (operand_148)[@intCast(operand_149)];
                            };

                            break :block_152 (try function_21(allocator, operand_151));
                        };
                        const operand_153 = block_158: {
                            const operand_157 = block_156: {
                                const operand_154 = ((in).table).second;
                                const operand_155 = (in).index;

                                if ((operand_155 >= (operand_154).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_156 (operand_154)[@intCast(operand_155)];
                            };

                            break :block_158 (try function_21(allocator, operand_157));
                        };

                        const operand_159 = value_1;

                        break :block_160 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_145, .first = operand_147, .remaining = operand_153, .pending = operand_159, });
                    };

                    var state_capacity_163: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_164 = false;

                    defer (state_capacity_163).deinit(allocator);

                    var state_capacity_165: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_166 = false;

                    defer (state_capacity_165).deinit(allocator);

                    var state_144: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_161;
                    var state_changed_162 = false;

                    while (((state_144).remaining > @as(u64, 0))) {
                        state_144 = block_184: {
                            const value_6: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_144;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_183: {
                                break :block_183 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_182: {
                                    break :block_182 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };

                            const value_9: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_181: {
                                break :block_181 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_180: {
                                    break :block_180 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_179: {
                                        const operand_172 = ((value_8).pending).ids;

                                        const operand_178 = block_177: {
                                            const operand_176 = block_175: {
                                                const operand_173 = (value_8).values;
                                                const operand_174 = ((value_8).first + (value_8).remaining);

                                                if ((operand_174 >= (operand_173).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_175 (operand_173)[@intCast(operand_174)];
                                            };

                                            break :block_177 (try function_21(allocator, operand_176));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_172).len, 1));

                                        if ((!state_capacity_started_164)) {
                                            (try (state_capacity_163).appendSlice(allocator, operand_172));

                                            state_capacity_started_164 = true;
                                        } else {
                                            ((state_capacity_163).items).len = (operand_172).len;
                                        }

                                        (try (state_capacity_163).append(allocator, operand_178));

                                        break :block_179 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_163).items, {}, null, });
                                    }).@"0", .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_171: {
                                break :block_171 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_170: {
                                    break :block_170 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = (block_169: {
                                        const operand_167 = ((value_11).pending).ready;
                                        const operand_168 = false;

                                        _ = (try ((std).math).add(usize, (operand_167).len, 1));

                                        if ((!state_capacity_started_166)) {
                                            (try (state_capacity_165).appendSlice(allocator, operand_167));

                                            state_capacity_started_166 = true;
                                        } else {
                                            ((state_capacity_165).items).len = (operand_167).len;
                                        }

                                        (try (state_capacity_165).append(allocator, operand_168));

                                        break :block_169 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_165).items, {}, null, });
                                    }).@"0", });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_184 value_14;
                        };

                        state_changed_162 = true;
                    }

                    var state_owned_185: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_185);

                    if (state_capacity_started_164) {
                        ((state_capacity_163).items).len = (((state_144).pending).ids).len;
                        state_owned_185 = (try (state_capacity_163).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_164) {
                        state_144 = (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_144).first, .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_185, .ready = ((state_144).pending).ready, }), .remaining = (state_144).remaining, .values = (state_144).values, };
                    }

                    var state_owned_186: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_186);

                    if (state_capacity_started_166) {
                        ((state_capacity_165).items).len = (((state_144).pending).ready).len;
                        state_owned_186 = (try (state_capacity_165).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_166) {
                        state_144 = (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_144).first, .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_144).pending).ids, .ready = state_owned_186, }), .remaining = (state_144).remaining, .values = (state_144).values, };
                    }

                    break :block_188 (if (state_changed_162) state_144 else operand_161);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

fn function_25_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (in).pending;

    const value_2: (zx_abi).zx_type_11 = block_363: {
        const operand_362 = block_361: {
            const operand_359 = ((in).table).kinds;
            const operand_360 = (in).index;

            if ((operand_360 >= (operand_359).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_361 (operand_359)[@intCast(operand_360)];
        };

        break :block_363 (try function_24(allocator, operand_362));
    };

    if ((block_195: {
        break :block_195 value_2;
    } == @as((zx_abi).zx_type_11, .Task))) {
        return block_270: {
            const operand_196 = @as([]const u64, (if (((buffers).lane_0 != null)) block_221: {
                const operand_214 = @as([]const u64, (if (((buffers).lane_0 != null)) block_204: {
                    const operand_197 = (value_1).ids;

                    const operand_203 = block_202: {
                        const operand_201 = block_200: {
                            const operand_198 = ((in).table).first;
                            const operand_199 = (in).index;

                            if ((operand_199 >= (operand_198).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_200 (operand_198)[@intCast(operand_199)];
                        };

                        break :block_202 (try function_21(allocator, operand_201));
                    };

                    _ = (try ((std).math).add(usize, (operand_197).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_197));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_197).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_203));

                    break :block_204 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_213: {
                    const operand_205 = (value_1).ids;
                    const operand_211 = block_210: {
                        const operand_209 = block_208: {
                            const operand_206 = ((in).table).first;
                            const operand_207 = (in).index;

                            if ((operand_207 >= (operand_206).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_208 (operand_206)[@intCast(operand_207)];
                        };

                        break :block_210 (try function_21(allocator, operand_209));
                    };

                    const operand_212 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_205).len, 1))));

                    @memcpy((operand_212)[0..(operand_205).len], operand_205);

                    (operand_212)[(operand_205).len] = operand_211;

                    break :block_213 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_212, {}, null, });
                }).@"0"));

                const operand_220 = block_219: {
                    const operand_218 = block_217: {
                        const operand_215 = ((in).table).second;
                        const operand_216 = (in).index;

                        if ((operand_216 >= (operand_215).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_217 (operand_215)[@intCast(operand_216)];
                    };

                    break :block_219 (try function_21(allocator, operand_218));
                };

                _ = (try ((std).math).add(usize, (operand_214).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_214));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_214).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_220));

                break :block_221 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_247: {
                const operand_239 = @as([]const u64, (if (((buffers).lane_0 != null)) block_229: {
                    const operand_222 = (value_1).ids;
                    const operand_228 = block_227: {
                        const operand_226 = block_225: {
                            const operand_223 = ((in).table).first;
                            const operand_224 = (in).index;

                            if ((operand_224 >= (operand_223).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_225 (operand_223)[@intCast(operand_224)];
                        };

                        break :block_227 (try function_21(allocator, operand_226));
                    };

                    _ = (try ((std).math).add(usize, (operand_222).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_222));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_222).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_228));

                    break :block_229 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_238: {
                    const operand_230 = (value_1).ids;

                    const operand_236 = block_235: {
                        const operand_234 = block_233: {
                            const operand_231 = ((in).table).first;
                            const operand_232 = (in).index;

                            if ((operand_232 >= (operand_231).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_233 (operand_231)[@intCast(operand_232)];
                        };

                        break :block_235 (try function_21(allocator, operand_234));
                    };

                    const operand_237 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_230).len, 1))));

                    @memcpy((operand_237)[0..(operand_230).len], operand_230);
                    (operand_237)[(operand_230).len] = operand_236;

                    break :block_238 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_237, {}, null, });
                }).@"0"));

                const operand_245 = block_244: {
                    const operand_243 = block_242: {
                        const operand_240 = ((in).table).second;
                        const operand_241 = (in).index;

                        if ((operand_241 >= (operand_240).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_242 (operand_240)[@intCast(operand_241)];
                    };

                    break :block_244 (try function_21(allocator, operand_243));
                };

                const operand_246 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_239).len, 1))));

                @memcpy((operand_246)[0..(operand_239).len], operand_239);

                (operand_246)[(operand_239).len] = operand_245;

                break :block_247 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_246, {}, null, });
            }).@"0"));

            const operand_248 = @as([]const bool, (if (((buffers).lane_1 != null)) block_258: {
                const operand_256 = @as([]const bool, (if (((buffers).lane_1 != null)) block_251: {
                    const operand_249 = (value_1).ready;
                    const operand_250 = false;

                    _ = (try ((std).math).add(usize, (operand_249).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_249));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_249).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_250));

                    break :block_251 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_255: {
                    const operand_252 = (value_1).ready;
                    const operand_253 = false;
                    const operand_254 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_252).len, 1))));

                    @memcpy((operand_254)[0..(operand_252).len], operand_252);

                    (operand_254)[(operand_252).len] = operand_253;

                    break :block_255 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_254, {}, null, });
                }).@"0"));

                const operand_257 = false;

                _ = (try ((std).math).add(usize, (operand_256).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_256));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_256).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_257));

                break :block_258 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_269: {
                const operand_266 = @as([]const bool, (if (((buffers).lane_1 != null)) block_261: {
                    const operand_259 = (value_1).ready;
                    const operand_260 = false;

                    _ = (try ((std).math).add(usize, (operand_259).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_259));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_259).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_260));

                    break :block_261 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_265: {
                    const operand_262 = (value_1).ready;
                    const operand_263 = false;
                    const operand_264 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_262).len, 1))));

                    @memcpy((operand_264)[0..(operand_262).len], operand_262);

                    (operand_264)[(operand_262).len] = operand_263;

                    break :block_265 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_264, {}, null, });
                }).@"0"));

                const operand_267 = false;
                const operand_268 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_266).len, 1))));

                @memcpy((operand_268)[0..(operand_266).len], operand_266);

                (operand_268)[(operand_266).len] = operand_267;

                break :block_269 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_268, {}, null, });
            }).@"0"));

            break :block_270 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_196, .ready = operand_248, });
        };
    } else {
        if (((block_271: {
            break :block_271 value_2;
        } == @as((zx_abi).zx_type_11, .Optional)) or (block_272: {
            break :block_272 value_2;
        } == @as((zx_abi).zx_type_11, .List)))) {
            return block_299: {
                const operand_273 = @as([]const u64, (if (((buffers).lane_0 != null)) block_281: {
                    const operand_274 = (value_1).ids;

                    const operand_280 = block_279: {
                        const operand_278 = block_277: {
                            const operand_275 = ((in).table).first;
                            const operand_276 = (in).index;

                            if ((operand_276 >= (operand_275).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_277 (operand_275)[@intCast(operand_276)];
                        };

                        break :block_279 (try function_21(allocator, operand_278));
                    };

                    _ = (try ((std).math).add(usize, (operand_274).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_274));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_274).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_280));

                    break :block_281 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_290: {
                    const operand_282 = (value_1).ids;

                    const operand_288 = block_287: {
                        const operand_286 = block_285: {
                            const operand_283 = ((in).table).first;
                            const operand_284 = (in).index;

                            if ((operand_284 >= (operand_283).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_285 (operand_283)[@intCast(operand_284)];
                        };

                        break :block_287 (try function_21(allocator, operand_286));
                    };

                    const operand_289 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_282).len, 1))));

                    @memcpy((operand_289)[0..(operand_282).len], operand_282);

                    (operand_289)[(operand_282).len] = operand_288;

                    break :block_290 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_289, {}, null, });
                }).@"0"));

                const operand_291 = @as([]const bool, (if (((buffers).lane_1 != null)) block_294: {
                    const operand_292 = (value_1).ready;
                    const operand_293 = false;

                    _ = (try ((std).math).add(usize, (operand_292).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_292));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_292).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_293));

                    break :block_294 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_298: {
                    const operand_295 = (value_1).ready;
                    const operand_296 = false;
                    const operand_297 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_295).len, 1))));

                    @memcpy((operand_297)[0..(operand_295).len], operand_295);

                    (operand_297)[(operand_295).len] = operand_296;

                    break :block_298 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_297, {}, null, });
                }).@"0"));

                break :block_299 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_273, .ready = operand_291, });
            };
        } else {
            if (((block_300: {
                break :block_300 value_2;
            } == @as((zx_abi).zx_type_11, .Tuple)) or (block_301: {
                break :block_301 value_2;
            } == @as((zx_abi).zx_type_11, .Object)))) {
                const value_3: []const u32 = (if ((block_358: {
                    break :block_358 value_2;
                } == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_357: {
                    const operand_319 = block_318: {
                        const operand_303 = block_304: {
                            break :block_304 value_3;
                        };
                        const operand_305 = block_310: {
                            const operand_309 = block_308: {
                                const operand_306 = ((in).table).first;
                                const operand_307 = (in).index;

                                if ((operand_307 >= (operand_306).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_308 (operand_306)[@intCast(operand_307)];
                            };

                            break :block_310 (try function_21(allocator, operand_309));
                        };
                        const operand_311 = block_316: {
                            const operand_315 = block_314: {
                                const operand_312 = ((in).table).second;
                                const operand_313 = (in).index;

                                if ((operand_313 >= (operand_312).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_314 (operand_312)[@intCast(operand_313)];
                            };

                            break :block_316 (try function_21(allocator, operand_315));
                        };

                        const operand_317 = value_1;

                        break :block_318 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_303, .first = operand_305, .remaining = operand_311, .pending = operand_317, });
                    };

                    var state_capacity_321: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_322 = false;

                    defer (state_capacity_321).deinit(allocator);

                    var state_capacity_323: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_324 = false;

                    defer (state_capacity_323).deinit(allocator);

                    var state_302: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_319;
                    var state_changed_320 = false;

                    while (((state_302).remaining > @as(u64, 0))) {
                        state_302 = block_353: {
                            const value_6: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_302;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_352: {
                                break :block_352 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_351: {
                                    break :block_351 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };

                            const value_9: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_350: {
                                break :block_350 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_349: {
                                    break :block_349 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = @as([]const u64, (if (((buffers).lane_0 != null)) block_340: {
                                        const operand_333 = ((value_8).pending).ids;

                                        const operand_339 = block_338: {
                                            const operand_337 = block_336: {
                                                const operand_334 = (value_8).values;
                                                const operand_335 = ((value_8).first + (value_8).remaining);

                                                if ((operand_335 >= (operand_334).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_336 (operand_334)[@intCast(operand_335)];
                                            };

                                            break :block_338 (try function_21(allocator, operand_337));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_333).len, 1));

                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_333));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_333).len;
                                        }

                                        (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_339));

                                        break :block_340 ((((buffers).lane_0.?).buffer).*).items;
                                    } else (block_348: {
                                        const operand_341 = ((value_8).pending).ids;
                                        const operand_347 = block_346: {
                                            const operand_345 = block_344: {
                                                const operand_342 = (value_8).values;
                                                const operand_343 = ((value_8).first + (value_8).remaining);

                                                if ((operand_343 >= (operand_342).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_344 (operand_342)[@intCast(operand_343)];
                                            };

                                            break :block_346 (try function_21(allocator, operand_345));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_341).len, 1));

                                        if ((!state_capacity_started_322)) {
                                            (try (state_capacity_321).appendSlice(allocator, operand_341));
                                            state_capacity_started_322 = true;
                                        } else {
                                            ((state_capacity_321).items).len = (operand_341).len;
                                        }

                                        (try (state_capacity_321).append(allocator, operand_347));

                                        break :block_348 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_321).items, {}, null, });
                                    }).@"0")), .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_332: {
                                break :block_332 @as((zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_331: {
                                    break :block_331 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = @as([]const bool, (if (((buffers).lane_1 != null)) block_327: {
                                        const operand_325 = ((value_11).pending).ready;
                                        const operand_326 = false;

                                        _ = (try ((std).math).add(usize, (operand_325).len, 1));

                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_325));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_325).len;
                                        }

                                        (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_326));

                                        break :block_327 ((((buffers).lane_1.?).buffer).*).items;
                                    } else (block_330: {
                                        const operand_328 = ((value_11).pending).ready;
                                        const operand_329 = false;

                                        _ = (try ((std).math).add(usize, (operand_328).len, 1));

                                        if ((!state_capacity_started_324)) {
                                            (try (state_capacity_323).appendSlice(allocator, operand_328));
                                            state_capacity_started_324 = true;
                                        } else {
                                            ((state_capacity_323).items).len = (operand_328).len;
                                        }

                                        (try (state_capacity_323).append(allocator, operand_329));
                                        break :block_330 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_323).items, {}, null, });
                                    }).@"0")), });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_353 value_14;
                        };

                        state_changed_320 = true;
                    }

                    var state_owned_354: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_354);

                    if (state_capacity_started_322) {
                        ((state_capacity_321).items).len = (((state_302).pending).ids).len;
                        state_owned_354 = (try (state_capacity_321).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_322) {
                        state_302 = (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_302).first, .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_354, .ready = ((state_302).pending).ready, }), .remaining = (state_302).remaining, .values = (state_302).values, };
                    }

                    var state_owned_355: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_355);

                    if (state_capacity_started_324) {
                        ((state_capacity_323).items).len = (((state_302).pending).ready).len;
                        state_owned_355 = (try (state_capacity_323).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_324) {
                        state_302 = (zx_abi).value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_302).first, .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_302).pending).ids, .ready = state_owned_355, }), .remaining = (state_302).remaining, .values = (state_302).values, };
                    }

                    break :block_357 (if (state_changed_320) state_302 else operand_319);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

fn function_25_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_34 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_34 = (in).pending;

    const value_2: (zx_abi).zx_type_11 = (try function_24(allocator, block_516: {
        const operand_514 = ((in).table).kinds;
        const operand_515 = (in).index;

        if ((operand_515 >= (operand_514).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_516 (operand_514)[@intCast(operand_515)];
    }));

    if ((value_2 == @as((zx_abi).zx_type_11, .Task))) {
        return block_428: {
            const operand_364 = @as([]const u64, (if (((buffers).lane_0 != null)) block_383: {
                const operand_378 = @as([]const u64, (if (((buffers).lane_0 != null)) block_370: {
                    const operand_365 = (value_1).ids;

                    const operand_369 = (try function_21(allocator, block_368: {
                        const operand_366 = ((in).table).first;
                        const operand_367 = (in).index;

                        if ((operand_367 >= (operand_366).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_368 (operand_366)[@intCast(operand_367)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_365).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_365));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_365).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_369));

                    break :block_370 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_377: {
                    const operand_371 = (value_1).ids;

                    const operand_375 = (try function_21(allocator, block_374: {
                        const operand_372 = ((in).table).first;
                        const operand_373 = (in).index;

                        if ((operand_373 >= (operand_372).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_374 (operand_372)[@intCast(operand_373)];
                    }));

                    const operand_376 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_371).len, 1))));

                    @memcpy((operand_376)[0..(operand_371).len], operand_371);

                    (operand_376)[(operand_371).len] = operand_375;

                    break :block_377 @as((zx_abi).zx_type_36, .{ operand_376, {}, });
                }).@"0"));

                const operand_382 = (try function_21(allocator, block_381: {
                    const operand_379 = ((in).table).second;
                    const operand_380 = (in).index;

                    if ((operand_380 >= (operand_379).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_381 (operand_379)[@intCast(operand_380)];
                }));

                _ = (try ((std).math).add(usize, (operand_378).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_378));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_378).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_382));

                break :block_383 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_403: {
                const operand_397 = @as([]const u64, (if (((buffers).lane_0 != null)) block_389: {
                    const operand_384 = (value_1).ids;

                    const operand_388 = (try function_21(allocator, block_387: {
                        const operand_385 = ((in).table).first;
                        const operand_386 = (in).index;

                        if ((operand_386 >= (operand_385).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_387 (operand_385)[@intCast(operand_386)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_384).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_384));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_384).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_388));

                    break :block_389 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_396: {
                    const operand_390 = (value_1).ids;

                    const operand_394 = (try function_21(allocator, block_393: {
                        const operand_391 = ((in).table).first;
                        const operand_392 = (in).index;

                        if ((operand_392 >= (operand_391).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_393 (operand_391)[@intCast(operand_392)];
                    }));

                    const operand_395 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_390).len, 1))));

                    @memcpy((operand_395)[0..(operand_390).len], operand_390);

                    (operand_395)[(operand_390).len] = operand_394;

                    break :block_396 @as((zx_abi).zx_type_36, .{ operand_395, {}, });
                }).@"0"));

                const operand_401 = (try function_21(allocator, block_400: {
                    const operand_398 = ((in).table).second;
                    const operand_399 = (in).index;

                    if ((operand_399 >= (operand_398).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_400 (operand_398)[@intCast(operand_399)];
                }));

                const operand_402 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_397).len, 1))));

                @memcpy((operand_402)[0..(operand_397).len], operand_397);

                (operand_402)[(operand_397).len] = operand_401;

                break :block_403 @as((zx_abi).zx_type_36, .{ operand_402, {}, });
            }).@"0"));

            const operand_404 = @as([]const bool, (if (((buffers).lane_1 != null)) block_414: {
                const operand_412 = @as([]const bool, (if (((buffers).lane_1 != null)) block_407: {
                    const operand_405 = (value_1).ready;
                    const operand_406 = false;

                    _ = (try ((std).math).add(usize, (operand_405).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_405));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_405).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_406));

                    break :block_407 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_411: {
                    const operand_408 = (value_1).ready;
                    const operand_409 = false;
                    const operand_410 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_408).len, 1))));

                    @memcpy((operand_410)[0..(operand_408).len], operand_408);
                    (operand_410)[(operand_408).len] = operand_409;

                    break :block_411 @as((zx_abi).zx_type_37, .{ operand_410, {}, });
                }).@"0"));

                const operand_413 = false;

                _ = (try ((std).math).add(usize, (operand_412).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_412));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_412).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_413));

                break :block_414 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_425: {
                const operand_422 = @as([]const bool, (if (((buffers).lane_1 != null)) block_417: {
                    const operand_415 = (value_1).ready;
                    const operand_416 = false;

                    _ = (try ((std).math).add(usize, (operand_415).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_415));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_415).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_416));

                    break :block_417 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_421: {
                    const operand_418 = (value_1).ready;
                    const operand_419 = false;
                    const operand_420 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_418).len, 1))));

                    @memcpy((operand_420)[0..(operand_418).len], operand_418);

                    (operand_420)[(operand_418).len] = operand_419;

                    break :block_421 @as((zx_abi).zx_type_37, .{ operand_420, {}, });
                }).@"0"));

                const operand_423 = false;
                const operand_424 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_422).len, 1))));

                @memcpy((operand_424)[0..(operand_422).len], operand_422);

                (operand_424)[(operand_422).len] = operand_423;

                break :block_425 @as((zx_abi).zx_type_37, .{ operand_424, {}, });
            }).@"0"));

            break :block_428 block_427: {
                const operand_426 = (try (allocator).create((zx_abi).zx_type_34));

                (operand_426).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_364, .ready = operand_404, });

                break :block_427 @as(*const (zx_abi).zx_type_34, operand_426);
            };
        };
    } else {
        if (((value_2 == @as((zx_abi).zx_type_11, .Optional)) or (value_2 == @as((zx_abi).zx_type_11, .List)))) {
            return block_453: {
                const operand_429 = @as([]const u64, (if (((buffers).lane_0 != null)) block_435: {
                    const operand_430 = (value_1).ids;

                    const operand_434 = (try function_21(allocator, block_433: {
                        const operand_431 = ((in).table).first;
                        const operand_432 = (in).index;

                        if ((operand_432 >= (operand_431).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_433 (operand_431)[@intCast(operand_432)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_430).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_430));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_430).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_434));

                    break :block_435 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_442: {
                    const operand_436 = (value_1).ids;

                    const operand_440 = (try function_21(allocator, block_439: {
                        const operand_437 = ((in).table).first;
                        const operand_438 = (in).index;

                        if ((operand_438 >= (operand_437).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_439 (operand_437)[@intCast(operand_438)];
                    }));

                    const operand_441 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_436).len, 1))));

                    @memcpy((operand_441)[0..(operand_436).len], operand_436);

                    (operand_441)[(operand_436).len] = operand_440;

                    break :block_442 @as((zx_abi).zx_type_36, .{ operand_441, {}, });
                }).@"0"));

                const operand_443 = @as([]const bool, (if (((buffers).lane_1 != null)) block_446: {
                    const operand_444 = (value_1).ready;
                    const operand_445 = false;

                    _ = (try ((std).math).add(usize, (operand_444).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_444));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_444).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_445));

                    break :block_446 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_450: {
                    const operand_447 = (value_1).ready;
                    const operand_448 = false;
                    const operand_449 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_447).len, 1))));

                    @memcpy((operand_449)[0..(operand_447).len], operand_447);

                    (operand_449)[(operand_447).len] = operand_448;

                    break :block_450 @as((zx_abi).zx_type_37, .{ operand_449, {}, });
                }).@"0"));

                break :block_453 block_452: {
                    const operand_451 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_451).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_429, .ready = operand_443, });

                    break :block_452 @as(*const (zx_abi).zx_type_34, operand_451);
                };
            };
        } else {
            if (((value_2 == @as((zx_abi).zx_type_11, .Tuple)) or (value_2 == @as((zx_abi).zx_type_11, .Object)))) {
                const value_3: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: *const (zx_abi).zx_type_38 = block_513: {
                    const operand_468 = block_467: {
                        const operand_455 = value_3;

                        const operand_456 = (try function_21(allocator, block_459: {
                            const operand_457 = ((in).table).first;
                            const operand_458 = (in).index;

                            if ((operand_458 >= (operand_457).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_459 (operand_457)[@intCast(operand_458)];
                        }));

                        const operand_460 = (try function_21(allocator, block_463: {
                            const operand_461 = ((in).table).second;
                            const operand_462 = (in).index;

                            if ((operand_462 >= (operand_461).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_463 (operand_461)[@intCast(operand_462)];
                        }));

                        const operand_464 = value_1;

                        break :block_467 block_466: {
                            const operand_465 = (try (allocator).create((zx_abi).zx_type_38));

                            (operand_465).* = @as((zx_abi).zx_type_38, (zx_abi).zx_type_38{ .values = operand_455, .first = operand_456, .remaining = operand_460, .pending = operand_464, });

                            break :block_466 @as(*const (zx_abi).zx_type_38, operand_465);
                        };
                    };

                    var state_capacity_470: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_471 = false;

                    defer (state_capacity_470).deinit(allocator);

                    var state_capacity_472: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_473 = false;

                    defer (state_capacity_472).deinit(allocator);

                    const state_type_474 = struct {
                        ids: []const u64,
                        ready: []const bool,
                    };
                    const state_type_475 = struct {
                        first: u64,
                        pending: state_type_474,
                        remaining: u64,
                        values: []const u32,
                    };
                    const state_type_479 = struct { []const bool, void, };
                    const state_type_493 = struct { []const u64, void, };
                    var state_454: state_type_475 = state_type_475{ .first = (operand_468).first, .pending = state_type_474{ .ids = ((operand_468).pending).ids, .ready = ((operand_468).pending).ready, }, .remaining = (operand_468).remaining, .values = (operand_468).values, };
                    var state_changed_469 = false;

                    while (((state_454).remaining > @as(u64, 0))) {
                        state_454 = block_505: {
                            const value_6: state_type_475 = state_454;
                            const value_7: u64 = (value_6).remaining;
                            const value_8: state_type_475 = block_504: {
                                break :block_504 state_type_475{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (value_7 - @as(u64, 1)), .values = (value_6).values, };
                            };
                            const value_9: state_type_475 = value_8;
                            const value_10: state_type_474 = (value_9).pending;
                            const value_11: state_type_475 = block_503: {
                                break :block_503 state_type_475{ .first = (value_9).first, .pending = block_502: {
                                    break :block_502 state_type_474{ .ids = block_501: {
                                        const operand_500 = @as([]const u64, (if (((buffers).lane_0 != null)) block_492: {
                                            const operand_487 = ((value_8).pending).ids;

                                            const operand_491 = (try function_21(allocator, block_490: {
                                                const operand_488 = (value_8).values;
                                                const operand_489 = ((value_8).first + (value_8).remaining);

                                                if ((operand_489 >= (operand_488).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_490 (operand_488)[@intCast(operand_489)];
                                            }));

                                            _ = (try ((std).math).add(usize, (operand_487).len, 1));

                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_487));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_487).len;
                                            }

                                            (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_491));

                                            break :block_492 ((((buffers).lane_0.?).buffer).*).items;
                                        } else (block_499: {
                                            const operand_494 = ((value_8).pending).ids;

                                            const operand_498 = (try function_21(allocator, block_497: {
                                                const operand_495 = (value_8).values;
                                                const operand_496 = ((value_8).first + (value_8).remaining);

                                                if ((operand_496 >= (operand_495).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_497 (operand_495)[@intCast(operand_496)];
                                            }));

                                            _ = (try ((std).math).add(usize, (operand_494).len, 1));

                                            if ((!state_capacity_started_471)) {
                                                (try (state_capacity_470).appendSlice(allocator, operand_494));
                                                state_capacity_started_471 = true;
                                            } else {
                                                ((state_capacity_470).items).len = (operand_494).len;
                                            }

                                            (try (state_capacity_470).append(allocator, operand_498));

                                            break :block_499 @as(state_type_493, .{ (state_capacity_470).items, {}, });
                                        }).@"0"));

                                        break :block_501 operand_500;
                                    }, .ready = (value_10).ready, };
                                }, .remaining = (value_9).remaining, .values = (value_9).values, };
                            };
                            const value_12: state_type_475 = value_11;
                            const value_13: state_type_474 = (value_12).pending;
                            const value_14: state_type_475 = block_486: {
                                break :block_486 state_type_475{ .first = (value_12).first, .pending = block_485: {
                                    break :block_485 state_type_474{ .ids = (value_13).ids, .ready = block_484: {
                                        const operand_483 = @as([]const bool, (if (((buffers).lane_1 != null)) block_478: {
                                            const operand_476 = ((value_11).pending).ready;
                                            const operand_477 = false;

                                            _ = (try ((std).math).add(usize, (operand_476).len, 1));

                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_476));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_476).len;
                                            }

                                            (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_477));

                                            break :block_478 ((((buffers).lane_1.?).buffer).*).items;
                                        } else (block_482: {
                                            const operand_480 = ((value_11).pending).ready;
                                            const operand_481 = false;

                                            _ = (try ((std).math).add(usize, (operand_480).len, 1));

                                            if ((!state_capacity_started_473)) {
                                                (try (state_capacity_472).appendSlice(allocator, operand_480));
                                                state_capacity_started_473 = true;
                                            } else {
                                                ((state_capacity_472).items).len = (operand_480).len;
                                            }

                                            (try (state_capacity_472).append(allocator, operand_481));

                                            break :block_482 @as(state_type_479, .{ (state_capacity_472).items, {}, });
                                        }).@"0"));

                                        break :block_484 operand_483;
                                    }, };
                                }, .remaining = (value_12).remaining, .values = (value_12).values, };
                            };

                            break :block_505 value_14;
                        };

                        state_changed_469 = true;
                    }

                    var state_owned_506: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_506);

                    if (state_capacity_started_471) {
                        ((state_capacity_470).items).len = (((state_454).pending).ids).len;
                        state_owned_506 = (try (state_capacity_470).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_471) {
                        ((state_454).pending).ids = state_owned_506;
                    }

                    var state_owned_507: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_507);

                    if (state_capacity_started_473) {
                        ((state_capacity_472).items).len = (((state_454).pending).ready).len;
                        state_owned_507 = (try (state_capacity_472).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_473) {
                        ((state_454).pending).ready = state_owned_507;
                    }

                    break :block_513 (if (state_changed_469) block_512: {
                        const operand_511 = (try (allocator).create((zx_abi).zx_type_38));

                        (operand_511).* = @as((zx_abi).zx_type_38, (zx_abi).zx_type_38{ .first = (state_454).first, .pending = block_510: {
                            const operand_509 = (try (allocator).create((zx_abi).zx_type_34));

                            (operand_509).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = ((state_454).pending).ids, .ready = ((state_454).pending).ready, });

                            break :block_510 @as(*const (zx_abi).zx_type_34, operand_509);
                        }, .remaining = (state_454).remaining, .values = (state_454).values, });

                        break :block_512 @as(*const (zx_abi).zx_type_38, operand_511);
                    } else operand_468);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

fn function_26(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_39) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_12: (zx_abi).zx_type_40 = block_32: {
        const operand_10 = block_9: {
            const operand_2 = (in).origins;
            const operand_3 = (in).names;
            const operand_4 = (in).index;
            const operand_5 = (in).name;
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_40{ .origins = operand_2, .names = operand_3, .id = operand_4, .name = operand_5, .index = operand_6, .result = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (operand_10).id, .index = (operand_10).index, .name = (operand_10).name, .names = (operand_10).names, .origins = (operand_10).origins, .result = (operand_10).result, .valid = (operand_10).valid, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).origins).ids).len)))) {
            state_1 = block_29: {
                const value_8: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_17: {
                    const operand_16 = block_15: {
                        const operand_13 = ((state_1).origins).ids;
                        const operand_14 = (state_1).index;

                        if ((operand_14 >= (operand_13).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_15 (operand_13)[@intCast(operand_14)];
                    };

                    break :block_17 (try function_21(allocator, operand_16));
                } == (state_1).id)) block_28: {
                    const value_7: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((((state_1).result != @as(u64, 0)) or (!block_23: {
                        const operand_21 = block_20: {
                            const operand_18 = (state_1).names;
                            const operand_19 = (state_1).index;

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        };

                        const operand_22 = (state_1).name;

                        break :block_23 ((std).mem).eql(u8, operand_21, operand_22);
                    }))) block_25: {
                        const value_3: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        const value_4: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_24: {
                            break :block_24 @as((zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_3).id, .index = (value_3).index, .name = (value_3).name, .names = (value_3).names, .origins = (value_3).origins, .result = (value_3).result, .valid = false, });
                        };

                        break :block_25 value_4;
                    } else block_27: {
                        const value_5: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        const value_6: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_26: {
                            break :block_26 @as((zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_5).id, .index = (value_5).index, .name = (value_5).name, .names = (value_5).names, .origins = (value_5).origins, .result = ((state_1).index + @as(u64, 2)), .valid = (value_5).valid, });
                        };

                        break :block_27 value_6;
                    });

                    break :block_28 value_7;
                } else state_1);

                const value_9: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_9).id, .index = (block_11: {
                        break :block_11 value_10;
                    } + @as(u64, 1)), .name = (value_9).name, .names = (value_9).names, .origins = (value_9).origins, .result = (value_9).result, .valid = (value_9).valid, });
                };

                break :block_29 value_11;
            };
        }

        break :block_32 block_31: {
            break :block_31 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_30: {
                break :block_30 (zx_abi).zx_type_40{ .id = (state_1).id, .index = (state_1).index, .name = (state_1).name, .names = (state_1).names, .origins = (state_1).origins, .result = (state_1).result, .valid = (state_1).valid, };
            });
        };
    };

    return (if (((&value_12)).valid) ((&value_12)).result else @as(u64, 1));
}

fn function_27(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_150: {
        const operand_149 = (in).index;

        break :block_150 (try (allocator).dupe(u64, (&[_]u64{operand_149, })));
    };

    const value_2: []const bool = block_148: {
        const operand_147 = false;

        break :block_148 (try (allocator).dupe(bool, (&[_]bool{operand_147, })));
    };

    const value_55: *const (zx_abi).zx_type_42 = block_146: {
        const operand_13 = block_12: {
            const operand_2 = (in).request;
            const operand_3 = (in).state;

            const operand_4 = block_9: {
                const operand_5 = value_1;
                const operand_6 = value_2;

                break :block_9 block_8: {
                    const operand_7 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_7).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_5, .ready = operand_6, });

                    break :block_8 @as(*const (zx_abi).zx_type_34, operand_7);
                };
            };

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_42));

                (operand_10).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{ .request = operand_2, .plan = operand_3, .pending = operand_4, });

                break :block_11 @as(*const (zx_abi).zx_type_42, operand_10);
            };
        };

        var state_capacity_15: (std).ArrayList(u64) = .empty;
        var state_capacity_started_16 = false;

        defer (state_capacity_15).deinit(allocator);

        var state_capacity_17: (std).ArrayList(bool) = .empty;
        var state_capacity_started_18 = false;

        defer (state_capacity_17).deinit(allocator);

        var state_items_19: []u64 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_items_23: []u64 = undefined;
        var state_items_started_24 = false;

        const state_type_28 = struct {
            ids: []const u64,
            ready: []const bool,
        };
        const state_type_29 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_30 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_31 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_32 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_30,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_31,
        };
        const state_type_33 = struct {
            pending: state_type_28,
            plan: state_type_29,
            request: state_type_32,
        };
        const state_type_34 = struct {
            index: u64,
            pending: state_type_28,
            table: state_type_31,
        };

        const state_type_50 = struct { []const bool, void, };
        const state_type_56 = struct { []const u64, void, };

        const state_type_78 = struct {
            index: u64,
            name: []const u8,
            names: []const []const u8,
            origins: state_type_30,
        };
        const state_type_114 = struct { []const bool, ?bool, };
        const state_type_119 = struct { []const u64, ?u64, };
        var state_1: state_type_33 = state_type_33{ .pending = state_type_28{ .ids = ((operand_13).pending).ids, .ready = ((operand_13).pending).ready, }, .plan = state_type_29{ .count = ((operand_13).plan).count, .mapping = ((operand_13).plan).mapping, .order = ((operand_13).plan).order, .origins = ((operand_13).plan).origins, .status = ((operand_13).plan).status, }, .request = state_type_32{ .maximum_count = ((operand_13).request).maximum_count, .names = ((operand_13).request).names, .origins = state_type_30{ .ids = (((operand_13).request).origins).ids, .kinds = (((operand_13).request).origins).kinds, .members = (((operand_13).request).origins).members, .owners = (((operand_13).request).origins).owners, }, .roots = ((operand_13).request).roots, .scalar_count = ((operand_13).request).scalar_count, .table = state_type_31{ .children = (((operand_13).request).table).children, .field_names = (((operand_13).request).table).field_names, .field_types = (((operand_13).request).table).field_types, .first = (((operand_13).request).table).first, .kinds = (((operand_13).request).table).kinds, .labels = (((operand_13).request).table).labels, .names = (((operand_13).request).table).names, .second = (((operand_13).request).table).second, }, }, };
        var state_changed_14 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_27, .Ready)) and (@as(u64, (((state_1).pending).ids).len) > @as(u64, 0)))) {
            state_1 = block_130: {
                const value_5: u64 = (@as(u64, (((state_1).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_129: {
                    const operand_127 = ((state_1).pending).ids;
                    const operand_128 = value_5;

                    if ((operand_128 >= (operand_127).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_129 (operand_127)[@intCast(operand_128)];
                };
                const value_7: bool = block_126: {
                    const operand_124 = ((state_1).pending).ready;
                    const operand_125 = value_5;

                    if ((operand_125 >= (operand_124).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_126 (operand_124)[@intCast(operand_125)];
                };
                const value_8: state_type_33 = state_1;
                const value_9: state_type_28 = (value_8).pending;

                const value_10: state_type_33 = block_123: {
                    break :block_123 state_type_33{ .pending = block_122: {
                        break :block_122 state_type_28{ .ids = (block_121: {
                            const operand_120 = ((state_1).pending).ids;

                            break :block_121 @as(state_type_119, (if (((operand_120).len == 0)) .{ operand_120, null, } else .{ (operand_120)[0..((operand_120).len - 1)], (operand_120)[((operand_120).len - 1)], }));
                        }).@"0", .ready = (value_9).ready, };
                    }, .plan = (value_8).plan, .request = (value_8).request, };
                };
                const value_11: state_type_33 = value_10;
                const value_12: state_type_28 = (value_11).pending;

                const value_13: state_type_33 = block_118: {
                    break :block_118 state_type_33{ .pending = block_117: {
                        break :block_117 state_type_28{ .ids = (value_12).ids, .ready = (block_116: {
                            const operand_115 = ((value_10).pending).ready;

                            break :block_116 @as(state_type_114, (if (((operand_115).len == 0)) .{ operand_115, null, } else .{ (operand_115)[0..((operand_115).len - 1)], (operand_115)[((operand_115).len - 1)], }));
                        }).@"0", };
                    }, .plan = (value_11).plan, .request = (value_11).request, };
                };
                const value_54: state_type_33 = (if ((block_27: {
                    const operand_25 = ((value_13).plan).mapping;
                    const operand_26 = value_6;

                    if ((operand_26 >= (operand_25).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_27 (operand_25)[@intCast(operand_26)];
                } == @as(u64, 0))) block_113: {
                    const value_53: state_type_33 = (if ((!value_7)) block_62: {
                        const value_14: state_type_33 = value_13;
                        const value_15: state_type_28 = (value_14).pending;
                        const value_16: state_type_33 = block_61: {
                            break :block_61 state_type_33{ .pending = block_60: {
                                break :block_60 state_type_28{ .ids = (block_59: {
                                    const operand_57 = ((value_13).pending).ids;
                                    const operand_58 = value_6;

                                    _ = (try ((std).math).add(usize, (operand_57).len, 1));

                                    if ((!state_capacity_started_16)) {
                                        (try (state_capacity_15).appendSlice(allocator, operand_57));
                                        state_capacity_started_16 = true;
                                    } else {
                                        ((state_capacity_15).items).len = (operand_57).len;
                                    }

                                    (try (state_capacity_15).append(allocator, operand_58));

                                    break :block_59 @as(state_type_56, .{ (state_capacity_15).items, {}, });
                                }).@"0", .ready = (value_15).ready, };
                            }, .plan = (value_14).plan, .request = (value_14).request, };
                        };
                        const value_17: state_type_33 = value_16;
                        const value_18: state_type_28 = (value_17).pending;
                        const value_19: state_type_33 = block_55: {
                            break :block_55 state_type_33{ .pending = block_54: {
                                break :block_54 state_type_28{ .ids = (value_18).ids, .ready = (block_53: {
                                    const operand_51 = ((value_16).pending).ready;
                                    const operand_52 = true;

                                    _ = (try ((std).math).add(usize, (operand_51).len, 1));

                                    if ((!state_capacity_started_18)) {
                                        (try (state_capacity_17).appendSlice(allocator, operand_51));

                                        state_capacity_started_18 = true;
                                    } else {
                                        ((state_capacity_17).items).len = (operand_51).len;
                                    }

                                    (try (state_capacity_17).append(allocator, operand_52));

                                    break :block_53 @as(state_type_50, .{ (state_capacity_17).items, {}, });
                                }).@"0", };
                            }, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_20: state_type_33 = value_19;
                        const value_21: state_type_33 = block_49: {
                            break :block_49 state_type_33{ .pending = block_48: {
                                const operand_39 = block_38: {
                                    const operand_35 = ((value_19).request).table;
                                    const operand_36 = value_6;
                                    const operand_37 = (value_19).pending;

                                    break :block_38 state_type_34{ .table = operand_35, .index = operand_36, .pending = operand_37, };
                                };

                                const operand_40 = (zx_abi).zx_type_34{ .ids = ((operand_39).pending).ids, .ready = ((operand_39).pending).ready, };
                                const operand_41 = (zx_abi).zx_type_15{ .children = ((operand_39).table).children, .field_names = ((operand_39).table).field_names, .field_types = ((operand_39).table).field_types, .first = ((operand_39).table).first, .kinds = ((operand_39).table).kinds, .labels = ((operand_39).table).labels, .names = ((operand_39).table).names, .second = ((operand_39).table).second, };
                                const operand_42 = (zx_abi).zx_type_35{ .index = (operand_39).index, .pending = (&operand_40), .table = (&operand_41), };

                                const operand_47 = block_46: {
                                    const operand_43 = (&operand_42);
                                    const operand_44 = (try function_25_buffered(allocator, (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_43).index, .pending = (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_43).pending).ids, .ready = ((operand_43).pending).ready, .zx_origin = (operand_43).pending, }, .table = (operand_43).table, .zx_origin = operand_43, }, .{ .lane_0 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, .lane_1 = .{ .buffer = (&state_capacity_17), .started = (&state_capacity_started_18), }, }));

                                    break :block_46 (if (((operand_44).zx_origin != null)) ((operand_44).zx_origin.?).* else block_45: {
                                        break :block_45 (zx_abi).zx_type_34{ .ids = (operand_44).ids, .ready = (operand_44).ready, };
                                    });
                                };

                                break :block_48 state_type_28{ .ids = (operand_47).ids, .ready = (operand_47).ready, };
                            }, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_62 value_21;
                    } else block_112: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: state_type_33 = value_13;
                        const value_24: state_type_29 = (value_23).plan;
                        const value_25: []const u64 = (value_24).mapping;
                        const value_26: u64 = value_6;
                        const value_27: state_type_33 = block_111: {
                            break :block_111 state_type_33{ .pending = (value_23).pending, .plan = block_110: {
                                break :block_110 state_type_29{ .count = (value_24).count, .mapping = block_109: {
                                    const operand_105 = value_25;
                                    const operand_106 = value_26;

                                    if ((operand_106 >= (operand_105).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_107 = (value_22 + @as(u64, 1));

                                    break :block_109 block_108: {
                                        if ((!state_items_started_20)) {
                                            state_items_19 = (try (allocator).dupe(u64, operand_105));
                                            state_items_started_20 = true;
                                        }

                                        (state_items_19)[@intCast(operand_106)] = operand_107;

                                        break :block_108 state_items_19;
                                    };
                                }, .order = (value_24).order, .origins = (value_24).origins, .status = (value_24).status, };
                            }, .request = (value_23).request, };
                        };
                        const value_28: state_type_33 = value_27;
                        const value_29: state_type_29 = (value_28).plan;
                        const value_30: []const u32 = (value_29).order;
                        const value_31: u64 = value_22;
                        const value_32: state_type_33 = block_104: {
                            break :block_104 state_type_33{ .pending = (value_28).pending, .plan = block_103: {
                                break :block_103 state_type_29{ .count = (value_29).count, .mapping = (value_29).mapping, .order = block_102: {
                                    const operand_98 = value_30;
                                    const operand_99 = value_31;

                                    if ((operand_99 >= (operand_98).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_100 = (try function_23(allocator, value_6));

                                    break :block_102 block_101: {
                                        if ((!state_items_started_22)) {
                                            state_items_21 = (try (allocator).dupe(u32, operand_98));
                                            state_items_started_22 = true;
                                        }

                                        (state_items_21)[@intCast(operand_99)] = operand_100;

                                        break :block_101 state_items_21;
                                    };
                                }, .origins = (value_29).origins, .status = (value_29).status, };
                            }, .request = (value_28).request, };
                        };
                        const value_33: state_type_33 = value_32;
                        const value_34: state_type_29 = (value_33).plan;
                        const value_35: u64 = (value_34).count;

                        const value_36: state_type_33 = block_97: {
                            break :block_97 state_type_33{ .pending = (value_33).pending, .plan = block_96: {
                                break :block_96 state_type_29{ .count = (value_35 + @as(u64, 1)), .mapping = (value_34).mapping, .order = (value_34).order, .origins = (value_34).origins, .status = (value_34).status, };
                            }, .request = (value_33).request, };
                        };
                        const value_37: (zx_abi).zx_type_11 = (try function_24(allocator, block_95: {
                            const operand_93 = (((value_36).request).table).kinds;
                            const operand_94 = value_6;

                            if ((operand_94 >= (operand_93).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_95 (operand_93)[@intCast(operand_94)];
                        }));

                        const value_52: state_type_33 = (if (((value_37 == @as((zx_abi).zx_type_11, .Enumeration)) or (value_37 == @as((zx_abi).zx_type_11, .NativeReference)))) block_92: {
                            const value_38: u64 = block_91: {
                                const operand_87 = block_86: {
                                    const operand_79 = ((value_36).request).origins;
                                    const operand_80 = ((value_36).request).names;
                                    const operand_81 = value_6;
                                    const operand_85 = block_84: {
                                        const operand_82 = (((value_36).request).table).labels;
                                        const operand_83 = value_6;

                                        if ((operand_83 >= (operand_82).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_84 (operand_82)[@intCast(operand_83)];
                                    };

                                    break :block_86 state_type_78{ .origins = operand_79, .names = operand_80, .index = operand_81, .name = operand_85, };
                                };

                                const operand_88 = (zx_abi).zx_type_23{ .ids = ((operand_87).origins).ids, .kinds = ((operand_87).origins).kinds, .members = ((operand_87).origins).members, .owners = ((operand_87).origins).owners, };
                                const operand_89 = (zx_abi).zx_type_39{ .index = (operand_87).index, .name = (operand_87).name, .names = (operand_87).names, .origins = (&operand_88), };
                                const operand_90 = (try function_26(allocator, (&operand_89)));

                                break :block_91 operand_90;
                            };
                            const value_51: state_type_33 = (if ((value_38 == @as(u64, 0))) block_65: {
                                const value_39: state_type_33 = value_36;
                                const value_40: state_type_29 = (value_39).plan;

                                const value_41: state_type_33 = block_64: {
                                    break :block_64 state_type_33{ .pending = (value_39).pending, .plan = block_63: {
                                        break :block_63 state_type_29{ .count = (value_40).count, .mapping = (value_40).mapping, .order = (value_40).order, .origins = (value_40).origins, .status = @as((zx_abi).zx_type_27, .MissingOrigin), };
                                    }, .request = (value_39).request, };
                                };

                                break :block_65 value_41;
                            } else block_77: {
                                const value_50: state_type_33 = (if ((value_38 == @as(u64, 1))) block_68: {
                                    const value_42: state_type_33 = value_36;
                                    const value_43: state_type_29 = (value_42).plan;
                                    const value_44: state_type_33 = block_67: {
                                        break :block_67 state_type_33{ .pending = (value_42).pending, .plan = block_66: {
                                            break :block_66 state_type_29{ .count = (value_43).count, .mapping = (value_43).mapping, .order = (value_43).order, .origins = (value_43).origins, .status = @as((zx_abi).zx_type_27, .Invalid), };
                                        }, .request = (value_42).request, };
                                    };

                                    break :block_68 value_44;
                                } else block_76: {
                                    const value_45: state_type_33 = value_36;
                                    const value_46: state_type_29 = (value_45).plan;
                                    const value_47: []const u64 = (value_46).origins;
                                    const value_48: u64 = value_22;
                                    const value_49: state_type_33 = block_75: {
                                        break :block_75 state_type_33{ .pending = (value_45).pending, .plan = block_74: {
                                            break :block_74 state_type_29{ .count = (value_46).count, .mapping = (value_46).mapping, .order = (value_46).order, .origins = block_73: {
                                                const operand_69 = value_47;
                                                const operand_70 = value_48;

                                                if ((operand_70 >= (operand_69).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_71 = (value_38 - @as(u64, 1));

                                                break :block_73 block_72: {
                                                    if ((!state_items_started_24)) {
                                                        state_items_23 = (try (allocator).dupe(u64, operand_69));
                                                        state_items_started_24 = true;
                                                    }

                                                    (state_items_23)[@intCast(operand_70)] = operand_71;

                                                    break :block_72 state_items_23;
                                                };
                                            }, .status = (value_46).status, };
                                        }, .request = (value_45).request, };
                                    };

                                    break :block_76 value_49;
                                });

                                break :block_77 value_50;
                            });

                            break :block_92 value_51;
                        } else value_36);

                        break :block_112 value_52;
                    });

                    break :block_113 value_53;
                } else value_13);

                break :block_130 value_54;
            };

            state_changed_14 = true;
        }

        var state_owned_131: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_131);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).pending).ids).len;
            state_owned_131 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            ((state_1).pending).ids = state_owned_131;
        }

        var state_owned_132: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_132);

        if (state_capacity_started_18) {
            ((state_capacity_17).items).len = (((state_1).pending).ready).len;
            state_owned_132 = (try (state_capacity_17).toOwnedSlice(allocator));
        }

        if (state_capacity_started_18) {
            ((state_1).pending).ready = state_owned_132;
        }

        break :block_146 (if (state_changed_14) block_145: {
            const operand_144 = (try (allocator).create((zx_abi).zx_type_42));

            (operand_144).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{ .pending = block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_34));

                (operand_134).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = ((state_1).pending).ids, .ready = ((state_1).pending).ready, });

                break :block_135 @as(*const (zx_abi).zx_type_34, operand_134);
            }, .plan = block_137: {
                const operand_136 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_136).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_137 @as(*const (zx_abi).zx_type_29, operand_136);
            }, .request = block_143: {
                const operand_142 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_142).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = block_139: {
                    const operand_138 = (try (allocator).create((zx_abi).zx_type_23));

                    (operand_138).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (((state_1).request).origins).ids, .kinds = (((state_1).request).origins).kinds, .members = (((state_1).request).origins).members, .owners = (((state_1).request).origins).owners, });

                    break :block_139 @as(*const (zx_abi).zx_type_23, operand_138);
                }, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = block_141: {
                    const operand_140 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_140).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).request).table).children, .field_names = (((state_1).request).table).field_names, .field_types = (((state_1).request).table).field_types, .first = (((state_1).request).table).first, .kinds = (((state_1).request).table).kinds, .labels = (((state_1).request).table).labels, .names = (((state_1).request).table).names, .second = (((state_1).request).table).second, });

                    break :block_141 @as(*const (zx_abi).zx_type_15, operand_140);
                }, });

                break :block_143 @as(*const (zx_abi).zx_type_31, operand_142);
            }, });

            break :block_145 @as(*const (zx_abi).zx_type_42, operand_144);
        } else operand_13);
    };

    return (value_55).plan;
}

fn function_27_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_335: {
        const operand_334 = (in).index;

        break :block_335 (try (allocator).dupe(u64, (&[_]u64{operand_334, })));
    };

    const value_2: []const bool = block_333: {
        const operand_332 = false;

        break :block_333 (try (allocator).dupe(bool, (&[_]bool{operand_332, })));
    };

    const value_55: (zx_abi).zx_type_42 = block_331: {
        const operand_161 = block_160: {
            const operand_152 = (in).request;
            const operand_153 = (in).state;

            const operand_154 = block_159: {
                const operand_155 = value_1;
                const operand_156 = value_2;

                break :block_159 block_158: {
                    const operand_157 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_157).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_155, .ready = operand_156, });

                    break :block_158 @as(*const (zx_abi).zx_type_34, operand_157);
                };
            };

            break :block_160 (zx_abi).zx_type_42{ .request = operand_152, .plan = operand_153, .pending = operand_154, };
        };

        var state_capacity_162: (std).ArrayList(u64) = .empty;
        var state_capacity_started_163 = false;

        defer (state_capacity_162).deinit(allocator);

        var state_capacity_164: (std).ArrayList(bool) = .empty;
        var state_capacity_started_165 = false;

        defer (state_capacity_164).deinit(allocator);

        var state_items_166: []u64 = undefined;
        var state_items_started_167 = false;
        var state_items_168: []u32 = undefined;
        var state_items_started_169 = false;
        var state_items_170: []u64 = undefined;
        var state_items_started_171 = false;
        var state_151: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_161).pending).ids, .ready = ((operand_161).pending).ready, .zx_origin = (operand_161).pending, }, .plan = (operand_161).plan, .request = (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_161).request).maximum_count, .names = ((operand_161).request).names, .origins = ((operand_161).request).origins, .roots = ((operand_161).request).roots, .scalar_count = ((operand_161).request).scalar_count, .table = ((operand_161).request).table, .zx_origin = (operand_161).request, }, .zx_origin = (&operand_161), };

        while (((((state_151).plan).status == @as((zx_abi).zx_type_27, .Ready)) and (@as(u64, (((state_151).pending).ids).len) > @as(u64, 0)))) {
            state_151 = block_322: {
                const value_5: u64 = (@as(u64, (((state_151).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_321: {
                    const operand_319 = ((state_151).pending).ids;

                    const operand_320 = block_318: {
                        break :block_318 value_5;
                    };

                    if ((operand_320 >= (operand_319).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_321 (operand_319)[@intCast(operand_320)];
                };
                const value_7: bool = block_317: {
                    const operand_315 = ((state_151).pending).ready;

                    const operand_316 = block_314: {
                        break :block_314 value_5;
                    };

                    if ((operand_316 >= (operand_315).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_317 (operand_315)[@intCast(operand_316)];
                };
                const value_8: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_151;
                const value_9: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_313: {
                    break :block_313 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_312: {
                        break :block_312 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_311: {
                            const operand_310 = ((state_151).pending).ids;

                            break :block_311 @as((zx_abi).value_zx_type_44_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_310).len == 0)) .{ operand_310, null, null, } else .{ (operand_310)[0..((operand_310).len - 1)], (operand_310)[((operand_310).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_309: {
                    break :block_309 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_308: {
                        break :block_308 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_307: {
                            const operand_306 = ((value_10).pending).ready;

                            break :block_307 @as((zx_abi).value_zx_type_46_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_306).len == 0)) .{ operand_306, null, null, } else .{ (operand_306)[0..((operand_306).len - 1)], (operand_306)[((operand_306).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_175: {
                    const operand_173 = ((value_13).plan).mapping;

                    const operand_174 = block_172: {
                        break :block_172 value_6;
                    };

                    if ((operand_174 >= (operand_173).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_175 (operand_173)[@intCast(operand_174)];
                } == @as(u64, 0))) block_305: {
                    const value_53: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_176: {
                        break :block_176 value_7;
                    })) block_195: {
                        const value_14: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_194: {
                            break :block_194 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_193: {
                                break :block_193 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_192: {
                                    const operand_189 = ((value_13).pending).ids;

                                    const operand_191 = block_190: {
                                        break :block_190 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_189).len, 1));

                                    if ((!state_capacity_started_163)) {
                                        (try (state_capacity_162).appendSlice(allocator, operand_189));

                                        state_capacity_started_163 = true;
                                    } else {
                                        ((state_capacity_162).items).len = (operand_189).len;
                                    }

                                    (try (state_capacity_162).append(allocator, operand_191));

                                    break :block_192 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_162).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_188: {
                            break :block_188 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_187: {
                                break :block_187 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_186: {
                                    const operand_184 = ((value_16).pending).ready;
                                    const operand_185 = true;

                                    _ = (try ((std).math).add(usize, (operand_184).len, 1));

                                    if ((!state_capacity_started_165)) {
                                        (try (state_capacity_164).appendSlice(allocator, operand_184));

                                        state_capacity_started_165 = true;
                                    } else {
                                        ((state_capacity_164).items).len = (operand_184).len;
                                    }

                                    (try (state_capacity_164).append(allocator, operand_185));

                                    break :block_186 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_164).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_183: {
                            break :block_183 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_182: {
                                break :block_182 (try function_25_buffered(allocator, block_181: {
                                    const operand_177 = ((value_19).request).table;

                                    const operand_178 = block_179: {
                                        break :block_179 value_6;
                                    };

                                    const operand_180 = (value_19).pending;

                                    break :block_181 @as((zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_177, .index = operand_178, .pending = operand_180, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_162), .started = (&state_capacity_started_163), }, .lane_1 = .{ .buffer = (&state_capacity_164), .started = (&state_capacity_started_165), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_195 value_21;
                    } else block_304: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_29 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_303: {
                            break :block_303 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_302: {
                            break :block_302 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_301: {
                            break :block_301 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_300: {
                                break :block_300 block_299: {
                                    const operand_298 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_298).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_286: {
                                        break :block_286 (&value_24);
                                    }).count, .mapping = block_294: {
                                        const operand_288 = block_287: {
                                            break :block_287 value_25;
                                        };
                                        const operand_290 = block_289: {
                                            break :block_289 value_26;
                                        };

                                        if ((operand_290 >= (operand_288).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_292 = (block_291: {
                                            break :block_291 value_22;
                                        } + @as(u64, 1));

                                        break :block_294 block_293: {
                                            if ((!state_items_started_167)) {
                                                state_items_166 = (try (allocator).dupe(u64, operand_288));
                                                state_items_started_167 = true;
                                            }

                                            (state_items_166)[@intCast(operand_290)] = operand_292;

                                            break :block_293 state_items_166;
                                        };
                                    }, .order = (block_295: {
                                        break :block_295 (&value_24);
                                    }).order, .origins = (block_296: {
                                        break :block_296 (&value_24);
                                    }).origins, .status = (block_297: {
                                        break :block_297 (&value_24);
                                    }).status, });

                                    break :block_299 @as(*const (zx_abi).zx_type_29, operand_298);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_29 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_285: {
                            break :block_285 (&value_29);
                        }).order;
                        const value_31: u64 = block_284: {
                            break :block_284 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_283: {
                            break :block_283 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_282: {
                                break :block_282 block_281: {
                                    const operand_280 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_280).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_266: {
                                        break :block_266 (&value_29);
                                    }).count, .mapping = (block_267: {
                                        break :block_267 (&value_29);
                                    }).mapping, .order = block_277: {
                                        const operand_269 = block_268: {
                                            break :block_268 value_30;
                                        };
                                        const operand_271 = block_270: {
                                            break :block_270 value_31;
                                        };

                                        if ((operand_271 >= (operand_269).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_275 = block_274: {
                                            const operand_273 = block_272: {
                                                break :block_272 value_6;
                                            };

                                            break :block_274 (try function_23(allocator, operand_273));
                                        };

                                        break :block_277 block_276: {
                                            if ((!state_items_started_169)) {
                                                state_items_168 = (try (allocator).dupe(u32, operand_269));
                                                state_items_started_169 = true;
                                            }

                                            (state_items_168)[@intCast(operand_271)] = operand_275;

                                            break :block_276 state_items_168;
                                        };
                                    }, .origins = (block_278: {
                                        break :block_278 (&value_29);
                                    }).origins, .status = (block_279: {
                                        break :block_279 (&value_29);
                                    }).status, });

                                    break :block_281 @as(*const (zx_abi).zx_type_29, operand_280);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_29 = ((value_33).plan).*;

                        const value_35: u64 = (block_265: {
                            break :block_265 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_264: {
                            break :block_264 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_263: {
                                break :block_263 block_262: {
                                    const operand_261 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_261).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_256: {
                                        break :block_256 value_35;
                                    } + @as(u64, 1)), .mapping = (block_257: {
                                        break :block_257 (&value_34);
                                    }).mapping, .order = (block_258: {
                                        break :block_258 (&value_34);
                                    }).order, .origins = (block_259: {
                                        break :block_259 (&value_34);
                                    }).origins, .status = (block_260: {
                                        break :block_260 (&value_34);
                                    }).status, });

                                    break :block_262 @as(*const (zx_abi).zx_type_29, operand_261);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_11 = block_255: {
                            const operand_254 = block_253: {
                                const operand_251 = (((value_36).request).table).kinds;

                                const operand_252 = block_250: {
                                    break :block_250 value_6;
                                };

                                if ((operand_252 >= (operand_251).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_253 (operand_251)[@intCast(operand_252)];
                            };

                            break :block_255 (try function_24(allocator, operand_254));
                        };

                        const value_52: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_196: {
                            break :block_196 value_37;
                        } == @as((zx_abi).zx_type_11, .Enumeration)) or (block_197: {
                            break :block_197 value_37;
                        } == @as((zx_abi).zx_type_11, .NativeReference)))) block_249: {
                            const value_38: u64 = block_248: {
                                const operand_238 = ((value_36).request).origins;
                                const operand_239 = ((value_36).request).names;

                                const operand_241 = block_240: {
                                    break :block_240 value_6;
                                };
                                const operand_246 = block_245: {
                                    const operand_243 = (((value_36).request).table).labels;

                                    const operand_244 = block_242: {
                                        break :block_242 value_6;
                                    };

                                    if ((operand_244 >= (operand_243).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_245 (operand_243)[@intCast(operand_244)];
                                };

                                const operand_247 = (zx_abi).zx_type_39{ .origins = operand_238, .names = operand_239, .index = operand_241, .name = operand_246, };

                                break :block_248 (try function_26(allocator, (&operand_247)));
                            };
                            const value_51: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_198: {
                                break :block_198 value_38;
                            } == @as(u64, 0))) block_207: {
                                const value_39: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_29 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_206: {
                                    break :block_206 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_205: {
                                        break :block_205 block_204: {
                                            const operand_203 = (try (allocator).create((zx_abi).zx_type_29));

                                            (operand_203).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_199: {
                                                break :block_199 (&value_40);
                                            }).count, .mapping = (block_200: {
                                                break :block_200 (&value_40);
                                            }).mapping, .order = (block_201: {
                                                break :block_201 (&value_40);
                                            }).order, .origins = (block_202: {
                                                break :block_202 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_27, .MissingOrigin), });

                                            break :block_204 @as(*const (zx_abi).zx_type_29, operand_203);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_207 value_41;
                            } else block_237: {
                                const value_50: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_208: {
                                    break :block_208 value_38;
                                } == @as(u64, 1))) block_217: {
                                    const value_42: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_29 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_216: {
                                        break :block_216 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_215: {
                                            break :block_215 block_214: {
                                                const operand_213 = (try (allocator).create((zx_abi).zx_type_29));

                                                (operand_213).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_209: {
                                                    break :block_209 (&value_43);
                                                }).count, .mapping = (block_210: {
                                                    break :block_210 (&value_43);
                                                }).mapping, .order = (block_211: {
                                                    break :block_211 (&value_43);
                                                }).order, .origins = (block_212: {
                                                    break :block_212 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_27, .Invalid), });

                                                break :block_214 @as(*const (zx_abi).zx_type_29, operand_213);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_217 value_44;
                                } else block_236: {
                                    const value_45: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_29 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_235: {
                                        break :block_235 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_234: {
                                        break :block_234 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_233: {
                                        break :block_233 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_232: {
                                            break :block_232 block_231: {
                                                const operand_230 = (try (allocator).create((zx_abi).zx_type_29));

                                                (operand_230).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_218: {
                                                    break :block_218 (&value_46);
                                                }).count, .mapping = (block_219: {
                                                    break :block_219 (&value_46);
                                                }).mapping, .order = (block_220: {
                                                    break :block_220 (&value_46);
                                                }).order, .origins = block_228: {
                                                    const operand_222 = block_221: {
                                                        break :block_221 value_47;
                                                    };
                                                    const operand_224 = block_223: {
                                                        break :block_223 value_48;
                                                    };

                                                    if ((operand_224 >= (operand_222).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_226 = (block_225: {
                                                        break :block_225 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_228 block_227: {
                                                        if ((!state_items_started_171)) {
                                                            state_items_170 = (try (allocator).dupe(u64, operand_222));
                                                            state_items_started_171 = true;
                                                        }

                                                        (state_items_170)[@intCast(operand_224)] = operand_226;

                                                        break :block_227 state_items_170;
                                                    };
                                                }, .status = (block_229: {
                                                    break :block_229 (&value_46);
                                                }).status, });

                                                break :block_231 @as(*const (zx_abi).zx_type_29, operand_230);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_236 value_49;
                                });

                                break :block_237 value_50;
                            });

                            break :block_249 value_51;
                        } else value_36);

                        break :block_304 value_52;
                    });

                    break :block_305 value_53;
                } else value_13);

                break :block_322 value_54;
            };
        }

        var state_owned_323: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_323);

        if (state_capacity_started_163) {
            ((state_capacity_162).items).len = (((state_151).pending).ids).len;
            state_owned_323 = (try (state_capacity_162).toOwnedSlice(allocator));
        }

        if (state_capacity_started_163) {
            state_151 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_323, .ready = ((state_151).pending).ready, }), .plan = (state_151).plan, .request = (state_151).request, };
        }

        var state_owned_324: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_324);

        if (state_capacity_started_165) {
            ((state_capacity_164).items).len = (((state_151).pending).ready).len;
            state_owned_324 = (try (state_capacity_164).toOwnedSlice(allocator));
        }

        if (state_capacity_started_165) {
            state_151 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_151).pending).ids, .ready = state_owned_324, }), .plan = (state_151).plan, .request = (state_151).request, };
        }

        break :block_331 block_330: {
            break :block_330 (if (((state_151).zx_origin != null)) ((state_151).zx_origin.?).* else block_329: {
                break :block_329 (zx_abi).zx_type_42{ .pending = (if ((((state_151).pending).zx_origin != null)) ((state_151).pending).zx_origin.? else block_326: {
                    const operand_325 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_325).* = (zx_abi).zx_type_34{ .ids = ((state_151).pending).ids, .ready = ((state_151).pending).ready, };

                    break :block_326 @as(*const (zx_abi).zx_type_34, operand_325);
                }), .plan = (state_151).plan, .request = (if ((((state_151).request).zx_origin != null)) ((state_151).request).zx_origin.? else block_328: {
                    const operand_327 = (try (allocator).create((zx_abi).zx_type_31));

                    (operand_327).* = (zx_abi).zx_type_31{ .maximum_count = ((state_151).request).maximum_count, .names = ((state_151).request).names, .origins = ((state_151).request).origins, .roots = ((state_151).request).roots, .scalar_count = ((state_151).request).scalar_count, .table = ((state_151).request).table, };

                    break :block_328 @as(*const (zx_abi).zx_type_31, operand_327);
                }), };
            });
        };
    };

    return (((&value_55)).plan).*;
}

fn function_27_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_532: {
        const operand_531 = (in).index;

        break :block_532 (try (allocator).dupe(u64, (&[_]u64{operand_531, })));
    };

    const value_2: []const bool = block_530: {
        const operand_529 = false;

        break :block_530 (try (allocator).dupe(bool, (&[_]bool{operand_529, })));
    };

    const value_55: (zx_abi).zx_type_42 = block_528: {
        const operand_346 = block_345: {
            const operand_337 = (in).request;
            const operand_338 = (in).state;

            const operand_339 = block_344: {
                const operand_340 = value_1;
                const operand_341 = value_2;

                break :block_344 block_343: {
                    const operand_342 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_342).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_340, .ready = operand_341, });

                    break :block_343 @as(*const (zx_abi).zx_type_34, operand_342);
                };
            };

            break :block_345 (zx_abi).zx_type_42{ .request = operand_337, .plan = operand_338, .pending = operand_339, };
        };

        var state_capacity_347: (std).ArrayList(u64) = .empty;
        var state_capacity_started_348 = false;

        defer (state_capacity_347).deinit(allocator);

        var state_capacity_349: (std).ArrayList(bool) = .empty;
        var state_capacity_started_350 = false;

        defer (state_capacity_349).deinit(allocator);

        var state_capacity_351: (std).ArrayList(u64) = .empty;
        var state_capacity_started_352 = false;

        defer (state_capacity_351).deinit(allocator);

        var state_capacity_353: (std).ArrayList(u32) = .empty;
        var state_capacity_started_354 = false;

        defer (state_capacity_353).deinit(allocator);

        var state_capacity_355: (std).ArrayList(u64) = .empty;
        var state_capacity_started_356 = false;

        defer (state_capacity_355).deinit(allocator);

        var state_336: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_346).pending).ids, .ready = ((operand_346).pending).ready, .zx_origin = (operand_346).pending, }, .plan = (operand_346).plan, .request = (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_346).request).maximum_count, .names = ((operand_346).request).names, .origins = ((operand_346).request).origins, .roots = ((operand_346).request).roots, .scalar_count = ((operand_346).request).scalar_count, .table = ((operand_346).request).table, .zx_origin = (operand_346).request, }, .zx_origin = (&operand_346), };

        while (((((state_336).plan).status == @as((zx_abi).zx_type_27, .Ready)) and (@as(u64, (((state_336).pending).ids).len) > @as(u64, 0)))) {
            state_336 = block_510: {
                const value_5: u64 = (@as(u64, (((state_336).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_509: {
                    const operand_507 = ((state_336).pending).ids;

                    const operand_508 = block_506: {
                        break :block_506 value_5;
                    };

                    if ((operand_508 >= (operand_507).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_509 (operand_507)[@intCast(operand_508)];
                };
                const value_7: bool = block_505: {
                    const operand_503 = ((state_336).pending).ready;

                    const operand_504 = block_502: {
                        break :block_502 value_5;
                    };

                    if ((operand_504 >= (operand_503).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_505 (operand_503)[@intCast(operand_504)];
                };

                const value_8: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_336;
                const value_9: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_501: {
                    break :block_501 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_500: {
                        break :block_500 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_499: {
                            const operand_498 = ((state_336).pending).ids;

                            break :block_499 @as((zx_abi).value_zx_type_44_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_498).len == 0)) .{ operand_498, null, null, } else .{ (operand_498)[0..((operand_498).len - 1)], (operand_498)[((operand_498).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_497: {
                    break :block_497 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_496: {
                        break :block_496 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_495: {
                            const operand_494 = ((value_10).pending).ready;

                            break :block_495 @as((zx_abi).value_zx_type_46_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_494).len == 0)) .{ operand_494, null, null, } else .{ (operand_494)[0..((operand_494).len - 1)], (operand_494)[((operand_494).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_360: {
                    const operand_358 = ((value_13).plan).mapping;

                    const operand_359 = block_357: {
                        break :block_357 value_6;
                    };

                    if ((operand_359 >= (operand_358).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_360 (operand_358)[@intCast(operand_359)];
                } == @as(u64, 0))) block_493: {
                    const value_53: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_361: {
                        break :block_361 value_7;
                    })) block_380: {
                        const value_14: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_379: {
                            break :block_379 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_378: {
                                break :block_378 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_377: {
                                    const operand_374 = ((value_13).pending).ids;

                                    const operand_376 = block_375: {
                                        break :block_375 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_374).len, 1));

                                    if ((!state_capacity_started_348)) {
                                        (try (state_capacity_347).appendSlice(allocator, operand_374));

                                        state_capacity_started_348 = true;
                                    } else {
                                        ((state_capacity_347).items).len = (operand_374).len;
                                    }

                                    (try (state_capacity_347).append(allocator, operand_376));

                                    break :block_377 @as((zx_abi).value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_347).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_373: {
                            break :block_373 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_372: {
                                break :block_372 @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_371: {
                                    const operand_369 = ((value_16).pending).ready;
                                    const operand_370 = true;

                                    _ = (try ((std).math).add(usize, (operand_369).len, 1));

                                    if ((!state_capacity_started_350)) {
                                        (try (state_capacity_349).appendSlice(allocator, operand_369));

                                        state_capacity_started_350 = true;
                                    } else {
                                        ((state_capacity_349).items).len = (operand_369).len;
                                    }

                                    (try (state_capacity_349).append(allocator, operand_370));

                                    break :block_371 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_349).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_368: {
                            break :block_368 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_367: {
                                break :block_367 (try function_25_buffered(allocator, block_366: {
                                    const operand_362 = ((value_19).request).table;

                                    const operand_363 = block_364: {
                                        break :block_364 value_6;
                                    };

                                    const operand_365 = (value_19).pending;

                                    break :block_366 @as((zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_362, .index = operand_363, .pending = operand_365, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_347), .started = (&state_capacity_started_348), }, .lane_1 = .{ .buffer = (&state_capacity_349), .started = (&state_capacity_started_350), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_380 value_21;
                    } else block_492: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_29 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_491: {
                            break :block_491 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_490: {
                            break :block_490 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_489: {
                            break :block_489 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_488: {
                                break :block_488 block_487: {
                                    const operand_486 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_486).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_473: {
                                        break :block_473 (&value_24);
                                    }).count, .mapping = block_482: {
                                        const operand_475 = block_474: {
                                            break :block_474 value_25;
                                        };
                                        const operand_477 = block_476: {
                                            break :block_476 value_26;
                                        };

                                        if ((operand_477 >= (operand_475).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_479 = (block_478: {
                                            break :block_478 value_22;
                                        } + @as(u64, 1));

                                        break :block_482 @as([]const u64, (if (((buffers).lane_0 != null)) block_480: {
                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_475));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_475).len;
                                            }

                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_477)] = operand_479;

                                            break :block_480 ((((buffers).lane_0.?).buffer).*).items;
                                        } else block_481: {
                                            if ((!state_capacity_started_352)) {
                                                (try (state_capacity_351).appendSlice(allocator, operand_475));

                                                state_capacity_started_352 = true;
                                            } else {
                                                ((state_capacity_351).items).len = (operand_475).len;
                                            }

                                            ((state_capacity_351).items)[@intCast(operand_477)] = operand_479;

                                            break :block_481 (state_capacity_351).items;
                                        }));
                                    }, .order = (block_483: {
                                        break :block_483 (&value_24);
                                    }).order, .origins = (block_484: {
                                        break :block_484 (&value_24);
                                    }).origins, .status = (block_485: {
                                        break :block_485 (&value_24);
                                    }).status, });

                                    break :block_487 @as(*const (zx_abi).zx_type_29, operand_486);
                                };
                            }, .request = (value_23).request, });
                        };
                        const value_28: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_29 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_472: {
                            break :block_472 (&value_29);
                        }).order;
                        const value_31: u64 = block_471: {
                            break :block_471 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_470: {
                            break :block_470 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_469: {
                                break :block_469 block_468: {
                                    const operand_467 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_467).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_452: {
                                        break :block_452 (&value_29);
                                    }).count, .mapping = (block_453: {
                                        break :block_453 (&value_29);
                                    }).mapping, .order = block_464: {
                                        const operand_455 = block_454: {
                                            break :block_454 value_30;
                                        };
                                        const operand_457 = block_456: {
                                            break :block_456 value_31;
                                        };

                                        if ((operand_457 >= (operand_455).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_461 = block_460: {
                                            const operand_459 = block_458: {
                                                break :block_458 value_6;
                                            };

                                            break :block_460 (try function_23(allocator, operand_459));
                                        };

                                        break :block_464 @as([]const u32, (if (((buffers).lane_1 != null)) block_462: {
                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_455));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_455).len;
                                            }

                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_457)] = operand_461;

                                            break :block_462 ((((buffers).lane_1.?).buffer).*).items;
                                        } else block_463: {
                                            if ((!state_capacity_started_354)) {
                                                (try (state_capacity_353).appendSlice(allocator, operand_455));

                                                state_capacity_started_354 = true;
                                            } else {
                                                ((state_capacity_353).items).len = (operand_455).len;
                                            }

                                            ((state_capacity_353).items)[@intCast(operand_457)] = operand_461;

                                            break :block_463 (state_capacity_353).items;
                                        }));
                                    }, .origins = (block_465: {
                                        break :block_465 (&value_29);
                                    }).origins, .status = (block_466: {
                                        break :block_466 (&value_29);
                                    }).status, });

                                    break :block_468 @as(*const (zx_abi).zx_type_29, operand_467);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_29 = ((value_33).plan).*;

                        const value_35: u64 = (block_451: {
                            break :block_451 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_450: {
                            break :block_450 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_449: {
                                break :block_449 block_448: {
                                    const operand_447 = (try (allocator).create((zx_abi).zx_type_29));

                                    (operand_447).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_442: {
                                        break :block_442 value_35;
                                    } + @as(u64, 1)), .mapping = (block_443: {
                                        break :block_443 (&value_34);
                                    }).mapping, .order = (block_444: {
                                        break :block_444 (&value_34);
                                    }).order, .origins = (block_445: {
                                        break :block_445 (&value_34);
                                    }).origins, .status = (block_446: {
                                        break :block_446 (&value_34);
                                    }).status, });

                                    break :block_448 @as(*const (zx_abi).zx_type_29, operand_447);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_11 = block_441: {
                            const operand_440 = block_439: {
                                const operand_437 = (((value_36).request).table).kinds;

                                const operand_438 = block_436: {
                                    break :block_436 value_6;
                                };

                                if ((operand_438 >= (operand_437).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_439 (operand_437)[@intCast(operand_438)];
                            };

                            break :block_441 (try function_24(allocator, operand_440));
                        };

                        const value_52: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_381: {
                            break :block_381 value_37;
                        } == @as((zx_abi).zx_type_11, .Enumeration)) or (block_382: {
                            break :block_382 value_37;
                        } == @as((zx_abi).zx_type_11, .NativeReference)))) block_435: {
                            const value_38: u64 = block_434: {
                                const operand_424 = ((value_36).request).origins;
                                const operand_425 = ((value_36).request).names;

                                const operand_427 = block_426: {
                                    break :block_426 value_6;
                                };
                                const operand_432 = block_431: {
                                    const operand_429 = (((value_36).request).table).labels;

                                    const operand_430 = block_428: {
                                        break :block_428 value_6;
                                    };

                                    if ((operand_430 >= (operand_429).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_431 (operand_429)[@intCast(operand_430)];
                                };

                                const operand_433 = (zx_abi).zx_type_39{ .origins = operand_424, .names = operand_425, .index = operand_427, .name = operand_432, };

                                break :block_434 (try function_26(allocator, (&operand_433)));
                            };
                            const value_51: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_383: {
                                break :block_383 value_38;
                            } == @as(u64, 0))) block_392: {
                                const value_39: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_29 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_391: {
                                    break :block_391 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_390: {
                                        break :block_390 block_389: {
                                            const operand_388 = (try (allocator).create((zx_abi).zx_type_29));

                                            (operand_388).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_384: {
                                                break :block_384 (&value_40);
                                            }).count, .mapping = (block_385: {
                                                break :block_385 (&value_40);
                                            }).mapping, .order = (block_386: {
                                                break :block_386 (&value_40);
                                            }).order, .origins = (block_387: {
                                                break :block_387 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_27, .MissingOrigin), });

                                            break :block_389 @as(*const (zx_abi).zx_type_29, operand_388);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_392 value_41;
                            } else block_423: {
                                const value_50: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_393: {
                                    break :block_393 value_38;
                                } == @as(u64, 1))) block_402: {
                                    const value_42: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_29 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_401: {
                                        break :block_401 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_400: {
                                            break :block_400 block_399: {
                                                const operand_398 = (try (allocator).create((zx_abi).zx_type_29));

                                                (operand_398).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_394: {
                                                    break :block_394 (&value_43);
                                                }).count, .mapping = (block_395: {
                                                    break :block_395 (&value_43);
                                                }).mapping, .order = (block_396: {
                                                    break :block_396 (&value_43);
                                                }).order, .origins = (block_397: {
                                                    break :block_397 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_27, .Invalid), });

                                                break :block_399 @as(*const (zx_abi).zx_type_29, operand_398);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_402 value_44;
                                } else block_422: {
                                    const value_45: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_29 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_421: {
                                        break :block_421 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_420: {
                                        break :block_420 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_419: {
                                        break :block_419 @as((zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_418: {
                                            break :block_418 block_417: {
                                                const operand_416 = (try (allocator).create((zx_abi).zx_type_29));

                                                (operand_416).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = (block_403: {
                                                    break :block_403 (&value_46);
                                                }).count, .mapping = (block_404: {
                                                    break :block_404 (&value_46);
                                                }).mapping, .order = (block_405: {
                                                    break :block_405 (&value_46);
                                                }).order, .origins = block_414: {
                                                    const operand_407 = block_406: {
                                                        break :block_406 value_47;
                                                    };
                                                    const operand_409 = block_408: {
                                                        break :block_408 value_48;
                                                    };

                                                    if ((operand_409 >= (operand_407).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_411 = (block_410: {
                                                        break :block_410 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_414 @as([]const u64, (if (((buffers).lane_2 != null)) block_412: {
                                                        if ((!(((buffers).lane_2.?).started).*)) {
                                                            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_407));
                                                            (((buffers).lane_2.?).started).* = true;
                                                        } else {
                                                            (((((buffers).lane_2.?).buffer).*).items).len = (operand_407).len;
                                                        }

                                                        (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_409)] = operand_411;

                                                        break :block_412 ((((buffers).lane_2.?).buffer).*).items;
                                                    } else block_413: {
                                                        if ((!state_capacity_started_356)) {
                                                            (try (state_capacity_355).appendSlice(allocator, operand_407));

                                                            state_capacity_started_356 = true;
                                                        } else {
                                                            ((state_capacity_355).items).len = (operand_407).len;
                                                        }

                                                        ((state_capacity_355).items)[@intCast(operand_409)] = operand_411;
                                                        break :block_413 (state_capacity_355).items;
                                                    }));
                                                }, .status = (block_415: {
                                                    break :block_415 (&value_46);
                                                }).status, });

                                                break :block_417 @as(*const (zx_abi).zx_type_29, operand_416);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_422 value_49;
                                });

                                break :block_423 value_50;
                            });

                            break :block_435 value_51;
                        } else value_36);

                        break :block_492 value_52;
                    });

                    break :block_493 value_53;
                } else value_13);

                break :block_510 value_54;
            };
        }

        var state_owned_511: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_511);

        if (state_capacity_started_348) {
            ((state_capacity_347).items).len = (((state_336).pending).ids).len;
            state_owned_511 = (try (state_capacity_347).toOwnedSlice(allocator));
        }

        if (state_capacity_started_348) {
            state_336 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_511, .ready = ((state_336).pending).ready, }), .plan = (state_336).plan, .request = (state_336).request, };
        }

        var state_owned_512: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_512);

        if (state_capacity_started_350) {
            ((state_capacity_349).items).len = (((state_336).pending).ready).len;
            state_owned_512 = (try (state_capacity_349).toOwnedSlice(allocator));
        }

        if (state_capacity_started_350) {
            state_336 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_336).pending).ids, .ready = state_owned_512, }), .plan = (state_336).plan, .request = (state_336).request, };
        }

        var state_owned_513: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_513);

        if (state_capacity_started_352) {
            ((state_capacity_351).items).len = (((state_336).plan).mapping).len;
            state_owned_513 = (try (state_capacity_351).toOwnedSlice(allocator));
        }

        if (state_capacity_started_352) {
            state_336 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_515: {
                const operand_514 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_514).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_336).plan).count, .mapping = state_owned_513, .order = ((state_336).plan).order, .origins = ((state_336).plan).origins, .status = ((state_336).plan).status, });

                break :block_515 @as(*const (zx_abi).zx_type_29, operand_514);
            }, .request = (state_336).request, };
        }

        var state_owned_516: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_516);

        if (state_capacity_started_354) {
            ((state_capacity_353).items).len = (((state_336).plan).order).len;
            state_owned_516 = (try (state_capacity_353).toOwnedSlice(allocator));
        }

        if (state_capacity_started_354) {
            state_336 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_518: {
                const operand_517 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_517).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_336).plan).count, .mapping = ((state_336).plan).mapping, .order = state_owned_516, .origins = ((state_336).plan).origins, .status = ((state_336).plan).status, });

                break :block_518 @as(*const (zx_abi).zx_type_29, operand_517);
            }, .request = (state_336).request, };
        }

        var state_owned_519: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_519);

        if (state_capacity_started_356) {
            ((state_capacity_355).items).len = (((state_336).plan).origins).len;
            state_owned_519 = (try (state_capacity_355).toOwnedSlice(allocator));
        }

        if (state_capacity_started_356) {
            state_336 = (zx_abi).value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_521: {
                const operand_520 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_520).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_336).plan).count, .mapping = ((state_336).plan).mapping, .order = ((state_336).plan).order, .origins = state_owned_519, .status = ((state_336).plan).status, });

                break :block_521 @as(*const (zx_abi).zx_type_29, operand_520);
            }, .request = (state_336).request, };
        }

        break :block_528 block_527: {
            break :block_527 (if (((state_336).zx_origin != null)) ((state_336).zx_origin.?).* else block_526: {
                break :block_526 (zx_abi).zx_type_42{ .pending = (if ((((state_336).pending).zx_origin != null)) ((state_336).pending).zx_origin.? else block_523: {
                    const operand_522 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_522).* = (zx_abi).zx_type_34{ .ids = ((state_336).pending).ids, .ready = ((state_336).pending).ready, };

                    break :block_523 @as(*const (zx_abi).zx_type_34, operand_522);
                }), .plan = (state_336).plan, .request = (if ((((state_336).request).zx_origin != null)) ((state_336).request).zx_origin.? else block_525: {
                    const operand_524 = (try (allocator).create((zx_abi).zx_type_31));

                    (operand_524).* = (zx_abi).zx_type_31{ .maximum_count = ((state_336).request).maximum_count, .names = ((state_336).request).names, .origins = ((state_336).request).origins, .roots = ((state_336).request).roots, .scalar_count = ((state_336).request).scalar_count, .table = ((state_336).request).table, };

                    break :block_525 @as(*const (zx_abi).zx_type_31, operand_524);
                }), };
            });
        };
    };

    return (((&value_55)).plan).*;
}

fn function_27_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_688: {
        const operand_687 = (in).index;

        break :block_688 (try (allocator).dupe(u64, (&[_]u64{operand_687, })));
    };

    const value_2: []const bool = block_686: {
        const operand_685 = false;

        break :block_686 (try (allocator).dupe(bool, (&[_]bool{operand_685, })));
    };

    const value_55: *const (zx_abi).zx_type_42 = block_684: {
        const operand_545 = block_544: {
            const operand_534 = (in).request;
            const operand_535 = (in).state;

            const operand_536 = block_541: {
                const operand_537 = value_1;
                const operand_538 = value_2;

                break :block_541 block_540: {
                    const operand_539 = (try (allocator).create((zx_abi).zx_type_34));

                    (operand_539).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = operand_537, .ready = operand_538, });

                    break :block_540 @as(*const (zx_abi).zx_type_34, operand_539);
                };
            };

            break :block_544 block_543: {
                const operand_542 = (try (allocator).create((zx_abi).zx_type_42));

                (operand_542).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{ .request = operand_534, .plan = operand_535, .pending = operand_536, });

                break :block_543 @as(*const (zx_abi).zx_type_42, operand_542);
            };
        };

        var state_capacity_547: (std).ArrayList(u64) = .empty;
        var state_capacity_started_548 = false;

        defer (state_capacity_547).deinit(allocator);

        var state_capacity_549: (std).ArrayList(bool) = .empty;
        var state_capacity_started_550 = false;

        defer (state_capacity_549).deinit(allocator);

        var state_capacity_551: (std).ArrayList(u64) = .empty;
        var state_capacity_started_552 = false;

        defer (state_capacity_551).deinit(allocator);

        var state_capacity_553: (std).ArrayList(u32) = .empty;
        var state_capacity_started_554 = false;

        defer (state_capacity_553).deinit(allocator);

        var state_capacity_555: (std).ArrayList(u64) = .empty;
        var state_capacity_started_556 = false;

        defer (state_capacity_555).deinit(allocator);

        const state_type_560 = struct {
            ids: []const u64,
            ready: []const bool,
        };
        const state_type_561 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_562 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_563 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_564 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_562,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_563,
        };
        const state_type_565 = struct {
            pending: state_type_560,
            plan: state_type_561,
            request: state_type_564,
        };
        const state_type_566 = struct {
            index: u64,
            pending: state_type_560,
            table: state_type_563,
        };
        const state_type_582 = struct { []const bool, void, };
        const state_type_588 = struct { []const u64, void, };

        const state_type_611 = struct {
            index: u64,
            name: []const u8,
            names: []const []const u8,
            origins: state_type_562,
        };
        const state_type_649 = struct { []const bool, ?bool, };
        const state_type_654 = struct { []const u64, ?u64, };
        var state_533: state_type_565 = state_type_565{ .pending = state_type_560{ .ids = ((operand_545).pending).ids, .ready = ((operand_545).pending).ready, }, .plan = state_type_561{ .count = ((operand_545).plan).count, .mapping = ((operand_545).plan).mapping, .order = ((operand_545).plan).order, .origins = ((operand_545).plan).origins, .status = ((operand_545).plan).status, }, .request = state_type_564{ .maximum_count = ((operand_545).request).maximum_count, .names = ((operand_545).request).names, .origins = state_type_562{ .ids = (((operand_545).request).origins).ids, .kinds = (((operand_545).request).origins).kinds, .members = (((operand_545).request).origins).members, .owners = (((operand_545).request).origins).owners, }, .roots = ((operand_545).request).roots, .scalar_count = ((operand_545).request).scalar_count, .table = state_type_563{ .children = (((operand_545).request).table).children, .field_names = (((operand_545).request).table).field_names, .field_types = (((operand_545).request).table).field_types, .first = (((operand_545).request).table).first, .kinds = (((operand_545).request).table).kinds, .labels = (((operand_545).request).table).labels, .names = (((operand_545).request).table).names, .second = (((operand_545).request).table).second, }, }, };
        var state_changed_546 = false;

        while (((((state_533).plan).status == @as((zx_abi).zx_type_27, .Ready)) and (@as(u64, (((state_533).pending).ids).len) > @as(u64, 0)))) {
            state_533 = block_665: {
                const value_5: u64 = (@as(u64, (((state_533).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_664: {
                    const operand_662 = ((state_533).pending).ids;
                    const operand_663 = value_5;

                    if ((operand_663 >= (operand_662).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_664 (operand_662)[@intCast(operand_663)];
                };
                const value_7: bool = block_661: {
                    const operand_659 = ((state_533).pending).ready;
                    const operand_660 = value_5;

                    if ((operand_660 >= (operand_659).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_661 (operand_659)[@intCast(operand_660)];
                };
                const value_8: state_type_565 = state_533;
                const value_9: state_type_560 = (value_8).pending;

                const value_10: state_type_565 = block_658: {
                    break :block_658 state_type_565{ .pending = block_657: {
                        break :block_657 state_type_560{ .ids = (block_656: {
                            const operand_655 = ((state_533).pending).ids;

                            break :block_656 @as(state_type_654, (if (((operand_655).len == 0)) .{ operand_655, null, } else .{ (operand_655)[0..((operand_655).len - 1)], (operand_655)[((operand_655).len - 1)], }));
                        }).@"0", .ready = (value_9).ready, };
                    }, .plan = (value_8).plan, .request = (value_8).request, };
                };
                const value_11: state_type_565 = value_10;
                const value_12: state_type_560 = (value_11).pending;

                const value_13: state_type_565 = block_653: {
                    break :block_653 state_type_565{ .pending = block_652: {
                        break :block_652 state_type_560{ .ids = (value_12).ids, .ready = (block_651: {
                            const operand_650 = ((value_10).pending).ready;

                            break :block_651 @as(state_type_649, (if (((operand_650).len == 0)) .{ operand_650, null, } else .{ (operand_650)[0..((operand_650).len - 1)], (operand_650)[((operand_650).len - 1)], }));
                        }).@"0", };
                    }, .plan = (value_11).plan, .request = (value_11).request, };
                };
                const value_54: state_type_565 = (if ((block_559: {
                    const operand_557 = ((value_13).plan).mapping;
                    const operand_558 = value_6;

                    if ((operand_558 >= (operand_557).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_559 (operand_557)[@intCast(operand_558)];
                } == @as(u64, 0))) block_648: {
                    const value_53: state_type_565 = (if ((!value_7)) block_594: {
                        const value_14: state_type_565 = value_13;
                        const value_15: state_type_560 = (value_14).pending;
                        const value_16: state_type_565 = block_593: {
                            break :block_593 state_type_565{ .pending = block_592: {
                                break :block_592 state_type_560{ .ids = (block_591: {
                                    const operand_589 = ((value_13).pending).ids;
                                    const operand_590 = value_6;

                                    _ = (try ((std).math).add(usize, (operand_589).len, 1));

                                    if ((!state_capacity_started_548)) {
                                        (try (state_capacity_547).appendSlice(allocator, operand_589));
                                        state_capacity_started_548 = true;
                                    } else {
                                        ((state_capacity_547).items).len = (operand_589).len;
                                    }

                                    (try (state_capacity_547).append(allocator, operand_590));

                                    break :block_591 @as(state_type_588, .{ (state_capacity_547).items, {}, });
                                }).@"0", .ready = (value_15).ready, };
                            }, .plan = (value_14).plan, .request = (value_14).request, };
                        };
                        const value_17: state_type_565 = value_16;
                        const value_18: state_type_560 = (value_17).pending;
                        const value_19: state_type_565 = block_587: {
                            break :block_587 state_type_565{ .pending = block_586: {
                                break :block_586 state_type_560{ .ids = (value_18).ids, .ready = (block_585: {
                                    const operand_583 = ((value_16).pending).ready;
                                    const operand_584 = true;

                                    _ = (try ((std).math).add(usize, (operand_583).len, 1));

                                    if ((!state_capacity_started_550)) {
                                        (try (state_capacity_549).appendSlice(allocator, operand_583));
                                        state_capacity_started_550 = true;
                                    } else {
                                        ((state_capacity_549).items).len = (operand_583).len;
                                    }

                                    (try (state_capacity_549).append(allocator, operand_584));

                                    break :block_585 @as(state_type_582, .{ (state_capacity_549).items, {}, });
                                }).@"0", };
                            }, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_20: state_type_565 = value_19;
                        const value_21: state_type_565 = block_581: {
                            break :block_581 state_type_565{ .pending = block_580: {
                                const operand_571 = block_570: {
                                    const operand_567 = ((value_19).request).table;
                                    const operand_568 = value_6;
                                    const operand_569 = (value_19).pending;

                                    break :block_570 state_type_566{ .table = operand_567, .index = operand_568, .pending = operand_569, };
                                };

                                const operand_572 = (zx_abi).zx_type_34{ .ids = ((operand_571).pending).ids, .ready = ((operand_571).pending).ready, };
                                const operand_573 = (zx_abi).zx_type_15{ .children = ((operand_571).table).children, .field_names = ((operand_571).table).field_names, .field_types = ((operand_571).table).field_types, .first = ((operand_571).table).first, .kinds = ((operand_571).table).kinds, .labels = ((operand_571).table).labels, .names = ((operand_571).table).names, .second = ((operand_571).table).second, };
                                const operand_574 = (zx_abi).zx_type_35{ .index = (operand_571).index, .pending = (&operand_572), .table = (&operand_573), };
                                const operand_579 = block_578: {
                                    const operand_575 = (&operand_574);
                                    const operand_576 = (try function_25_buffered(allocator, (zx_abi).value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_575).index, .pending = (zx_abi).value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_575).pending).ids, .ready = ((operand_575).pending).ready, .zx_origin = (operand_575).pending, }, .table = (operand_575).table, .zx_origin = operand_575, }, .{ .lane_0 = .{ .buffer = (&state_capacity_547), .started = (&state_capacity_started_548), }, .lane_1 = .{ .buffer = (&state_capacity_549), .started = (&state_capacity_started_550), }, }));

                                    break :block_578 (if (((operand_576).zx_origin != null)) ((operand_576).zx_origin.?).* else block_577: {
                                        break :block_577 (zx_abi).zx_type_34{ .ids = (operand_576).ids, .ready = (operand_576).ready, };
                                    });
                                };

                                break :block_580 state_type_560{ .ids = (operand_579).ids, .ready = (operand_579).ready, };
                            }, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_594 value_21;
                    } else block_647: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: state_type_565 = value_13;
                        const value_24: state_type_561 = (value_23).plan;
                        const value_25: []const u64 = (value_24).mapping;
                        const value_26: u64 = value_6;
                        const value_27: state_type_565 = block_646: {
                            break :block_646 state_type_565{ .pending = (value_23).pending, .plan = block_645: {
                                break :block_645 state_type_561{ .count = (value_24).count, .mapping = block_644: {
                                    const operand_639 = value_25;
                                    const operand_640 = value_26;

                                    if ((operand_640 >= (operand_639).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_641 = (value_22 + @as(u64, 1));

                                    break :block_644 @as([]const u64, (if (((buffers).lane_0 != null)) block_642: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_639));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_639).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_640)] = operand_641;

                                        break :block_642 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_643: {
                                        if ((!state_capacity_started_552)) {
                                            (try (state_capacity_551).appendSlice(allocator, operand_639));

                                            state_capacity_started_552 = true;
                                        } else {
                                            ((state_capacity_551).items).len = (operand_639).len;
                                        }

                                        ((state_capacity_551).items)[@intCast(operand_640)] = operand_641;

                                        break :block_643 (state_capacity_551).items;
                                    }));
                                }, .order = (value_24).order, .origins = (value_24).origins, .status = (value_24).status, };
                            }, .request = (value_23).request, };
                        };
                        const value_28: state_type_565 = value_27;
                        const value_29: state_type_561 = (value_28).plan;
                        const value_30: []const u32 = (value_29).order;
                        const value_31: u64 = value_22;
                        const value_32: state_type_565 = block_638: {
                            break :block_638 state_type_565{ .pending = (value_28).pending, .plan = block_637: {
                                break :block_637 state_type_561{ .count = (value_29).count, .mapping = (value_29).mapping, .order = block_636: {
                                    const operand_631 = value_30;
                                    const operand_632 = value_31;

                                    if ((operand_632 >= (operand_631).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_633 = (try function_23(allocator, value_6));

                                    break :block_636 @as([]const u32, (if (((buffers).lane_1 != null)) block_634: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_631));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_631).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_632)] = operand_633;

                                        break :block_634 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_635: {
                                        if ((!state_capacity_started_554)) {
                                            (try (state_capacity_553).appendSlice(allocator, operand_631));

                                            state_capacity_started_554 = true;
                                        } else {
                                            ((state_capacity_553).items).len = (operand_631).len;
                                        }

                                        ((state_capacity_553).items)[@intCast(operand_632)] = operand_633;

                                        break :block_635 (state_capacity_553).items;
                                    }));
                                }, .origins = (value_29).origins, .status = (value_29).status, };
                            }, .request = (value_28).request, };
                        };
                        const value_33: state_type_565 = value_32;
                        const value_34: state_type_561 = (value_33).plan;
                        const value_35: u64 = (value_34).count;

                        const value_36: state_type_565 = block_630: {
                            break :block_630 state_type_565{ .pending = (value_33).pending, .plan = block_629: {
                                break :block_629 state_type_561{ .count = (value_35 + @as(u64, 1)), .mapping = (value_34).mapping, .order = (value_34).order, .origins = (value_34).origins, .status = (value_34).status, };
                            }, .request = (value_33).request, };
                        };
                        const value_37: (zx_abi).zx_type_11 = (try function_24(allocator, block_628: {
                            const operand_626 = (((value_36).request).table).kinds;
                            const operand_627 = value_6;

                            if ((operand_627 >= (operand_626).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_628 (operand_626)[@intCast(operand_627)];
                        }));

                        const value_52: state_type_565 = (if (((value_37 == @as((zx_abi).zx_type_11, .Enumeration)) or (value_37 == @as((zx_abi).zx_type_11, .NativeReference)))) block_625: {
                            const value_38: u64 = block_624: {
                                const operand_620 = block_619: {
                                    const operand_612 = ((value_36).request).origins;
                                    const operand_613 = ((value_36).request).names;
                                    const operand_614 = value_6;
                                    const operand_618 = block_617: {
                                        const operand_615 = (((value_36).request).table).labels;
                                        const operand_616 = value_6;

                                        if ((operand_616 >= (operand_615).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_617 (operand_615)[@intCast(operand_616)];
                                    };

                                    break :block_619 state_type_611{ .origins = operand_612, .names = operand_613, .index = operand_614, .name = operand_618, };
                                };

                                const operand_621 = (zx_abi).zx_type_23{ .ids = ((operand_620).origins).ids, .kinds = ((operand_620).origins).kinds, .members = ((operand_620).origins).members, .owners = ((operand_620).origins).owners, };
                                const operand_622 = (zx_abi).zx_type_39{ .index = (operand_620).index, .name = (operand_620).name, .names = (operand_620).names, .origins = (&operand_621), };
                                const operand_623 = (try function_26(allocator, (&operand_622)));

                                break :block_624 operand_623;
                            };
                            const value_51: state_type_565 = (if ((value_38 == @as(u64, 0))) block_597: {
                                const value_39: state_type_565 = value_36;
                                const value_40: state_type_561 = (value_39).plan;
                                const value_41: state_type_565 = block_596: {
                                    break :block_596 state_type_565{ .pending = (value_39).pending, .plan = block_595: {
                                        break :block_595 state_type_561{ .count = (value_40).count, .mapping = (value_40).mapping, .order = (value_40).order, .origins = (value_40).origins, .status = @as((zx_abi).zx_type_27, .MissingOrigin), };
                                    }, .request = (value_39).request, };
                                };

                                break :block_597 value_41;
                            } else block_610: {
                                const value_50: state_type_565 = (if ((value_38 == @as(u64, 1))) block_600: {
                                    const value_42: state_type_565 = value_36;
                                    const value_43: state_type_561 = (value_42).plan;
                                    const value_44: state_type_565 = block_599: {
                                        break :block_599 state_type_565{ .pending = (value_42).pending, .plan = block_598: {
                                            break :block_598 state_type_561{ .count = (value_43).count, .mapping = (value_43).mapping, .order = (value_43).order, .origins = (value_43).origins, .status = @as((zx_abi).zx_type_27, .Invalid), };
                                        }, .request = (value_42).request, };
                                    };

                                    break :block_600 value_44;
                                } else block_609: {
                                    const value_45: state_type_565 = value_36;
                                    const value_46: state_type_561 = (value_45).plan;
                                    const value_47: []const u64 = (value_46).origins;
                                    const value_48: u64 = value_22;
                                    const value_49: state_type_565 = block_608: {
                                        break :block_608 state_type_565{ .pending = (value_45).pending, .plan = block_607: {
                                            break :block_607 state_type_561{ .count = (value_46).count, .mapping = (value_46).mapping, .order = (value_46).order, .origins = block_606: {
                                                const operand_601 = value_47;
                                                const operand_602 = value_48;

                                                if ((operand_602 >= (operand_601).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_603 = (value_38 - @as(u64, 1));

                                                break :block_606 @as([]const u64, (if (((buffers).lane_2 != null)) block_604: {
                                                    if ((!(((buffers).lane_2.?).started).*)) {
                                                        (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_601));
                                                        (((buffers).lane_2.?).started).* = true;
                                                    } else {
                                                        (((((buffers).lane_2.?).buffer).*).items).len = (operand_601).len;
                                                    }

                                                    (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_602)] = operand_603;

                                                    break :block_604 ((((buffers).lane_2.?).buffer).*).items;
                                                } else block_605: {
                                                    if ((!state_capacity_started_556)) {
                                                        (try (state_capacity_555).appendSlice(allocator, operand_601));

                                                        state_capacity_started_556 = true;
                                                    } else {
                                                        ((state_capacity_555).items).len = (operand_601).len;
                                                    }

                                                    ((state_capacity_555).items)[@intCast(operand_602)] = operand_603;
                                                    break :block_605 (state_capacity_555).items;
                                                }));
                                            }, .status = (value_46).status, };
                                        }, .request = (value_45).request, };
                                    };

                                    break :block_609 value_49;
                                });

                                break :block_610 value_50;
                            });

                            break :block_625 value_51;
                        } else value_36);

                        break :block_647 value_52;
                    });

                    break :block_648 value_53;
                } else value_13);

                break :block_665 value_54;
            };

            state_changed_546 = true;
        }

        var state_owned_666: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_666);

        if (state_capacity_started_548) {
            ((state_capacity_547).items).len = (((state_533).pending).ids).len;
            state_owned_666 = (try (state_capacity_547).toOwnedSlice(allocator));
        }

        if (state_capacity_started_548) {
            ((state_533).pending).ids = state_owned_666;
        }

        var state_owned_667: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_667);

        if (state_capacity_started_550) {
            ((state_capacity_549).items).len = (((state_533).pending).ready).len;
            state_owned_667 = (try (state_capacity_549).toOwnedSlice(allocator));
        }

        if (state_capacity_started_550) {
            ((state_533).pending).ready = state_owned_667;
        }

        var state_owned_668: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_668);

        if (state_capacity_started_552) {
            ((state_capacity_551).items).len = (((state_533).plan).mapping).len;
            state_owned_668 = (try (state_capacity_551).toOwnedSlice(allocator));
        }

        if (state_capacity_started_552) {
            ((state_533).plan).mapping = state_owned_668;
        }

        var state_owned_669: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_669);

        if (state_capacity_started_554) {
            ((state_capacity_553).items).len = (((state_533).plan).order).len;
            state_owned_669 = (try (state_capacity_553).toOwnedSlice(allocator));
        }

        if (state_capacity_started_554) {
            ((state_533).plan).order = state_owned_669;
        }

        var state_owned_670: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_670);

        if (state_capacity_started_556) {
            ((state_capacity_555).items).len = (((state_533).plan).origins).len;
            state_owned_670 = (try (state_capacity_555).toOwnedSlice(allocator));
        }

        if (state_capacity_started_556) {
            ((state_533).plan).origins = state_owned_670;
        }

        break :block_684 (if (state_changed_546) block_683: {
            const operand_682 = (try (allocator).create((zx_abi).zx_type_42));

            (operand_682).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{ .pending = block_673: {
                const operand_672 = (try (allocator).create((zx_abi).zx_type_34));

                (operand_672).* = @as((zx_abi).zx_type_34, (zx_abi).zx_type_34{ .ids = ((state_533).pending).ids, .ready = ((state_533).pending).ready, });

                break :block_673 @as(*const (zx_abi).zx_type_34, operand_672);
            }, .plan = block_675: {
                const operand_674 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_674).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_533).plan).count, .mapping = ((state_533).plan).mapping, .order = ((state_533).plan).order, .origins = ((state_533).plan).origins, .status = ((state_533).plan).status, });

                break :block_675 @as(*const (zx_abi).zx_type_29, operand_674);
            }, .request = block_681: {
                const operand_680 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_680).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .maximum_count = ((state_533).request).maximum_count, .names = ((state_533).request).names, .origins = block_677: {
                    const operand_676 = (try (allocator).create((zx_abi).zx_type_23));

                    (operand_676).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (((state_533).request).origins).ids, .kinds = (((state_533).request).origins).kinds, .members = (((state_533).request).origins).members, .owners = (((state_533).request).origins).owners, });

                    break :block_677 @as(*const (zx_abi).zx_type_23, operand_676);
                }, .roots = ((state_533).request).roots, .scalar_count = ((state_533).request).scalar_count, .table = block_679: {
                    const operand_678 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_678).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_533).request).table).children, .field_names = (((state_533).request).table).field_names, .field_types = (((state_533).request).table).field_types, .first = (((state_533).request).table).first, .kinds = (((state_533).request).table).kinds, .labels = (((state_533).request).table).labels, .names = (((state_533).request).table).names, .second = (((state_533).request).table).second, });

                    break :block_679 @as(*const (zx_abi).zx_type_15, operand_678);
                }, });

                break :block_681 @as(*const (zx_abi).zx_type_31, operand_680);
            }, });

            break :block_683 @as(*const (zx_abi).zx_type_42, operand_682);
        } else operand_545);
    };

    return (value_55).plan;
}

fn function_28(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_9: *const (zx_abi).zx_type_48 = block_56: {
        const operand_8 = block_7: {
            const operand_2 = (in).request;
            const operand_3 = (in).state;
            const operand_4 = @as(u64, 0);

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_48));

                (operand_5).* = @as((zx_abi).zx_type_48, (zx_abi).zx_type_48{ .request = operand_2, .plan = operand_3, .index = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_48, operand_5);
            };
        };

        var state_capacity_10: (std).ArrayList(u64) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_capacity_12: (std).ArrayList(u32) = .empty;
        var state_capacity_started_13 = false;

        defer (state_capacity_12).deinit(allocator);

        var state_capacity_14: (std).ArrayList(u64) = .empty;
        var state_capacity_started_15 = false;

        defer (state_capacity_14).deinit(allocator);

        const state_type_16 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_17 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_18 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_19 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_17,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_18,
        };
        const state_type_20 = struct {
            index: u64,
            plan: state_type_16,
            request: state_type_19,
        };
        const state_type_25 = struct {
            index: u64,
            request: state_type_19,
            state: state_type_16,
        };

        var state_1: state_type_20 = state_type_20{ .index = (operand_8).index, .plan = state_type_16{ .count = ((operand_8).plan).count, .mapping = ((operand_8).plan).mapping, .order = ((operand_8).plan).order, .origins = ((operand_8).plan).origins, .status = ((operand_8).plan).status, }, .request = state_type_19{ .maximum_count = ((operand_8).request).maximum_count, .names = ((operand_8).request).names, .origins = state_type_17{ .ids = (((operand_8).request).origins).ids, .kinds = (((operand_8).request).origins).kinds, .members = (((operand_8).request).origins).members, .owners = (((operand_8).request).origins).owners, }, .roots = ((operand_8).request).roots, .scalar_count = ((operand_8).request).scalar_count, .table = state_type_18{ .children = (((operand_8).request).table).children, .field_names = (((operand_8).request).table).field_names, .field_types = (((operand_8).request).table).field_types, .first = (((operand_8).request).table).first, .kinds = (((operand_8).request).table).kinds, .labels = (((operand_8).request).table).labels, .names = (((operand_8).request).table).names, .second = (((operand_8).request).table).second, }, }, };
        var state_changed_9 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_27, .Ready)) and ((state_1).index < @as(u64, (((state_1).request).roots).len)))) {
            state_1 = block_41: {
                const value_5: state_type_20 = (if (block_24: {
                    const operand_22 = ((state_1).request).roots;
                    const operand_23 = (state_1).index;

                    if ((operand_23 >= (operand_22).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_24 (operand_22)[@intCast(operand_23)];
                }) block_40: {
                    const value_3: state_type_20 = state_1;

                    const value_4: state_type_20 = block_39: {
                        break :block_39 state_type_20{ .index = (value_3).index, .plan = block_38: {
                            const operand_30 = block_29: {
                                const operand_26 = (state_1).request;
                                const operand_27 = (state_1).plan;
                                const operand_28 = (state_1).index;

                                break :block_29 state_type_25{ .request = operand_26, .state = operand_27, .index = operand_28, };
                            };

                            const operand_31 = (zx_abi).zx_type_23{ .ids = (((operand_30).request).origins).ids, .kinds = (((operand_30).request).origins).kinds, .members = (((operand_30).request).origins).members, .owners = (((operand_30).request).origins).owners, };
                            const operand_32 = (zx_abi).zx_type_15{ .children = (((operand_30).request).table).children, .field_names = (((operand_30).request).table).field_names, .field_types = (((operand_30).request).table).field_types, .first = (((operand_30).request).table).first, .kinds = (((operand_30).request).table).kinds, .labels = (((operand_30).request).table).labels, .names = (((operand_30).request).table).names, .second = (((operand_30).request).table).second, };
                            const operand_33 = (zx_abi).zx_type_31{ .maximum_count = ((operand_30).request).maximum_count, .names = ((operand_30).request).names, .origins = (&operand_31), .roots = ((operand_30).request).roots, .scalar_count = ((operand_30).request).scalar_count, .table = (&operand_32), };
                            const operand_34 = (zx_abi).zx_type_29{ .count = ((operand_30).state).count, .mapping = ((operand_30).state).mapping, .order = ((operand_30).state).order, .origins = ((operand_30).state).origins, .status = ((operand_30).state).status, };
                            const operand_35 = (zx_abi).zx_type_41{ .index = (operand_30).index, .request = (&operand_33), .state = (&operand_34), };

                            const operand_37 = block_36: {
                                break :block_36 (try function_27_buffered(allocator, (&operand_35), .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, .lane_1 = .{ .buffer = (&state_capacity_12), .started = (&state_capacity_started_13), }, .lane_2 = .{ .buffer = (&state_capacity_14), .started = (&state_capacity_started_15), }, }));
                            };

                            break :block_38 state_type_16{ .count = (operand_37).count, .mapping = (operand_37).mapping, .order = (operand_37).order, .origins = (operand_37).origins, .status = (operand_37).status, };
                        }, .request = (value_3).request, };
                    };

                    break :block_40 value_4;
                } else state_1);

                const value_6: state_type_20 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: state_type_20 = block_21: {
                    break :block_21 state_type_20{ .index = (value_7 + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, };
                };

                break :block_41 value_8;
            };

            state_changed_9 = true;
        }

        var state_owned_42: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_42);

        if (state_capacity_started_11) {
            ((state_capacity_10).items).len = (((state_1).plan).mapping).len;
            state_owned_42 = (try (state_capacity_10).toOwnedSlice(allocator));
        }

        if (state_capacity_started_11) {
            ((state_1).plan).mapping = state_owned_42;
        }

        var state_owned_43: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_43);

        if (state_capacity_started_13) {
            ((state_capacity_12).items).len = (((state_1).plan).order).len;
            state_owned_43 = (try (state_capacity_12).toOwnedSlice(allocator));
        }

        if (state_capacity_started_13) {
            ((state_1).plan).order = state_owned_43;
        }

        var state_owned_44: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_44);

        if (state_capacity_started_15) {
            ((state_capacity_14).items).len = (((state_1).plan).origins).len;
            state_owned_44 = (try (state_capacity_14).toOwnedSlice(allocator));
        }

        if (state_capacity_started_15) {
            ((state_1).plan).origins = state_owned_44;
        }

        break :block_56 (if (state_changed_9) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_48));

            (operand_54).* = @as((zx_abi).zx_type_48, (zx_abi).zx_type_48{ .index = (state_1).index, .plan = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_46).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_47 @as(*const (zx_abi).zx_type_29, operand_46);
            }, .request = block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_52).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_23));

                    (operand_48).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (((state_1).request).origins).ids, .kinds = (((state_1).request).origins).kinds, .members = (((state_1).request).origins).members, .owners = (((state_1).request).origins).owners, });

                    break :block_49 @as(*const (zx_abi).zx_type_23, operand_48);
                }, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_50).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).request).table).children, .field_names = (((state_1).request).table).field_names, .field_types = (((state_1).request).table).field_types, .first = (((state_1).request).table).first, .kinds = (((state_1).request).table).kinds, .labels = (((state_1).request).table).labels, .names = (((state_1).request).table).names, .second = (((state_1).request).table).second, });

                    break :block_51 @as(*const (zx_abi).zx_type_15, operand_50);
                }, });

                break :block_53 @as(*const (zx_abi).zx_type_31, operand_52);
            }, });

            break :block_55 @as(*const (zx_abi).zx_type_48, operand_54);
        } else operand_8);
    };

    return (value_9).plan;
}

fn function_28_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_9: (zx_abi).zx_type_48 = block_100: {
        const operand_62 = block_61: {
            const operand_58 = (in).request;
            const operand_59 = (in).state;
            const operand_60 = @as(u64, 0);

            break :block_61 (zx_abi).zx_type_48{ .request = operand_58, .plan = operand_59, .index = operand_60, };
        };

        var state_capacity_63: (std).ArrayList(u64) = .empty;
        var state_capacity_started_64 = false;

        defer (state_capacity_63).deinit(allocator);

        var state_capacity_65: (std).ArrayList(u32) = .empty;
        var state_capacity_started_66 = false;

        defer (state_capacity_65).deinit(allocator);

        var state_capacity_67: (std).ArrayList(u64) = .empty;
        var state_capacity_started_68 = false;

        defer (state_capacity_67).deinit(allocator);

        var state_57: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_62).index, .plan = (operand_62).plan, .request = (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_62).request).maximum_count, .names = ((operand_62).request).names, .origins = ((operand_62).request).origins, .roots = ((operand_62).request).roots, .scalar_count = ((operand_62).request).scalar_count, .table = ((operand_62).request).table, .zx_origin = (operand_62).request, }, .zx_origin = (&operand_62), };

        while (((((state_57).plan).status == @as((zx_abi).zx_type_27, .Ready)) and ((state_57).index < @as(u64, (((state_57).request).roots).len)))) {
            state_57 = block_86: {
                const value_5: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_73: {
                    const operand_71 = ((state_57).request).roots;
                    const operand_72 = (state_57).index;

                    if ((operand_72 >= (operand_71).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_73 (operand_71)[@intCast(operand_72)];
                }) block_85: {
                    const value_3: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_57;

                    const value_4: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_84: {
                        break :block_84 @as((zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_83: {
                            const operand_82 = (try (allocator).create((zx_abi).zx_type_29));

                            (operand_82).* = @as((zx_abi).zx_type_29, block_81: {
                                const operand_78 = block_77: {
                                    const operand_74 = (state_57).request;
                                    const operand_75 = (state_57).plan;
                                    const operand_76 = (state_57).index;

                                    break :block_77 @as((zx_abi).value_zx_type_41_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_41_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_74, .state = operand_75, .index = operand_76, });
                                };
                                var state_borrow_79: (zx_abi).zx_type_31 = undefined;

                                state_borrow_79 = (zx_abi).zx_type_31{ .maximum_count = ((operand_78).request).maximum_count, .names = ((operand_78).request).names, .origins = ((operand_78).request).origins, .roots = ((operand_78).request).roots, .scalar_count = ((operand_78).request).scalar_count, .table = ((operand_78).request).table, };

                                var state_borrow_80: (zx_abi).zx_type_41 = undefined;

                                state_borrow_80 = (zx_abi).zx_type_41{ .index = (operand_78).index, .request = (((operand_78).request).zx_origin orelse (&state_borrow_79)), .state = (operand_78).state, };

                                break :block_81 (try function_27_buffered(allocator, ((operand_78).zx_origin orelse (&state_borrow_80)), .{ .lane_0 = .{ .buffer = (&state_capacity_63), .started = (&state_capacity_started_64), }, .lane_1 = .{ .buffer = (&state_capacity_65), .started = (&state_capacity_started_66), }, .lane_2 = .{ .buffer = (&state_capacity_67), .started = (&state_capacity_started_68), }, }));
                            });

                            break :block_83 @as(*const (zx_abi).zx_type_29, operand_82);
                        }, .request = (value_3).request, });
                    };

                    break :block_85 value_4;
                } else state_57);

                const value_6: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_69: {
                        break :block_69 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_86 value_8;
            };
        }

        var state_owned_87: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_87);

        if (state_capacity_started_64) {
            ((state_capacity_63).items).len = (((state_57).plan).mapping).len;
            state_owned_87 = (try (state_capacity_63).toOwnedSlice(allocator));
        }

        if (state_capacity_started_64) {
            state_57 = (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_88).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_57).plan).count, .mapping = state_owned_87, .order = ((state_57).plan).order, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_89 @as(*const (zx_abi).zx_type_29, operand_88);
            }, .request = (state_57).request, };
        }

        var state_owned_90: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_90);

        if (state_capacity_started_66) {
            ((state_capacity_65).items).len = (((state_57).plan).order).len;
            state_owned_90 = (try (state_capacity_65).toOwnedSlice(allocator));
        }

        if (state_capacity_started_66) {
            state_57 = (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_91).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = state_owned_90, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_92 @as(*const (zx_abi).zx_type_29, operand_91);
            }, .request = (state_57).request, };
        }

        var state_owned_93: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_68) {
            ((state_capacity_67).items).len = (((state_57).plan).origins).len;
            state_owned_93 = (try (state_capacity_67).toOwnedSlice(allocator));
        }

        if (state_capacity_started_68) {
            state_57 = (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_94).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = ((state_57).plan).order, .origins = state_owned_93, .status = ((state_57).plan).status, });

                break :block_95 @as(*const (zx_abi).zx_type_29, operand_94);
            }, .request = (state_57).request, };
        }

        break :block_100 block_99: {
            break :block_99 (if (((state_57).zx_origin != null)) ((state_57).zx_origin.?).* else block_98: {
                break :block_98 (zx_abi).zx_type_48{ .index = (state_57).index, .plan = (state_57).plan, .request = (if ((((state_57).request).zx_origin != null)) ((state_57).request).zx_origin.? else block_97: {
                    const operand_96 = (try (allocator).create((zx_abi).zx_type_31));

                    (operand_96).* = (zx_abi).zx_type_31{ .maximum_count = ((state_57).request).maximum_count, .names = ((state_57).request).names, .origins = ((state_57).request).origins, .roots = ((state_57).request).roots, .scalar_count = ((state_57).request).scalar_count, .table = ((state_57).request).table, };

                    break :block_97 @as(*const (zx_abi).zx_type_31, operand_96);
                }), };
            });
        };
    };

    return (((&value_9)).plan).*;
}

fn function_28_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_9: (zx_abi).zx_type_48 = block_129: {
        const operand_106 = block_105: {
            const operand_102 = (in).request;
            const operand_103 = (in).state;
            const operand_104 = @as(u64, 0);

            break :block_105 (zx_abi).zx_type_48{ .request = operand_102, .plan = operand_103, .index = operand_104, };
        };

        var state_101: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_106).index, .plan = (operand_106).plan, .request = (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_106).request).maximum_count, .names = ((operand_106).request).names, .origins = ((operand_106).request).origins, .roots = ((operand_106).request).roots, .scalar_count = ((operand_106).request).scalar_count, .table = ((operand_106).request).table, .zx_origin = (operand_106).request, }, .zx_origin = (&operand_106), };

        while (((((state_101).plan).status == @as((zx_abi).zx_type_27, .Ready)) and ((state_101).index < @as(u64, (((state_101).request).roots).len)))) {
            state_101 = block_124: {
                const value_5: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_111: {
                    const operand_109 = ((state_101).request).roots;
                    const operand_110 = (state_101).index;

                    if ((operand_110 >= (operand_109).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_111 (operand_109)[@intCast(operand_110)];
                }) block_123: {
                    const value_3: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_101;

                    const value_4: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_122: {
                        break :block_122 @as((zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_121: {
                            const operand_120 = (try (allocator).create((zx_abi).zx_type_29));

                            (operand_120).* = @as((zx_abi).zx_type_29, block_119: {
                                const operand_116 = block_115: {
                                    const operand_112 = (state_101).request;
                                    const operand_113 = (state_101).plan;
                                    const operand_114 = (state_101).index;

                                    break :block_115 @as((zx_abi).value_zx_type_41_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_41_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_112, .state = operand_113, .index = operand_114, });
                                };
                                var state_borrow_117: (zx_abi).zx_type_31 = undefined;

                                state_borrow_117 = (zx_abi).zx_type_31{ .maximum_count = ((operand_116).request).maximum_count, .names = ((operand_116).request).names, .origins = ((operand_116).request).origins, .roots = ((operand_116).request).roots, .scalar_count = ((operand_116).request).scalar_count, .table = ((operand_116).request).table, };

                                var state_borrow_118: (zx_abi).zx_type_41 = undefined;
                                state_borrow_118 = (zx_abi).zx_type_41{ .index = (operand_116).index, .request = (((operand_116).request).zx_origin orelse (&state_borrow_117)), .state = (operand_116).state, };

                                break :block_119 (try function_27_buffered(allocator, ((operand_116).zx_origin orelse (&state_borrow_118)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            });

                            break :block_121 @as(*const (zx_abi).zx_type_29, operand_120);
                        }, .request = (value_3).request, });
                    };

                    break :block_123 value_4;
                } else state_101);

                const value_6: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_108: {
                    break :block_108 @as((zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_48_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_107: {
                        break :block_107 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_124 value_8;
            };
        }

        break :block_129 block_128: {
            break :block_128 (if (((state_101).zx_origin != null)) ((state_101).zx_origin.?).* else block_127: {
                break :block_127 (zx_abi).zx_type_48{ .index = (state_101).index, .plan = (state_101).plan, .request = (if ((((state_101).request).zx_origin != null)) ((state_101).request).zx_origin.? else block_126: {
                    const operand_125 = (try (allocator).create((zx_abi).zx_type_31));

                    (operand_125).* = (zx_abi).zx_type_31{ .maximum_count = ((state_101).request).maximum_count, .names = ((state_101).request).names, .origins = ((state_101).request).origins, .roots = ((state_101).request).roots, .scalar_count = ((state_101).request).scalar_count, .table = ((state_101).request).table, };

                    break :block_126 @as(*const (zx_abi).zx_type_31, operand_125);
                }), };
            });
        };
    };

    return (((&value_9)).plan).*;
}

fn function_28_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_9: *const (zx_abi).zx_type_48 = block_176: {
        const operand_137 = block_136: {
            const operand_131 = (in).request;
            const operand_132 = (in).state;
            const operand_133 = @as(u64, 0);

            break :block_136 block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_48));

                (operand_134).* = @as((zx_abi).zx_type_48, (zx_abi).zx_type_48{ .request = operand_131, .plan = operand_132, .index = operand_133, });

                break :block_135 @as(*const (zx_abi).zx_type_48, operand_134);
            };
        };
        const state_type_139 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_27,
        };
        const state_type_140 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_141 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_142 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_140,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_141,
        };
        const state_type_143 = struct {
            index: u64,
            plan: state_type_139,
            request: state_type_142,
        };
        const state_type_148 = struct {
            index: u64,
            request: state_type_142,
            state: state_type_139,
        };

        var state_130: state_type_143 = state_type_143{ .index = (operand_137).index, .plan = state_type_139{ .count = ((operand_137).plan).count, .mapping = ((operand_137).plan).mapping, .order = ((operand_137).plan).order, .origins = ((operand_137).plan).origins, .status = ((operand_137).plan).status, }, .request = state_type_142{ .maximum_count = ((operand_137).request).maximum_count, .names = ((operand_137).request).names, .origins = state_type_140{ .ids = (((operand_137).request).origins).ids, .kinds = (((operand_137).request).origins).kinds, .members = (((operand_137).request).origins).members, .owners = (((operand_137).request).origins).owners, }, .roots = ((operand_137).request).roots, .scalar_count = ((operand_137).request).scalar_count, .table = state_type_141{ .children = (((operand_137).request).table).children, .field_names = (((operand_137).request).table).field_names, .field_types = (((operand_137).request).table).field_types, .first = (((operand_137).request).table).first, .kinds = (((operand_137).request).table).kinds, .labels = (((operand_137).request).table).labels, .names = (((operand_137).request).table).names, .second = (((operand_137).request).table).second, }, }, };
        var state_changed_138 = false;

        while (((((state_130).plan).status == @as((zx_abi).zx_type_27, .Ready)) and ((state_130).index < @as(u64, (((state_130).request).roots).len)))) {
            state_130 = block_164: {
                const value_5: state_type_143 = (if (block_147: {
                    const operand_145 = ((state_130).request).roots;
                    const operand_146 = (state_130).index;

                    if ((operand_146 >= (operand_145).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_147 (operand_145)[@intCast(operand_146)];
                }) block_163: {
                    const value_3: state_type_143 = state_130;
                    const value_4: state_type_143 = block_162: {
                        break :block_162 state_type_143{ .index = (value_3).index, .plan = block_161: {
                            const operand_153 = block_152: {
                                const operand_149 = (state_130).request;
                                const operand_150 = (state_130).plan;
                                const operand_151 = (state_130).index;

                                break :block_152 state_type_148{ .request = operand_149, .state = operand_150, .index = operand_151, };
                            };

                            const operand_154 = (zx_abi).zx_type_23{ .ids = (((operand_153).request).origins).ids, .kinds = (((operand_153).request).origins).kinds, .members = (((operand_153).request).origins).members, .owners = (((operand_153).request).origins).owners, };
                            const operand_155 = (zx_abi).zx_type_15{ .children = (((operand_153).request).table).children, .field_names = (((operand_153).request).table).field_names, .field_types = (((operand_153).request).table).field_types, .first = (((operand_153).request).table).first, .kinds = (((operand_153).request).table).kinds, .labels = (((operand_153).request).table).labels, .names = (((operand_153).request).table).names, .second = (((operand_153).request).table).second, };
                            const operand_156 = (zx_abi).zx_type_31{ .maximum_count = ((operand_153).request).maximum_count, .names = ((operand_153).request).names, .origins = (&operand_154), .roots = ((operand_153).request).roots, .scalar_count = ((operand_153).request).scalar_count, .table = (&operand_155), };
                            const operand_157 = (zx_abi).zx_type_29{ .count = ((operand_153).state).count, .mapping = ((operand_153).state).mapping, .order = ((operand_153).state).order, .origins = ((operand_153).state).origins, .status = ((operand_153).state).status, };
                            const operand_158 = (zx_abi).zx_type_41{ .index = (operand_153).index, .request = (&operand_156), .state = (&operand_157), };

                            const operand_160 = block_159: {
                                break :block_159 (try function_27_buffered(allocator, (&operand_158), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            };

                            break :block_161 state_type_139{ .count = (operand_160).count, .mapping = (operand_160).mapping, .order = (operand_160).order, .origins = (operand_160).origins, .status = (operand_160).status, };
                        }, .request = (value_3).request, };
                    };

                    break :block_163 value_4;
                } else state_130);

                const value_6: state_type_143 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: state_type_143 = block_144: {
                    break :block_144 state_type_143{ .index = (value_7 + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, };
                };

                break :block_164 value_8;
            };

            state_changed_138 = true;
        }

        break :block_176 (if (state_changed_138) block_175: {
            const operand_174 = (try (allocator).create((zx_abi).zx_type_48));

            (operand_174).* = @as((zx_abi).zx_type_48, (zx_abi).zx_type_48{ .index = (state_130).index, .plan = block_167: {
                const operand_166 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_166).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .count = ((state_130).plan).count, .mapping = ((state_130).plan).mapping, .order = ((state_130).plan).order, .origins = ((state_130).plan).origins, .status = ((state_130).plan).status, });

                break :block_167 @as(*const (zx_abi).zx_type_29, operand_166);
            }, .request = block_173: {
                const operand_172 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_172).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .maximum_count = ((state_130).request).maximum_count, .names = ((state_130).request).names, .origins = block_169: {
                    const operand_168 = (try (allocator).create((zx_abi).zx_type_23));

                    (operand_168).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .ids = (((state_130).request).origins).ids, .kinds = (((state_130).request).origins).kinds, .members = (((state_130).request).origins).members, .owners = (((state_130).request).origins).owners, });

                    break :block_169 @as(*const (zx_abi).zx_type_23, operand_168);
                }, .roots = ((state_130).request).roots, .scalar_count = ((state_130).request).scalar_count, .table = block_171: {
                    const operand_170 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_170).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_130).request).table).children, .field_names = (((state_130).request).table).field_names, .field_types = (((state_130).request).table).field_types, .first = (((state_130).request).table).first, .kinds = (((state_130).request).table).kinds, .labels = (((state_130).request).table).labels, .names = (((state_130).request).table).names, .second = (((state_130).request).table).second, });

                    break :block_171 @as(*const (zx_abi).zx_type_15, operand_170);
                }, });

                break :block_173 @as(*const (zx_abi).zx_type_31, operand_172);
            }, });

            break :block_175 @as(*const (zx_abi).zx_type_48, operand_174);
        } else operand_137);
    };

    return (value_9).plan;
}

fn function_29(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_29 = block_25: {
        const operand_22 = (try function_20_value(allocator, block_21: {
            const operand_17 = ((in).table).kinds;
            const operand_18 = (in).scalar_count;

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create((zx_abi).zx_type_32));

                (operand_19).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .kinds = operand_17, .scalar_count = operand_18, });

                break :block_20 @as(*const (zx_abi).zx_type_32, operand_19);
            };
        }));

        break :block_25 block_24: {
            const operand_23 = (try (allocator).create((zx_abi).zx_type_29));

            (operand_23).* = @as((zx_abi).zx_type_29, operand_22);

            break :block_24 @as(*const (zx_abi).zx_type_29, operand_23);
        };
    };

    const value_2: *const (zx_abi).zx_type_29 = block_16: {
        const operand_6 = block_5: {
            const operand_1 = in;
            const operand_2 = value_1;

            break :block_5 block_4: {
                const operand_3 = (try (allocator).create((zx_abi).zx_type_47));

                (operand_3).* = @as((zx_abi).zx_type_47, (zx_abi).zx_type_47{ .request = operand_1, .state = operand_2, });

                break :block_4 @as(*const (zx_abi).zx_type_47, operand_3);
            };
        };

        const operand_7 = ((operand_6).state).mapping;
        var transferred_items_8: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_7));
        var transferred_started_9 = true;
        const operand_10 = ((operand_6).state).order;
        var transferred_items_11: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_10));
        var transferred_started_12 = true;
        const operand_13 = ((operand_6).state).origins;
        var transferred_items_14: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_13));
        var transferred_started_15 = true;

        break :block_16 (try function_28_buffered_pointer(allocator, operand_6, .{ .lane_0 = .{ .buffer = (&transferred_items_8), .started = (&transferred_started_9), }, .lane_1 = .{ .buffer = (&transferred_items_11), .started = (&transferred_started_12), }, .lane_2 = .{ .buffer = (&transferred_items_14), .started = (&transferred_started_15), }, }));
    };

    return value_2;
}

fn function_29_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_29 = block_44: {
        const operand_41 = ((in).table).kinds;
        const operand_42 = (in).scalar_count;
        const operand_43 = (zx_abi).zx_type_32{ .kinds = operand_41, .scalar_count = operand_42, };

        break :block_44 (try function_20_value(allocator, (&operand_43)));
    };

    const value_2: (zx_abi).zx_type_29 = block_40: {
        const operand_29 = block_28: {
            const operand_26 = in;
            const operand_27 = (&value_1);

            break :block_28 (zx_abi).zx_type_47{ .request = operand_26, .state = operand_27, };
        };

        const operand_30 = (&operand_29);
        const operand_31 = ((operand_30).state).mapping;
        var transferred_items_32: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_31));
        var transferred_started_33 = true;
        const operand_34 = ((operand_30).state).order;
        var transferred_items_35: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_34));
        var transferred_started_36 = true;
        const operand_37 = ((operand_30).state).origins;
        var transferred_items_38: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_37));
        var transferred_started_39 = true;

        break :block_40 (try function_28_buffered(allocator, operand_30, .{ .lane_0 = .{ .buffer = (&transferred_items_32), .started = (&transferred_started_33), }, .lane_1 = .{ .buffer = (&transferred_items_35), .started = (&transferred_started_36), }, .lane_2 = .{ .buffer = (&transferred_items_38), .started = (&transferred_started_39), }, }));
    };

    return ((&value_2)).*;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!?*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: bool = block_6: {
        const operand_2 = (in).table;
        const operand_3 = (in).scalar_count;
        const operand_4 = (in).maximum_count;
        const operand_5 = (zx_abi).zx_type_49{ .table = operand_2, .scalar_count = operand_3, .maximum_count = operand_4, };

        break :block_6 (try function_15(allocator, (&operand_5)));
    };

    const value_2: bool = (try function_16(allocator, in));
    const switch_1 = (value_1 and value_2);

    if ((switch_1 == true)) {
        const value_3: *const (zx_abi).zx_type_29 = (try function_29(allocator, in));

        return @as(?*const (zx_abi).zx_type_29, value_3);
    } else {
        return @as(?*const (zx_abi).zx_type_29, null);
    }
}

