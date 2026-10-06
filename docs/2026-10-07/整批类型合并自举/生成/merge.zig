const std = @import("std");
const zx_native_0 = @import("integers");
const zx_native_1 = @import("merge_writer");
const zx_native_2 = @import("references");
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
const zx_shape_11 = .{ .kind = .native_reference, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_5, .@"3" = zx_shape_1, }, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_17 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_18 = .{ .kind = .scalar, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .field_names = zx_shape_16, .field_types = zx_shape_13, .first = zx_shape_13, .kinds = zx_shape_17, .labels = zx_shape_16, .names = zx_shape_16, .second = zx_shape_13, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .base = zx_shape_19, .delta = zx_shape_19, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .names = zx_shape_16, .types = zx_shape_13, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .fields = zx_shape_22, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .names = zx_shape_16, .second = zx_shape_4, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .delta = zx_shape_19, .id = zx_shape_4, }, };
const zx_shape_26 = .{ .kind = .native_reference, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_26, .@"1" = zx_shape_4, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_26, .@"1" = zx_shape_5, .@"2" = zx_shape_4, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .index = zx_shape_5, .table = zx_shape_19, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .values = zx_shape_13, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .kinds = zx_shape_17, .members = zx_shape_16, .owners = zx_shape_16, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .base = zx_shape_32, .delta = zx_shape_32, }, };
const zx_shape_34 = .{ .kind = .scalar, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_34, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .field_names = zx_shape_16, .field_types = zx_shape_13, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .names = zx_shape_16, .offset = zx_shape_5, .second = zx_shape_4, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .left = zx_shape_36, .right = zx_shape_36, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_36, .right = zx_shape_36, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_19, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .id = zx_shape_4, .tables = zx_shape_20, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_20, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .origin = zx_shape_31, .origins = zx_shape_33, .tables = zx_shape_20, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .count = zx_shape_5, .id = zx_shape_4, .index = zx_shape_5, .origin = zx_shape_31, .origins = zx_shape_33, .status = zx_shape_34, .tables = zx_shape_20, }, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .source = zx_shape_19, .writer = zx_shape_11, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .origin = zx_shape_5, .origins = zx_shape_32, .source = zx_shape_19, .writer = zx_shape_11, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .tables = zx_shape_20, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_20, }, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .first = zx_shape_5, .origins = zx_shape_32, .source = zx_shape_19, .writer = zx_shape_11, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .index = zx_shape_5, .origins = zx_shape_32, .source = zx_shape_19, .status = zx_shape_5, .writer = zx_shape_11, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_48, }, };
const zx_shape_51 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_48, .@"1" = zx_shape_5, }, };
pub const input_shape = zx_shape_48;
pub const output_shape = zx_shape_5;
pub const Input = *const (zx_abi).zx_type_48;
pub const Output = u64;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_1).prepareReferences((in).@"0", (in).@"1", (in).@"2", (in).@"3"));

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).references(in);

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ }!bool {
    const native_result = (zx_native_1).hasOrigin((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ }!u64 {
    const native_result = (zx_native_1).originIndex((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!void {
    const native_result = (zx_native_1).setMapping((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!u64 {
    const native_result = (try (zx_native_1).appendType((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_1).appendOrigin((in).@"0", (in).@"1", (in).@"2"));

    _ = allocator;

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ }![]const []const u8 {
    const native_result = (zx_native_1).fieldNames((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ }![]const []const u8 {
    const native_result = (zx_native_1).memberNames((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u8 {
    const native_result = (zx_native_1).kinds(in);

    _ = allocator;

    return native_result;
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).first(in);

    _ = allocator;

    return native_result;
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).second(in);

    _ = allocator;

    return native_result;
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_1).labels(in);

    _ = allocator;

    return native_result;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).children(in);

    _ = allocator;

    return native_result;
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).fieldTypes(in);

    _ = allocator;

    return native_result;
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_1).allFieldNames(in);

    _ = allocator;

    return native_result;
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_1).names(in);

    _ = allocator;

    return native_result;
}

fn function_19(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_1).originIds(in);

    _ = allocator;

    return native_result;
}

fn function_20(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u8 {
    const native_result = (zx_native_1).originKinds(in);

    _ = allocator;

    return native_result;
}

fn function_21(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_1).originOwners(in);

    _ = allocator;

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_1).originMembers(in);

    _ = allocator;

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_18, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_18, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_18, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_18, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_18, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_18, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_18, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_18, .Enumeration) else @as((zx_abi).zx_type_18, .NativeReference)))))))));
    };
}

fn function_24(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ }!u32 {
    const native_result = (zx_native_2).get((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_25(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28) error{ }!void {
    const native_result = (zx_native_2).set((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_26(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_18 = (try function_23(allocator, block_79: {
        const operand_77 = ((in).table).kinds;
        const operand_78 = (in).index;

        if ((operand_78 >= (operand_77).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_79 (operand_77)[@intCast(operand_78)];
    }));

    if (((value_1 == @as((zx_abi).zx_type_18, .Optional)) or (value_1 == @as((zx_abi).zx_type_18, .List)))) {
        _ = block_14: {
            const operand_13 = @as((zx_abi).zx_type_28, block_12: {
                const operand_1 = (in).buffer;
                const operand_2 = @as(u64, 0);

                const operand_11 = block_10: {
                    const operand_9 = @as((zx_abi).zx_type_27, block_8: {
                        const operand_3 = (in).buffer;

                        const operand_7 = block_6: {
                            const operand_4 = ((in).table).first;
                            const operand_5 = (in).index;

                            if ((operand_5 >= (operand_4).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_6 (operand_4)[@intCast(operand_5)];
                        };

                        break :block_8 .{ operand_3, operand_7, };
                    });

                    break :block_10 (try function_24(allocator, (&operand_9)));
                };

                break :block_12 .{ operand_1, operand_2, operand_11, };
            });

            break :block_14 (try function_25(allocator, (&operand_13)));
        };
    } else {
        if ((value_1 == @as((zx_abi).zx_type_18, .Task))) {
            _ = block_42: {
                const operand_41 = @as((zx_abi).zx_type_28, block_40: {
                    const operand_29 = (in).buffer;
                    const operand_30 = @as(u64, 0);
                    const operand_39 = block_38: {
                        const operand_37 = @as((zx_abi).zx_type_27, block_36: {
                            const operand_31 = (in).buffer;
                            const operand_35 = block_34: {
                                const operand_32 = ((in).table).first;
                                const operand_33 = (in).index;

                                if ((operand_33 >= (operand_32).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_34 (operand_32)[@intCast(operand_33)];
                            };

                            break :block_36 .{ operand_31, operand_35, };
                        });

                        break :block_38 (try function_24(allocator, (&operand_37)));
                    };

                    break :block_40 .{ operand_29, operand_30, operand_39, };
                });

                break :block_42 (try function_25(allocator, (&operand_41)));
            };

            _ = block_28: {
                const operand_27 = @as((zx_abi).zx_type_28, block_26: {
                    const operand_15 = (in).buffer;
                    const operand_16 = @as(u64, 1);
                    const operand_25 = block_24: {
                        const operand_23 = @as((zx_abi).zx_type_27, block_22: {
                            const operand_17 = (in).buffer;
                            const operand_21 = block_20: {
                                const operand_18 = ((in).table).second;
                                const operand_19 = (in).index;

                                if ((operand_19 >= (operand_18).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_20 (operand_18)[@intCast(operand_19)];
                            };

                            break :block_22 .{ operand_17, operand_21, };
                        });

                        break :block_24 (try function_24(allocator, (&operand_23)));
                    };

                    break :block_26 .{ operand_15, operand_16, operand_25, };
                });

                break :block_28 (try function_25(allocator, (&operand_27)));
            };
        } else {
            if (((value_1 == @as((zx_abi).zx_type_18, .Tuple)) or (value_1 == @as((zx_abi).zx_type_18, .Object)))) {
                const value_2: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_18, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_3: u64 = (try function_0(allocator, block_76: {
                    const operand_74 = ((in).table).first;
                    const operand_75 = (in).index;

                    if ((operand_75 >= (operand_74).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_76 (operand_74)[@intCast(operand_75)];
                }));

                const value_4: u64 = (try function_0(allocator, block_73: {
                    const operand_71 = ((in).table).second;
                    const operand_72 = (in).index;

                    if ((operand_72 >= (operand_71).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_73 (operand_71)[@intCast(operand_72)];
                }));

                _ = block_70: {
                    const operand_50 = block_49: {
                        const operand_44 = value_2;
                        const operand_45 = value_3;
                        const operand_46 = value_4;
                        const operand_47 = @as(u64, 0);
                        const operand_48 = (in).buffer;

                        break :block_49 (zx_abi).zx_type_30{ .values = operand_44, .first = operand_45, .count = operand_46, .index = operand_47, .buffer = operand_48, };
                    };

                    var state_43: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .buffer = (operand_50).buffer, .count = (operand_50).count, .first = (operand_50).first, .index = (operand_50).index, .values = (operand_50).values, .zx_origin = (&operand_50), };

                    while (((state_43).index < (state_43).count)) {
                        state_43 = block_69: {
                            const value_7: u32 = block_68: {
                                const operand_66 = (state_43).values;
                                const operand_67 = ((state_43).first + (state_43).index);

                                if ((operand_67 >= (operand_66).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_68 (operand_66)[@intCast(operand_67)];
                            };
                            _ = block_65: {
                                const operand_64 = @as((zx_abi).zx_type_28, block_63: {
                                    const operand_54 = (state_43).buffer;
                                    const operand_55 = (state_43).index;
                                    const operand_62 = block_61: {
                                        const operand_60 = @as((zx_abi).zx_type_27, block_59: {
                                            const operand_56 = (state_43).buffer;
                                            const operand_58 = block_57: {
                                                break :block_57 value_7;
                                            };

                                            break :block_59 .{ operand_56, operand_58, };
                                        });

                                        break :block_61 (try function_24(allocator, (&operand_60)));
                                    };

                                    break :block_63 .{ operand_54, operand_55, operand_62, };
                                });

                                break :block_65 (try function_25(allocator, (&operand_64)));
                            };

                            const value_8: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_43;
                            const value_9: u64 = (value_8).index;
                            const value_10: u64 = @as(u64, 1);

                            const value_11: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_53: {
                                break :block_53 @as((zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .buffer = (value_8).buffer, .count = (value_8).count, .first = (value_8).first, .index = (block_51: {
                                    break :block_51 value_9;
                                } + block_52: {
                                    break :block_52 value_10;
                                }), .values = (value_8).values, });
                            };

                            break :block_69 value_11;
                        };
                    }

                    break :block_70 {};
                };
            }
        }
    }

    return;
}

fn function_27(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ }!u64 {
    @setRuntimeSafety(true);

    return block_2: {
        const operand_1 = (in).status;

        break :block_2 (if ((operand_1 == @as((zx_abi).zx_type_34, .Missing))) @as(u64, 0) else (if ((operand_1 == @as((zx_abi).zx_type_34, .Conflict))) @as(u64, 1) else ((try function_0(allocator, (in).id)) + @as(u64, 2))));
    };
}

fn function_28(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ OutOfMemory, }!*const (zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    const value_1: u64 = block_15: {
        const operand_14 = (in).kind;

        break :block_15 (if ((operand_14 == @as((zx_abi).zx_type_18, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_14 == @as((zx_abi).zx_type_18, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_13: {
        const operand_1 = (in).kind;
        const operand_2 = (in).first;
        const operand_3 = (in).second;
        const operand_4 = (in).label;
        const operand_5 = @as(u64, 0);
        const operand_6 = value_1;
        const operand_7 = (in).children;
        const operand_8 = ((in).fields).names;
        const operand_9 = ((in).fields).types;
        const operand_10 = (in).names;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_36));

            (operand_11).* = @as((zx_abi).zx_type_36, (zx_abi).zx_type_36{ .kind = operand_1, .first = operand_2, .second = operand_3, .label = operand_4, .offset = operand_5, .count = operand_6, .children = operand_7, .field_names = operand_8, .field_types = operand_9, .names = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_36, operand_11);
        };
    };
}

fn function_28_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ OutOfMemory, }!(zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = block_28: {
        const operand_27 = (in).kind;

        break :block_28 (if ((operand_27 == @as((zx_abi).zx_type_18, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_27 == @as((zx_abi).zx_type_18, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_26: {
        const operand_16 = (in).kind;
        const operand_17 = (in).first;
        const operand_18 = (in).second;
        const operand_19 = (in).label;
        const operand_20 = @as(u64, 0);
        const operand_21 = value_1;
        const operand_22 = (in).children;
        const operand_23 = ((in).fields).names;
        const operand_24 = ((in).fields).types;
        const operand_25 = (in).names;

        break :block_26 (zx_abi).zx_type_36{ .kind = operand_16, .first = operand_17, .second = operand_18, .label = operand_19, .offset = operand_20, .count = operand_21, .children = operand_22, .field_names = operand_23, .field_types = operand_24, .names = operand_25, };
    };
}

fn function_28_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    const value_1: u64 = block_41: {
        const operand_40 = (in).kind;

        break :block_41 (if ((operand_40 == @as((zx_abi).zx_type_18, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_40 == @as((zx_abi).zx_type_18, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_39: {
        const operand_29 = (in).kind;
        const operand_30 = (in).first;
        const operand_31 = (in).second;
        const operand_32 = (in).label;
        const operand_33 = @as(u64, 0);
        const operand_34 = value_1;
        const operand_35 = (in).children;
        const operand_36 = ((in).fields).names;
        const operand_37 = ((in).fields).types;
        const operand_38 = (in).names;

        break :block_39 (zx_abi).zx_type_36{ .kind = operand_29, .first = operand_30, .second = operand_31, .label = operand_32, .offset = operand_33, .count = operand_34, .children = operand_35, .field_names = operand_36, .field_types = operand_37, .names = operand_38, };
    };
}

fn function_29(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_36 = ((in).left).*;
    const value_2: (zx_abi).zx_type_36 = ((in).right).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_18, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_18, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_18, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_18, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_18, .NativeReference))) {
        return block_63: {
            const operand_61 = ((&value_1)).label;
            const operand_62 = ((&value_2)).label;

            break :block_63 ((std).mem).eql(u8, operand_61, operand_62);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_18, .Enumeration)) and (!block_60: {
        const operand_58 = ((&value_1)).label;
        const operand_59 = ((&value_2)).label;

        break :block_60 ((std).mem).eql(u8, operand_58, operand_59);
    }))) {
        return false;
    }

    if ((((&value_1)).count != ((&value_2)).count)) {
        return false;
    }

    const value_16: (zx_abi).zx_type_38 = block_57: {
        const operand_7 = block_6: {
            const operand_2 = (&value_1);
            const operand_3 = (&value_2);
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_38{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (operand_7).equal, .index = (operand_7).index, .left = (operand_7).left, .right = (operand_7).right, .zx_origin = (&operand_7), };

        while (((state_1).equal and ((state_1).index < ((state_1).left).count))) {
            state_1 = block_54: {
                const value_5: u64 = (((state_1).left).offset + (state_1).index);
                const value_6: u64 = (((state_1).right).offset + (state_1).index);

                const value_7: bool = block_53: {
                    const operand_14 = ((state_1).left).kind;

                    break :block_53 (if ((operand_14 == @as((zx_abi).zx_type_18, .Object))) (block_44: {
                        const operand_42 = block_37: {
                            const operand_35 = ((state_1).left).field_names;

                            const operand_36 = block_34: {
                                break :block_34 value_5;
                            };

                            if ((operand_36 >= (operand_35).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_37 (operand_35)[@intCast(operand_36)];
                        };
                        const operand_43 = block_41: {
                            const operand_39 = ((state_1).right).field_names;

                            const operand_40 = block_38: {
                                break :block_38 value_6;
                            };

                            if ((operand_40 >= (operand_39).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_41 (operand_39)[@intCast(operand_40)];
                        };

                        break :block_44 ((std).mem).eql(u8, operand_42, operand_43);
                    } and (block_48: {
                        const operand_46 = ((state_1).left).field_types;

                        const operand_47 = block_45: {
                            break :block_45 value_5;
                        };

                        if ((operand_47 >= (operand_46).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_48 (operand_46)[@intCast(operand_47)];
                    } == block_52: {
                        const operand_50 = ((state_1).right).field_types;

                        const operand_51 = block_49: {
                            break :block_49 value_6;
                        };

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    })) else (if ((operand_14 == @as((zx_abi).zx_type_18, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).left).children;

                        const operand_28 = block_26: {
                            break :block_26 value_5;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_33: {
                        const operand_31 = ((state_1).right).children;

                        const operand_32 = block_30: {
                            break :block_30 value_6;
                        };

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    }) else block_25: {
                        const operand_23 = block_18: {
                            const operand_16 = ((state_1).left).names;

                            const operand_17 = block_15: {
                                break :block_15 value_5;
                            };

                            if ((operand_17 >= (operand_16).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_18 (operand_16)[@intCast(operand_17)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).right).names;

                            const operand_21 = block_19: {
                                break :block_19 value_6;
                            };

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_8: (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };

                const value_11: (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = block_11: {
                        break :block_11 value_10;
                    }, .index = (value_8).index, .left = (value_8).left, .right = (value_8).right, });
                };

                const value_12: (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (value_12).equal, .index = (block_8: {
                        break :block_8 value_13;
                    } + block_9: {
                        break :block_9 value_14;
                    }), .left = (value_12).left, .right = (value_12).right, });
                };

                break :block_54 value_15;
            };
        }

        break :block_57 block_56: {
            break :block_56 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_55: {
                break :block_55 (zx_abi).zx_type_38{ .equal = (state_1).equal, .index = (state_1).index, .left = (state_1).left, .right = (state_1).right, };
            });
        };
    };

    return ((&value_16)).equal;
}

fn function_30(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_39) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_23(allocator, block_4: {
            const operand_2 = ((in).table).kinds;
            const operand_3 = (in).index;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = ((in).table).first;
            const operand_7 = (in).index;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = ((in).table).second;
            const operand_11 = (in).index;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = ((in).table).labels;
            const operand_15 = (in).index;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };
        const operand_17 = (try function_0(allocator, block_20: {
            const operand_18 = ((in).table).first;
            const operand_19 = (in).index;

            if ((operand_19 >= (operand_18).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_20 (operand_18)[@intCast(operand_19)];
        }));

        const operand_21 = (try function_0(allocator, block_24: {
            const operand_22 = ((in).table).second;
            const operand_23 = (in).index;

            if ((operand_23 >= (operand_22).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_24 (operand_22)[@intCast(operand_23)];
        }));

        const operand_25 = ((in).table).children;
        const operand_26 = ((in).table).field_names;
        const operand_27 = ((in).table).field_types;
        const operand_28 = ((in).table).names;

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_36));

            (operand_29).* = @as((zx_abi).zx_type_36, (zx_abi).zx_type_36{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .offset = operand_17, .count = operand_21, .children = operand_25, .field_names = operand_26, .field_types = operand_27, .names = operand_28, });

            break :block_30 @as(*const (zx_abi).zx_type_36, operand_29);
        };
    };
}

fn function_30_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_39) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_23(allocator, block_35: {
            const operand_33 = ((in).table).kinds;
            const operand_34 = (in).index;

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        }));

        const operand_36 = block_39: {
            const operand_37 = ((in).table).first;
            const operand_38 = (in).index;

            if ((operand_38 >= (operand_37).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_39 (operand_37)[@intCast(operand_38)];
        };
        const operand_40 = block_43: {
            const operand_41 = ((in).table).second;
            const operand_42 = (in).index;

            if ((operand_42 >= (operand_41).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_43 (operand_41)[@intCast(operand_42)];
        };
        const operand_44 = block_47: {
            const operand_45 = ((in).table).labels;
            const operand_46 = (in).index;

            if ((operand_46 >= (operand_45).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_47 (operand_45)[@intCast(operand_46)];
        };
        const operand_48 = (try function_0(allocator, block_51: {
            const operand_49 = ((in).table).first;
            const operand_50 = (in).index;

            if ((operand_50 >= (operand_49).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_51 (operand_49)[@intCast(operand_50)];
        }));

        const operand_52 = (try function_0(allocator, block_55: {
            const operand_53 = ((in).table).second;
            const operand_54 = (in).index;

            if ((operand_54 >= (operand_53).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_55 (operand_53)[@intCast(operand_54)];
        }));

        const operand_56 = ((in).table).children;
        const operand_57 = ((in).table).field_names;
        const operand_58 = ((in).table).field_types;
        const operand_59 = ((in).table).names;

        break :block_60 (zx_abi).zx_type_36{ .kind = operand_32, .first = operand_36, .second = operand_40, .label = operand_44, .offset = operand_48, .count = operand_52, .children = operand_56, .field_names = operand_57, .field_types = operand_58, .names = operand_59, };
    };
}

fn function_30_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_39, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_36 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_23(allocator, block_64: {
            const operand_62 = ((in).table).kinds;
            const operand_63 = (in).index;

            if ((operand_63 >= (operand_62).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_64 (operand_62)[@intCast(operand_63)];
        }));

        const operand_65 = block_68: {
            const operand_66 = ((in).table).first;
            const operand_67 = (in).index;

            if ((operand_67 >= (operand_66).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_68 (operand_66)[@intCast(operand_67)];
        };
        const operand_69 = block_72: {
            const operand_70 = ((in).table).second;
            const operand_71 = (in).index;

            if ((operand_71 >= (operand_70).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_72 (operand_70)[@intCast(operand_71)];
        };
        const operand_73 = block_76: {
            const operand_74 = ((in).table).labels;
            const operand_75 = (in).index;

            if ((operand_75 >= (operand_74).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_76 (operand_74)[@intCast(operand_75)];
        };
        const operand_77 = (try function_0(allocator, block_80: {
            const operand_78 = ((in).table).first;
            const operand_79 = (in).index;

            if ((operand_79 >= (operand_78).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_80 (operand_78)[@intCast(operand_79)];
        }));

        const operand_81 = (try function_0(allocator, block_84: {
            const operand_82 = ((in).table).second;
            const operand_83 = (in).index;

            if ((operand_83 >= (operand_82).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_84 (operand_82)[@intCast(operand_83)];
        }));

        const operand_85 = ((in).table).children;
        const operand_86 = ((in).table).field_names;
        const operand_87 = ((in).table).field_types;
        const operand_88 = ((in).table).names;

        break :block_89 (zx_abi).zx_type_36{ .kind = operand_61, .first = operand_65, .second = operand_69, .label = operand_73, .offset = operand_77, .count = operand_81, .children = operand_85, .field_names = operand_86, .field_types = operand_87, .names = operand_88, };
    };
}

fn function_31(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_40) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_3: bool = (value_1 >= value_2);
    const value_4: (zx_abi).zx_type_19 = (if (value_3) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: u64 = (if (value_3) (value_1 - value_2) else value_1);

    return block_9: {
        const operand_1 = (&value_4);
        const operand_2 = value_5;
        const operand_3 = (zx_abi).zx_type_39{ .table = operand_1, .index = operand_2, };
        const operand_4 = (try function_30_value(allocator, (&operand_3)));
        const operand_5 = (&operand_4);
        const operand_6 = (try function_28_value(allocator, (in).candidate));
        const operand_7 = (&operand_6);
        const operand_8 = (zx_abi).zx_type_37{ .left = operand_5, .right = operand_7, };

        break :block_9 (try function_29(allocator, (&operand_8)));
    };
}

fn function_32(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_21 {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_0(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_19 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_23(allocator, block_4: {
            const operand_2 = (value_4).kinds;
            const operand_3 = value_5;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = (value_4).first;
            const operand_7 = value_5;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = (value_4).second;
            const operand_11 = value_5;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = (value_4).labels;
            const operand_15 = value_5;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        const operand_17 = value_3;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_21));

            (operand_18).* = @as((zx_abi).zx_type_21, (zx_abi).zx_type_21{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .delta = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_21, operand_18);
        };
    };
}

fn function_32_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_41_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);

    const value_2: u64 = block_58: {
        const operand_57 = (in).id;

        break :block_58 (try function_0(allocator, operand_57));
    };

    const value_3: bool = (block_55: {
        break :block_55 value_2;
    } >= block_56: {
        break :block_56 value_1;
    });

    const value_4: (zx_abi).zx_type_19 = (if (block_54: {
        break :block_54 value_3;
    }) (((in).tables).delta).* else (((in).tables).base).*);

    const value_5: u64 = (if (block_50: {
        break :block_50 value_3;
    }) (block_51: {
        break :block_51 value_2;
    } - block_52: {
        break :block_52 value_1;
    }) else block_53: {
        break :block_53 value_2;
    });

    return block_49: {
        const operand_21 = block_28: {
            const operand_27 = block_26: {
                const operand_24 = (block_22: {
                    break :block_22 (&value_4);
                }).kinds;

                const operand_25 = block_23: {
                    break :block_23 value_5;
                };

                if ((operand_25 >= (operand_24).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_26 (operand_24)[@intCast(operand_25)];
            };

            break :block_28 (try function_23(allocator, operand_27));
        };

        const operand_29 = block_34: {
            const operand_32 = (block_30: {
                break :block_30 (&value_4);
            }).first;

            const operand_33 = block_31: {
                break :block_31 value_5;
            };

            if ((operand_33 >= (operand_32).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_34 (operand_32)[@intCast(operand_33)];
        };
        const operand_35 = block_40: {
            const operand_38 = (block_36: {
                break :block_36 (&value_4);
            }).second;

            const operand_39 = block_37: {
                break :block_37 value_5;
            };

            if ((operand_39 >= (operand_38).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_40 (operand_38)[@intCast(operand_39)];
        };
        const operand_41 = block_46: {
            const operand_44 = (block_42: {
                break :block_42 (&value_4);
            }).labels;

            const operand_45 = block_43: {
                break :block_43 value_5;
            };

            if ((operand_45 >= (operand_44).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_46 (operand_44)[@intCast(operand_45)];
        };

        const operand_47 = block_48: {
            break :block_48 value_3;
        };

        break :block_49 @as((zx_abi).value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .kind = operand_21, .first = operand_29, .second = operand_35, .label = operand_41, .delta = operand_47, });
    };
}

fn function_33(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_42) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_35 {
    @setRuntimeSafety(true);

    const value_1: u64 = (@as(u64, ((((in).origins).base).ids).len) + @as(u64, ((((in).origins).delta).ids).len));
    const value_2: u32 = @as(u32, 0);

    const value_14: *const (zx_abi).zx_type_43 = block_106: {
        const operand_18 = block_17: {
            const operand_7 = (in).tables;
            const operand_8 = (in).origins;
            const operand_9 = (in).origin;
            const operand_10 = (in).candidate;
            const operand_11 = value_1;
            const operand_12 = @as(u64, 0);
            const operand_13 = @as((zx_abi).zx_type_34, .Missing);
            const operand_14 = value_2;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_43));

                (operand_15).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{ .tables = operand_7, .origins = operand_8, .origin = operand_9, .candidate = operand_10, .count = operand_11, .index = operand_12, .status = operand_13, .id = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_43, operand_15);
            };
        };
        const state_type_20 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_21 = struct {
            children: []const u32,
            fields: state_type_20,
            first: u32,
            kind: (zx_abi).zx_type_18,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };

        const state_type_22 = struct {
            kind: u8,
            member: []const u8,
            owner: []const u8,
        };
        const state_type_23 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };

        const state_type_24 = struct {
            base: state_type_23,
            delta: state_type_23,
        };
        const state_type_25 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_26 = struct {
            base: state_type_25,
            delta: state_type_25,
        };

        const state_type_27 = struct {
            candidate: state_type_21,
            count: u64,
            id: u32,
            index: u64,
            origin: state_type_22,
            origins: state_type_24,
            status: (zx_abi).zx_type_34,
            tables: state_type_26,
        };
        const state_type_33 = struct {
            candidate: state_type_21,
            id: u32,
            tables: state_type_26,
        };
        const state_type_47 = struct {
            id: u32,
            tables: state_type_26,
        };

        const state_type_61 = struct {
            delta: bool,
            first: u32,
            kind: (zx_abi).zx_type_18,
            label: []const u8,
            second: u32,
        };

        var state_6: state_type_27 = state_type_27{ .candidate = state_type_21{ .children = ((operand_18).candidate).children, .fields = state_type_20{ .names = (((operand_18).candidate).fields).names, .types = (((operand_18).candidate).fields).types, }, .first = ((operand_18).candidate).first, .kind = ((operand_18).candidate).kind, .label = ((operand_18).candidate).label, .names = ((operand_18).candidate).names, .second = ((operand_18).candidate).second, }, .count = (operand_18).count, .id = (operand_18).id, .index = (operand_18).index, .origin = state_type_22{ .kind = ((operand_18).origin).kind, .member = ((operand_18).origin).member, .owner = ((operand_18).origin).owner, }, .origins = state_type_24{ .base = state_type_23{ .ids = (((operand_18).origins).base).ids, .kinds = (((operand_18).origins).base).kinds, .members = (((operand_18).origins).base).members, .owners = (((operand_18).origins).base).owners, }, .delta = state_type_23{ .ids = (((operand_18).origins).delta).ids, .kinds = (((operand_18).origins).delta).kinds, .members = (((operand_18).origins).delta).members, .owners = (((operand_18).origins).delta).owners, }, }, .status = (operand_18).status, .tables = state_type_26{ .base = state_type_25{ .children = (((operand_18).tables).base).children, .field_names = (((operand_18).tables).base).field_names, .field_types = (((operand_18).tables).base).field_types, .first = (((operand_18).tables).base).first, .kinds = (((operand_18).tables).base).kinds, .labels = (((operand_18).tables).base).labels, .names = (((operand_18).tables).base).names, .second = (((operand_18).tables).base).second, }, .delta = state_type_25{ .children = (((operand_18).tables).delta).children, .field_names = (((operand_18).tables).delta).field_names, .field_types = (((operand_18).tables).delta).field_types, .first = (((operand_18).tables).delta).first, .kinds = (((operand_18).tables).delta).kinds, .labels = (((operand_18).tables).delta).labels, .names = (((operand_18).tables).delta).names, .second = (((operand_18).tables).delta).second, }, }, };
        var state_changed_19 = false;

        while ((((state_6).status == @as((zx_abi).zx_type_34, .Missing)) and ((state_6).index < (state_6).count))) {
            state_6 = block_84: {
                const value_5: u64 = @as(u64, ((((state_6).origins).base).ids).len);
                const value_6: bool = ((state_6).index >= value_5);
                const value_7: state_type_23 = (if (value_6) ((state_6).origins).delta else ((state_6).origins).base);
                const value_8: u64 = (if (value_6) ((state_6).index - value_5) else (state_6).index);

                const value_9: u32 = block_83: {
                    const operand_81 = (value_7).ids;
                    const operand_82 = value_8;

                    if ((operand_82 >= (operand_81).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_83 (operand_81)[@intCast(operand_82)];
                };
                const value_10: bool = (((block_68: {
                    const operand_66 = (value_7).kinds;
                    const operand_67 = value_8;

                    if ((operand_67 >= (operand_66).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_68 (operand_66)[@intCast(operand_67)];
                } == ((state_6).origin).kind) and block_74: {
                    const operand_72 = block_71: {
                        const operand_69 = (value_7).owners;
                        const operand_70 = value_8;

                        if ((operand_70 >= (operand_69).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_71 (operand_69)[@intCast(operand_70)];
                    };

                    const operand_73 = ((state_6).origin).owner;

                    break :block_74 ((std).mem).eql(u8, operand_72, operand_73);
                }) and block_80: {
                    const operand_78 = block_77: {
                        const operand_75 = (value_7).members;
                        const operand_76 = value_8;

                        if ((operand_76 >= (operand_75).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_77 (operand_75)[@intCast(operand_76)];
                    };

                    const operand_79 = ((state_6).origin).member;

                    break :block_80 ((std).mem).eql(u8, operand_78, operand_79);
                });

                const value_11: bool = (value_10 and block_65: {
                    const operand_63 = (block_62: {
                        const operand_51 = block_50: {
                            const operand_48 = (state_6).tables;
                            const operand_49 = value_9;

                            break :block_50 state_type_47{ .tables = operand_48, .id = operand_49, };
                        };

                        const operand_52 = (zx_abi).zx_type_19{ .children = (((operand_51).tables).base).children, .field_names = (((operand_51).tables).base).field_names, .field_types = (((operand_51).tables).base).field_types, .first = (((operand_51).tables).base).first, .kinds = (((operand_51).tables).base).kinds, .labels = (((operand_51).tables).base).labels, .names = (((operand_51).tables).base).names, .second = (((operand_51).tables).base).second, };
                        const operand_53 = (zx_abi).zx_type_19{ .children = (((operand_51).tables).delta).children, .field_names = (((operand_51).tables).delta).field_names, .field_types = (((operand_51).tables).delta).field_types, .first = (((operand_51).tables).delta).first, .kinds = (((operand_51).tables).delta).kinds, .labels = (((operand_51).tables).delta).labels, .names = (((operand_51).tables).delta).names, .second = (((operand_51).tables).delta).second, };
                        const operand_54 = (zx_abi).zx_type_20{ .base = (&operand_52), .delta = (&operand_53), };
                        const operand_55 = (zx_abi).zx_type_41{ .id = (operand_51).id, .tables = (&operand_54), };

                        const operand_60 = block_59: {
                            const operand_56 = (&operand_55);
                            const operand_57 = (try function_32_value(allocator, (zx_abi).value_zx_type_41_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_56).id, .tables = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_56).tables).base, .delta = ((operand_56).tables).delta, .zx_origin = (operand_56).tables, }, .zx_origin = operand_56, }));

                            break :block_59 (if (((operand_57).zx_origin != null)) ((operand_57).zx_origin.?).* else block_58: {
                                break :block_58 (zx_abi).zx_type_21{ .delta = (operand_57).delta, .first = (operand_57).first, .kind = (operand_57).kind, .label = (operand_57).label, .second = (operand_57).second, };
                            });
                        };

                        break :block_62 state_type_61{ .delta = (operand_60).delta, .first = (operand_60).first, .kind = (operand_60).kind, .label = (operand_60).label, .second = (operand_60).second, };
                    }).label;

                    const operand_64 = ((state_6).candidate).label;

                    break :block_65 ((std).mem).eql(u8, operand_63, operand_64);
                });

                const value_12: (zx_abi).zx_type_34 = (if ((!value_11)) @as((zx_abi).zx_type_34, .Missing) else (if (block_46: {
                    const operand_38 = block_37: {
                        const operand_34 = (state_6).tables;
                        const operand_35 = value_9;
                        const operand_36 = (state_6).candidate;

                        break :block_37 state_type_33{ .tables = operand_34, .id = operand_35, .candidate = operand_36, };
                    };

                    const operand_39 = (zx_abi).zx_type_22{ .names = (((operand_38).candidate).fields).names, .types = (((operand_38).candidate).fields).types, };
                    const operand_40 = (zx_abi).zx_type_23{ .children = ((operand_38).candidate).children, .fields = (&operand_39), .first = ((operand_38).candidate).first, .kind = ((operand_38).candidate).kind, .label = ((operand_38).candidate).label, .names = ((operand_38).candidate).names, .second = ((operand_38).candidate).second, };
                    const operand_41 = (zx_abi).zx_type_19{ .children = (((operand_38).tables).base).children, .field_names = (((operand_38).tables).base).field_names, .field_types = (((operand_38).tables).base).field_types, .first = (((operand_38).tables).base).first, .kinds = (((operand_38).tables).base).kinds, .labels = (((operand_38).tables).base).labels, .names = (((operand_38).tables).base).names, .second = (((operand_38).tables).base).second, };
                    const operand_42 = (zx_abi).zx_type_19{ .children = (((operand_38).tables).delta).children, .field_names = (((operand_38).tables).delta).field_names, .field_types = (((operand_38).tables).delta).field_types, .first = (((operand_38).tables).delta).first, .kinds = (((operand_38).tables).delta).kinds, .labels = (((operand_38).tables).delta).labels, .names = (((operand_38).tables).delta).names, .second = (((operand_38).tables).delta).second, };
                    const operand_43 = (zx_abi).zx_type_20{ .base = (&operand_41), .delta = (&operand_42), };
                    const operand_44 = (zx_abi).zx_type_40{ .candidate = (&operand_40), .id = (operand_38).id, .tables = (&operand_43), };
                    const operand_45 = (try function_31(allocator, (&operand_44)));

                    break :block_46 operand_45;
                }) @as((zx_abi).zx_type_34, .Found) else @as((zx_abi).zx_type_34, .Conflict)));

                const value_13: state_type_27 = block_32: {
                    const operand_28 = state_6;
                    const operand_29 = ((state_6).index + @as(u64, 1));
                    const operand_30 = value_12;
                    const operand_31 = (if (value_11) value_9 else (state_6).id);

                    break :block_32 state_type_27{ .candidate = (operand_28).candidate, .count = (operand_28).count, .id = operand_31, .index = operand_29, .origin = (operand_28).origin, .origins = (operand_28).origins, .status = operand_30, .tables = (operand_28).tables, };
                };

                break :block_84 value_13;
            };

            state_changed_19 = true;
        }

        break :block_106 (if (state_changed_19) block_105: {
            const operand_104 = (try (allocator).create((zx_abi).zx_type_43));

            (operand_104).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{ .candidate = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_88).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .children = ((state_6).candidate).children, .fields = block_87: {
                    const operand_86 = (try (allocator).create((zx_abi).zx_type_22));

                    (operand_86).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_87 @as(*const (zx_abi).zx_type_22, operand_86);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_89 @as(*const (zx_abi).zx_type_23, operand_88);
            }, .count = (state_6).count, .id = (state_6).id, .index = (state_6).index, .origin = block_91: {
                const operand_90 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_90).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .kind = ((state_6).origin).kind, .member = ((state_6).origin).member, .owner = ((state_6).origin).owner, });

                break :block_91 @as(*const (zx_abi).zx_type_31, operand_90);
            }, .origins = block_97: {
                const operand_96 = (try (allocator).create((zx_abi).zx_type_33));

                (operand_96).* = @as((zx_abi).zx_type_33, (zx_abi).zx_type_33{ .base = block_93: {
                    const operand_92 = (try (allocator).create((zx_abi).zx_type_32));

                    (operand_92).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .ids = (((state_6).origins).base).ids, .kinds = (((state_6).origins).base).kinds, .members = (((state_6).origins).base).members, .owners = (((state_6).origins).base).owners, });

                    break :block_93 @as(*const (zx_abi).zx_type_32, operand_92);
                }, .delta = block_95: {
                    const operand_94 = (try (allocator).create((zx_abi).zx_type_32));

                    (operand_94).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .ids = (((state_6).origins).delta).ids, .kinds = (((state_6).origins).delta).kinds, .members = (((state_6).origins).delta).members, .owners = (((state_6).origins).delta).owners, });

                    break :block_95 @as(*const (zx_abi).zx_type_32, operand_94);
                }, });

                break :block_97 @as(*const (zx_abi).zx_type_33, operand_96);
            }, .status = (state_6).status, .tables = block_103: {
                const operand_102 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_102).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .base = block_99: {
                    const operand_98 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_98).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_99 @as(*const (zx_abi).zx_type_19, operand_98);
                }, .delta = block_101: {
                    const operand_100 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_100).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_101 @as(*const (zx_abi).zx_type_19, operand_100);
                }, });

                break :block_103 @as(*const (zx_abi).zx_type_20, operand_102);
            }, });

            break :block_105 @as(*const (zx_abi).zx_type_43, operand_104);
        } else operand_18);
    };

    return block_5: {
        const operand_1 = (value_14).status;
        const operand_2 = (value_14).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_35));

            (operand_3).* = @as((zx_abi).zx_type_35, (zx_abi).zx_type_35{ .status = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_35, operand_3);
        };
    };
}

fn function_33_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_42_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: u64 = (@as(u64, ((((in).origins).base).ids).len) + @as(u64, ((((in).origins).delta).ids).len));
    const value_2: u32 = @as(u32, 0);

    const value_14: (zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = block_190: {
        const operand_122 = block_121: {
            const operand_111 = (in).tables;
            const operand_112 = (in).origins;
            const operand_113 = (in).origin;
            const operand_114 = (in).candidate;

            const operand_115 = block_116: {
                break :block_116 value_1;
            };

            const operand_117 = @as(u64, 0);
            const operand_118 = @as((zx_abi).zx_type_34, .Missing);

            const operand_119 = block_120: {
                break :block_120 value_2;
            };

            break :block_121 @as((zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34, (zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34{ .tables = operand_111, .origins = operand_112, .origin = operand_113, .candidate = operand_114, .count = operand_115, .index = operand_117, .status = operand_118, .id = operand_119, });
        };

        var state_110: (zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = operand_122;
        var state_changed_123 = false;

        while ((((state_110).status == @as((zx_abi).zx_type_34, .Missing)) and ((state_110).index < (state_110).count))) {
            state_110 = block_188: {
                const value_5: u64 = @as(u64, ((((state_110).origins).base).ids).len);

                const value_6: bool = ((state_110).index >= block_187: {
                    break :block_187 value_5;
                });

                const value_7: *const (zx_abi).zx_type_32 = (if (block_186: {
                    break :block_186 value_6;
                }) ((state_110).origins).delta else ((state_110).origins).base);

                const value_8: u64 = (if (block_184: {
                    break :block_184 value_6;
                }) ((state_110).index - block_185: {
                    break :block_185 value_5;
                }) else (state_110).index);

                const value_9: u32 = block_183: {
                    const operand_181 = (block_179: {
                        break :block_179 value_7;
                    }).ids;
                    const operand_182 = block_180: {
                        break :block_180 value_8;
                    };

                    if ((operand_182 >= (operand_181).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_183 (operand_181)[@intCast(operand_182)];
                };
                const value_10: bool = (((block_162: {
                    const operand_160 = (block_158: {
                        break :block_158 value_7;
                    }).kinds;

                    const operand_161 = block_159: {
                        break :block_159 value_8;
                    };

                    if ((operand_161 >= (operand_160).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_162 (operand_160)[@intCast(operand_161)];
                } == ((state_110).origin).kind) and block_170: {
                    const operand_168 = block_167: {
                        const operand_165 = (block_163: {
                            break :block_163 value_7;
                        }).owners;
                        const operand_166 = block_164: {
                            break :block_164 value_8;
                        };

                        if ((operand_166 >= (operand_165).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_167 (operand_165)[@intCast(operand_166)];
                    };

                    const operand_169 = ((state_110).origin).owner;

                    break :block_170 ((std).mem).eql(u8, operand_168, operand_169);
                }) and block_178: {
                    const operand_176 = block_175: {
                        const operand_173 = (block_171: {
                            break :block_171 value_7;
                        }).members;
                        const operand_174 = block_172: {
                            break :block_172 value_8;
                        };

                        if ((operand_174 >= (operand_173).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_175 (operand_173)[@intCast(operand_174)];
                    };

                    const operand_177 = ((state_110).origin).member;

                    break :block_178 ((std).mem).eql(u8, operand_176, operand_177);
                });

                const value_11: bool = (block_149: {
                    break :block_149 value_10;
                } and block_157: {
                    const operand_155 = (block_154: {
                        break :block_154 (try function_32_value(allocator, block_153: {
                            const operand_150 = (state_110).tables;

                            const operand_151 = block_152: {
                                break :block_152 value_9;
                            };

                            break :block_153 @as((zx_abi).value_zx_type_41_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_41_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_150, .id = operand_151, });
                        }));
                    }).label;

                    const operand_156 = ((state_110).candidate).label;

                    break :block_157 ((std).mem).eql(u8, operand_155, operand_156);
                });

                const value_12: (zx_abi).zx_type_34 = (if ((!block_148: {
                    break :block_148 value_11;
                })) @as((zx_abi).zx_type_34, .Missing) else (if (block_147: {
                    const operand_132 = (state_110).tables;
                    var state_borrow_133: (zx_abi).zx_type_20 = undefined;

                    state_borrow_133 = (zx_abi).zx_type_20{ .base = (operand_132).base, .delta = (operand_132).delta, };

                    const operand_134 = ((operand_132).zx_origin orelse (&state_borrow_133));

                    const operand_136 = block_135: {
                        break :block_135 value_9;
                    };

                    const operand_137 = (state_110).candidate;
                    var state_borrow_138: (zx_abi).zx_type_22 = undefined;
                    state_borrow_138 = (zx_abi).zx_type_22{ .names = ((operand_137).fields).names, .types = ((operand_137).fields).types, };

                    var state_borrow_139: (zx_abi).zx_type_23 = undefined;
                    state_borrow_139 = (zx_abi).zx_type_23{ .children = (operand_137).children, .fields = (((operand_137).fields).zx_origin orelse (&state_borrow_138)), .first = (operand_137).first, .kind = (operand_137).kind, .label = (operand_137).label, .names = (operand_137).names, .second = (operand_137).second, };
                    const operand_140 = ((operand_137).zx_origin orelse (&state_borrow_139));
                    const operand_141 = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_134).base, .delta = (operand_134).delta, .zx_origin = operand_134, };
                    var state_borrow_142: (zx_abi).zx_type_20 = undefined;
                    state_borrow_142 = (zx_abi).zx_type_20{ .base = (operand_141).base, .delta = (operand_141).delta, };
                    const operand_143 = (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = (operand_140).children, .fields = (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = ((operand_140).fields).names, .types = ((operand_140).fields).types, .zx_origin = (operand_140).fields, }, .first = (operand_140).first, .kind = (operand_140).kind, .label = (operand_140).label, .names = (operand_140).names, .second = (operand_140).second, .zx_origin = operand_140, };
                    var state_borrow_144: (zx_abi).zx_type_22 = undefined;
                    state_borrow_144 = (zx_abi).zx_type_22{ .names = ((operand_143).fields).names, .types = ((operand_143).fields).types, };

                    var state_borrow_145: (zx_abi).zx_type_23 = undefined;
                    state_borrow_145 = (zx_abi).zx_type_23{ .children = (operand_143).children, .fields = (((operand_143).fields).zx_origin orelse (&state_borrow_144)), .first = (operand_143).first, .kind = (operand_143).kind, .label = (operand_143).label, .names = (operand_143).names, .second = (operand_143).second, };

                    const operand_146 = (zx_abi).zx_type_40{ .tables = ((operand_141).zx_origin orelse (&state_borrow_142)), .id = operand_136, .candidate = ((operand_143).zx_origin orelse (&state_borrow_145)), };

                    break :block_147 (try function_31(allocator, (&operand_146)));
                }) @as((zx_abi).zx_type_34, .Found) else @as((zx_abi).zx_type_34, .Conflict)));

                const value_13: (zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = block_131: {
                    const operand_124 = state_110;
                    const operand_125 = ((state_110).index + @as(u64, 1));

                    const operand_126 = block_127: {
                        break :block_127 value_12;
                    };

                    const operand_128 = (if (block_129: {
                        break :block_129 value_11;
                    }) block_130: {
                        break :block_130 value_9;
                    } else (state_110).id);

                    break :block_131 @as((zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34, (zx_abi).value_zx_type_43_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34{ .candidate = (operand_124).candidate, .count = (operand_124).count, .id = operand_128, .index = operand_125, .origin = (operand_124).origin, .origins = (operand_124).origins, .status = operand_126, .tables = (operand_124).tables, });
                };

                break :block_188 value_13;
            };

            state_changed_123 = true;
        }

        break :block_190 (if (state_changed_123) state_110 else operand_122);
    };

    return block_109: {
        const operand_107 = (value_14).status;
        const operand_108 = (value_14).id;

        break :block_109 @as((zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .status = operand_107, .id = operand_108, });
    };
}

fn function_34(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!*const (zx_abi).zx_type_32 {
    @setRuntimeSafety(true);

    return block_7: {
        const operand_1 = (try function_19(allocator, in));
        const operand_2 = (try function_20(allocator, in));
        const operand_3 = (try function_21(allocator, in));
        const operand_4 = (try function_22(allocator, in));

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_32));

            (operand_5).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .ids = operand_1, .kinds = operand_2, .owners = operand_3, .members = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_32, operand_5);
        };
    };
}

fn function_34_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!(zx_abi).zx_type_32 {
    @setRuntimeSafety(true);

    return block_12: {
        const operand_8 = (try function_19(allocator, in));
        const operand_9 = (try function_20(allocator, in));
        const operand_10 = (try function_21(allocator, in));
        const operand_11 = (try function_22(allocator, in));

        break :block_12 (zx_abi).zx_type_32{ .ids = operand_8, .kinds = operand_9, .owners = operand_10, .members = operand_11, };
    };
}

fn function_35(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_44) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_23 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_18 = (try function_23(allocator, block_44: {
        const operand_42 = ((in).source).kinds;
        const operand_43 = (in).index;

        if ((operand_43 >= (operand_42).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_44 (operand_42)[@intCast(operand_43)];
    }));

    const value_2: []const u32 = (try function_3(allocator, (in).writer));
    const value_3: bool = (((value_1 == @as((zx_abi).zx_type_18, .Optional)) or (value_1 == @as((zx_abi).zx_type_18, .List))) or (value_1 == @as((zx_abi).zx_type_18, .Task)));

    return block_41: {
        const operand_1 = value_1;

        const operand_2 = (if (value_3) block_5: {
            const operand_3 = value_2;
            const operand_4 = @as(u64, 0);

            if ((operand_4 >= (operand_3).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_5 (operand_3)[@intCast(operand_4)];
        } else block_8: {
            const operand_6 = ((in).source).first;
            const operand_7 = (in).index;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        });

        const operand_9 = (if ((value_1 == @as((zx_abi).zx_type_18, .Task))) block_12: {
            const operand_10 = value_2;
            const operand_11 = @as(u64, 1);

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        } else @as(u32, 0));

        const operand_13 = block_16: {
            const operand_14 = ((in).source).labels;
            const operand_15 = (in).index;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        const operand_17 = (if ((value_1 == @as((zx_abi).zx_type_18, .Tuple))) value_2 else block_18: {
            break :block_18 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_19 = block_31: {
            const operand_20 = (if ((value_1 == @as((zx_abi).zx_type_18, .Object))) block_25: {
                const operand_24 = @as((zx_abi).zx_type_14, block_23: {
                    const operand_21 = (in).writer;
                    const operand_22 = (in).index;

                    break :block_23 .{ operand_21, operand_22, };
                });

                break :block_25 (try function_9(allocator, (&operand_24)));
            } else block_26: {
                break :block_26 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            });

            const operand_27 = (if ((value_1 == @as((zx_abi).zx_type_18, .Object))) value_2 else block_28: {
                break :block_28 (try (allocator).dupe(u32, (&[_]u32{})));
            });

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_22));

                (operand_29).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .names = operand_20, .types = operand_27, });

                break :block_30 @as(*const (zx_abi).zx_type_22, operand_29);
            };
        };

        const operand_32 = (if (((value_1 == @as((zx_abi).zx_type_18, .Enumeration)) or (value_1 == @as((zx_abi).zx_type_18, .ErrorSet)))) block_37: {
            const operand_36 = @as((zx_abi).zx_type_14, block_35: {
                const operand_33 = (in).writer;
                const operand_34 = (in).index;

                break :block_35 .{ operand_33, operand_34, };
            });

            break :block_37 (try function_10(allocator, (&operand_36)));
        } else block_38: {
            break :block_38 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        break :block_41 block_40: {
            const operand_39 = (try (allocator).create((zx_abi).zx_type_23));

            (operand_39).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .kind = operand_1, .first = operand_2, .second = operand_9, .label = operand_13, .children = operand_17, .fields = operand_19, .names = operand_32, });

            break :block_40 @as(*const (zx_abi).zx_type_23, operand_39);
        };
    };
}

fn function_35_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_44_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_18 = block_103: {
        const operand_102 = block_101: {
            const operand_99 = ((in).source).kinds;
            const operand_100 = (in).index;

            if ((operand_100 >= (operand_99).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_101 (operand_99)[@intCast(operand_100)];
        };

        break :block_103 (try function_23(allocator, operand_102));
    };

    const value_2: []const u32 = block_98: {
        const operand_97 = (in).writer;

        break :block_98 (try function_3(allocator, operand_97));
    };

    const value_3: bool = (((block_94: {
        break :block_94 value_1;
    } == @as((zx_abi).zx_type_18, .Optional)) or (block_95: {
        break :block_95 value_1;
    } == @as((zx_abi).zx_type_18, .List))) or (block_96: {
        break :block_96 value_1;
    } == @as((zx_abi).zx_type_18, .Task)));

    return block_93: {
        const operand_45 = block_46: {
            break :block_46 value_1;
        };

        const operand_47 = (if (block_48: {
            break :block_48 value_3;
        }) block_52: {
            const operand_50 = block_49: {
                break :block_49 value_2;
            };

            const operand_51 = @as(u64, 0);

            if ((operand_51 >= (operand_50).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_52 (operand_50)[@intCast(operand_51)];
        } else block_55: {
            const operand_53 = ((in).source).first;
            const operand_54 = (in).index;

            if ((operand_54 >= (operand_53).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_55 (operand_53)[@intCast(operand_54)];
        });

        const operand_56 = (if ((block_57: {
            break :block_57 value_1;
        } == @as((zx_abi).zx_type_18, .Task))) block_61: {
            const operand_59 = block_58: {
                break :block_58 value_2;
            };

            const operand_60 = @as(u64, 1);

            if ((operand_60 >= (operand_59).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_61 (operand_59)[@intCast(operand_60)];
        } else @as(u32, 0));

        const operand_62 = block_65: {
            const operand_63 = ((in).source).labels;
            const operand_64 = (in).index;

            if ((operand_64 >= (operand_63).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_65 (operand_63)[@intCast(operand_64)];
        };

        const operand_66 = (if ((block_67: {
            break :block_67 value_1;
        } == @as((zx_abi).zx_type_18, .Tuple))) block_68: {
            break :block_68 value_2;
        } else block_69: {
            break :block_69 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_70 = block_83: {
            const operand_71 = (if ((block_72: {
                break :block_72 value_1;
            } == @as((zx_abi).zx_type_18, .Object))) block_77: {
                const operand_76 = @as((zx_abi).zx_type_14, block_75: {
                    const operand_73 = (in).writer;
                    const operand_74 = (in).index;

                    break :block_75 .{ operand_73, operand_74, };
                });

                break :block_77 (try function_9(allocator, (&operand_76)));
            } else block_78: {
                break :block_78 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            });

            const operand_79 = (if ((block_80: {
                break :block_80 value_1;
            } == @as((zx_abi).zx_type_18, .Object))) block_81: {
                break :block_81 value_2;
            } else block_82: {
                break :block_82 (try (allocator).dupe(u32, (&[_]u32{})));
            });

            break :block_83 @as((zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = operand_71, .types = operand_79, });
        };

        const operand_84 = (if (((block_85: {
            break :block_85 value_1;
        } == @as((zx_abi).zx_type_18, .Enumeration)) or (block_86: {
            break :block_86 value_1;
        } == @as((zx_abi).zx_type_18, .ErrorSet)))) block_91: {
            const operand_90 = @as((zx_abi).zx_type_14, block_89: {
                const operand_87 = (in).writer;
                const operand_88 = (in).index;

                break :block_89 .{ operand_87, operand_88, };
            });

            break :block_91 (try function_10(allocator, (&operand_90)));
        } else block_92: {
            break :block_92 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        break :block_93 @as((zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384, (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .kind = operand_45, .first = operand_47, .second = operand_56, .label = operand_62, .children = operand_66, .fields = operand_70, .names = operand_84, });
    };
}

fn function_36(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    return block_11: {
        const operand_1 = (try function_11(allocator, in));
        const operand_2 = (try function_12(allocator, in));
        const operand_3 = (try function_13(allocator, in));
        const operand_4 = (try function_14(allocator, in));
        const operand_5 = (try function_15(allocator, in));
        const operand_6 = (try function_16(allocator, in));
        const operand_7 = (try function_17(allocator, in));
        const operand_8 = (try function_18(allocator, in));

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_9).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kinds = operand_1, .first = operand_2, .second = operand_3, .labels = operand_4, .children = operand_5, .field_types = operand_6, .field_names = operand_7, .names = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_19, operand_9);
        };
    };
}

fn function_36_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!(zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    return block_20: {
        const operand_12 = (try function_11(allocator, in));
        const operand_13 = (try function_12(allocator, in));
        const operand_14 = (try function_13(allocator, in));
        const operand_15 = (try function_14(allocator, in));
        const operand_16 = (try function_15(allocator, in));
        const operand_17 = (try function_16(allocator, in));
        const operand_18 = (try function_17(allocator, in));
        const operand_19 = (try function_18(allocator, in));

        break :block_20 (zx_abi).zx_type_19{ .kinds = operand_12, .first = operand_13, .second = operand_14, .labels = operand_15, .children = operand_16, .field_types = operand_17, .field_names = operand_18, .names = operand_19, };
    };
}

fn function_37(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_45) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_35 = block_52: {
        const operand_1 = (try function_36_value(allocator, (in).writer));
        const operand_2 = (&operand_1);
        const operand_3 = @as([]const u8, (comptime (&[_]u8{})));
        const operand_4 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_5 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_6 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_7 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_8 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_9 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_10 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_11 = (zx_abi).zx_type_19{ .kinds = operand_3, .first = operand_4, .second = operand_5, .labels = operand_6, .children = operand_7, .field_types = operand_8, .field_names = operand_9, .names = operand_10, };
        const operand_12 = (&operand_11);
        const operand_13 = (zx_abi).zx_type_20{ .base = operand_2, .delta = operand_12, };
        const operand_14 = (&operand_13);
        const operand_15 = (try function_34_value(allocator, (in).writer));
        const operand_16 = (&operand_15);
        const operand_17 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_18 = @as([]const u8, (comptime (&[_]u8{})));
        const operand_19 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_20 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_21 = (zx_abi).zx_type_32{ .ids = operand_17, .kinds = operand_18, .owners = operand_19, .members = operand_20, };
        const operand_22 = (&operand_21);
        const operand_23 = (zx_abi).zx_type_33{ .base = operand_16, .delta = operand_22, };
        const operand_24 = (&operand_23);

        const operand_28 = block_27: {
            const operand_25 = ((in).origins).kinds;
            const operand_26 = (in).origin;

            if ((operand_26 >= (operand_25).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_27 (operand_25)[@intCast(operand_26)];
        };
        const operand_32 = block_31: {
            const operand_29 = ((in).origins).owners;
            const operand_30 = (in).origin;

            if ((operand_30 >= (operand_29).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_31 (operand_29)[@intCast(operand_30)];
        };
        const operand_36 = block_35: {
            const operand_33 = ((in).origins).members;
            const operand_34 = (in).origin;

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        };

        const operand_37 = (zx_abi).zx_type_31{ .kind = operand_28, .owner = operand_32, .member = operand_36, };
        const operand_38 = (&operand_37);
        const operand_39 = (in).source;
        const operand_40 = (in).index;
        const operand_41 = (in).writer;
        const operand_42 = (zx_abi).zx_type_44{ .source = operand_39, .index = operand_40, .writer = operand_41, };
        const operand_43 = (&operand_42);
        const operand_44 = (try function_35_value(allocator, (zx_abi).value_zx_type_44_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_43).index, .source = (operand_43).source, .writer = (operand_43).writer, .zx_origin = operand_43, }));
        var state_borrow_45: (zx_abi).zx_type_22 = undefined;

        state_borrow_45 = (zx_abi).zx_type_22{ .names = ((operand_44).fields).names, .types = ((operand_44).fields).types, };

        var state_borrow_46: (zx_abi).zx_type_23 = undefined;

        state_borrow_46 = (zx_abi).zx_type_23{ .children = (operand_44).children, .fields = (((operand_44).fields).zx_origin orelse (&state_borrow_45)), .first = (operand_44).first, .kind = (operand_44).kind, .label = (operand_44).label, .names = (operand_44).names, .second = (operand_44).second, };

        const operand_47 = ((operand_44).zx_origin orelse (&state_borrow_46));
        const operand_48 = (zx_abi).zx_type_42{ .tables = operand_14, .origins = operand_24, .origin = operand_38, .candidate = operand_47, };
        const operand_49 = (&operand_48);
        const operand_50 = (try function_33_value(allocator, (zx_abi).value_zx_type_42_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1{ .candidate = (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_49).candidate).children, .fields = (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_49).candidate).fields).names, .types = (((operand_49).candidate).fields).types, .zx_origin = ((operand_49).candidate).fields, }, .first = ((operand_49).candidate).first, .kind = ((operand_49).candidate).kind, .label = ((operand_49).candidate).label, .names = ((operand_49).candidate).names, .second = ((operand_49).candidate).second, .zx_origin = (operand_49).candidate, }, .origin = (zx_abi).value_zx_type_31_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .kind = ((operand_49).origin).kind, .member = ((operand_49).origin).member, .owner = ((operand_49).origin).owner, .zx_origin = (operand_49).origin, }, .origins = (zx_abi).value_zx_type_33_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_49).origins).base, .delta = ((operand_49).origins).delta, .zx_origin = (operand_49).origins, }, .tables = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_49).tables).base, .delta = ((operand_49).tables).delta, .zx_origin = (operand_49).tables, }, .zx_origin = operand_49, }));

        break :block_52 (if (((operand_50).zx_origin != null)) ((operand_50).zx_origin.?).* else block_51: {
            break :block_51 (zx_abi).zx_type_35{ .id = (operand_50).id, .status = (operand_50).status, };
        });
    };

    return (try function_27(allocator, (&value_1)));
}

fn function_38(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_46) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_24 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_18, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_18, .NativeReference)))) {
        return block_61: {
            const operand_57 = false;
            const operand_58 = @as(u32, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_24));

                (operand_59).* = @as((zx_abi).zx_type_24, (zx_abi).zx_type_24{ .found = operand_57, .id = operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_24, operand_59);
            };
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: *const (zx_abi).zx_type_47 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_47));

                (operand_13).* = @as((zx_abi).zx_type_47, (zx_abi).zx_type_47{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_47, operand_13);
            };
        };
        const state_type_18 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_19 = struct {
            children: []const u32,
            fields: state_type_18,
            first: u32,
            kind: (zx_abi).zx_type_18,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };
        const state_type_20 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_21 = struct {
            base: state_type_20,
            delta: state_type_20,
        };

        const state_type_22 = struct {
            candidate: state_type_19,
            count: u64,
            found: bool,
            id: u32,
            index: u64,
            tables: state_type_21,
        };
        const state_type_28 = struct {
            candidate: state_type_19,
            id: u32,
            tables: state_type_21,
        };

        var state_6: state_type_22 = state_type_22{ .candidate = state_type_19{ .children = ((operand_16).candidate).children, .fields = state_type_18{ .names = (((operand_16).candidate).fields).names, .types = (((operand_16).candidate).fields).types, }, .first = ((operand_16).candidate).first, .kind = ((operand_16).candidate).kind, .label = ((operand_16).candidate).label, .names = ((operand_16).candidate).names, .second = ((operand_16).candidate).second, }, .count = (operand_16).count, .found = (operand_16).found, .id = (operand_16).id, .index = (operand_16).index, .tables = state_type_21{ .base = state_type_20{ .children = (((operand_16).tables).base).children, .field_names = (((operand_16).tables).base).field_names, .field_types = (((operand_16).tables).base).field_types, .first = (((operand_16).tables).base).first, .kinds = (((operand_16).tables).base).kinds, .labels = (((operand_16).tables).base).labels, .names = (((operand_16).tables).base).names, .second = (((operand_16).tables).base).second, }, .delta = state_type_20{ .children = (((operand_16).tables).delta).children, .field_names = (((operand_16).tables).delta).field_names, .field_types = (((operand_16).tables).delta).field_types, .first = (((operand_16).tables).delta).first, .kinds = (((operand_16).tables).delta).kinds, .labels = (((operand_16).tables).delta).labels, .names = (((operand_16).tables).delta).names, .second = (((operand_16).tables).delta).second, }, }, };
        var state_changed_17 = false;

        while (((!(state_6).found) and ((state_6).index < (state_6).count))) {
            state_6 = block_42: {
                const value_5: u32 = (try function_1(allocator, (state_6).index));

                const value_6: bool = block_41: {
                    const operand_33 = block_32: {
                        const operand_29 = (state_6).tables;
                        const operand_30 = value_5;
                        const operand_31 = (state_6).candidate;

                        break :block_32 state_type_28{ .tables = operand_29, .id = operand_30, .candidate = operand_31, };
                    };

                    const operand_34 = (zx_abi).zx_type_22{ .names = (((operand_33).candidate).fields).names, .types = (((operand_33).candidate).fields).types, };
                    const operand_35 = (zx_abi).zx_type_23{ .children = ((operand_33).candidate).children, .fields = (&operand_34), .first = ((operand_33).candidate).first, .kind = ((operand_33).candidate).kind, .label = ((operand_33).candidate).label, .names = ((operand_33).candidate).names, .second = ((operand_33).candidate).second, };
                    const operand_36 = (zx_abi).zx_type_19{ .children = (((operand_33).tables).base).children, .field_names = (((operand_33).tables).base).field_names, .field_types = (((operand_33).tables).base).field_types, .first = (((operand_33).tables).base).first, .kinds = (((operand_33).tables).base).kinds, .labels = (((operand_33).tables).base).labels, .names = (((operand_33).tables).base).names, .second = (((operand_33).tables).base).second, };
                    const operand_37 = (zx_abi).zx_type_19{ .children = (((operand_33).tables).delta).children, .field_names = (((operand_33).tables).delta).field_names, .field_types = (((operand_33).tables).delta).field_types, .first = (((operand_33).tables).delta).first, .kinds = (((operand_33).tables).delta).kinds, .labels = (((operand_33).tables).delta).labels, .names = (((operand_33).tables).delta).names, .second = (((operand_33).tables).delta).second, };
                    const operand_38 = (zx_abi).zx_type_20{ .base = (&operand_36), .delta = (&operand_37), };
                    const operand_39 = (zx_abi).zx_type_40{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_31(allocator, (&operand_39)));

                    break :block_41 operand_40;
                };
                const value_7: state_type_22 = block_27: {
                    const operand_23 = state_6;
                    const operand_24 = ((state_6).index + @as(u64, 1));
                    const operand_25 = value_6;
                    const operand_26 = value_5;

                    break :block_27 state_type_22{ .candidate = (operand_23).candidate, .count = (operand_23).count, .found = operand_25, .id = operand_26, .index = operand_24, .tables = (operand_23).tables, };
                };

                break :block_42 value_7;
            };

            state_changed_17 = true;
        }

        break :block_56 (if (state_changed_17) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_47));

            (operand_54).* = @as((zx_abi).zx_type_47, (zx_abi).zx_type_47{ .candidate = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_23));

                (operand_46).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .children = ((state_6).candidate).children, .fields = block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_22));

                    (operand_44).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_45 @as(*const (zx_abi).zx_type_22, operand_44);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_47 @as(*const (zx_abi).zx_type_23, operand_46);
            }, .count = (state_6).count, .found = (state_6).found, .id = (state_6).id, .index = (state_6).index, .tables = block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_52).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .base = block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_48).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_49 @as(*const (zx_abi).zx_type_19, operand_48);
                }, .delta = block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_50).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_51 @as(*const (zx_abi).zx_type_19, operand_50);
                }, });

                break :block_53 @as(*const (zx_abi).zx_type_20, operand_52);
            }, });

            break :block_55 @as(*const (zx_abi).zx_type_47, operand_54);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_8).found;
        const operand_2 = (value_8).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_24));

            (operand_3).* = @as((zx_abi).zx_type_24, (zx_abi).zx_type_24{ .found = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_24, operand_3);
        };
    };
}

fn function_38_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_46_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_18, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_18, .NativeReference)))) {
        return block_107: {
            const operand_105 = false;
            const operand_106 = @as(u32, 0);

            break :block_107 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_105, .id = operand_106, });
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: (zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_104: {
        const operand_75 = block_74: {
            const operand_66 = (in).tables;
            const operand_67 = (in).candidate;

            const operand_68 = block_69: {
                break :block_69 value_2;
            };

            const operand_70 = @as(u64, 0);
            const operand_71 = false;

            const operand_72 = block_73: {
                break :block_73 value_1;
            };

            break :block_74 @as((zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .tables = operand_66, .candidate = operand_67, .count = operand_68, .index = operand_70, .found = operand_71, .id = operand_72, });
        };

        var state_65: (zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_102: {
                const value_5: u32 = block_101: {
                    const operand_100 = (state_65).index;

                    break :block_101 (try function_1(allocator, operand_100));
                };
                const value_6: bool = block_99: {
                    const operand_84 = (state_65).tables;
                    var state_borrow_85: (zx_abi).zx_type_20 = undefined;
                    state_borrow_85 = (zx_abi).zx_type_20{ .base = (operand_84).base, .delta = (operand_84).delta, };

                    const operand_86 = ((operand_84).zx_origin orelse (&state_borrow_85));

                    const operand_88 = block_87: {
                        break :block_87 value_5;
                    };

                    const operand_89 = (state_65).candidate;
                    var state_borrow_90: (zx_abi).zx_type_22 = undefined;
                    state_borrow_90 = (zx_abi).zx_type_22{ .names = ((operand_89).fields).names, .types = ((operand_89).fields).types, };

                    var state_borrow_91: (zx_abi).zx_type_23 = undefined;
                    state_borrow_91 = (zx_abi).zx_type_23{ .children = (operand_89).children, .fields = (((operand_89).fields).zx_origin orelse (&state_borrow_90)), .first = (operand_89).first, .kind = (operand_89).kind, .label = (operand_89).label, .names = (operand_89).names, .second = (operand_89).second, };

                    const operand_92 = ((operand_89).zx_origin orelse (&state_borrow_91));
                    const operand_93 = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_86).base, .delta = (operand_86).delta, .zx_origin = operand_86, };
                    var state_borrow_94: (zx_abi).zx_type_20 = undefined;

                    state_borrow_94 = (zx_abi).zx_type_20{ .base = (operand_93).base, .delta = (operand_93).delta, };
                    const operand_95 = (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = (operand_92).children, .fields = (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = ((operand_92).fields).names, .types = ((operand_92).fields).types, .zx_origin = (operand_92).fields, }, .first = (operand_92).first, .kind = (operand_92).kind, .label = (operand_92).label, .names = (operand_92).names, .second = (operand_92).second, .zx_origin = operand_92, };
                    var state_borrow_96: (zx_abi).zx_type_22 = undefined;
                    state_borrow_96 = (zx_abi).zx_type_22{ .names = ((operand_95).fields).names, .types = ((operand_95).fields).types, };

                    var state_borrow_97: (zx_abi).zx_type_23 = undefined;
                    state_borrow_97 = (zx_abi).zx_type_23{ .children = (operand_95).children, .fields = (((operand_95).fields).zx_origin orelse (&state_borrow_96)), .first = (operand_95).first, .kind = (operand_95).kind, .label = (operand_95).label, .names = (operand_95).names, .second = (operand_95).second, };

                    const operand_98 = (zx_abi).zx_type_40{ .tables = ((operand_93).zx_origin orelse (&state_borrow_94)), .id = operand_88, .candidate = ((operand_95).zx_origin orelse (&state_borrow_97)), };

                    break :block_99 (try function_31(allocator, (&operand_98)));
                };

                const value_7: (zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_47_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .candidate = (operand_77).candidate, .count = (operand_77).count, .found = operand_79, .id = operand_81, .index = operand_78, .tables = (operand_77).tables, });
                };

                break :block_102 value_7;
            };

            state_changed_76 = true;
        }

        break :block_104 (if (state_changed_76) state_65 else operand_75);
    };

    return block_64: {
        const operand_62 = (value_8).found;
        const operand_63 = (value_8).id;

        break :block_64 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_62, .id = operand_63, });
    };
}

fn function_39(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_44) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_24 = block_24: {
        const operand_1 = (try function_36_value(allocator, (in).writer));
        const operand_2 = (&operand_1);
        const operand_3 = @as([]const u8, (comptime (&[_]u8{})));
        const operand_4 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_5 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_6 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_7 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_8 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_9 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_10 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_11 = (zx_abi).zx_type_19{ .kinds = operand_3, .first = operand_4, .second = operand_5, .labels = operand_6, .children = operand_7, .field_types = operand_8, .field_names = operand_9, .names = operand_10, };
        const operand_12 = (&operand_11);
        const operand_13 = (zx_abi).zx_type_20{ .base = operand_2, .delta = operand_12, };
        const operand_14 = (&operand_13);
        const operand_15 = in;
        const operand_16 = (try function_35_value(allocator, (zx_abi).value_zx_type_44_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_15).index, .source = (operand_15).source, .writer = (operand_15).writer, .zx_origin = operand_15, }));
        var state_borrow_17: (zx_abi).zx_type_22 = undefined;
        state_borrow_17 = (zx_abi).zx_type_22{ .names = ((operand_16).fields).names, .types = ((operand_16).fields).types, };

        var state_borrow_18: (zx_abi).zx_type_23 = undefined;

        state_borrow_18 = (zx_abi).zx_type_23{ .children = (operand_16).children, .fields = (((operand_16).fields).zx_origin orelse (&state_borrow_17)), .first = (operand_16).first, .kind = (operand_16).kind, .label = (operand_16).label, .names = (operand_16).names, .second = (operand_16).second, };

        const operand_19 = ((operand_16).zx_origin orelse (&state_borrow_18));
        const operand_20 = (zx_abi).zx_type_46{ .tables = operand_14, .candidate = operand_19, };
        const operand_21 = (&operand_20);
        const operand_22 = (try function_38_value(allocator, (zx_abi).value_zx_type_46_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22{ .candidate = (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_21).candidate).children, .fields = (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_21).candidate).fields).names, .types = (((operand_21).candidate).fields).types, .zx_origin = ((operand_21).candidate).fields, }, .first = ((operand_21).candidate).first, .kind = ((operand_21).candidate).kind, .label = ((operand_21).candidate).label, .names = ((operand_21).candidate).names, .second = ((operand_21).candidate).second, .zx_origin = (operand_21).candidate, }, .tables = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_21).tables).base, .delta = ((operand_21).tables).delta, .zx_origin = (operand_21).tables, }, .zx_origin = operand_21, }));

        break :block_24 (if (((operand_22).zx_origin != null)) ((operand_22).zx_origin.?).* else block_23: {
            break :block_23 (zx_abi).zx_type_24{ .found = (operand_22).found, .id = (operand_22).id, };
        });
    };

    return (if (((&value_1)).found) ((try function_0(allocator, ((&value_1)).id)) + @as(u64, 2)) else @as(u64, 0));
}

fn function_40(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_48) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_25: (zx_abi).zx_type_49 = block_111: {
        const operand_9 = block_8: {
            const operand_2 = (in).source;
            const operand_3 = (in).origins;
            const operand_4 = (in).first;
            const operand_5 = (in).writer;
            const operand_6 = (in).buffer;
            const operand_7 = @as(u64, 0);

            break :block_8 (zx_abi).zx_type_49{ .source = operand_2, .origins = operand_3, .index = operand_4, .writer = operand_5, .buffer = operand_6, .status = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (operand_9).buffer, .index = (operand_9).index, .origins = (operand_9).origins, .source = (operand_9).source, .status = (operand_9).status, .writer = (operand_9).writer, .zx_origin = (&operand_9), };

        while ((((state_1).status == @as(u64, 0)) and ((state_1).index < @as(u64, (((state_1).source).kinds).len)))) {
            state_1 = block_108: {
                const value_3: (zx_abi).zx_type_18 = block_107: {
                    const operand_106 = block_105: {
                        const operand_103 = ((state_1).source).kinds;
                        const operand_104 = (state_1).index;

                        if ((operand_104 >= (operand_103).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_105 (operand_103)[@intCast(operand_104)];
                    };

                    break :block_107 (try function_23(allocator, operand_106));
                };

                const value_4: bool = ((block_101: {
                    break :block_101 value_3;
                } == @as((zx_abi).zx_type_18, .Tuple)) or (block_102: {
                    break :block_102 value_3;
                } == @as((zx_abi).zx_type_18, .Object)));

                _ = block_100: {
                    const operand_99 = @as((zx_abi).zx_type_12, block_98: {
                        const operand_87 = (state_1).writer;
                        const operand_88 = (state_1).index;

                        const operand_95 = (if (block_89: {
                            break :block_89 value_4;
                        }) block_94: {
                            const operand_93 = block_92: {
                                const operand_90 = ((state_1).source).second;
                                const operand_91 = (state_1).index;

                                if ((operand_91 >= (operand_90).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_92 (operand_90)[@intCast(operand_91)];
                            };

                            break :block_94 (try function_0(allocator, operand_93));
                        } else @as(u64, 0));

                        const operand_97 = block_96: {
                            break :block_96 value_4;
                        };

                        break :block_98 .{ operand_87, operand_88, operand_95, operand_97, };
                    });

                    break :block_100 (try function_2(allocator, (&operand_99)));
                };
                _ = block_86: {
                    const operand_82 = (state_1).source;
                    const operand_83 = (state_1).index;
                    const operand_84 = (state_1).buffer;
                    const operand_85 = (zx_abi).zx_type_29{ .table = operand_82, .index = operand_83, .buffer = operand_84, };

                    break :block_86 (try function_26(allocator, (&operand_85)));
                };

                const value_5: bool = ((block_80: {
                    break :block_80 value_3;
                } == @as((zx_abi).zx_type_18, .Enumeration)) or (block_81: {
                    break :block_81 value_3;
                } == @as((zx_abi).zx_type_18, .NativeReference)));

                const value_20: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((block_13: {
                    break :block_13 value_5;
                } and (!block_18: {
                    const operand_17 = @as((zx_abi).zx_type_14, block_16: {
                        const operand_14 = (state_1).writer;
                        const operand_15 = (state_1).index;

                        break :block_16 .{ operand_14, operand_15, };
                    });

                    break :block_18 (try function_4(allocator, (&operand_17)));
                }))) block_21: {
                    const value_6: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                    _ = (value_6).status;

                    const value_8: u64 = @as(u64, 1);

                    const value_9: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_20: {
                        break :block_20 @as((zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (value_6).buffer, .index = (value_6).index, .origins = (value_6).origins, .source = (value_6).source, .status = block_19: {
                            break :block_19 value_8;
                        }, .writer = (value_6).writer, });
                    };

                    break :block_21 value_9;
                } else block_79: {
                    const value_10: u64 = (if (block_73: {
                        break :block_73 value_5;
                    }) block_78: {
                        const operand_77 = @as((zx_abi).zx_type_14, block_76: {
                            const operand_74 = (state_1).writer;
                            const operand_75 = (state_1).index;

                            break :block_76 .{ operand_74, operand_75, };
                        });

                        break :block_78 (try function_5(allocator, (&operand_77)));
                    } else @as(u64, 0));

                    const value_11: u64 = (if (block_59: {
                        break :block_59 value_5;
                    }) block_67: {
                        const operand_60 = (state_1).source;
                        const operand_61 = (state_1).index;
                        const operand_62 = (state_1).writer;
                        const operand_63 = (state_1).origins;

                        const operand_65 = block_64: {
                            break :block_64 value_10;
                        };

                        const operand_66 = (zx_abi).zx_type_45{ .source = operand_60, .index = operand_61, .writer = operand_62, .origins = operand_63, .origin = operand_65, };

                        break :block_67 (try function_37(allocator, (&operand_66)));
                    } else block_72: {
                        const operand_68 = (state_1).source;
                        const operand_69 = (state_1).index;
                        const operand_70 = (state_1).writer;
                        const operand_71 = (zx_abi).zx_type_44{ .source = operand_68, .index = operand_69, .writer = operand_70, };

                        break :block_72 (try function_39(allocator, (&operand_71)));
                    });

                    const value_19: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((block_22: {
                        break :block_22 value_11;
                    } == @as(u64, 1))) block_25: {
                        const value_12: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                        _ = (value_12).status;
                        const value_14: u64 = @as(u64, 2);

                        const value_15: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_24: {
                            break :block_24 @as((zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (value_12).buffer, .index = (value_12).index, .origins = (value_12).origins, .source = (value_12).source, .status = block_23: {
                                break :block_23 value_14;
                            }, .writer = (value_12).writer, });
                        };

                        break :block_25 value_15;
                    } else block_58: {
                        const value_18: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((block_26: {
                            break :block_26 value_11;
                        } == @as(u64, 0))) block_49: {
                            const value_16: u64 = block_48: {
                                const operand_47 = @as((zx_abi).zx_type_14, block_46: {
                                    const operand_44 = (state_1).writer;
                                    const operand_45 = (state_1).index;

                                    break :block_46 .{ operand_44, operand_45, };
                                });

                                break :block_48 (try function_7(allocator, (&operand_47)));
                            };
                            const value_17: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_34: {
                                break :block_34 value_5;
                            }) block_43: {
                                _ = block_42: {
                                    const operand_41 = @as((zx_abi).zx_type_15, block_40: {
                                        const operand_35 = (state_1).writer;

                                        const operand_37 = block_36: {
                                            break :block_36 value_16;
                                        };
                                        const operand_39 = block_38: {
                                            break :block_38 value_10;
                                        };

                                        break :block_40 .{ operand_35, operand_37, operand_39, };
                                    });

                                    break :block_42 (try function_8(allocator, (&operand_41)));
                                };

                                break :block_43 state_1;
                            } else state_1);

                            _ = block_33: {
                                const operand_32 = @as((zx_abi).zx_type_15, block_31: {
                                    const operand_27 = (value_17).writer;
                                    const operand_28 = (value_17).index;
                                    const operand_30 = block_29: {
                                        break :block_29 value_16;
                                    };

                                    break :block_31 .{ operand_27, operand_28, operand_30, };
                                });

                                break :block_33 (try function_6(allocator, (&operand_32)));
                            };

                            break :block_49 value_17;
                        } else block_57: {
                            _ = block_56: {
                                const operand_55 = @as((zx_abi).zx_type_15, block_54: {
                                    const operand_50 = (state_1).writer;
                                    const operand_51 = (state_1).index;

                                    const operand_53 = (block_52: {
                                        break :block_52 value_11;
                                    } - @as(u64, 2));

                                    break :block_54 .{ operand_50, operand_51, operand_53, };
                                });

                                break :block_56 (try function_6(allocator, (&operand_55)));
                            };

                            break :block_57 state_1;
                        });

                        break :block_58 value_18;
                    });

                    break :block_79 value_19;
                });

                const value_21: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_20;
                const value_22: u64 = (value_21).index;
                const value_23: u64 = @as(u64, 1);

                const value_24: (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (value_21).buffer, .index = (block_10: {
                        break :block_10 value_22;
                    } + block_11: {
                        break :block_11 value_23;
                    }), .origins = (value_21).origins, .source = (value_21).source, .status = (value_21).status, .writer = (value_21).writer, });
                };

                break :block_108 value_24;
            };
        }

        break :block_111 block_110: {
            break :block_110 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_109: {
                break :block_109 (zx_abi).zx_type_49{ .buffer = (state_1).buffer, .index = (state_1).index, .origins = (state_1).origins, .source = (state_1).source, .status = (state_1).status, .writer = (state_1).writer, };
            });
        };
    };

    return ((&value_25)).status;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_48) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try function_40(allocator, in));

    return value_1;
}

