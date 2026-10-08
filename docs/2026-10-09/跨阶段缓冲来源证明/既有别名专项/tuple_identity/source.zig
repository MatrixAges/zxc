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

    const value_1: *const (zx_abi).zx_type_18 = block_65: {
        const operand_51 = block_61: {
            const operand_57 = block_56: {
                const operand_52 = (in).start;
                const operand_53 = (in).start;

                break :block_56 block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_54).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_52, .previous = operand_53, });

                    break :block_55 @as(*const (zx_abi).zx_type_14, operand_54);
                };
            };

            const operand_58 = @as(u64, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_59).* = @as((zx_abi).zx_type_16, .{ operand_57, operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_16, operand_59);
            };
        };

        const operand_62 = (in).count;

        break :block_65 block_64: {
            const operand_63 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_63).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_51, .limit = operand_62, });

            break :block_64 @as(*const (zx_abi).zx_type_18, operand_63);
        };
    };

    const value_18: *const (zx_abi).zx_type_18 = block_50: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_14 = struct { state_type_13, u64, };

        const state_type_15 = struct {
            limit: u64,
            pair: state_type_14,
        };

        var state_10: state_type_15 = state_type_15{ .limit = (operand_11).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_11).pair).@"0").previous, .total = (((operand_11).pair).@"0").total, }, ((operand_11).pair).@"1", }), };
        var state_changed_12 = false;

        while ((((state_10).pair).@"1" < (state_10).limit)) {
            state_10 = block_42: {
                const value_4: state_type_15 = block_41: {
                    const operand_30 = state_10;
                    const operand_31 = (zx_abi).zx_type_14{ .previous = (((operand_30).pair).@"0").previous, .total = (((operand_30).pair).@"0").total, };
                    const operand_32 = @as((zx_abi).zx_type_16, .{ (&operand_31), ((operand_30).pair).@"1", });
                    const operand_33 = (zx_abi).zx_type_18{ .limit = (operand_30).limit, .pair = (&operand_32), };

                    const operand_40 = block_39: {
                        const operand_34 = (&operand_33);
                        const operand_35 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_34).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_34).pair).@"0", ((operand_34).pair).@"1", (operand_34).pair, }), .zx_origin = operand_34, }));

                        break :block_39 (if (((operand_35).zx_origin != null)) ((operand_35).zx_origin.?).* else block_38: {
                            break :block_38 (zx_abi).zx_type_18{ .limit = (operand_35).limit, .pair = (if ((((operand_35).pair).@"2" != null)) ((operand_35).pair).@"2".? else block_37: {
                                const operand_36 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_36).* = @as((zx_abi).zx_type_16, .{ ((operand_35).pair).@"0", ((operand_35).pair).@"1", });
                                break :block_37 @as(*const (zx_abi).zx_type_16, operand_36);
                            }), };
                        });
                    };

                    break :block_41 state_type_15{ .limit = (operand_40).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_40).pair).@"0").previous, .total = (((operand_40).pair).@"0").total, }, ((operand_40).pair).@"1", }), };
                };

                const value_5: state_type_15 = state_10;
                const value_6: state_type_14 = (value_5).pair;
                const value_7: state_type_13 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_15 = block_29: {
                    break :block_29 state_type_15{ .limit = (value_5).limit, .pair = block_28: {
                        const operand_26 = block_25: {
                            break :block_25 state_type_13{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_27 = (value_6).@"1";

                        break :block_28 @as(state_type_14, .{ operand_26, operand_27, });
                    }, };
                };
                const value_10: state_type_15 = value_9;
                const value_11: state_type_14 = (value_10).pair;
                const value_12: state_type_13 = (value_11).@"0";

                const value_13: state_type_15 = block_24: {
                    break :block_24 state_type_15{ .limit = (value_10).limit, .pair = block_23: {
                        const operand_21 = block_20: {
                            break :block_20 state_type_13{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_22 = (value_11).@"1";

                        break :block_23 @as(state_type_14, .{ operand_21, operand_22, });
                    }, };
                };
                const value_14: state_type_15 = value_13;
                const value_15: state_type_14 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: state_type_15 = block_19: {
                    break :block_19 state_type_15{ .limit = (value_14).limit, .pair = block_18: {
                        const operand_16 = (value_15).@"0";
                        const operand_17 = (value_16 + @as(u64, 1));

                        break :block_18 @as(state_type_14, .{ operand_16, operand_17, });
                    }, };
                };

                break :block_42 value_17;
            };

            state_changed_12 = true;
        }

        break :block_50 (if (state_changed_12) block_49: {
            const operand_48 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_48).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .limit = (state_10).limit, .pair = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_46).* = @as((zx_abi).zx_type_16, @as((zx_abi).zx_type_16, .{ block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_44).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((state_10).pair).@"0").previous, .total = (((state_10).pair).@"0").total, });

                    break :block_45 @as(*const (zx_abi).zx_type_14, operand_44);
                }, ((state_10).pair).@"1", }));

                break :block_47 @as(*const (zx_abi).zx_type_16, operand_46);
            }, });

            break :block_49 @as(*const (zx_abi).zx_type_18, operand_48);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (((value_1).pair).@"0").total;
        const operand_2 = (((value_18).pair).@"0").total;
        const operand_3 = (((value_18).pair).@"0").previous;
        const operand_4 = ((value_18).pair).@"1";
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

