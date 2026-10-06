const std = @import("std");
const zx_native_0 = @import("construction");
const zx_native_1 = @import("integers");
const zx_native_2 = @import("type_flags");
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
const zx_shape_12 = .{ .kind = .scalar, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_12, }, };
const zx_shape_18 = .{ .kind = .scalar, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_14, .field_names = zx_shape_15, .field_types = zx_shape_14, .first = zx_shape_14, .kinds = zx_shape_13, .labels = zx_shape_15, .names = zx_shape_15, .second = zx_shape_14, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .base = zx_shape_19, .delta = zx_shape_19, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .names = zx_shape_15, .types = zx_shape_14, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .children = zx_shape_14, .fields = zx_shape_22, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .names = zx_shape_15, .second = zx_shape_4, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .delta = zx_shape_19, .id = zx_shape_4, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .children = zx_shape_14, .count = zx_shape_5, .field_names = zx_shape_15, .field_types = zx_shape_14, .first = zx_shape_4, .kind = zx_shape_18, .label = zx_shape_10, .names = zx_shape_15, .offset = zx_shape_5, .second = zx_shape_4, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .left = zx_shape_26, .right = zx_shape_26, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_26, .right = zx_shape_26, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_19, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .id = zx_shape_4, .tables = zx_shape_20, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .tables = zx_shape_20, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_20, }, };
const zx_shape_33 = .{ .kind = .native_reference, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_33, .@"1" = zx_shape_5, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_33, .@"1" = zx_shape_5, .@"2" = zx_shape_1, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .flags = zx_shape_33, .index = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_19, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .children = zx_shape_14, .count = zx_shape_5, .flags = zx_shape_33, .found = zx_shape_1, .index = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .flags = zx_shape_33, .id = zx_shape_4, .native_references = zx_shape_1, .table = zx_shape_19, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .table = zx_shape_19, .target = zx_shape_18, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .flags = zx_shape_33, .index = zx_shape_5, .limit = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_19, }, };
const zx_shape_41 = .{ .kind = .scalar, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_23, .table = zx_shape_19, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .children = zx_shape_14, .found = zx_shape_1, .index = zx_shape_5, .table = zx_shape_19, }, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .flags = zx_shape_33, .writer = zx_shape_11, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .writer = zx_shape_11, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_44, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_44, .@"1" = zx_shape_5, }, };
pub const input_shape = zx_shape_44;
pub const output_shape = zx_shape_5;
pub const Input = *const (zx_abi).zx_type_44;
pub const Output = u64;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u8 {
    const native_result = (zx_native_0).kinds(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).first(in);

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).second(in);

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_0).labels(in);

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).children(in);

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).allFieldTypes(in);

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_0).allFieldNames(in);

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_0).names(in);

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u8 {
    const native_result = (zx_native_0).candidateKind(in);

    _ = allocator;

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u32 {
    const native_result = (zx_native_0).candidateFirst(in);

    _ = allocator;

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u32 {
    const native_result = (zx_native_0).candidateSecond(in);

    _ = allocator;

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).references(in);

    _ = allocator;

    return native_result;
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_0).fieldNames(in);

    _ = allocator;

    return native_result;
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const u32 {
    const native_result = (zx_native_0).fieldTypes(in);

    _ = allocator;

    return native_result;
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }![]const []const u8 {
    const native_result = (zx_native_0).memberNames(in);

    _ = allocator;

    return native_result;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).prepareNames(in));

    _ = allocator;

    return native_result;
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).copyName((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).sortNames(in));

    _ = allocator;

    return native_result;
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!u64 {
    const native_result = (try (zx_native_0).append(in));

    _ = allocator;

    return native_result;
}

fn function_19(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ InvalidSource, OutOfMemory, }!void {
    const native_result = (try (zx_native_0).failType((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_20(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ InvalidSource, OutOfMemory, }!void {
    const native_result = (try (zx_native_0).failOwnership((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_21(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ InvalidSource, OutOfMemory, }!void {
    const native_result = (try (zx_native_0).failCapability((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_1).widen(in);

    _ = allocator;

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_1).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_24(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ OutOfMemory, }!*const (zx_abi).zx_type_26 {
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
            const operand_11 = (try (allocator).create((zx_abi).zx_type_26));

            (operand_11).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .kind = operand_1, .first = operand_2, .second = operand_3, .label = operand_4, .offset = operand_5, .count = operand_6, .children = operand_7, .field_names = operand_8, .field_types = operand_9, .names = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_26, operand_11);
        };
    };
}

fn function_24_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ OutOfMemory, }!(zx_abi).zx_type_26 {
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

        break :block_26 (zx_abi).zx_type_26{ .kind = operand_16, .first = operand_17, .second = operand_18, .label = operand_19, .offset = operand_20, .count = operand_21, .children = operand_22, .field_names = operand_23, .field_types = operand_24, .names = operand_25, };
    };
}

fn function_24_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23, buffers: struct {
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
}) error{ OutOfMemory, }!(zx_abi).zx_type_26 {
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

        break :block_39 (zx_abi).zx_type_26{ .kind = operand_29, .first = operand_30, .second = operand_31, .label = operand_32, .offset = operand_33, .count = operand_34, .children = operand_35, .field_names = operand_36, .field_types = operand_37, .names = operand_38, };
    };
}

fn function_25(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_26 = ((in).left).*;
    const value_2: (zx_abi).zx_type_26 = ((in).right).*;

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

    const value_16: (zx_abi).zx_type_28 = block_57: {
        const operand_7 = block_6: {
            const operand_2 = (&value_1);
            const operand_3 = (&value_2);
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_28{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (operand_7).equal, .index = (operand_7).index, .left = (operand_7).left, .right = (operand_7).right, .zx_origin = (&operand_7), };

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
                const value_8: (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };

                const value_11: (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = block_11: {
                        break :block_11 value_10;
                    }, .index = (value_8).index, .left = (value_8).left, .right = (value_8).right, });
                };

                const value_12: (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (value_12).equal, .index = (block_8: {
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
                break :block_55 (zx_abi).zx_type_28{ .equal = (state_1).equal, .index = (state_1).index, .left = (state_1).left, .right = (state_1).right, };
            });
        };
    };

    return ((&value_16)).equal;
}

fn function_26(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_18, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_18, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_18, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_18, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_18, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_18, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_18, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_18, .Enumeration) else @as((zx_abi).zx_type_18, .NativeReference)))))))));
    };
}

fn function_27(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_26 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_26(allocator, block_4: {
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
        const operand_17 = (try function_22(allocator, block_20: {
            const operand_18 = ((in).table).first;
            const operand_19 = (in).index;

            if ((operand_19 >= (operand_18).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_20 (operand_18)[@intCast(operand_19)];
        }));

        const operand_21 = (try function_22(allocator, block_24: {
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
            const operand_29 = (try (allocator).create((zx_abi).zx_type_26));

            (operand_29).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .offset = operand_17, .count = operand_21, .children = operand_25, .field_names = operand_26, .field_types = operand_27, .names = operand_28, });

            break :block_30 @as(*const (zx_abi).zx_type_26, operand_29);
        };
    };
}

fn function_27_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_26 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_26(allocator, block_35: {
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
        const operand_48 = (try function_22(allocator, block_51: {
            const operand_49 = ((in).table).first;
            const operand_50 = (in).index;

            if ((operand_50 >= (operand_49).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_51 (operand_49)[@intCast(operand_50)];
        }));

        const operand_52 = (try function_22(allocator, block_55: {
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

        break :block_60 (zx_abi).zx_type_26{ .kind = operand_32, .first = operand_36, .second = operand_40, .label = operand_44, .offset = operand_48, .count = operand_52, .children = operand_56, .field_names = operand_57, .field_types = operand_58, .names = operand_59, };
    };
}

fn function_27_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29, buffers: struct {
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
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_26 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_26(allocator, block_64: {
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
        const operand_77 = (try function_22(allocator, block_80: {
            const operand_78 = ((in).table).first;
            const operand_79 = (in).index;

            if ((operand_79 >= (operand_78).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_80 (operand_78)[@intCast(operand_79)];
        }));

        const operand_81 = (try function_22(allocator, block_84: {
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

        break :block_89 (zx_abi).zx_type_26{ .kind = operand_61, .first = operand_65, .second = operand_69, .label = operand_73, .offset = operand_77, .count = operand_81, .children = operand_85, .field_names = operand_86, .field_types = operand_87, .names = operand_88, };
    };
}

fn function_28(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_30) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_22(allocator, (in).id));
    const value_2: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_3: bool = (value_1 >= value_2);
    const value_4: (zx_abi).zx_type_19 = (if (value_3) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: u64 = (if (value_3) (value_1 - value_2) else value_1);

    return block_9: {
        const operand_1 = (&value_4);
        const operand_2 = value_5;
        const operand_3 = (zx_abi).zx_type_29{ .table = operand_1, .index = operand_2, };
        const operand_4 = (try function_27_value(allocator, (&operand_3)));
        const operand_5 = (&operand_4);
        const operand_6 = (try function_24_value(allocator, (in).candidate));
        const operand_7 = (&operand_6);
        const operand_8 = (zx_abi).zx_type_27{ .left = operand_5, .right = operand_7, };

        break :block_9 (try function_25(allocator, (&operand_8)));
    };
}

fn function_29(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_24 {
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

    const value_8: *const (zx_abi).zx_type_32 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_32));

                (operand_13).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_32, operand_13);
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
                const value_5: u32 = (try function_23(allocator, (state_6).index));

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
                    const operand_39 = (zx_abi).zx_type_30{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_28(allocator, (&operand_39)));

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
            const operand_54 = (try (allocator).create((zx_abi).zx_type_32));

            (operand_54).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .candidate = block_47: {
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

            break :block_55 @as(*const (zx_abi).zx_type_32, operand_54);
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

fn function_29_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_31_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
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

    const value_8: (zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_104: {
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

            break :block_74 @as((zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .tables = operand_66, .candidate = operand_67, .count = operand_68, .index = operand_70, .found = operand_71, .id = operand_72, });
        };

        var state_65: (zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_102: {
                const value_5: u32 = block_101: {
                    const operand_100 = (state_65).index;

                    break :block_101 (try function_23(allocator, operand_100));
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

                    const operand_98 = (zx_abi).zx_type_30{ .tables = ((operand_93).zx_origin orelse (&state_borrow_94)), .id = operand_88, .candidate = ((operand_95).zx_origin orelse (&state_borrow_97)), };

                    break :block_99 (try function_28(allocator, (&operand_98)));
                };

                const value_7: (zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .candidate = (operand_77).candidate, .count = (operand_77).count, .found = operand_79, .id = operand_81, .index = operand_78, .tables = (operand_77).tables, });
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

fn function_30(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!*const (zx_abi).zx_type_23 {
    @setRuntimeSafety(true);

    return block_15: {
        const operand_1 = (try function_26(allocator, (try function_8(allocator, in))));
        const operand_2 = (try function_9(allocator, in));
        const operand_3 = (try function_10(allocator, in));
        const operand_4 = @as([]const u8, "");
        const operand_5 = (try function_11(allocator, in));

        const operand_6 = block_11: {
            const operand_7 = (try function_12(allocator, in));
            const operand_8 = (try function_13(allocator, in));

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create((zx_abi).zx_type_22));

                (operand_9).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .names = operand_7, .types = operand_8, });

                break :block_10 @as(*const (zx_abi).zx_type_22, operand_9);
            };
        };

        const operand_12 = (try function_14(allocator, in));

        break :block_15 block_14: {
            const operand_13 = (try (allocator).create((zx_abi).zx_type_23));

            (operand_13).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .kind = operand_1, .first = operand_2, .second = operand_3, .label = operand_4, .children = operand_5, .fields = operand_6, .names = operand_12, });

            break :block_14 @as(*const (zx_abi).zx_type_23, operand_13);
        };
    };
}

fn function_30_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!(zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 {
    @setRuntimeSafety(true);

    return block_42: {
        const operand_16 = block_20: {
            const operand_19 = block_18: {
                const operand_17 = in;

                break :block_18 (try function_8(allocator, operand_17));
            };

            break :block_20 (try function_26(allocator, operand_19));
        };
        const operand_21 = block_23: {
            const operand_22 = in;

            break :block_23 (try function_9(allocator, operand_22));
        };
        const operand_24 = block_26: {
            const operand_25 = in;

            break :block_26 (try function_10(allocator, operand_25));
        };

        const operand_27 = @as([]const u8, "");

        const operand_28 = block_30: {
            const operand_29 = in;

            break :block_30 (try function_11(allocator, operand_29));
        };
        const operand_31 = block_38: {
            const operand_32 = block_34: {
                const operand_33 = in;

                break :block_34 (try function_12(allocator, operand_33));
            };
            const operand_35 = block_37: {
                const operand_36 = in;

                break :block_37 (try function_13(allocator, operand_36));
            };

            break :block_38 @as((zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = operand_32, .types = operand_35, });
        };

        const operand_39 = block_41: {
            const operand_40 = in;

            break :block_41 (try function_14(allocator, operand_40));
        };

        break :block_42 @as((zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384, (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .kind = operand_16, .first = operand_21, .second = operand_24, .label = operand_27, .children = operand_28, .fields = operand_31, .names = operand_39, });
    };
}

fn function_31(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    return block_11: {
        const operand_1 = (try function_0(allocator, in));
        const operand_2 = (try function_1(allocator, in));
        const operand_3 = (try function_2(allocator, in));
        const operand_4 = (try function_3(allocator, in));
        const operand_5 = (try function_4(allocator, in));
        const operand_6 = (try function_5(allocator, in));
        const operand_7 = (try function_6(allocator, in));
        const operand_8 = (try function_7(allocator, in));

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_9).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kinds = operand_1, .first = operand_2, .second = operand_3, .labels = operand_4, .children = operand_5, .field_types = operand_6, .field_names = operand_7, .names = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_19, operand_9);
        };
    };
}

fn function_31_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!(zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    return block_20: {
        const operand_12 = (try function_0(allocator, in));
        const operand_13 = (try function_1(allocator, in));
        const operand_14 = (try function_2(allocator, in));
        const operand_15 = (try function_3(allocator, in));
        const operand_16 = (try function_4(allocator, in));
        const operand_17 = (try function_5(allocator, in));
        const operand_18 = (try function_6(allocator, in));
        const operand_19 = (try function_7(allocator, in));

        break :block_20 (zx_abi).zx_type_19{ .kinds = operand_12, .first = operand_13, .second = operand_14, .labels = operand_15, .children = operand_16, .field_types = operand_17, .field_names = operand_18, .names = operand_19, };
    };
}

fn function_32(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_2).allocate((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_33(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34) error{ }!bool {
    const native_result = (zx_native_2).get((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_34(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ }!void {
    const native_result = (zx_native_2).set((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_35(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33) error{ }!void {
    const native_result = (zx_native_2).release(in);

    _ = allocator;

    return native_result;
}

fn function_36(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_18 = (try function_26(allocator, block_45: {
        const operand_43 = ((in).table).kinds;
        const operand_44 = (in).index;

        if ((operand_44 >= (operand_43).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_45 (operand_43)[@intCast(operand_44)];
    }));

    const value_2: (zx_abi).zx_type_18 = (if ((in).native_references) @as((zx_abi).zx_type_18, .NativeReference) else @as((zx_abi).zx_type_18, .List));

    if ((value_1 == value_2)) {
        return true;
    }

    if (((value_1 == @as((zx_abi).zx_type_18, .Optional)) or ((in).native_references and ((value_1 == @as((zx_abi).zx_type_18, .List)) or (value_1 == @as((zx_abi).zx_type_18, .Task)))))) {
        return block_42: {
            const operand_41 = @as((zx_abi).zx_type_34, block_40: {
                const operand_35 = (in).flags;

                const operand_39 = (try function_22(allocator, block_38: {
                    const operand_36 = ((in).table).first;
                    const operand_37 = (in).index;

                    if ((operand_37 >= (operand_36).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_38 (operand_36)[@intCast(operand_37)];
                }));

                break :block_40 .{ operand_35, operand_39, };
            });

            break :block_42 (try function_33(allocator, (&operand_41)));
        };
    }

    if (((value_1 != @as((zx_abi).zx_type_18, .Tuple)) and (value_1 != @as((zx_abi).zx_type_18, .Object)))) {
        return false;
    }

    const value_3: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_18, .Tuple))) ((in).table).children else ((in).table).field_types);

    const value_14: (zx_abi).zx_type_37 = block_34: {
        const operand_15 = block_14: {
            const operand_2 = (in).flags;
            const operand_3 = value_3;

            const operand_4 = (try function_22(allocator, block_7: {
                const operand_5 = ((in).table).first;
                const operand_6 = (in).index;

                if ((operand_6 >= (operand_5).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_7 (operand_5)[@intCast(operand_6)];
            }));

            const operand_8 = (try function_22(allocator, block_11: {
                const operand_9 = ((in).table).second;
                const operand_10 = (in).index;

                if ((operand_10 >= (operand_9).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_11 (operand_9)[@intCast(operand_10)];
            }));

            const operand_12 = @as(u64, 0);
            const operand_13 = false;

            break :block_14 (zx_abi).zx_type_37{ .flags = operand_2, .children = operand_3, .offset = operand_4, .count = operand_8, .index = operand_12, .found = operand_13, };
        };

        var state_1: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (operand_15).children, .count = (operand_15).count, .flags = (operand_15).flags, .found = (operand_15).found, .index = (operand_15).index, .offset = (operand_15).offset, .zx_origin = (&operand_15), };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_31: {
                const value_6: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                _ = (value_6).found;

                const value_8: bool = block_30: {
                    const operand_29 = @as((zx_abi).zx_type_34, block_28: {
                        const operand_21 = (state_1).flags;

                        const operand_27 = block_26: {
                            const operand_25 = block_24: {
                                const operand_22 = (state_1).children;
                                const operand_23 = ((state_1).offset + (state_1).index);

                                if ((operand_23 >= (operand_22).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_24 (operand_22)[@intCast(operand_23)];
                            };

                            break :block_26 (try function_22(allocator, operand_25));
                        };

                        break :block_28 .{ operand_21, operand_27, };
                    });

                    break :block_30 (try function_33(allocator, (&operand_29)));
                };

                const value_9: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_6).children, .count = (value_6).count, .flags = (value_6).flags, .found = block_19: {
                        break :block_19 value_8;
                    }, .index = (value_6).index, .offset = (value_6).offset, });
                };

                const value_10: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_10).children, .count = (value_10).count, .flags = (value_10).flags, .found = (value_10).found, .index = (block_16: {
                        break :block_16 value_11;
                    } + block_17: {
                        break :block_17 value_12;
                    }), .offset = (value_10).offset, });
                };

                break :block_31 value_13;
            };
        }

        break :block_34 block_33: {
            break :block_33 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_32: {
                break :block_32 (zx_abi).zx_type_37{ .children = (state_1).children, .count = (state_1).count, .flags = (state_1).flags, .found = (state_1).found, .index = (state_1).index, .offset = (state_1).offset, };
            });
        };
    };

    return ((&value_14)).found;
}

fn function_37(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_38) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_22(allocator, (in).id));
    const value_2: (zx_abi).zx_type_18 = (if ((in).native_references) @as((zx_abi).zx_type_18, .NativeReference) else @as((zx_abi).zx_type_18, .List));

    if (((try function_26(allocator, block_61: {
        const operand_59 = ((in).table).kinds;
        const operand_60 = value_1;

        if ((operand_60 >= (operand_59).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_61 (operand_59)[@intCast(operand_60)];
    })) == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_39 = block_58: {
        const operand_44 = block_43: {
            const operand_38 = (in).table;
            const operand_39 = value_1;
            const operand_40 = value_2;
            const operand_41 = @as(u64, 0);
            const operand_42 = false;

            break :block_43 (zx_abi).zx_type_39{ .table = operand_38, .limit = operand_39, .target = operand_40, .index = operand_41, .found = operand_42, };
        };

        var state_37: (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (operand_44).found, .index = (operand_44).index, .limit = (operand_44).limit, .table = (operand_44).table, .target = (operand_44).target, .zx_origin = (&operand_44), };

        while (((!(state_37).found) and ((state_37).index < (state_37).limit))) {
            state_37 = block_55: {
                const value_5: (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_37;
                _ = (value_5).found;

                const value_7: bool = (block_54: {
                    const operand_53 = block_52: {
                        const operand_50 = ((state_37).table).kinds;
                        const operand_51 = (state_37).index;

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    };

                    break :block_54 (try function_26(allocator, operand_53));
                } == (state_37).target);

                const value_8: (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_49: {
                    break :block_49 @as((zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = block_48: {
                        break :block_48 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .table = (value_5).table, .target = (value_5).target, });
                };

                const value_9: (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_47: {
                    break :block_47 @as((zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (value_9).found, .index = (block_45: {
                        break :block_45 value_10;
                    } + block_46: {
                        break :block_46 value_11;
                    }), .limit = (value_9).limit, .table = (value_9).table, .target = (value_9).target, });
                };

                break :block_55 value_12;
            };
        }

        break :block_58 block_57: {
            break :block_57 (if (((state_37).zx_origin != null)) ((state_37).zx_origin.?).* else block_56: {
                break :block_56 (zx_abi).zx_type_39{ .found = (state_37).found, .index = (state_37).index, .limit = (state_37).limit, .table = (state_37).table, .target = (state_37).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    _ = block_36: {
        const operand_35 = @as((zx_abi).zx_type_34, block_34: {
            const operand_32 = (in).flags;
            const operand_33 = (value_1 + @as(u64, 1));

            break :block_34 .{ operand_32, operand_33, };
        });

        break :block_36 (try function_32(allocator, (&operand_35)));
    };

    _ = block_31: {
        const operand_13 = block_12: {
            const operand_7 = (in).table;
            const operand_8 = (((&value_13)).index - @as(u64, 1));
            const operand_9 = (value_1 + @as(u64, 1));
            const operand_10 = (in).flags;
            const operand_11 = (in).native_references;

            break :block_12 (zx_abi).zx_type_40{ .table = operand_7, .index = operand_8, .limit = operand_9, .flags = operand_10, .native_references = operand_11, };
        };

        var state_6: (zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .flags = (operand_13).flags, .index = (operand_13).index, .limit = (operand_13).limit, .native_references = (operand_13).native_references, .table = (operand_13).table, .zx_origin = (&operand_13), };

        while (((state_6).index < (state_6).limit)) {
            state_6 = block_30: {
                const value_16: bool = block_29: {
                    const operand_24 = (state_6).table;
                    const operand_25 = (state_6).index;
                    const operand_26 = (state_6).flags;
                    const operand_27 = (state_6).native_references;
                    const operand_28 = (zx_abi).zx_type_36{ .table = operand_24, .index = operand_25, .flags = operand_26, .native_references = operand_27, };

                    break :block_29 (try function_36(allocator, (&operand_28)));
                };
                _ = block_23: {
                    const operand_22 = @as((zx_abi).zx_type_35, block_21: {
                        const operand_17 = (state_6).flags;
                        const operand_18 = (state_6).index;

                        const operand_20 = block_19: {
                            break :block_19 value_16;
                        };

                        break :block_21 .{ operand_17, operand_18, operand_20, };
                    });

                    break :block_23 (try function_34(allocator, (&operand_22)));
                };

                const value_17: (zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_6;
                const value_18: u64 = (value_17).index;
                const value_19: u64 = @as(u64, 1);

                const value_20: (zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .flags = (value_17).flags, .index = (block_14: {
                        break :block_14 value_18;
                    } + block_15: {
                        break :block_15 value_19;
                    }), .limit = (value_17).limit, .native_references = (value_17).native_references, .table = (value_17).table, });
                };

                break :block_30 value_20;
            };
        }

        break :block_31 {};
    };

    const value_21: bool = block_5: {
        const operand_4 = @as((zx_abi).zx_type_34, block_3: {
            const operand_1 = (in).flags;
            const operand_2 = value_1;

            break :block_3 .{ operand_1, operand_2, };
        });

        break :block_5 (try function_33(allocator, (&operand_4)));
    };

    _ = (try function_35(allocator, (in).flags));

    return value_21;
}

fn function_38(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_42) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_41 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_18, .Optional)) or (((in).candidate).kind == @as((zx_abi).zx_type_18, .List)))) {
        if (((try function_26(allocator, block_29: {
            const operand_27 = ((in).table).kinds;
            const operand_28 = (try function_22(allocator, ((in).candidate).first));

            if ((operand_28 >= (operand_27).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_29 (operand_27)[@intCast(operand_28)];
        })) == @as((zx_abi).zx_type_18, .Task))) {
            return @as((zx_abi).zx_type_41, .TaskContainer);
        }

        return (if (((((in).candidate).kind == @as((zx_abi).zx_type_18, .List)) and (((in).candidate).first == @as(u32, 0)))) @as((zx_abi).zx_type_41, .VoidList) else @as((zx_abi).zx_type_41, .None));
    }

    if (((((in).candidate).kind != @as((zx_abi).zx_type_18, .Tuple)) and (((in).candidate).kind != @as((zx_abi).zx_type_18, .Object)))) {
        return @as((zx_abi).zx_type_41, .None);
    }

    const value_1: []const u32 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_18, .Tuple))) ((in).candidate).children else (((in).candidate).fields).types);

    const value_12: (zx_abi).zx_type_43 = block_26: {
        const operand_7 = block_6: {
            const operand_2 = (in).table;
            const operand_3 = value_1;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 (zx_abi).zx_type_43{ .table = operand_2, .children = operand_3, .index = operand_4, .found = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .children = (operand_7).children, .found = (operand_7).found, .index = (operand_7).index, .table = (operand_7).table, .zx_origin = (&operand_7), };

        while (((!(state_1).found) and ((state_1).index < @as(u64, ((state_1).children).len)))) {
            state_1 = block_23: {
                const value_4: (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;
                _ = (value_4).found;

                const value_6: bool = (block_22: {
                    const operand_21 = block_20: {
                        const operand_18 = ((state_1).table).kinds;

                        const operand_19 = block_17: {
                            const operand_16 = block_15: {
                                const operand_13 = (state_1).children;
                                const operand_14 = (state_1).index;

                                if ((operand_14 >= (operand_13).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_15 (operand_13)[@intCast(operand_14)];
                            };

                            break :block_17 (try function_22(allocator, operand_16));
                        };

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };

                    break :block_22 (try function_26(allocator, operand_21));
                } == @as((zx_abi).zx_type_18, .Task));

                const value_7: (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .children = (value_4).children, .found = block_11: {
                        break :block_11 value_6;
                    }, .index = (value_4).index, .table = (value_4).table, });
                };

                const value_8: (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_7;
                const value_9: u64 = (value_8).index;
                const value_10: u64 = @as(u64, 1);

                const value_11: (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .children = (value_8).children, .found = (value_8).found, .index = (block_8: {
                        break :block_8 value_9;
                    } + block_9: {
                        break :block_9 value_10;
                    }), .table = (value_8).table, });
                };

                break :block_23 value_11;
            };
        }

        break :block_26 block_25: {
            break :block_25 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_24: {
                break :block_24 (zx_abi).zx_type_43{ .children = (state_1).children, .found = (state_1).found, .index = (state_1).index, .table = (state_1).table, };
            });
        };
    };

    if ((!((&value_12)).found)) {
        return @as((zx_abi).zx_type_41, .None);
    }

    return (if ((((in).candidate).kind == @as((zx_abi).zx_type_18, .Tuple))) @as((zx_abi).zx_type_41, .TaskTuple) else @as((zx_abi).zx_type_41, .TaskObject));
}

fn function_39(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_44) error{ IndexOutOfBounds, InvalidSource, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_19 = block_48: {
        break :block_48 (try function_31_value(allocator, (in).writer));
    };

    const value_2: (zx_abi).zx_type_41 = block_47: {
        const operand_40 = (&value_1);
        const operand_41 = (in).writer;
        const operand_42 = (try function_30_value(allocator, operand_41));
        var state_borrow_43: (zx_abi).zx_type_22 = undefined;
        state_borrow_43 = (zx_abi).zx_type_22{ .names = ((operand_42).fields).names, .types = ((operand_42).fields).types, };

        var state_borrow_44: (zx_abi).zx_type_23 = undefined;

        state_borrow_44 = (zx_abi).zx_type_23{ .children = (operand_42).children, .fields = (((operand_42).fields).zx_origin orelse (&state_borrow_43)), .first = (operand_42).first, .kind = (operand_42).kind, .label = (operand_42).label, .names = (operand_42).names, .second = (operand_42).second, };

        const operand_45 = ((operand_42).zx_origin orelse (&state_borrow_44));
        const operand_46 = (zx_abi).zx_type_42{ .table = operand_40, .candidate = operand_45, };

        break :block_47 (try function_38(allocator, (&operand_46)));
    };

    if ((value_2 == @as((zx_abi).zx_type_41, .TaskContainer))) {
        _ = block_24: {
            const operand_23 = @as((zx_abi).zx_type_17, block_22: {
                const operand_20 = (in).writer;
                const operand_21 = @as((zx_abi).zx_type_12, .TaskContainer);

                break :block_22 .{ operand_20, operand_21, };
            });

            break :block_24 (try function_20(allocator, (&operand_23)));
        };
    } else {
        if ((value_2 == @as((zx_abi).zx_type_41, .VoidList))) {
            _ = block_29: {
                const operand_28 = @as((zx_abi).zx_type_17, block_27: {
                    const operand_25 = (in).writer;
                    const operand_26 = @as((zx_abi).zx_type_12, .VoidList);

                    break :block_27 .{ operand_25, operand_26, };
                });

                break :block_29 (try function_19(allocator, (&operand_28)));
            };
        } else {
            if ((value_2 == @as((zx_abi).zx_type_41, .TaskTuple))) {
                _ = block_34: {
                    const operand_33 = @as((zx_abi).zx_type_17, block_32: {
                        const operand_30 = (in).writer;
                        const operand_31 = @as((zx_abi).zx_type_12, .TaskTuple);

                        break :block_32 .{ operand_30, operand_31, };
                    });

                    break :block_34 (try function_20(allocator, (&operand_33)));
                };
            } else {
                if ((value_2 == @as((zx_abi).zx_type_41, .TaskObject))) {
                    _ = block_39: {
                        const operand_38 = @as((zx_abi).zx_type_17, block_37: {
                            const operand_35 = (in).writer;
                            const operand_36 = @as((zx_abi).zx_type_12, .TaskObject);

                            break :block_37 .{ operand_35, operand_36, };
                        });

                        break :block_39 (try function_20(allocator, (&operand_38)));
                    };
                }
            }
        }
    }

    if (((try function_26(allocator, (try function_8(allocator, (in).writer)))) == @as((zx_abi).zx_type_18, .Task))) {
        const value_3: u32 = (try function_9(allocator, (in).writer));

        if (block_14: {
            const operand_9 = (&value_1);
            const operand_10 = value_3;
            const operand_11 = (in).flags;
            const operand_12 = true;
            const operand_13 = (zx_abi).zx_type_38{ .table = operand_9, .id = operand_10, .flags = operand_11, .native_references = operand_12, };

            break :block_14 (try function_37(allocator, (&operand_13)));
        }) {
            _ = block_19: {
                const operand_18 = @as((zx_abi).zx_type_17, block_17: {
                    const operand_15 = (in).writer;
                    const operand_16 = @as((zx_abi).zx_type_12, .NativeTask);

                    break :block_17 .{ operand_15, operand_16, };
                });

                break :block_19 (try function_21(allocator, (&operand_18)));
            };
        }

        if (((try function_26(allocator, block_3: {
            const operand_1 = ((&value_1)).kinds;
            const operand_2 = (try function_22(allocator, value_3));

            if ((operand_2 >= (operand_1).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_3 (operand_1)[@intCast(operand_2)];
        })) == @as((zx_abi).zx_type_18, .Task))) {
            _ = block_8: {
                const operand_7 = @as((zx_abi).zx_type_17, block_6: {
                    const operand_4 = (in).writer;
                    const operand_5 = @as((zx_abi).zx_type_12, .NestedTask);

                    break :block_6 .{ operand_4, operand_5, };
                });

                break :block_8 (try function_20(allocator, (&operand_7)));
            };
        }
    }

    return;
}

fn function_40(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_44) error{ IndexOutOfBounds, IntegerOverflow, InvalidSource, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    _ = (try function_39(allocator, in));

    const value_1: (zx_abi).zx_type_18 = (try function_26(allocator, (try function_8(allocator, (in).writer))));

    if ((value_1 == @as((zx_abi).zx_type_18, .ErrorSet))) {
        _ = (try function_15(allocator, (in).writer));
    }

    if (((value_1 == @as((zx_abi).zx_type_18, .ErrorSet)) or (value_1 == @as((zx_abi).zx_type_18, .Object)))) {
        _ = (try function_17(allocator, (in).writer));
    }

    const value_2: (zx_abi).zx_type_24 = block_41: {
        const operand_18 = (try function_31_value(allocator, (in).writer));
        const operand_19 = (&operand_18);
        const operand_20 = @as([]const u8, (comptime (&[_]u8{})));
        const operand_21 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_22 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_23 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_24 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_25 = @as([]const u32, (comptime (&[_]u32{})));
        const operand_26 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_27 = @as([]const []const u8, (comptime (&[_][]const u8{})));
        const operand_28 = (zx_abi).zx_type_19{ .kinds = operand_20, .first = operand_21, .second = operand_22, .labels = operand_23, .children = operand_24, .field_types = operand_25, .field_names = operand_26, .names = operand_27, };
        const operand_29 = (&operand_28);
        const operand_30 = (zx_abi).zx_type_20{ .base = operand_19, .delta = operand_29, };
        const operand_31 = (&operand_30);
        const operand_32 = (in).writer;
        const operand_33 = (try function_30_value(allocator, operand_32));
        var state_borrow_34: (zx_abi).zx_type_22 = undefined;
        state_borrow_34 = (zx_abi).zx_type_22{ .names = ((operand_33).fields).names, .types = ((operand_33).fields).types, };

        var state_borrow_35: (zx_abi).zx_type_23 = undefined;
        state_borrow_35 = (zx_abi).zx_type_23{ .children = (operand_33).children, .fields = (((operand_33).fields).zx_origin orelse (&state_borrow_34)), .first = (operand_33).first, .kind = (operand_33).kind, .label = (operand_33).label, .names = (operand_33).names, .second = (operand_33).second, };

        const operand_36 = ((operand_33).zx_origin orelse (&state_borrow_35));
        const operand_37 = (zx_abi).zx_type_31{ .tables = operand_31, .candidate = operand_36, };
        const operand_38 = (&operand_37);
        const operand_39 = (try function_29_value(allocator, (zx_abi).value_zx_type_31_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22{ .candidate = (zx_abi).value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_38).candidate).children, .fields = (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_38).candidate).fields).names, .types = (((operand_38).candidate).fields).types, .zx_origin = ((operand_38).candidate).fields, }, .first = ((operand_38).candidate).first, .kind = ((operand_38).candidate).kind, .label = ((operand_38).candidate).label, .names = ((operand_38).candidate).names, .second = ((operand_38).candidate).second, .zx_origin = (operand_38).candidate, }, .tables = (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_38).tables).base, .delta = ((operand_38).tables).delta, .zx_origin = (operand_38).tables, }, .zx_origin = operand_38, }));

        break :block_41 (if (((operand_39).zx_origin != null)) ((operand_39).zx_origin.?).* else block_40: {
            break :block_40 (zx_abi).zx_type_24{ .found = (operand_39).found, .id = (operand_39).id, };
        });
    };

    if (((&value_2)).found) {
        return (try function_22(allocator, ((&value_2)).id));
    }

    if ((value_1 == @as((zx_abi).zx_type_18, .ErrorSet))) {
        _ = block_17: {
            const operand_5 = block_4: {
                const operand_2 = (in).writer;
                const operand_3 = @as(u64, 0);

                break :block_4 (zx_abi).zx_type_45{ .writer = operand_2, .index = operand_3, };
            };

            var state_1: (zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .index = (operand_5).index, .writer = (operand_5).writer, .zx_origin = (&operand_5), };

            while (((state_1).index < @as(u64, (block_7: {
                const operand_6 = (state_1).writer;

                break :block_7 (try function_14(allocator, operand_6));
            }).len))) {
                state_1 = block_16: {
                    _ = block_15: {
                        const operand_14 = @as((zx_abi).zx_type_16, block_13: {
                            const operand_11 = (state_1).writer;
                            const operand_12 = (state_1).index;

                            break :block_13 .{ operand_11, operand_12, };
                        });

                        break :block_15 (try function_16(allocator, (&operand_14)));
                    };

                    const value_5: (zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = state_1;
                    const value_6: u64 = (value_5).index;
                    const value_7: u64 = @as(u64, 1);

                    const value_8: (zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_10: {
                        break :block_10 @as((zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .index = (block_8: {
                            break :block_8 value_6;
                        } + block_9: {
                            break :block_9 value_7;
                        }), .writer = (value_5).writer, });
                    };

                    break :block_16 value_8;
                };
            }

            break :block_17 {};
        };
    }

    return (try function_18(allocator, (in).writer));
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_44) error{ IndexOutOfBounds, IntegerOverflow, InvalidSource, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try function_40(allocator, in));

    return value_1;
}
