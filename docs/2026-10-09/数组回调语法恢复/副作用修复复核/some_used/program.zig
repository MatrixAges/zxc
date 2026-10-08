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
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_7, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .captures = zx_shape_14, .index = zx_shape_5, .result = zx_shape_1, .source = zx_shape_11, }, };
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
    const value_1: []const i64 = (try function_1(allocator, (in).items));
    const value_2: i64 = (try function_0(allocator, (in).tag));

    return block_32: {
        const value_5: []const i64 = value_1;

        const value_10: *const (zx_abi).zx_type_15 = block_31: {
            var state_2: *const (zx_abi).zx_type_15 = block_13: {
                const operand_3 = value_5;
                const operand_4 = @as(u64, 0);
                const operand_5 = false;
                const operand_6 = block_10: {
                    const operand_7 = value_2;

                    break :block_10 block_9: {
                        const operand_8 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_8).* = @as((zx_abi).zx_type_14, .{ operand_7, });

                        break :block_9 @as(*const (zx_abi).zx_type_14, operand_8);
                    };
                };

                break :block_13 block_12: {
                    const operand_11 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_11).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .captures = operand_6, .index = operand_4, .result = operand_5, .source = operand_3, });

                    break :block_12 @as(*const (zx_abi).zx_type_15, operand_11);
                };
            };

            while ((((state_2).index < @as(u64, ((state_2).source).len)) and (!(state_2).result))) {
                state_2 = block_29: {
                    const value_8: i64 = block_28: {
                        const operand_26 = (state_2).source;
                        const operand_27 = (state_2).index;

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_28 (operand_26)[@intCast(operand_27)];
                    };

                    const value_4: i64 = ((state_2).captures).@"0";
                    const value_3: i64 = value_8;

                    const value_9: bool = (try function_2(allocator, block_25: {
                        const operand_21 = value_3;
                        const operand_22 = value_4;

                        break :block_25 block_24: {
                            const operand_23 = (try (allocator).create((zx_abi).zx_type_12));

                            (operand_23).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .item = operand_21, .context = operand_22, });

                            break :block_24 @as(*const (zx_abi).zx_type_12, operand_23);
                        };
                    }));

                    break :block_29 block_20: {
                        const operand_14 = (state_2).source;
                        const operand_15 = ((state_2).index + @as(u64, 1));
                        const operand_16 = value_9;
                        const operand_17 = (state_2).captures;

                        break :block_20 block_19: {
                            const operand_18 = (try (allocator).create((zx_abi).zx_type_15));

                            (operand_18).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .captures = operand_17, .index = operand_15, .result = operand_16, .source = operand_14, });

                            break :block_19 @as(*const (zx_abi).zx_type_15, operand_18);
                        };
                    };
                };
            }

            break :block_31 state_2;
        };

        break :block_32 (value_10).result;
    };
}

