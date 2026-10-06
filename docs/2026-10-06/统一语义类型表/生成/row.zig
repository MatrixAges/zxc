const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_22;
pub const Output = *const (zx_abi).zx_type_17;
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
const zx_shape_22 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_16, }, };
pub const input_shape = zx_shape_22;
pub const output_shape = zx_shape_17;

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

fn function_2(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_17 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_0(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_15 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_2(allocator, block_4: {
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
            const operand_18 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_18).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .delta = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_17, operand_18);
        };
    };
}
