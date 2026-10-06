const std = @import("std");
const zx_native_0 = @import("origin_writer");
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .scalar, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_16 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .children = zx_shape_15, .field_names = zx_shape_16, .field_types = zx_shape_15, .first = zx_shape_15, .kinds = zx_shape_14, .labels = zx_shape_16, .names = zx_shape_16, .second = zx_shape_15, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .base = zx_shape_17, .delta = zx_shape_17, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_13, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .names = zx_shape_16, .types = zx_shape_15, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .children = zx_shape_15, .fields = zx_shape_20, .first = zx_shape_4, .kind = zx_shape_13, .label = zx_shape_10, .names = zx_shape_16, .second = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .delta = zx_shape_17, .id = zx_shape_4, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .kinds = zx_shape_14, .writer = zx_shape_11, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .kinds = zx_shape_14, .writer = zx_shape_11, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_24, }, };
pub const input_shape = zx_shape_24;
pub const output_shape = zx_shape_0;
pub const Input = *const (zx_abi).zx_type_24;
pub const Output = void;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).append((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_13, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_13, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_13, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_13, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_13, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_13, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_13, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_13, .Enumeration) else @as((zx_abi).zx_type_13, .NativeReference)))))))));
    };
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_24) error{ IndexOutOfBounds, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    _ = block_26: {
        const operand_6 = block_5: {
            const operand_2 = (in).kinds;
            const operand_3 = (in).first;
            const operand_4 = (in).writer;

            break :block_5 (zx_abi).zx_type_25{ .kinds = operand_2, .index = operand_3, .writer = operand_4, };
        };

        var state_1: (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_6).index, .kinds = (operand_6).kinds, .writer = (operand_6).writer, .zx_origin = (&operand_6), };

        while (((state_1).index < @as(u64, ((state_1).kinds).len))) {
            state_1 = block_23: {
                const value_3: (zx_abi).zx_type_13 = block_22: {
                    const operand_21 = block_20: {
                        const operand_18 = (state_1).kinds;
                        const operand_19 = (state_1).index;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };

                    break :block_22 (try function_1(allocator, operand_21));
                };

                const value_4: (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (if (((block_10: {
                    break :block_10 value_3;
                } == @as((zx_abi).zx_type_13, .Enumeration)) or (block_11: {
                    break :block_11 value_3;
                } == @as((zx_abi).zx_type_13, .NativeReference)))) block_17: {
                    block_16: {
                        const operand_15 = @as((zx_abi).zx_type_12, block_14: {
                            const operand_12 = (state_1).writer;
                            const operand_13 = (state_1).index;

                            break :block_14 .{ operand_12, operand_13, };
                        });

                        break :block_16 (try function_0(allocator, (&operand_15)));
                    }

                    break :block_17 state_1;
                } else state_1);

                const value_5: (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_4;
                const value_6: u64 = (value_5).index;
                const value_7: u64 = @as(u64, 1);

                const value_8: (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_9: {
                    break :block_9 @as((zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_7: {
                        break :block_7 value_6;
                    } + block_8: {
                        break :block_8 value_7;
                    }), .kinds = (value_5).kinds, .writer = (value_5).writer, });
                };

                break :block_23 value_8;
            };
        }

        break :block_26 block_25: {
            break :block_25 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_24: {
                break :block_24 (zx_abi).zx_type_25{ .index = (state_1).index, .kinds = (state_1).kinds, .writer = (state_1).writer, };
            });
        };
    };

    return;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_24) error{ IndexOutOfBounds, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = (try function_2(allocator, in));

    return;
}

