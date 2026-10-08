const std = @import("std");
const zx_native_0 = @import("native_scalar");
const zx_abi = @import("zxc_abi");
pub const State = *const (zx_abi).zx_type_12;
pub const Input = *const (zx_abi).zx_type_13;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .last = zx_shape_5, .steps = zx_shape_11, .total = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .first = zx_shape_12, .second = zx_shape_12, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: u64) error{ NativeFailure, }!u64 {
    const native_result = (try (zx_native_0).first(in));

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ NativeFailure, }!u64 {
    const native_result = (try (zx_native_0).second(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: u64) error{ NativeFailure, OutOfMemory, }!u64 {
    const native_result = (try (zx_native_0).allocated(allocator, in));

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_14: {
        const operand_2 = in;
        var state_1: (zx_abi).zx_type_12 = (operand_2).*;
        var state_changed_3 = false;

        while ((((&state_1)).index < @as(u64, (((&state_1)).steps).len))) {
            state_1 = block_10: {
                const value_3: u64 = (try function_0(allocator, block_9: {
                    const operand_7 = ((&state_1)).steps;
                    const operand_8 = ((&state_1)).index;

                    if ((operand_8 >= (operand_7).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_9 (operand_7)[@intCast(operand_8)];
                }));

                const value_4: u64 = (try function_1(allocator, value_3));
                const value_5: u64 = (try function_2(allocator, value_4));
                const value_6: (zx_abi).zx_type_12 = ((&state_1)).*;
                const value_7: u64 = ((&value_6)).total;

                const value_8: (zx_abi).zx_type_12 = block_6: {
                    break :block_6 (zx_abi).zx_type_12{ .index = ((&value_6)).index, .last = ((&value_6)).last, .steps = ((&value_6)).steps, .total = (value_7 + value_5), };
                };

                const value_9: (zx_abi).zx_type_12 = ((&value_8)).*;

                const value_10: (zx_abi).zx_type_12 = block_5: {
                    break :block_5 (zx_abi).zx_type_12{ .index = ((&value_9)).index, .last = value_5, .steps = ((&value_9)).steps, .total = ((&value_9)).total, };
                };

                const value_11: (zx_abi).zx_type_12 = ((&value_10)).*;
                const value_12: u64 = ((&value_11)).index;

                const value_13: (zx_abi).zx_type_12 = block_4: {
                    break :block_4 (zx_abi).zx_type_12{ .index = (value_12 + @as(u64, 1)), .last = ((&value_11)).last, .steps = ((&value_11)).steps, .total = ((&value_11)).total, };
                };

                break :block_10 ((&value_13)).*;
            };

            state_changed_3 = true;
        }

        break :block_14 (if (state_changed_3) block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_12).* = @as((zx_abi).zx_type_12, state_1);

            break :block_13 @as(*const (zx_abi).zx_type_12, operand_12);
        } else operand_2);
    };
}

fn function_3_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!(zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_25: {
        const operand_16 = (in).*;
        var state_15: (zx_abi).zx_type_12 = operand_16;

        while ((((&state_15)).index < @as(u64, (((&state_15)).steps).len))) {
            state_15 = block_23: {
                const value_3: u64 = (try function_0(allocator, block_22: {
                    const operand_20 = ((&state_15)).steps;
                    const operand_21 = ((&state_15)).index;

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                }));

                const value_4: u64 = (try function_1(allocator, value_3));
                const value_5: u64 = (try function_2(allocator, value_4));
                const value_6: (zx_abi).zx_type_12 = ((&state_15)).*;
                const value_7: u64 = ((&value_6)).total;

                const value_8: (zx_abi).zx_type_12 = block_19: {
                    break :block_19 (zx_abi).zx_type_12{ .index = ((&value_6)).index, .last = ((&value_6)).last, .steps = ((&value_6)).steps, .total = (value_7 + value_5), };
                };

                const value_9: (zx_abi).zx_type_12 = ((&value_8)).*;

                const value_10: (zx_abi).zx_type_12 = block_18: {
                    break :block_18 (zx_abi).zx_type_12{ .index = ((&value_9)).index, .last = value_5, .steps = ((&value_9)).steps, .total = ((&value_9)).total, };
                };

                const value_11: (zx_abi).zx_type_12 = ((&value_10)).*;
                const value_12: u64 = ((&value_11)).index;

                const value_13: (zx_abi).zx_type_12 = block_17: {
                    break :block_17 (zx_abi).zx_type_12{ .index = (value_12 + @as(u64, 1)), .last = ((&value_11)).last, .steps = ((&value_11)).steps, .total = ((&value_11)).total, };
                };

                break :block_23 ((&value_13)).*;
            };
        }

        break :block_25 block_24: {
            break :block_24 state_15;
        };
    };
}

fn function_3_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!(zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_36: {
        const operand_27 = (in).*;
        var state_26: (zx_abi).zx_type_12 = operand_27;

        while ((((&state_26)).index < @as(u64, (((&state_26)).steps).len))) {
            state_26 = block_34: {
                const value_3: u64 = (try function_0(allocator, block_33: {
                    const operand_31 = ((&state_26)).steps;
                    const operand_32 = ((&state_26)).index;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                }));

                const value_4: u64 = (try function_1(allocator, value_3));
                const value_5: u64 = (try function_2(allocator, value_4));
                const value_6: (zx_abi).zx_type_12 = ((&state_26)).*;
                const value_7: u64 = ((&value_6)).total;

                const value_8: (zx_abi).zx_type_12 = block_30: {
                    break :block_30 (zx_abi).zx_type_12{ .index = ((&value_6)).index, .last = ((&value_6)).last, .steps = ((&value_6)).steps, .total = (value_7 + value_5), };
                };

                const value_9: (zx_abi).zx_type_12 = ((&value_8)).*;

                const value_10: (zx_abi).zx_type_12 = block_29: {
                    break :block_29 (zx_abi).zx_type_12{ .index = ((&value_9)).index, .last = value_5, .steps = ((&value_9)).steps, .total = ((&value_9)).total, };
                };

                const value_11: (zx_abi).zx_type_12 = ((&value_10)).*;
                const value_12: u64 = ((&value_11)).index;

                const value_13: (zx_abi).zx_type_12 = block_28: {
                    break :block_28 (zx_abi).zx_type_12{ .index = (value_12 + @as(u64, 1)), .last = ((&value_11)).last, .steps = ((&value_11)).steps, .total = ((&value_11)).total, };
                };

                break :block_34 ((&value_13)).*;
            };
        }

        break :block_36 block_35: {
            break :block_35 state_26;
        };
    };
}

fn function_3_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_50: {
        const operand_38 = in;
        var state_37: (zx_abi).zx_type_12 = (operand_38).*;
        var state_changed_39 = false;

        while ((((&state_37)).index < @as(u64, (((&state_37)).steps).len))) {
            state_37 = block_46: {
                const value_3: u64 = (try function_0(allocator, block_45: {
                    const operand_43 = ((&state_37)).steps;
                    const operand_44 = ((&state_37)).index;

                    if ((operand_44 >= (operand_43).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_45 (operand_43)[@intCast(operand_44)];
                }));

                const value_4: u64 = (try function_1(allocator, value_3));
                const value_5: u64 = (try function_2(allocator, value_4));
                const value_6: (zx_abi).zx_type_12 = ((&state_37)).*;
                const value_7: u64 = ((&value_6)).total;

                const value_8: (zx_abi).zx_type_12 = block_42: {
                    break :block_42 (zx_abi).zx_type_12{ .index = ((&value_6)).index, .last = ((&value_6)).last, .steps = ((&value_6)).steps, .total = (value_7 + value_5), };
                };

                const value_9: (zx_abi).zx_type_12 = ((&value_8)).*;

                const value_10: (zx_abi).zx_type_12 = block_41: {
                    break :block_41 (zx_abi).zx_type_12{ .index = ((&value_9)).index, .last = value_5, .steps = ((&value_9)).steps, .total = ((&value_9)).total, };
                };

                const value_11: (zx_abi).zx_type_12 = ((&value_10)).*;
                const value_12: u64 = ((&value_11)).index;

                const value_13: (zx_abi).zx_type_12 = block_40: {
                    break :block_40 (zx_abi).zx_type_12{ .index = (value_12 + @as(u64, 1)), .last = ((&value_11)).last, .steps = ((&value_11)).steps, .total = ((&value_11)).total, };
                };

                break :block_46 ((&value_13)).*;
            };

            state_changed_39 = true;
        }

        break :block_50 (if (state_changed_39) block_49: {
            const operand_48 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_48).* = @as((zx_abi).zx_type_12, state_37);

            break :block_49 @as(*const (zx_abi).zx_type_12, operand_48);
        } else operand_38);
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_12 = (try function_3(allocator, (in).first));
    const value_2: *const (zx_abi).zx_type_12 = (try function_3(allocator, (in).second));

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_2;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_3).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .first = operand_1, .second = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_13, operand_3);
        };
    };
}

