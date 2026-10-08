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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ }!(zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_18 = block_60: {
        const operand_46 = block_56: {
            const operand_52 = block_51: {
                const operand_47 = (in).start;
                const operand_48 = (in).start;

                break :block_51 block_50: {
                    const operand_49 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_49).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_47, .previous = operand_48, });

                    break :block_50 @as(*const (zx_abi).zx_type_14, operand_49);
                };
            };

            const operand_53 = @as(u64, 0);

            break :block_56 block_55: {
                const operand_54 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_54).* = @as((zx_abi).zx_type_16, .{ operand_52, operand_53, });

                break :block_55 @as(*const (zx_abi).zx_type_16, operand_54);
            };
        };

        const operand_57 = (in).count;

        break :block_60 block_59: {
            const operand_58 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_58).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_46, .limit = operand_57, });

            break :block_59 @as(*const (zx_abi).zx_type_18, operand_58);
        };
    };

    return block_45: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_4 = struct { state_type_3, u64, };

        const state_type_5 = struct {
            limit: u64,
            pair: state_type_4,
        };
        const operand_7 = block_6: {
            const operand_2 = value_1;

            break :block_6 state_type_5{ .limit = (operand_2).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_2).pair).@"0").previous, .total = (((operand_2).pair).@"0").total, }, ((operand_2).pair).@"1", }), };
        };

        var state_1: state_type_5 = operand_7;
        var state_changed_8 = false;

        while ((((state_1).pair).@"1" < (state_1).limit)) {
            state_1 = block_35: {
                const value_4: state_type_5 = block_34: {
                    const operand_23 = state_1;
                    const operand_24 = (zx_abi).zx_type_14{ .previous = (((operand_23).pair).@"0").previous, .total = (((operand_23).pair).@"0").total, };
                    const operand_25 = @as((zx_abi).zx_type_16, .{ (&operand_24), ((operand_23).pair).@"1", });
                    const operand_26 = (zx_abi).zx_type_18{ .limit = (operand_23).limit, .pair = (&operand_25), };

                    const operand_33 = block_32: {
                        const operand_27 = (&operand_26);
                        const operand_28 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_27).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_27).pair).@"0", ((operand_27).pair).@"1", (operand_27).pair, }), .zx_origin = operand_27, }));

                        break :block_32 (if (((operand_28).zx_origin != null)) ((operand_28).zx_origin.?).* else block_31: {
                            break :block_31 (zx_abi).zx_type_18{ .limit = (operand_28).limit, .pair = (if ((((operand_28).pair).@"2" != null)) ((operand_28).pair).@"2".? else block_30: {
                                const operand_29 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_29).* = @as((zx_abi).zx_type_16, .{ ((operand_28).pair).@"0", ((operand_28).pair).@"1", });
                                break :block_30 @as(*const (zx_abi).zx_type_16, operand_29);
                            }), };
                        });
                    };

                    break :block_34 state_type_5{ .limit = (operand_33).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_33).pair).@"0").previous, .total = (((operand_33).pair).@"0").total, }, ((operand_33).pair).@"1", }), };
                };

                const value_5: state_type_5 = state_1;
                const value_6: state_type_4 = (value_5).pair;
                const value_7: state_type_3 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_5 = block_22: {
                    break :block_22 state_type_5{ .limit = (value_5).limit, .pair = block_21: {
                        const operand_19 = block_18: {
                            break :block_18 state_type_3{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_20 = (value_6).@"1";

                        break :block_21 @as(state_type_4, .{ operand_19, operand_20, });
                    }, };
                };
                const value_10: state_type_5 = value_9;
                const value_11: state_type_4 = (value_10).pair;
                const value_12: state_type_3 = (value_11).@"0";

                const value_13: state_type_5 = block_17: {
                    break :block_17 state_type_5{ .limit = (value_10).limit, .pair = block_16: {
                        const operand_14 = block_13: {
                            break :block_13 state_type_3{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_15 = (value_11).@"1";

                        break :block_16 @as(state_type_4, .{ operand_14, operand_15, });
                    }, };
                };
                const value_14: state_type_5 = value_13;
                const value_15: state_type_4 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";
                const value_17: state_type_5 = block_12: {
                    break :block_12 state_type_5{ .limit = (value_14).limit, .pair = block_11: {
                        const operand_9 = (value_15).@"0";
                        const operand_10 = (value_16 + @as(u64, 1));

                        break :block_11 @as(state_type_4, .{ operand_9, operand_10, });
                    }, };
                };

                break :block_35 value_17;
            };

            state_changed_8 = true;
        }

        break :block_45 block_44: {
            const operand_36 = (((value_1).pair).@"0").total;
            const operand_37 = (((state_1).pair).@"0").total;
            const operand_38 = (((state_1).pair).@"0").previous;
            const operand_39 = ((state_1).pair).@"1";
            const operand_40 = @as(i64, 0);
            const operand_41 = (in).values;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_42).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_36, .total = operand_37, .previous = operand_38, .steps = operand_39, .other = operand_40, .values = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_13, operand_42);
            };
        };
    };
}

