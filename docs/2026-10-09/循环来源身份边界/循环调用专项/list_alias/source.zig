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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20) error{ }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).box;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be) error{ }!(zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).box;
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ }!(zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return (in).box;
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return (in).box;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_20 = block_58: {
        const operand_47 = block_53: {
            const operand_48 = (in).values;
            const operand_49 = (in).start;
            const operand_50 = (in).start;

            break :block_53 block_52: {
                const operand_51 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_51).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .values = operand_48, .total = operand_49, .previous = operand_50, });

                break :block_52 @as(*const (zx_abi).zx_type_19, operand_51);
            };
        };

        const operand_54 = @as(u64, 0);
        const operand_55 = (in).count;

        break :block_58 block_57: {
            const operand_56 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_56).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = operand_47, .index = operand_54, .limit = operand_55, });

            break :block_57 @as(*const (zx_abi).zx_type_20, operand_56);
        };
    };

    const value_21: *const (zx_abi).zx_type_20 = block_46: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = ((operand_11).box).previous, .total = ((operand_11).box).total, .values = ((operand_11).box).values, .zx_origin = (operand_11).box, }, .index = (operand_11).index, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_40: {
                const value_4: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_39: {
                    break :block_39 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = state_10;
                const value_6: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);

                const value_9: i64 = block_38: {
                    const operand_36 = block_34: {
                        break :block_34 value_7;
                    };
                    const operand_37 = block_35: {
                        break :block_35 value_8;
                    };

                    if ((operand_37 >= (operand_36).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_38 (operand_36)[@intCast(operand_37)];
                };
                const value_10: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_33: {
                    break :block_33 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_32: {
                        break :block_32 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_6).previous, .total = (value_6).total, .values = block_31: {
                            const operand_24 = block_23: {
                                break :block_23 value_7;
                            };
                            const operand_26 = block_25: {
                                break :block_25 value_8;
                            };

                            if ((operand_26 >= (operand_24).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_28 = (block_27: {
                                break :block_27 value_9;
                            } + @as(i64, 1));

                            break :block_31 block_30: {
                                const operand_29 = (try (allocator).dupe(i64, operand_24));

                                (operand_29)[@intCast(operand_26)] = operand_28;

                                break :block_30 operand_29;
                            };
                        }, });
                    }, .index = (value_5).index, .limit = (value_5).limit, });
                };
                const value_11: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_10;
                const value_12: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_22: {
                    break :block_22 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_21: {
                        break :block_21 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_12).previous, .total = (block_17: {
                            break :block_17 value_13;
                        } + block_20: {
                            const operand_18 = (value_4).values;
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        }), .values = (value_12).values, });
                    }, .index = (value_11).index, .limit = (value_11).limit, });
                };

                const value_15: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_14;
                const value_16: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_15).box;

                const value_17: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_15: {
                        break :block_15 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, });
                    }, .index = (value_15).index, .limit = (value_15).limit, });
                };

                const value_18: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (value_18).box, .index = (block_13: {
                        break :block_13 value_19;
                    } + @as(u64, 1)), .limit = (value_18).limit, });
                };

                break :block_40 value_20;
            };

            state_changed_12 = true;
        }

        break :block_46 (if (state_changed_12) block_45: {
            break :block_45 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_43).* = (zx_abi).zx_type_20{ .box = (if ((((state_10).box).zx_origin != null)) ((state_10).box).zx_origin.? else block_42: {
                    const operand_41 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_41).* = (zx_abi).zx_type_19{ .previous = ((state_10).box).previous, .total = ((state_10).box).total, .values = ((state_10).box).values, };

                    break :block_42 @as(*const (zx_abi).zx_type_19, operand_41);
                }), .index = (state_10).index, .limit = (state_10).limit, };

                break :block_44 @as(*const (zx_abi).zx_type_20, operand_43);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).box).total;
        const operand_2 = ((value_21).box).total;
        const operand_3 = ((value_21).box).previous;
        const operand_4 = (value_21).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = ((value_21).box).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

