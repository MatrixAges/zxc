const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .start = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .initial = zx_shape_7, .other = zx_shape_7, .previous = zx_shape_7, .steps = zx_shape_5, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .leaf = zx_shape_14, .limit = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .left = zx_shape_14, .limit = zx_shape_5, .previous = zx_shape_7, .right = zx_shape_14, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .limit = zx_shape_5, .pair = zx_shape_16, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .box = zx_shape_19, .index = zx_shape_5, .limit = zx_shape_5, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) (in).left else (in).right);
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) ((in).left).* else ((in).right).*);
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_17 = block_56: {
        const operand_39 = block_44: {
            const operand_40 = (in).start;
            const operand_41 = (in).start;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_42).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_40, .previous = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_14, operand_42);
            };
        };
        const operand_45 = block_50: {
            const operand_46 = ((in).start + @as(i64, 100));
            const operand_47 = (in).start;

            break :block_50 block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_48).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_46, .previous = operand_47, });

                break :block_49 @as(*const (zx_abi).zx_type_14, operand_48);
            };
        };

        const operand_51 = @as(u64, 0);
        const operand_52 = (in).count;
        const operand_53 = (in).start;

        break :block_56 block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_54).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_39, .right = operand_45, .index = operand_51, .limit = operand_52, .previous = operand_53, });

            break :block_55 @as(*const (zx_abi).zx_type_17, operand_54);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_38: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_11).index, .left = (operand_11).left, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = (operand_11).right, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_34: {
                const value_4: *const (zx_abi).zx_type_14 = block_33: {
                    const operand_31 = state_10;
                    var state_borrow_32: (zx_abi).zx_type_17 = undefined;

                    state_borrow_32 = (zx_abi).zx_type_17{ .index = (operand_31).index, .left = (operand_31).left, .limit = (operand_31).limit, .previous = (operand_31).previous, .right = (operand_31).right, };

                    break :block_33 (try function_0(allocator, ((operand_31).zx_origin orelse (&state_borrow_32))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).left;

                const value_7: i64 = (block_30: {
                    break :block_30 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_29: {
                    break :block_29 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_28: {
                        break :block_28 block_27: {
                            const operand_26 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_26).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_24: {
                                break :block_24 value_6;
                            }).previous, .total = (block_25: {
                                break :block_25 value_7;
                            } + @as(i64, 1)), });

                            break :block_27 @as(*const (zx_abi).zx_type_14, operand_26);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).right;

                const value_11: i64 = (block_23: {
                    break :block_23 value_10;
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_22: {
                    break :block_22 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_21: {
                        break :block_21 block_20: {
                            const operand_19 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_19).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_17: {
                                break :block_17 value_10;
                            }).previous, .total = (block_18: {
                                break :block_18 value_11;
                            } + @as(i64, 2)), });

                            break :block_20 @as(*const (zx_abi).zx_type_14, operand_19);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_15: {
                        break :block_15 value_4;
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_13: {
                        break :block_13 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_34 value_17;
            };

            state_changed_12 = true;
        }

        break :block_38 (if (state_changed_12) block_37: {
            break :block_37 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_35).* = (zx_abi).zx_type_17{ .index = (state_10).index, .left = (state_10).left, .limit = (state_10).limit, .previous = (state_10).previous, .right = (state_10).right, };

                break :block_36 @as(*const (zx_abi).zx_type_17, operand_35);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).left).total;
        const operand_2 = ((value_18).left).total;
        const operand_3 = (value_18).previous;
        const operand_4 = (value_18).index;
        const operand_5 = ((value_18).right).total;
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

