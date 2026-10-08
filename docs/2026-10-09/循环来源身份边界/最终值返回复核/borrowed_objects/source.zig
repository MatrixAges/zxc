const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const *const (zx_abi).zx_type_15;
pub const Output = []const *const (zx_abi).zx_type_16;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .label = zx_shape_10, .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .saved = zx_shape_13, .total = zx_shape_5, .values = zx_shape_12, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .ordinal = zx_shape_5, .saved = zx_shape_13, .seed = zx_shape_5, .values = zx_shape_12, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .empty = zx_shape_14, .first = zx_shape_14, .second = zx_shape_14, }, };
const zx_shape_17 = .{ .kind = .list, .child = zx_shape_15, };
const zx_shape_18 = .{ .kind = .list, .child = zx_shape_16, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_18, .source = zx_shape_17, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_18, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_17;
pub const output_shape = zx_shape_18;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_14: {
        const operand_2 = in;
        var state_1: (zx_abi).zx_type_14 = (operand_2).*;
        var state_changed_3 = false;

        while ((((&state_1)).index < @as(u64, (((&state_1)).values).len))) {
            state_1 = block_10: {
                const value_3: *const (zx_abi).zx_type_11 = block_9: {
                    const operand_7 = ((&state_1)).values;
                    const operand_8 = ((&state_1)).index;

                    if ((operand_8 >= (operand_7).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_9 (operand_7)[@intCast(operand_8)];
                };

                const value_4: (zx_abi).zx_type_14 = ((&state_1)).*;
                const value_5: u64 = ((&value_4)).total;

                const value_6: (zx_abi).zx_type_14 = block_6: {
                    break :block_6 (zx_abi).zx_type_14{ .index = ((&value_4)).index, .saved = ((&value_4)).saved, .total = (value_5 + (value_3).value), .values = ((&value_4)).values, };
                };

                const value_7: (zx_abi).zx_type_14 = ((&value_6)).*;

                const value_8: (zx_abi).zx_type_14 = block_5: {
                    break :block_5 (zx_abi).zx_type_14{ .index = ((&value_7)).index, .saved = @as(?*const (zx_abi).zx_type_11, value_3), .total = ((&value_7)).total, .values = ((&value_7)).values, };
                };

                const value_9: (zx_abi).zx_type_14 = ((&value_8)).*;
                const value_10: u64 = ((&value_9)).index;

                const value_11: (zx_abi).zx_type_14 = block_4: {
                    break :block_4 (zx_abi).zx_type_14{ .index = (value_10 + @as(u64, 1)), .saved = ((&value_9)).saved, .total = ((&value_9)).total, .values = ((&value_9)).values, };
                };

                break :block_10 ((&value_11)).*;
            };

            state_changed_3 = true;
        }

        break :block_14 (if (state_changed_3) block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_12).* = @as((zx_abi).zx_type_14, state_1);

            break :block_13 @as(*const (zx_abi).zx_type_14, operand_12);
        } else operand_2);
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_25: {
        const operand_16 = (in).*;
        var state_15: (zx_abi).zx_type_14 = operand_16;

        while ((((&state_15)).index < @as(u64, (((&state_15)).values).len))) {
            state_15 = block_23: {
                const value_3: *const (zx_abi).zx_type_11 = block_22: {
                    const operand_20 = ((&state_15)).values;
                    const operand_21 = ((&state_15)).index;

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };

                const value_4: (zx_abi).zx_type_14 = ((&state_15)).*;
                const value_5: u64 = ((&value_4)).total;

                const value_6: (zx_abi).zx_type_14 = block_19: {
                    break :block_19 (zx_abi).zx_type_14{ .index = ((&value_4)).index, .saved = ((&value_4)).saved, .total = (value_5 + (value_3).value), .values = ((&value_4)).values, };
                };

                const value_7: (zx_abi).zx_type_14 = ((&value_6)).*;

                const value_8: (zx_abi).zx_type_14 = block_18: {
                    break :block_18 (zx_abi).zx_type_14{ .index = ((&value_7)).index, .saved = @as(?*const (zx_abi).zx_type_11, value_3), .total = ((&value_7)).total, .values = ((&value_7)).values, };
                };

                const value_9: (zx_abi).zx_type_14 = ((&value_8)).*;
                const value_10: u64 = ((&value_9)).index;

                const value_11: (zx_abi).zx_type_14 = block_17: {
                    break :block_17 (zx_abi).zx_type_14{ .index = (value_10 + @as(u64, 1)), .saved = ((&value_9)).saved, .total = ((&value_9)).total, .values = ((&value_9)).values, };
                };

                break :block_23 ((&value_11)).*;
            };
        }

        break :block_25 block_24: {
            break :block_24 state_15;
        };
    };
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_11),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_36: {
        const operand_27 = (in).*;
        var state_26: (zx_abi).zx_type_14 = operand_27;

        while ((((&state_26)).index < @as(u64, (((&state_26)).values).len))) {
            state_26 = block_34: {
                const value_3: *const (zx_abi).zx_type_11 = block_33: {
                    const operand_31 = ((&state_26)).values;
                    const operand_32 = ((&state_26)).index;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                };

                const value_4: (zx_abi).zx_type_14 = ((&state_26)).*;
                const value_5: u64 = ((&value_4)).total;

                const value_6: (zx_abi).zx_type_14 = block_30: {
                    break :block_30 (zx_abi).zx_type_14{ .index = ((&value_4)).index, .saved = ((&value_4)).saved, .total = (value_5 + (value_3).value), .values = ((&value_4)).values, };
                };

                const value_7: (zx_abi).zx_type_14 = ((&value_6)).*;

                const value_8: (zx_abi).zx_type_14 = block_29: {
                    break :block_29 (zx_abi).zx_type_14{ .index = ((&value_7)).index, .saved = @as(?*const (zx_abi).zx_type_11, value_3), .total = ((&value_7)).total, .values = ((&value_7)).values, };
                };

                const value_9: (zx_abi).zx_type_14 = ((&value_8)).*;
                const value_10: u64 = ((&value_9)).index;

                const value_11: (zx_abi).zx_type_14 = block_28: {
                    break :block_28 (zx_abi).zx_type_14{ .index = (value_10 + @as(u64, 1)), .saved = ((&value_9)).saved, .total = ((&value_9)).total, .values = ((&value_9)).values, };
                };

                break :block_34 ((&value_11)).*;
            };
        }

        break :block_36 block_35: {
            break :block_35 state_26;
        };
    };
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_11),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_50: {
        const operand_38 = in;
        var state_37: (zx_abi).zx_type_14 = (operand_38).*;
        var state_changed_39 = false;

        while ((((&state_37)).index < @as(u64, (((&state_37)).values).len))) {
            state_37 = block_46: {
                const value_3: *const (zx_abi).zx_type_11 = block_45: {
                    const operand_43 = ((&state_37)).values;
                    const operand_44 = ((&state_37)).index;

                    if ((operand_44 >= (operand_43).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_45 (operand_43)[@intCast(operand_44)];
                };

                const value_4: (zx_abi).zx_type_14 = ((&state_37)).*;
                const value_5: u64 = ((&value_4)).total;

                const value_6: (zx_abi).zx_type_14 = block_42: {
                    break :block_42 (zx_abi).zx_type_14{ .index = ((&value_4)).index, .saved = ((&value_4)).saved, .total = (value_5 + (value_3).value), .values = ((&value_4)).values, };
                };

                const value_7: (zx_abi).zx_type_14 = ((&value_6)).*;

                const value_8: (zx_abi).zx_type_14 = block_41: {
                    break :block_41 (zx_abi).zx_type_14{ .index = ((&value_7)).index, .saved = @as(?*const (zx_abi).zx_type_11, value_3), .total = ((&value_7)).total, .values = ((&value_7)).values, };
                };

                const value_9: (zx_abi).zx_type_14 = ((&value_8)).*;
                const value_10: u64 = ((&value_9)).index;

                const value_11: (zx_abi).zx_type_14 = block_40: {
                    break :block_40 (zx_abi).zx_type_14{ .index = (value_10 + @as(u64, 1)), .saved = ((&value_9)).saved, .total = ((&value_9)).total, .values = ((&value_9)).values, };
                };

                break :block_46 ((&value_11)).*;
            };

            state_changed_39 = true;
        }

        break :block_50 (if (state_changed_39) block_49: {
            const operand_48 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_48).* = @as((zx_abi).zx_type_14, state_37);

            break :block_49 @as(*const (zx_abi).zx_type_14, operand_48);
        } else operand_38);
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_27: {
        const operand_21 = @as(u64, ((in).values).len);
        const operand_22 = (in).seed;
        const operand_23 = (in).values;
        const operand_24 = @as(?*const (zx_abi).zx_type_11, null);

        break :block_27 block_26: {
            const operand_25 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_25).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_21, .total = operand_22, .values = operand_23, .saved = operand_24, });

            break :block_26 @as(*const (zx_abi).zx_type_14, operand_25);
        };
    }));

    const value_2: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_20: {
        const operand_14 = @as(u64, 0);
        const operand_15 = ((in).seed + ((in).ordinal * @as(u64, 2)));
        const operand_16 = (in).values;
        const operand_17 = (in).saved;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_18).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_14, .total = operand_15, .values = operand_16, .saved = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_14, operand_18);
        };
    }));

    const value_3: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_13: {
        const operand_7 = @as(u64, 0);
        const operand_8 = (((in).seed + ((in).ordinal * @as(u64, 2))) + @as(u64, 1));
        const operand_9 = (in).values;
        const operand_10 = (in).saved;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_11).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_7, .total = operand_8, .values = operand_9, .saved = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_14, operand_11);
        };
    }));

    return block_6: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_3;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_4).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .empty = operand_1, .first = operand_2, .second = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_16, operand_4);
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_52: {
        const operand_46 = @as(u64, ((in).values).len);
        const operand_47 = (in).seed;
        const operand_48 = (in).values;
        const operand_49 = @as(?*const (zx_abi).zx_type_11, null);

        break :block_52 block_51: {
            const operand_50 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_50).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_46, .total = operand_47, .values = operand_48, .saved = operand_49, });

            break :block_51 @as(*const (zx_abi).zx_type_14, operand_50);
        };
    }));

    const value_2: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_45: {
        const operand_39 = @as(u64, 0);
        const operand_40 = ((in).seed + ((in).ordinal * @as(u64, 2)));
        const operand_41 = (in).values;
        const operand_42 = (in).saved;

        break :block_45 block_44: {
            const operand_43 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_43).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_39, .total = operand_40, .values = operand_41, .saved = operand_42, });

            break :block_44 @as(*const (zx_abi).zx_type_14, operand_43);
        };
    }));

    const value_3: *const (zx_abi).zx_type_14 = (try function_0(allocator, block_38: {
        const operand_32 = @as(u64, 0);
        const operand_33 = (((in).seed + ((in).ordinal * @as(u64, 2))) + @as(u64, 1));
        const operand_34 = (in).values;
        const operand_35 = (in).saved;

        break :block_38 block_37: {
            const operand_36 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_36).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = operand_32, .total = operand_33, .values = operand_34, .saved = operand_35, });

            break :block_37 @as(*const (zx_abi).zx_type_14, operand_36);
        };
    }));

    return block_31: {
        const operand_28 = value_1;
        const operand_29 = value_2;
        const operand_30 = value_3;

        break :block_31 (zx_abi).zx_type_16{ .empty = operand_28, .first = operand_29, .second = operand_30, };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_31: {
        const value_2: []const *const (zx_abi).zx_type_15 = in;

        break :block_31 block_30: {
            const operand_7 = block_6: {
                const operand_2 = value_2;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(*const (zx_abi).zx_type_16, (&[_]*const (zx_abi).zx_type_16{})));
                };

                break :block_6 (zx_abi).zx_type_19{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_8: (std).ArrayList(*const (zx_abi).zx_type_16) = .empty;
            var state_capacity_started_9 = false;

            defer (state_capacity_8).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_28: {
                    const value_5: *const (zx_abi).zx_type_15 = block_27: {
                        const operand_25 = (state_1).source;
                        const operand_26 = (state_1).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };
                    const value_1: *const (zx_abi).zx_type_15 = block_24: {
                        break :block_24 value_5;
                    };
                    const value_6: *const (zx_abi).zx_type_16 = block_23: {
                        const operand_19 = block_18: {
                            break :block_18 value_1;
                        };

                        const operand_20 = (try function_1_value(allocator, operand_19));

                        break :block_23 block_22: {
                            const operand_21 = (try (allocator).create((zx_abi).zx_type_16));

                            (operand_21).* = @as((zx_abi).zx_type_16, operand_20);

                            break :block_22 @as(*const (zx_abi).zx_type_16, operand_21);
                        };
                    };

                    break :block_28 block_17: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));

                        const operand_12 = (block_16: {
                            const operand_13 = (state_1).result;

                            const operand_15 = block_14: {
                                break :block_14 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_13).len, 1));

                            if ((!state_capacity_started_9)) {
                                (try (state_capacity_8).ensureTotalCapacityPrecise(allocator, ((operand_7).source).len));
                                (try (state_capacity_8).appendSlice(allocator, operand_13));

                                state_capacity_started_9 = true;
                            } else {
                                ((state_capacity_8).items).len = (operand_13).len;
                            }

                            (try (state_capacity_8).append(allocator, operand_15));

                            break :block_16 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_8).items, {}, null, });
                        }).@"0";

                        break :block_17 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };
            }

            var state_owned_29: []const *const (zx_abi).zx_type_16 = (&[_]*const (zx_abi).zx_type_16{});

            errdefer (allocator).free(state_owned_29);

            if (state_capacity_started_9) {
                ((state_capacity_8).items).len = ((state_1).result).len;
                state_owned_29 = (try (state_capacity_8).toOwnedSlice(allocator));
            }

            if (state_capacity_started_9) {
                state_1 = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_1).index, .result = state_owned_29, .source = (state_1).source, };
            }

            break :block_30 (state_1).result;
        };
    };
}

