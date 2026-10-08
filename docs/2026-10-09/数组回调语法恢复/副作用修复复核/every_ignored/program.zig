const std = @import("std");
const zx_native_0 = @import("host");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = bool;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .context = zx_shape_7, .item = zx_shape_7, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, .tag = zx_shape_7, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_1, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_1;

fn function_0(allocator: ((std).mem).Allocator, in: i64) anyerror!i64 {
    const native_result = (try (zx_native_0).context(in));

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: []const i64) anyerror![]const i64 {
    const native_result = (try (zx_native_0).source(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) anyerror!bool {
    const native_result = (try (zx_native_0).predicate(in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) anyerror!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_26: {
        const value_3: []const i64 = (try function_1(allocator, (in).items));

        _ = (try function_0(allocator, (in).tag));

        const value_9: *const (zx_abi).zx_type_14 = block_25: {
            var state_2: *const (zx_abi).zx_type_14 = block_8: {
                const operand_3 = value_3;
                const operand_4 = @as(u64, 0);
                const operand_5 = true;

                break :block_8 block_7: {
                    const operand_6 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_6).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_4, .result = operand_5, .source = operand_3, });

                    break :block_7 @as(*const (zx_abi).zx_type_14, operand_6);
                };
            };

            while ((((state_2).index < @as(u64, ((state_2).source).len)) and (state_2).result)) {
                state_2 = block_23: {
                    const value_7: i64 = block_22: {
                        const operand_20 = (state_2).source;
                        const operand_21 = (state_2).index;

                        if ((operand_21 >= (operand_20).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_22 (operand_20)[@intCast(operand_21)];
                    };
                    const value_1: i64 = value_7;
                    _ = (state_2).index;

                    const value_8: bool = (try function_2(allocator, block_19: {
                        const operand_15 = value_1;
                        const operand_16 = @as(i64, 0);

                        break :block_19 block_18: {
                            const operand_17 = (try (allocator).create((zx_abi).zx_type_12));

                            (operand_17).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .item = operand_15, .context = operand_16, });

                            break :block_18 @as(*const (zx_abi).zx_type_12, operand_17);
                        };
                    }));

                    break :block_23 block_14: {
                        const operand_9 = (state_2).source;
                        const operand_10 = ((state_2).index + @as(u64, 1));
                        const operand_11 = value_8;

                        break :block_14 block_13: {
                            const operand_12 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_12).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_10, .result = operand_11, .source = operand_9, });

                            break :block_13 @as(*const (zx_abi).zx_type_14, operand_12);
                        };
                    };
                };
            }

            break :block_25 state_2;
        };

        break :block_26 (value_9).result;
    };
}

