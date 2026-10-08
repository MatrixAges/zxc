const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Child = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_13;
pub const Input = *const (zx_abi).zx_type_15;
pub const Output = *const (zx_abi).zx_type_13;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .child = zx_shape_11, .count = zx_shape_5, .labels = zx_shape_12, .last = zx_shape_5, .text = zx_shape_10, .total = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .seed = zx_shape_13, .steps = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_14, }, };
pub const input_shape = zx_shape_15;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: u64) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_34: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_33: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            const state_type_10 = struct {
                value: u64,
            };
            const state_type_11 = struct {
                child: state_type_10,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_12 = struct {
                index: u64,
                result: state_type_11,
                source: []const u64,
            };

            var state_1: state_type_12 = state_type_12{ .index = (operand_8).index, .result = state_type_11{ .child = state_type_10{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_25: {
                    const value_6: u64 = block_24: {
                        const operand_22 = (state_1).source;
                        const operand_23 = (state_1).index;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };

                    const value_1: state_type_11 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_11 = block_21: {
                        const operand_17 = value_1;
                        const operand_18 = ((value_1).count + @as(u64, 1));
                        const operand_19 = (((try function_0(allocator, (value_1).total)) + (value_1).count) + value_2);
                        const operand_20 = (value_1).count;

                        break :block_21 state_type_11{ .child = (operand_17).child, .count = operand_18, .labels = (operand_17).labels, .last = operand_20, .text = (operand_17).text, .total = operand_19, };
                    };

                    break :block_25 block_16: {
                        const operand_13 = (state_1).source;
                        const operand_14 = ((state_1).index + @as(u64, 1));
                        const operand_15 = value_7;

                        break :block_16 state_type_12{ .index = operand_14, .result = operand_15, .source = operand_13, };
                    };
                };

                state_changed_9 = true;
            }

            break :block_33 (if (state_changed_9) block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_31).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_27).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_28 @as(*const (zx_abi).zx_type_11, operand_27);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                }, .source = (state_1).source, });

                break :block_32 @as(*const (zx_abi).zx_type_16, operand_31);
            } else operand_8);
        };

        break :block_34 (value_8).result;
    };
}

