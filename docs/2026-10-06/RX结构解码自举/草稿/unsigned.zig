const std = @import("std");

const zx_type_12 = struct {
    end: u64,
    source: []const u8,
    start: u64,
};

const zx_type_14 = struct {
    end: u64,
    negative: bool,
    number: u64,
    offset: u64,
    source: []const u8,
    valid: bool,
};

pub const Input = *const zx_type_12;
pub const Output = ?u64;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .source = zx_shape_11, .start = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .negative = zx_shape_1, .number = zx_shape_5, .offset = zx_shape_5, .source = zx_shape_11, .valid = zx_shape_1, }, };

pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: u8) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_1 = in;

    if ((switch_1 == @as(u8, 48))) {
        return @as(u64, 0);
    } else {
        if ((switch_1 == @as(u8, 49))) {
            return @as(u64, 1);
        } else {
            if ((switch_1 == @as(u8, 50))) {
                return @as(u64, 2);
            } else {
                if ((switch_1 == @as(u8, 51))) {
                    return @as(u64, 3);
                } else {
                    if ((switch_1 == @as(u8, 52))) {
                        return @as(u64, 4);
                    } else {
                        if ((switch_1 == @as(u8, 53))) {
                            return @as(u64, 5);
                        } else {
                            if ((switch_1 == @as(u8, 54))) {
                                return @as(u64, 6);
                            } else {
                                if ((switch_1 == @as(u8, 55))) {
                                    return @as(u64, 7);
                                } else {
                                    if ((switch_1 == @as(u8, 56))) {
                                        return @as(u64, 8);
                                    } else {
                                        return @as(u64, 9);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!?u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    if (((in).start == (in).end)) {
        return @as(?u64, null);
    }

    const value_1: bool = (block_40: {
        const operand_38 = (in).source;
        const operand_39 = (in).start;

        if ((operand_39 >= (operand_38).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_40 (operand_38)[@intCast(operand_39)];
    } == @as(u8, 45));

    const value_2: bool = (value_1 or (block_37: {
        const operand_35 = (in).source;
        const operand_36 = (in).start;

        if ((operand_36 >= (operand_35).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_37 (operand_35)[@intCast(operand_36)];
    } == @as(u8, 43)));

    const value_3: u64 = ((in).start + (if (value_2) @as(u64, 1) else @as(u64, 0)));

    if ((((value_3 == (in).end) or (block_31: {
        const operand_29 = (in).source;
        const operand_30 = value_3;

        if ((operand_30 >= (operand_29).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_31 (operand_29)[@intCast(operand_30)];
    } == @as(u8, 95))) or (block_34: {
        const operand_32 = (in).source;
        const operand_33 = ((in).end - @as(u64, 1));

        if ((operand_33 >= (operand_32).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_34 (operand_32)[@intCast(operand_33)];
    } == @as(u8, 95)))) {
        return @as(?u64, null);
    }

    const value_27: *const zx_type_14 = block_28: {
        const operand_11 = block_10: {
            const operand_2 = (in).source;
            const operand_3 = value_3;
            const operand_4 = (in).end;
            const operand_5 = value_1;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create(zx_type_14));
                (operand_8).* = @as(zx_type_14, zx_type_14{ .source = operand_2, .offset = operand_3, .end = operand_4, .negative = operand_5, .number = operand_6, .valid = operand_7, });

                break :block_9 @as(*const zx_type_14, operand_8);
            };
        };

        var state_1: zx_type_14 = (operand_11).*;
        var state_changed_12 = false;

        while ((((&state_1)).valid and (((&state_1)).offset < ((&state_1)).end))) {
            state_1 = block_25: {
                const value_6: u8 = block_24: {
                    const operand_22 = ((&state_1)).source;
                    const operand_23 = ((&state_1)).offset;

                    if ((operand_23 >= (operand_22).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_24 (operand_22)[@intCast(operand_23)];
                };
                const value_22: zx_type_14 = (if ((value_6 != @as(u8, 95))) block_21: {
                    const value_21: zx_type_14 = (if (((value_6 < @as(u8, 48)) or (value_6 > @as(u8, 57)))) block_15: {
                        const value_7: zx_type_14 = ((&state_1)).*;
                        _ = ((&value_7)).valid;
                        const value_9: bool = false;

                        const value_10: zx_type_14 = block_14: {
                            break :block_14 zx_type_14{ .end = ((&value_7)).end, .negative = ((&value_7)).negative, .number = ((&value_7)).number, .offset = ((&value_7)).offset, .source = ((&value_7)).source, .valid = value_9, };
                        };

                        break :block_15 ((&value_10)).*;
                    } else block_20: {
                        const value_11: u64 = (try function_0(allocator, value_6));

                        const value_20: zx_type_14 = (if ((((((&state_1)).negative and (value_11 != @as(u64, 0))) or (((&state_1)).number > @as(u64, 429496729))) or ((((&state_1)).number == @as(u64, 429496729)) and (value_11 > @as(u64, 5))))) block_17: {
                            const value_12: zx_type_14 = ((&state_1)).*;
                            _ = ((&value_12)).valid;
                            const value_14: bool = false;
                            const value_15: zx_type_14 = block_16: {
                                break :block_16 zx_type_14{ .end = ((&value_12)).end, .negative = ((&value_12)).negative, .number = ((&value_12)).number, .offset = ((&value_12)).offset, .source = ((&value_12)).source, .valid = value_14, };
                            };

                            break :block_17 ((&value_15)).*;
                        } else block_19: {
                            const value_16: zx_type_14 = ((&state_1)).*;
                            _ = ((&value_16)).number;

                            const value_18: u64 = ((((&state_1)).number * @as(u64, 10)) + value_11);

                            const value_19: zx_type_14 = block_18: {
                                break :block_18 zx_type_14{ .end = ((&value_16)).end, .negative = ((&value_16)).negative, .number = value_18, .offset = ((&value_16)).offset, .source = ((&value_16)).source, .valid = ((&value_16)).valid, };
                            };

                            break :block_19 ((&value_19)).*;
                        });

                        break :block_20 ((&value_20)).*;
                    });

                    break :block_21 ((&value_21)).*;
                } else ((&state_1)).*);

                const value_23: zx_type_14 = ((&value_22)).*;
                const value_24: u64 = ((&value_23)).offset;
                const value_25: u64 = @as(u64, 1);

                const value_26: zx_type_14 = block_13: {
                    break :block_13 zx_type_14{ .end = ((&value_23)).end, .negative = ((&value_23)).negative, .number = ((&value_23)).number, .offset = (value_24 + value_25), .source = ((&value_23)).source, .valid = ((&value_23)).valid, };
                };

                break :block_25 ((&value_26)).*;
            };

            state_changed_12 = true;
        }

        break :block_28 (if (state_changed_12) block_27: {
            const operand_26 = (try (allocator).create(zx_type_14));

            (operand_26).* = @as(zx_type_14, state_1);

            break :block_27 @as(*const zx_type_14, operand_26);
        } else operand_11);
    };

    return (if ((value_27).valid) @as(?u64, (value_27).number) else @as(?u64, null));
}

