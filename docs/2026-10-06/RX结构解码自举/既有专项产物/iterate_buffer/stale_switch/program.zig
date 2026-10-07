const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    index: u64,
    seen: i64,
    values: []const i64,
};

const zx_type_14 = struct {
    original: []const i64,
    seen: i64,
    values: []const i64,
};

pub const Input = *const zx_type_12;
pub const State = *const zx_type_13;
pub const Output = *const zx_type_14;
pub const consumes_input = false;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enabled = zx_shape_1, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .seen = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_57: {
        const operand_51 = (in).values;
        const operand_52 = (in).count;
        const operand_53 = @as(u64, 0);
        const operand_54 = @as(i64, 0);

        break :block_57 block_56: {
            const operand_55 = (try (allocator).create(zx_type_13));

            (operand_55).* = @as(zx_type_13, zx_type_13{ .values = operand_51, .count = operand_52, .index = operand_53, .seen = operand_54, });

            break :block_56 @as(*const zx_type_13, operand_55);
        };
    };

    const value_32: *const zx_type_13 = block_50: {
        const operand_8 = value_1;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < ((&state_7)).count)) {
            state_7 = block_47: {
                const value_4: []const i64 = ((&state_7)).values;
                const value_23: zx_type_13 = block_46: {
                    const operand_15 = @rem(((&state_7)).index, @as(u64, 3));

                    break :block_46 (if ((operand_15 == @as(u64, 0))) block_45: {
                        const value_5: zx_type_13 = ((&state_7)).*;
                        const value_6: []const i64 = ((&value_5)).values;
                        const value_7: u64 = @as(u64, 0);
                        const value_8: i64 = block_44: {
                            const operand_42 = value_6;
                            const operand_43 = value_7;

                            if ((operand_43 >= (operand_42).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_44 (operand_42)[@intCast(operand_43)];
                        };
                        const value_9: i64 = @as(i64, 1);

                        const value_10: zx_type_13 = block_41: {
                            break :block_41 zx_type_13{ .count = ((&value_5)).count, .index = ((&value_5)).index, .seen = ((&value_5)).seen, .values = block_40: {
                                const operand_36 = value_6;
                                const operand_37 = value_7;
                                const operand_38 = (value_8 + value_9);

                                if ((operand_37 >= (operand_36).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_39 = (try (allocator).dupe(i64, operand_36));

                                (operand_39)[@intCast(operand_37)] = operand_38;
                                break :block_40 operand_39;
                            }, };
                        };

                        break :block_45 ((&value_10)).*;
                    } else (if ((operand_15 == @as(u64, 1))) block_35: {
                        const value_11: zx_type_13 = ((&state_7)).*;
                        const value_12: []const i64 = ((&value_11)).values;
                        const value_13: u64 = @as(u64, 0);
                        const value_14: i64 = block_34: {
                            const operand_32 = value_12;
                            const operand_33 = value_13;

                            if ((operand_33 >= (operand_32).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_34 (operand_32)[@intCast(operand_33)];
                        };
                        const value_15: i64 = @as(i64, 2);
                        const value_16: zx_type_13 = block_31: {
                            break :block_31 zx_type_13{ .count = ((&value_11)).count, .index = ((&value_11)).index, .seen = ((&value_11)).seen, .values = block_30: {
                                const operand_26 = value_12;
                                const operand_27 = value_13;
                                const operand_28 = (value_14 + value_15);

                                if ((operand_27 >= (operand_26).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_29 = (try (allocator).dupe(i64, operand_26));

                                (operand_29)[@intCast(operand_27)] = operand_28;

                                break :block_30 operand_29;
                            }, };
                        };

                        break :block_35 ((&value_16)).*;
                    } else block_25: {
                        const value_17: zx_type_13 = ((&state_7)).*;
                        const value_18: []const i64 = ((&value_17)).values;
                        const value_19: u64 = @as(u64, 0);
                        const value_20: i64 = block_24: {
                            const operand_22 = value_18;
                            const operand_23 = value_19;

                            if ((operand_23 >= (operand_22).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_24 (operand_22)[@intCast(operand_23)];
                        };
                        const value_21: i64 = @as(i64, 3);

                        const value_22: zx_type_13 = block_21: {
                            break :block_21 zx_type_13{ .count = ((&value_17)).count, .index = ((&value_17)).index, .seen = ((&value_17)).seen, .values = block_20: {
                                const operand_16 = value_18;
                                const operand_17 = value_19;
                                const operand_18 = (value_20 + value_21);

                                if ((operand_17 >= (operand_16).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_19 = (try (allocator).dupe(i64, operand_16));

                                (operand_19)[@intCast(operand_17)] = operand_18;

                                break :block_20 operand_19;
                            }, };
                        };

                        break :block_25 ((&value_22)).*;
                    }));
                };

                const value_24: zx_type_13 = ((&value_23)).*;
                const value_25: i64 = ((&value_24)).seen;

                const value_26: i64 = block_14: {
                    const operand_12 = value_4;
                    const operand_13 = @as(u64, 0);

                    if ((operand_13 >= (operand_12).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_14 (operand_12)[@intCast(operand_13)];
                };
                const value_27: zx_type_13 = block_11: {
                    break :block_11 zx_type_13{ .count = ((&value_24)).count, .index = ((&value_24)).index, .seen = (value_25 + value_26), .values = ((&value_24)).values, };
                };

                const value_28: zx_type_13 = ((&value_27)).*;
                const value_29: u64 = ((&value_28)).index;
                const value_30: u64 = @as(u64, 1);

                const value_31: zx_type_13 = block_10: {
                    break :block_10 zx_type_13{ .count = ((&value_28)).count, .index = (value_29 + value_30), .seen = ((&value_28)).seen, .values = ((&value_28)).values, };
                };

                break :block_47 ((&value_31)).*;
            };

            state_changed_9 = true;
        }

        break :block_50 (if (state_changed_9) block_49: {
            const operand_48 = (try (allocator).create(zx_type_13));

            (operand_48).* = @as(zx_type_13, state_7);

            break :block_49 @as(*const zx_type_13, operand_48);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = (value_32).values;
        const operand_3 = (value_32).seen;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}

