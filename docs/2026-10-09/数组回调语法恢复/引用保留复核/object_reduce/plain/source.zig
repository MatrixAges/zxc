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

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_35: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_34: {
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

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_26: {
                    const value_6: u64 = block_25: {
                        const operand_23 = (state_1).source;
                        const operand_24 = (state_1).index;

                        if ((operand_24 >= (operand_23).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_25 (operand_23)[@intCast(operand_24)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_22: {
                        break :block_22 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_21: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = (((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        });

                        const operand_17 = (value_1).count;
                        const operand_18 = (value_1).labels;
                        const operand_19 = (value_1).text;
                        const operand_20 = (value_1).child;

                        break :block_21 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_17, .labels = operand_18, .text = operand_19, .child = operand_20, });
                    };

                    break :block_26 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_34 (if (state_changed_9) block_33: {
                break :block_33 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_31).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_30: {
                        const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_29).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_28: {
                            const operand_27 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_27).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_28 @as(*const (zx_abi).zx_type_11, operand_27);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                    }), .source = (state_1).source, };

                    break :block_32 @as(*const (zx_abi).zx_type_16, operand_31);
                });
            } else operand_8);
        };

        break :block_35 (value_8).result;
    };
}

