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
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
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

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) anyerror!bool {
    const native_result = (try (zx_native_0).predicate(in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) anyerror![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_31: {
        const value_3: []const i64 = (try function_1(allocator, (in).items));

        _ = (try function_0(allocator, (in).tag));

        const value_9: *const (zx_abi).zx_type_14 = block_30: {
            var state_2: *const (zx_abi).zx_type_14 = block_9: {
                const operand_3 = value_3;
                const operand_4 = @as(u64, 0);

                const operand_5 = block_6: {
                    break :block_6 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_9 block_8: {
                    const operand_7 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_7).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_4, .result = operand_5, .source = operand_3, });

                    break :block_8 @as(*const (zx_abi).zx_type_14, operand_7);
                };
            };

            while (((state_2).index < @as(u64, ((state_2).source).len))) {
                state_2 = block_28: {
                    const value_7: i64 = block_27: {
                        const operand_25 = (state_2).source;
                        const operand_26 = (state_2).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };
                    const value_1: i64 = value_7;
                    _ = (state_2).index;

                    const value_8: bool = (try function_2(allocator, block_24: {
                        const operand_20 = value_1;
                        const operand_21 = @as(i64, 0);

                        break :block_24 block_23: {
                            const operand_22 = (try (allocator).create((zx_abi).zx_type_12));

                            (operand_22).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .item = operand_20, .context = operand_21, });

                            break :block_23 @as(*const (zx_abi).zx_type_12, operand_22);
                        };
                    }));

                    break :block_28 block_19: {
                        const operand_10 = (state_2).source;
                        const operand_11 = ((state_2).index + @as(u64, 1));

                        const operand_12 = (if (value_8) (block_16: {
                            const operand_13 = (state_2).result;
                            const operand_14 = value_7;
                            const operand_15 = (try (allocator).alloc(i64, (try ((std).math).add(usize, (operand_13).len, 1))));

                            @memcpy((operand_15)[0..(operand_13).len], operand_13);
                            (operand_15)[(operand_13).len] = operand_14;

                            break :block_16 @as((zx_abi).zx_type_15, .{ operand_15, {}, });
                        }).@"0" else (state_2).result);

                        break :block_19 block_18: {
                            const operand_17 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_17).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_11, .result = operand_12, .source = operand_10, });

                            break :block_18 @as(*const (zx_abi).zx_type_14, operand_17);
                        };
                    };
                };
            }

            break :block_30 state_2;
        };

        break :block_31 (value_9).result;
    };
}

