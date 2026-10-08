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

    return block_20: {
        const operand_2 = in;

        const state_type_4 = struct {
            label: []const u8,
            value: u64,
        };
        const state_type_5 = struct {
            index: u64,
            saved: ?state_type_4,
            total: u64,
            values: []const *const (zx_abi).zx_type_11,
        };

        var state_1: state_type_5 = state_type_5{ .index = (operand_2).index, .saved = @as(?state_type_4, (if (((operand_2).saved != null)) state_type_4{ .label = ((operand_2).saved.?).label, .value = ((operand_2).saved.?).value, } else null)), .total = (operand_2).total, .values = (operand_2).values, };
        var state_changed_3 = false;

        while (((state_1).index < @as(u64, ((state_1).values).len))) {
            state_1 = block_14: {
                const value_3: state_type_4 = block_13: {
                    const operand_12 = block_11: {
                        const operand_9 = (state_1).values;
                        const operand_10 = (state_1).index;

                        if ((operand_10 >= (operand_9).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_11 (operand_9)[@intCast(operand_10)];
                    };

                    break :block_13 state_type_4{ .label = (operand_12).label, .value = (operand_12).value, };
                };
                const value_4: state_type_5 = state_1;
                const value_5: u64 = (value_4).total;

                const value_6: state_type_5 = block_8: {
                    break :block_8 state_type_5{ .index = (value_4).index, .saved = (value_4).saved, .total = (value_5 + (value_3).value), .values = (value_4).values, };
                };

                const value_7: state_type_5 = value_6;

                const value_8: state_type_5 = block_7: {
                    break :block_7 state_type_5{ .index = (value_7).index, .saved = @as(?state_type_4, value_3), .total = (value_7).total, .values = (value_7).values, };
                };
                const value_9: state_type_5 = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: state_type_5 = block_6: {
                    break :block_6 state_type_5{ .index = (value_10 + @as(u64, 1)), .saved = (value_9).saved, .total = (value_9).total, .values = (value_9).values, };
                };

                break :block_14 value_11;
            };

            state_changed_3 = true;
        }

        break :block_20 (if (state_changed_3) block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_18).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = (state_1).index, .saved = @as(?*const (zx_abi).zx_type_11, (if (((state_1).saved != null)) block_17: {
                const operand_16 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_16).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .label = ((state_1).saved.?).label, .value = ((state_1).saved.?).value, });

                break :block_17 @as(*const (zx_abi).zx_type_11, operand_16);
            } else null)), .total = (state_1).total, .values = (state_1).values, });

            break :block_19 @as(*const (zx_abi).zx_type_14, operand_18);
        } else operand_2);
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return (block_41: {
        const operand_23 = in;

        const state_type_25 = struct {
            label: []const u8,
            value: u64,
        };

        const state_type_26 = struct {
            index: u64,
            saved: ?state_type_25,
            total: u64,
            values: []const *const (zx_abi).zx_type_11,
        };

        var state_22: state_type_26 = state_type_26{ .index = (operand_23).index, .saved = @as(?state_type_25, (if (((operand_23).saved != null)) state_type_25{ .label = ((operand_23).saved.?).label, .value = ((operand_23).saved.?).value, } else null)), .total = (operand_23).total, .values = (operand_23).values, };
        var state_changed_24 = false;

        while (((state_22).index < @as(u64, ((state_22).values).len))) {
            state_22 = block_35: {
                const value_3: state_type_25 = block_34: {
                    const operand_33 = block_32: {
                        const operand_30 = (state_22).values;
                        const operand_31 = (state_22).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    };

                    break :block_34 state_type_25{ .label = (operand_33).label, .value = (operand_33).value, };
                };
                const value_4: state_type_26 = state_22;
                const value_5: u64 = (value_4).total;

                const value_6: state_type_26 = block_29: {
                    break :block_29 state_type_26{ .index = (value_4).index, .saved = (value_4).saved, .total = (value_5 + (value_3).value), .values = (value_4).values, };
                };
                const value_7: state_type_26 = value_6;

                const value_8: state_type_26 = block_28: {
                    break :block_28 state_type_26{ .index = (value_7).index, .saved = @as(?state_type_25, value_3), .total = (value_7).total, .values = (value_7).values, };
                };
                const value_9: state_type_26 = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: state_type_26 = block_27: {
                    break :block_27 state_type_26{ .index = (value_10 + @as(u64, 1)), .saved = (value_9).saved, .total = (value_9).total, .values = (value_9).values, };
                };

                break :block_35 value_11;
            };

            state_changed_24 = true;
        }

        break :block_41 (if (state_changed_24) block_40: {
            const operand_39 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_39).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = (state_22).index, .saved = @as(?*const (zx_abi).zx_type_11, (if (((state_22).saved != null)) block_38: {
                const operand_37 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_37).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .label = ((state_22).saved.?).label, .value = ((state_22).saved.?).value, });

                break :block_38 @as(*const (zx_abi).zx_type_11, operand_37);
            } else null)), .total = (state_22).total, .values = (state_22).values, });

            break :block_40 @as(*const (zx_abi).zx_type_14, operand_39);
        } else operand_23);
    }).*;
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_11),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = buffers;

    return (block_62: {
        const operand_44 = in;

        const state_type_46 = struct {
            label: []const u8,
            value: u64,
        };

        const state_type_47 = struct {
            index: u64,
            saved: ?state_type_46,
            total: u64,
            values: []const *const (zx_abi).zx_type_11,
        };

        var state_43: state_type_47 = state_type_47{ .index = (operand_44).index, .saved = @as(?state_type_46, (if (((operand_44).saved != null)) state_type_46{ .label = ((operand_44).saved.?).label, .value = ((operand_44).saved.?).value, } else null)), .total = (operand_44).total, .values = (operand_44).values, };
        var state_changed_45 = false;

        while (((state_43).index < @as(u64, ((state_43).values).len))) {
            state_43 = block_56: {
                const value_3: state_type_46 = block_55: {
                    const operand_54 = block_53: {
                        const operand_51 = (state_43).values;
                        const operand_52 = (state_43).index;

                        if ((operand_52 >= (operand_51).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_53 (operand_51)[@intCast(operand_52)];
                    };

                    break :block_55 state_type_46{ .label = (operand_54).label, .value = (operand_54).value, };
                };
                const value_4: state_type_47 = state_43;
                const value_5: u64 = (value_4).total;

                const value_6: state_type_47 = block_50: {
                    break :block_50 state_type_47{ .index = (value_4).index, .saved = (value_4).saved, .total = (value_5 + (value_3).value), .values = (value_4).values, };
                };
                const value_7: state_type_47 = value_6;

                const value_8: state_type_47 = block_49: {
                    break :block_49 state_type_47{ .index = (value_7).index, .saved = @as(?state_type_46, value_3), .total = (value_7).total, .values = (value_7).values, };
                };
                const value_9: state_type_47 = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: state_type_47 = block_48: {
                    break :block_48 state_type_47{ .index = (value_10 + @as(u64, 1)), .saved = (value_9).saved, .total = (value_9).total, .values = (value_9).values, };
                };

                break :block_56 value_11;
            };

            state_changed_45 = true;
        }

        break :block_62 (if (state_changed_45) block_61: {
            const operand_60 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_60).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = (state_43).index, .saved = @as(?*const (zx_abi).zx_type_11, (if (((state_43).saved != null)) block_59: {
                const operand_58 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_58).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .label = ((state_43).saved.?).label, .value = ((state_43).saved.?).value, });

                break :block_59 @as(*const (zx_abi).zx_type_11, operand_58);
            } else null)), .total = (state_43).total, .values = (state_43).values, });

            break :block_61 @as(*const (zx_abi).zx_type_14, operand_60);
        } else operand_44);
    }).*;
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_11),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_82: {
        const operand_64 = in;

        const state_type_66 = struct {
            label: []const u8,
            value: u64,
        };
        const state_type_67 = struct {
            index: u64,
            saved: ?state_type_66,
            total: u64,
            values: []const *const (zx_abi).zx_type_11,
        };

        var state_63: state_type_67 = state_type_67{ .index = (operand_64).index, .saved = @as(?state_type_66, (if (((operand_64).saved != null)) state_type_66{ .label = ((operand_64).saved.?).label, .value = ((operand_64).saved.?).value, } else null)), .total = (operand_64).total, .values = (operand_64).values, };
        var state_changed_65 = false;

        while (((state_63).index < @as(u64, ((state_63).values).len))) {
            state_63 = block_76: {
                const value_3: state_type_66 = block_75: {
                    const operand_74 = block_73: {
                        const operand_71 = (state_63).values;
                        const operand_72 = (state_63).index;

                        if ((operand_72 >= (operand_71).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_73 (operand_71)[@intCast(operand_72)];
                    };

                    break :block_75 state_type_66{ .label = (operand_74).label, .value = (operand_74).value, };
                };
                const value_4: state_type_67 = state_63;
                const value_5: u64 = (value_4).total;

                const value_6: state_type_67 = block_70: {
                    break :block_70 state_type_67{ .index = (value_4).index, .saved = (value_4).saved, .total = (value_5 + (value_3).value), .values = (value_4).values, };
                };

                const value_7: state_type_67 = value_6;

                const value_8: state_type_67 = block_69: {
                    break :block_69 state_type_67{ .index = (value_7).index, .saved = @as(?state_type_66, value_3), .total = (value_7).total, .values = (value_7).values, };
                };
                const value_9: state_type_67 = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: state_type_67 = block_68: {
                    break :block_68 state_type_67{ .index = (value_10 + @as(u64, 1)), .saved = (value_9).saved, .total = (value_9).total, .values = (value_9).values, };
                };

                break :block_76 value_11;
            };

            state_changed_65 = true;
        }

        break :block_82 (if (state_changed_65) block_81: {
            const operand_80 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_80).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .index = (state_63).index, .saved = @as(?*const (zx_abi).zx_type_11, (if (((state_63).saved != null)) block_79: {
                const operand_78 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_78).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .label = ((state_63).saved.?).label, .value = ((state_63).saved.?).value, });

                break :block_79 @as(*const (zx_abi).zx_type_11, operand_78);
            } else null)), .total = (state_63).total, .values = (state_63).values, });

            break :block_81 @as(*const (zx_abi).zx_type_14, operand_80);
        } else operand_64);
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

fn function_2(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

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

