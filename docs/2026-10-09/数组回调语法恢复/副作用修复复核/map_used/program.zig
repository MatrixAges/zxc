const std = @import("std");
const zx_native_0 = @import("host");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = []const i64;
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
const zx_shape_15 = .{ .kind = .object, .fields = .{ .captures = zx_shape_14, .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_11;

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

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) anyerror!i64 {
    const native_result = (try (zx_native_0).mapValue(in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) anyerror![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: []const i64 = (try function_1(allocator, (in).items));
    const value_2: i64 = (try function_0(allocator, (in).tag));

    return block_37: {
        const value_5: []const i64 = value_1;

        const value_10: *const (zx_abi).zx_type_15 = block_36: {
            var state_2: *const (zx_abi).zx_type_15 = block_14: {
                const operand_3 = value_5;
                const operand_4 = @as(u64, 0);

                const operand_5 = block_6: {
                    break :block_6 (try (allocator).dupe(i64, (&[_]i64{})));
                };
                const operand_7 = block_11: {
                    const operand_8 = value_2;

                    break :block_11 block_10: {
                        const operand_9 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_9).* = @as((zx_abi).zx_type_14, .{ operand_8, });

                        break :block_10 @as(*const (zx_abi).zx_type_14, operand_9);
                    };
                };

                break :block_14 block_13: {
                    const operand_12 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_12).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .captures = operand_7, .index = operand_4, .result = operand_5, .source = operand_3, });

                    break :block_13 @as(*const (zx_abi).zx_type_15, operand_12);
                };
            };

            while (((state_2).index < @as(u64, ((state_2).source).len))) {
                state_2 = block_34: {
                    const value_8: i64 = block_33: {
                        const operand_31 = (state_2).source;
                        const operand_32 = (state_2).index;

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    };

                    const value_4: i64 = ((state_2).captures).@"0";
                    const value_3: i64 = value_8;

                    const value_9: i64 = (try function_2(allocator, block_30: {
                        const operand_26 = value_3;
                        const operand_27 = value_4;

                        break :block_30 block_29: {
                            const operand_28 = (try (allocator).create((zx_abi).zx_type_12));

                            (operand_28).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .item = operand_26, .context = operand_27, });

                            break :block_29 @as(*const (zx_abi).zx_type_12, operand_28);
                        };
                    }));

                    break :block_34 block_25: {
                        const operand_15 = (state_2).source;
                        const operand_16 = ((state_2).index + @as(u64, 1));

                        const operand_17 = (block_21: {
                            const operand_18 = (state_2).result;
                            const operand_19 = value_9;
                            const operand_20 = (try (allocator).alloc(i64, (try ((std).math).add(usize, (operand_18).len, 1))));

                            @memcpy((operand_20)[0..(operand_18).len], operand_18);

                            (operand_20)[(operand_18).len] = operand_19;

                            break :block_21 @as((zx_abi).zx_type_16, .{ operand_20, {}, });
                        }).@"0";

                        const operand_22 = (state_2).captures;

                        break :block_25 block_24: {
                            const operand_23 = (try (allocator).create((zx_abi).zx_type_15));

                            (operand_23).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .captures = operand_22, .index = operand_16, .result = operand_17, .source = operand_15, });

                            break :block_24 @as(*const (zx_abi).zx_type_15, operand_23);
                        };
                    };
                };
            }

            break :block_36 state_2;
        };

        break :block_37 (value_10).result;
    };
}

