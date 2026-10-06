const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_52;
pub const Output = *const (zx_abi).zx_type_53;
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
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .field_names = zx_shape_14, .field_types = zx_shape_13, .first = zx_shape_13, .kinds = zx_shape_12, .labels = zx_shape_14, .names = zx_shape_14, .second = zx_shape_13, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .base = zx_shape_15, .delta = zx_shape_15, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .names = zx_shape_14, .types = zx_shape_13, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .fields = zx_shape_18, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .second = zx_shape_4, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .id = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_23 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .flags = zx_shape_23, .index = zx_shape_5, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .flags = zx_shape_23, .found = zx_shape_1, .index = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .tables = zx_shape_16, .target = zx_shape_11, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .flags = zx_shape_23, .index = zx_shape_5, .limit = zx_shape_5, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_23, .@"1" = zx_shape_0, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .field_names = zx_shape_14, .field_types = zx_shape_13, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .offset = zx_shape_5, .second = zx_shape_4, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .left = zx_shape_30, .right = zx_shape_30, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_30, .right = zx_shape_30, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .tables = zx_shape_16, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .delta = zx_shape_15, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_10, .limit = zx_shape_5, .right = zx_shape_10, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .building = zx_shape_1, .count = zx_shape_5, .names = zx_shape_14, .remaining = zx_shape_5, .root = zx_shape_5, .sifting = zx_shape_1, .types = zx_shape_13, }, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .table = zx_shape_15, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .diagnostic = zx_shape_44, .id = zx_shape_4, }, };
const zx_shape_47 = .{ .kind = .scalar, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .found = zx_shape_1, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .base = zx_shape_15, .delta = zx_shape_15, .diagnostic = zx_shape_44, .ids = zx_shape_13, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .state = zx_shape_49, }, };
const zx_shape_51 = .{ .kind = .list, .child = zx_shape_19, };
const zx_shape_52 = .{ .kind = .object, .fields = .{ .base = zx_shape_15, .candidates = zx_shape_51, .delta = zx_shape_15, .query_id = zx_shape_4, }, };
const zx_shape_53 = .{ .kind = .object, .fields = .{ .contains_list = zx_shape_1, .contains_native = zx_shape_1, .delta = zx_shape_15, .diagnostic = zx_shape_44, .ids = zx_shape_13, }, };
pub const input_shape = zx_shape_52;
pub const output_shape = zx_shape_53;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_17 {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_0(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_15 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_2(allocator, block_4: {
            const operand_2 = (value_4).kinds;
            const operand_3 = value_5;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = (value_4).first;
            const operand_7 = value_5;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = (value_4).second;
            const operand_11 = value_5;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = (value_4).labels;
            const operand_15 = value_5;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        const operand_17 = value_3;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_18).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .delta = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_17, operand_18);
        };
    };
}

fn function_3_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);

    const value_2: u64 = block_58: {
        const operand_57 = (in).id;

        break :block_58 (try function_0(allocator, operand_57));
    };

    const value_3: bool = (block_55: {
        break :block_55 value_2;
    } >= block_56: {
        break :block_56 value_1;
    });

    const value_4: (zx_abi).zx_type_15 = (if (block_54: {
        break :block_54 value_3;
    }) (((in).tables).delta).* else (((in).tables).base).*);

    const value_5: u64 = (if (block_50: {
        break :block_50 value_3;
    }) (block_51: {
        break :block_51 value_2;
    } - block_52: {
        break :block_52 value_1;
    }) else block_53: {
        break :block_53 value_2;
    });

    return block_49: {
        const operand_21 = block_28: {
            const operand_27 = block_26: {
                const operand_24 = (block_22: {
                    break :block_22 (&value_4);
                }).kinds;

                const operand_25 = block_23: {
                    break :block_23 value_5;
                };

                if ((operand_25 >= (operand_24).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_26 (operand_24)[@intCast(operand_25)];
            };

            break :block_28 (try function_2(allocator, operand_27));
        };

        const operand_29 = block_34: {
            const operand_32 = (block_30: {
                break :block_30 (&value_4);
            }).first;

            const operand_33 = block_31: {
                break :block_31 value_5;
            };

            if ((operand_33 >= (operand_32).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_34 (operand_32)[@intCast(operand_33)];
        };
        const operand_35 = block_40: {
            const operand_38 = (block_36: {
                break :block_36 (&value_4);
            }).second;

            const operand_39 = block_37: {
                break :block_37 value_5;
            };

            if ((operand_39 >= (operand_38).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_40 (operand_38)[@intCast(operand_39)];
        };
        const operand_41 = block_46: {
            const operand_44 = (block_42: {
                break :block_42 (&value_4);
            }).labels;

            const operand_45 = block_43: {
                break :block_43 value_5;
            };

            if ((operand_45 >= (operand_44).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_46 (operand_44)[@intCast(operand_45)];
        };

        const operand_47 = block_48: {
            break :block_48 value_3;
        };

        break :block_49 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .kind = operand_21, .first = operand_29, .second = operand_35, .label = operand_41, .delta = operand_47, });
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_24) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_17 = block_34: {
        const operand_28 = (in).tables;
        const operand_29 = (try function_1(allocator, (in).index));
        const operand_30 = (zx_abi).zx_type_22{ .tables = operand_28, .id = operand_29, };
        const operand_31 = (&operand_30);
        const operand_32 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_31).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_31).tables).base, .delta = ((operand_31).tables).delta, .zx_origin = (operand_31).tables, }, .zx_origin = operand_31, }));

        break :block_34 (if (((operand_32).zx_origin != null)) ((operand_32).zx_origin.?).* else block_33: {
            break :block_33 (zx_abi).zx_type_17{ .delta = (operand_32).delta, .first = (operand_32).first, .kind = (operand_32).kind, .label = (operand_32).label, .second = (operand_32).second, };
        });
    };

    const value_2: (zx_abi).zx_type_11 = ((&value_1)).kind;
    const value_3: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if ((value_2 == value_3)) {
        return true;
    }

    if (((value_2 == @as((zx_abi).zx_type_11, .Optional)) or ((in).native_references and ((value_2 == @as((zx_abi).zx_type_11, .List)) or (value_2 == @as((zx_abi).zx_type_11, .Task)))))) {
        return block_27: {
            const operand_25 = (in).flags;
            const operand_26 = (try function_0(allocator, ((&value_1)).first));

            if ((operand_26 >= (operand_25).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_27 (operand_25)[@intCast(operand_26)];
        };
    }

    if (((value_2 != @as((zx_abi).zx_type_11, .Tuple)) and (value_2 != @as((zx_abi).zx_type_11, .Object)))) {
        return false;
    }

    const value_4: (zx_abi).zx_type_15 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_11, .Tuple))) ((&value_4)).children else ((&value_4)).field_types);

    return block_24: {
        const operand_9 = block_8: {
            const operand_2 = (in).flags;
            const operand_3 = value_5;
            const operand_4 = (try function_0(allocator, ((&value_1)).first));
            const operand_5 = (try function_0(allocator, ((&value_1)).second));
            const operand_6 = @as(u64, 0);
            const operand_7 = false;

            break :block_8 (zx_abi).zx_type_25{ .flags = operand_2, .children = operand_3, .offset = operand_4, .count = operand_5, .index = operand_6, .found = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (operand_9).children, .count = (operand_9).count, .flags = (operand_9).flags, .found = (operand_9).found, .index = (operand_9).index, .offset = (operand_9).offset, .zx_origin = (&operand_9), };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_23: {
                const value_8: (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;
                _ = (value_8).found;

                const value_10: bool = block_22: {
                    const operand_20 = (state_1).flags;

                    const operand_21 = block_19: {
                        const operand_18 = block_17: {
                            const operand_15 = (state_1).children;
                            const operand_16 = ((state_1).offset + (state_1).index);

                            if ((operand_16 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_17 (operand_15)[@intCast(operand_16)];
                        };

                        break :block_19 (try function_0(allocator, operand_18));
                    };

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };

                const value_11: (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_8).children, .count = (value_8).count, .flags = (value_8).flags, .found = block_13: {
                        break :block_13 value_10;
                    }, .index = (value_8).index, .offset = (value_8).offset, });
                };

                const value_12: (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_12).children, .count = (value_12).count, .flags = (value_12).flags, .found = (value_12).found, .index = (block_10: {
                        break :block_10 value_13;
                    } + block_11: {
                        break :block_11 value_14;
                    }), .offset = (value_12).offset, });
                };

                break :block_23 value_15;
            };
        }

        break :block_24 (state_1).found;
    };
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if (((block_68: {
        const operand_62 = (in).tables;
        const operand_63 = (in).id;
        const operand_64 = (zx_abi).zx_type_22{ .tables = operand_62, .id = operand_63, };
        const operand_65 = (&operand_64);
        const operand_66 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_65).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_65).tables).base, .delta = ((operand_65).tables).delta, .zx_origin = (operand_65).tables, }, .zx_origin = operand_65, }));

        break :block_68 (if (((operand_66).zx_origin != null)) ((operand_66).zx_origin.?).* else block_67: {
            break :block_67 (zx_abi).zx_type_17{ .delta = (operand_66).delta, .first = (operand_66).first, .kind = (operand_66).kind, .label = (operand_66).label, .second = (operand_66).second, };
        });
    }).kind == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_27 = block_61: {
        const operand_44 = block_43: {
            const operand_38 = (in).tables;
            const operand_39 = value_1;
            const operand_40 = value_2;
            const operand_41 = @as(u64, 0);
            const operand_42 = false;

            break :block_43 (zx_abi).zx_type_27{ .tables = operand_38, .limit = operand_39, .target = operand_40, .index = operand_41, .found = operand_42, };
        };

        var state_37: (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = (operand_44).found, .index = (operand_44).index, .limit = (operand_44).limit, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_44).tables).base, .delta = ((operand_44).tables).delta, .zx_origin = (operand_44).tables, }, .target = (operand_44).target, .zx_origin = (&operand_44), };

        while (((!(state_37).found) and ((state_37).index < (state_37).limit))) {
            state_37 = block_56: {
                const value_5: (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = state_37;
                _ = (value_5).found;

                const value_7: bool = ((block_55: {
                    break :block_55 (try function_3_value(allocator, block_54: {
                        const operand_50 = (state_37).tables;

                        const operand_51 = block_53: {
                            const operand_52 = (state_37).index;

                            break :block_53 (try function_1(allocator, operand_52));
                        };

                        break :block_54 @as((zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_50, .id = operand_51, });
                    }));
                }).kind == (state_37).target);

                const value_8: (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = block_49: {
                    break :block_49 @as((zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc, (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = block_48: {
                        break :block_48 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .tables = (value_5).tables, .target = (value_5).target, });
                };

                const value_9: (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = block_47: {
                    break :block_47 @as((zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc, (zx_abi).value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = (value_9).found, .index = (block_45: {
                        break :block_45 value_10;
                    } + block_46: {
                        break :block_46 value_11;
                    }), .limit = (value_9).limit, .tables = (value_9).tables, .target = (value_9).target, });
                };

                break :block_56 value_12;
            };
        }

        break :block_61 block_60: {
            break :block_60 (if (((state_37).zx_origin != null)) ((state_37).zx_origin.?).* else block_59: {
                break :block_59 (zx_abi).zx_type_27{ .found = (state_37).found, .index = (state_37).index, .limit = (state_37).limit, .tables = (if ((((state_37).tables).zx_origin != null)) ((state_37).tables).zx_origin.? else block_58: {
                    const operand_57 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_57).* = (zx_abi).zx_type_16{ .base = ((state_37).tables).base, .delta = ((state_37).tables).delta, };

                    break :block_58 @as(*const (zx_abi).zx_type_16, operand_57);
                }), .target = (state_37).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    const value_14: []const bool = @as([]const bool, (comptime (&[_]bool{})));

    return block_36: {
        const operand_9 = block_8: {
            const operand_2 = (in).tables;
            const operand_3 = @as(u64, 0);
            const operand_4 = (((&value_13)).index - @as(u64, 1));
            const operand_5 = (value_1 + @as(u64, 1));
            const operand_6 = value_14;
            const operand_7 = (in).native_references;

            break :block_8 (zx_abi).zx_type_28{ .tables = operand_2, .index = operand_3, .first = operand_4, .limit = operand_5, .flags = operand_6, .native_references = operand_7, };
        };

        var state_capacity_10: (std).ArrayList(bool) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (operand_9).first, .flags = (operand_9).flags, .index = (operand_9).index, .limit = (operand_9).limit, .native_references = (operand_9).native_references, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_9).tables).base, .delta = ((operand_9).tables).delta, .zx_origin = (operand_9).tables, }, .zx_origin = (&operand_9), };

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_31: {
                const value_17: bool = (((state_1).index >= (state_1).first) and block_30: {
                    const operand_21 = (state_1).tables;
                    var state_borrow_22: (zx_abi).zx_type_16 = undefined;

                    state_borrow_22 = (zx_abi).zx_type_16{ .base = (operand_21).base, .delta = (operand_21).delta, };

                    const operand_23 = ((operand_21).zx_origin orelse (&state_borrow_22));
                    const operand_24 = (state_1).index;
                    const operand_25 = (state_1).flags;
                    const operand_26 = (state_1).native_references;
                    const operand_27 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_23).base, .delta = (operand_23).delta, .zx_origin = operand_23, };
                    var state_borrow_28: (zx_abi).zx_type_16 = undefined;

                    state_borrow_28 = (zx_abi).zx_type_16{ .base = (operand_27).base, .delta = (operand_27).delta, };

                    const operand_29 = (zx_abi).zx_type_24{ .tables = ((operand_27).zx_origin orelse (&state_borrow_28)), .index = operand_24, .flags = operand_25, .native_references = operand_26, };

                    break :block_30 (try function_4(allocator, (&operand_29)));
                });

                const value_18: (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = state_1;

                _ = (value_18).flags;

                const value_20: []const bool = (block_20: {
                    const operand_17 = (state_1).flags;

                    const operand_19 = block_18: {
                        break :block_18 value_17;
                    };

                    _ = (try ((std).math).add(usize, (operand_17).len, 1));

                    if ((!state_capacity_started_11)) {
                        (try (state_capacity_10).appendSlice(allocator, operand_17));

                        state_capacity_started_11 = true;
                    } else {
                        ((state_capacity_10).items).len = (operand_17).len;
                    }

                    (try (state_capacity_10).append(allocator, operand_19));

                    break :block_20 @as((zx_abi).value_zx_type_29_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                }).@"0";

                const value_21: (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (value_18).first, .flags = block_15: {
                        break :block_15 value_20;
                    }, .index = (value_18).index, .limit = (value_18).limit, .native_references = (value_18).native_references, .tables = (value_18).tables, });
                };

                const value_22: (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = value_21;
                const value_23: u64 = (value_22).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (value_22).first, .flags = (value_22).flags, .index = (block_12: {
                        break :block_12 value_23;
                    } + block_13: {
                        break :block_13 value_24;
                    }), .limit = (value_22).limit, .native_references = (value_22).native_references, .tables = (value_22).tables, });
                };

                break :block_31 value_25;
            };
        }

        break :block_36 block_35: {
            const operand_33 = (state_1).flags;

            const operand_34 = block_32: {
                break :block_32 value_1;
            };

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        };
    };
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{ OutOfMemory, }!*const (zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    const value_1: u64 = block_15: {
        const operand_14 = (in).kind;

        break :block_15 (if ((operand_14 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_14 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_13: {
        const operand_1 = (in).kind;
        const operand_2 = (in).first;
        const operand_3 = (in).second;
        const operand_4 = (in).label;
        const operand_5 = @as(u64, 0);
        const operand_6 = value_1;
        const operand_7 = (in).children;
        const operand_8 = ((in).fields).names;
        const operand_9 = ((in).fields).types;
        const operand_10 = (in).names;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_30));

            (operand_11).* = @as((zx_abi).zx_type_30, (zx_abi).zx_type_30{ .kind = operand_1, .first = operand_2, .second = operand_3, .label = operand_4, .offset = operand_5, .count = operand_6, .children = operand_7, .field_names = operand_8, .field_types = operand_9, .names = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_30, operand_11);
        };
    };
}

fn function_6_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{ OutOfMemory, }!(zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = block_28: {
        const operand_27 = (in).kind;

        break :block_28 (if ((operand_27 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_27 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_26: {
        const operand_16 = (in).kind;
        const operand_17 = (in).first;
        const operand_18 = (in).second;
        const operand_19 = (in).label;
        const operand_20 = @as(u64, 0);
        const operand_21 = value_1;
        const operand_22 = (in).children;
        const operand_23 = ((in).fields).names;
        const operand_24 = ((in).fields).types;
        const operand_25 = (in).names;

        break :block_26 (zx_abi).zx_type_30{ .kind = operand_16, .first = operand_17, .second = operand_18, .label = operand_19, .offset = operand_20, .count = operand_21, .children = operand_22, .field_names = operand_23, .field_types = operand_24, .names = operand_25, };
    };
}

fn function_6_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    const value_1: u64 = block_41: {
        const operand_40 = (in).kind;

        break :block_41 (if ((operand_40 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_40 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_39: {
        const operand_29 = (in).kind;
        const operand_30 = (in).first;
        const operand_31 = (in).second;
        const operand_32 = (in).label;
        const operand_33 = @as(u64, 0);
        const operand_34 = value_1;
        const operand_35 = (in).children;
        const operand_36 = ((in).fields).names;
        const operand_37 = ((in).fields).types;
        const operand_38 = (in).names;

        break :block_39 (zx_abi).zx_type_30{ .kind = operand_29, .first = operand_30, .second = operand_31, .label = operand_32, .offset = operand_33, .count = operand_34, .children = operand_35, .field_names = operand_36, .field_types = operand_37, .names = operand_38, };
    };
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_30 = ((in).left).*;
    const value_2: (zx_abi).zx_type_30 = ((in).right).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_11, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_11, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_11, .NativeReference))) {
        return block_61: {
            const operand_59 = ((&value_1)).label;
            const operand_60 = ((&value_2)).label;

            break :block_61 ((std).mem).eql(u8, operand_59, operand_60);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_11, .Enumeration)) and (!block_58: {
        const operand_56 = ((&value_1)).label;
        const operand_57 = ((&value_2)).label;

        break :block_58 ((std).mem).eql(u8, operand_56, operand_57);
    }))) {
        return false;
    }

    if ((((&value_1)).count != ((&value_2)).count)) {
        return false;
    }

    return block_55: {
        const operand_7 = block_6: {
            const operand_2 = (&value_1);
            const operand_3 = (&value_2);
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_32{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (operand_7).equal, .index = (operand_7).index, .left = (operand_7).left, .right = (operand_7).right, .zx_origin = (&operand_7), };

        while (((state_1).equal and ((state_1).index < ((state_1).left).count))) {
            state_1 = block_54: {
                const value_5: u64 = (((state_1).left).offset + (state_1).index);
                const value_6: u64 = (((state_1).right).offset + (state_1).index);

                const value_7: bool = block_53: {
                    const operand_14 = ((state_1).left).kind;

                    break :block_53 (if ((operand_14 == @as((zx_abi).zx_type_11, .Object))) (block_44: {
                        const operand_42 = block_37: {
                            const operand_35 = ((state_1).left).field_names;

                            const operand_36 = block_34: {
                                break :block_34 value_5;
                            };

                            if ((operand_36 >= (operand_35).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_37 (operand_35)[@intCast(operand_36)];
                        };
                        const operand_43 = block_41: {
                            const operand_39 = ((state_1).right).field_names;

                            const operand_40 = block_38: {
                                break :block_38 value_6;
                            };

                            if ((operand_40 >= (operand_39).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_41 (operand_39)[@intCast(operand_40)];
                        };

                        break :block_44 ((std).mem).eql(u8, operand_42, operand_43);
                    } and (block_48: {
                        const operand_46 = ((state_1).left).field_types;

                        const operand_47 = block_45: {
                            break :block_45 value_5;
                        };

                        if ((operand_47 >= (operand_46).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_48 (operand_46)[@intCast(operand_47)];
                    } == block_52: {
                        const operand_50 = ((state_1).right).field_types;

                        const operand_51 = block_49: {
                            break :block_49 value_6;
                        };

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    })) else (if ((operand_14 == @as((zx_abi).zx_type_11, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).left).children;

                        const operand_28 = block_26: {
                            break :block_26 value_5;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_33: {
                        const operand_31 = ((state_1).right).children;

                        const operand_32 = block_30: {
                            break :block_30 value_6;
                        };

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    }) else block_25: {
                        const operand_23 = block_18: {
                            const operand_16 = ((state_1).left).names;

                            const operand_17 = block_15: {
                                break :block_15 value_5;
                            };

                            if ((operand_17 >= (operand_16).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_18 (operand_16)[@intCast(operand_17)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).right).names;

                            const operand_21 = block_19: {
                                break :block_19 value_6;
                            };

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_8: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };

                const value_11: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = block_11: {
                        break :block_11 value_10;
                    }, .index = (value_8).index, .left = (value_8).left, .right = (value_8).right, });
                };

                const value_12: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (value_12).equal, .index = (block_8: {
                        break :block_8 value_13;
                    } + block_9: {
                        break :block_9 value_14;
                    }), .left = (value_12).left, .right = (value_12).right, });
                };

                break :block_54 value_15;
            };
        }

        break :block_55 (state_1).equal;
    };
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_2(allocator, block_4: {
            const operand_2 = ((in).table).kinds;
            const operand_3 = (in).index;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = ((in).table).first;
            const operand_7 = (in).index;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = ((in).table).second;
            const operand_11 = (in).index;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = ((in).table).labels;
            const operand_15 = (in).index;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };
        const operand_17 = (try function_0(allocator, block_20: {
            const operand_18 = ((in).table).first;
            const operand_19 = (in).index;

            if ((operand_19 >= (operand_18).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_20 (operand_18)[@intCast(operand_19)];
        }));

        const operand_21 = (try function_0(allocator, block_24: {
            const operand_22 = ((in).table).second;
            const operand_23 = (in).index;

            if ((operand_23 >= (operand_22).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_24 (operand_22)[@intCast(operand_23)];
        }));

        const operand_25 = ((in).table).children;
        const operand_26 = ((in).table).field_names;
        const operand_27 = ((in).table).field_types;
        const operand_28 = ((in).table).names;

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_30));

            (operand_29).* = @as((zx_abi).zx_type_30, (zx_abi).zx_type_30{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .offset = operand_17, .count = operand_21, .children = operand_25, .field_names = operand_26, .field_types = operand_27, .names = operand_28, });

            break :block_30 @as(*const (zx_abi).zx_type_30, operand_29);
        };
    };
}

fn function_8_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_2(allocator, block_35: {
            const operand_33 = ((in).table).kinds;
            const operand_34 = (in).index;

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        }));

        const operand_36 = block_39: {
            const operand_37 = ((in).table).first;
            const operand_38 = (in).index;

            if ((operand_38 >= (operand_37).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_39 (operand_37)[@intCast(operand_38)];
        };
        const operand_40 = block_43: {
            const operand_41 = ((in).table).second;
            const operand_42 = (in).index;

            if ((operand_42 >= (operand_41).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_43 (operand_41)[@intCast(operand_42)];
        };
        const operand_44 = block_47: {
            const operand_45 = ((in).table).labels;
            const operand_46 = (in).index;

            if ((operand_46 >= (operand_45).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_47 (operand_45)[@intCast(operand_46)];
        };
        const operand_48 = (try function_0(allocator, block_51: {
            const operand_49 = ((in).table).first;
            const operand_50 = (in).index;

            if ((operand_50 >= (operand_49).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_51 (operand_49)[@intCast(operand_50)];
        }));

        const operand_52 = (try function_0(allocator, block_55: {
            const operand_53 = ((in).table).second;
            const operand_54 = (in).index;

            if ((operand_54 >= (operand_53).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_55 (operand_53)[@intCast(operand_54)];
        }));

        const operand_56 = ((in).table).children;
        const operand_57 = ((in).table).field_names;
        const operand_58 = ((in).table).field_types;
        const operand_59 = ((in).table).names;

        break :block_60 (zx_abi).zx_type_30{ .kind = operand_32, .first = operand_36, .second = operand_40, .label = operand_44, .offset = operand_48, .count = operand_52, .children = operand_56, .field_names = operand_57, .field_types = operand_58, .names = operand_59, };
    };
}

fn function_8_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_30 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_2(allocator, block_64: {
            const operand_62 = ((in).table).kinds;
            const operand_63 = (in).index;

            if ((operand_63 >= (operand_62).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_64 (operand_62)[@intCast(operand_63)];
        }));

        const operand_65 = block_68: {
            const operand_66 = ((in).table).first;
            const operand_67 = (in).index;

            if ((operand_67 >= (operand_66).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_68 (operand_66)[@intCast(operand_67)];
        };
        const operand_69 = block_72: {
            const operand_70 = ((in).table).second;
            const operand_71 = (in).index;

            if ((operand_71 >= (operand_70).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_72 (operand_70)[@intCast(operand_71)];
        };
        const operand_73 = block_76: {
            const operand_74 = ((in).table).labels;
            const operand_75 = (in).index;

            if ((operand_75 >= (operand_74).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_76 (operand_74)[@intCast(operand_75)];
        };
        const operand_77 = (try function_0(allocator, block_80: {
            const operand_78 = ((in).table).first;
            const operand_79 = (in).index;

            if ((operand_79 >= (operand_78).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_80 (operand_78)[@intCast(operand_79)];
        }));

        const operand_81 = (try function_0(allocator, block_84: {
            const operand_82 = ((in).table).second;
            const operand_83 = (in).index;

            if ((operand_83 >= (operand_82).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_84 (operand_82)[@intCast(operand_83)];
        }));

        const operand_85 = ((in).table).children;
        const operand_86 = ((in).table).field_names;
        const operand_87 = ((in).table).field_types;
        const operand_88 = ((in).table).names;

        break :block_89 (zx_abi).zx_type_30{ .kind = operand_61, .first = operand_65, .second = operand_69, .label = operand_73, .offset = operand_77, .count = operand_81, .children = operand_85, .field_names = operand_86, .field_types = operand_87, .names = operand_88, };
    };
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_3: bool = (value_1 >= value_2);
    const value_4: (zx_abi).zx_type_15 = (if (value_3) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: u64 = (if (value_3) (value_1 - value_2) else value_1);

    return block_9: {
        const operand_1 = (&value_4);
        const operand_2 = value_5;
        const operand_3 = (zx_abi).zx_type_33{ .table = operand_1, .index = operand_2, };
        const operand_4 = (try function_8_value(allocator, (&operand_3)));
        const operand_5 = (&operand_4);
        const operand_6 = (try function_6_value(allocator, (in).candidate));
        const operand_7 = (&operand_6);
        const operand_8 = (zx_abi).zx_type_31{ .left = operand_5, .right = operand_7, };

        break :block_9 (try function_7(allocator, (&operand_8)));
    };
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_20 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_61: {
            const operand_57 = false;
            const operand_58 = @as(u32, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_59).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .found = operand_57, .id = operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_20, operand_59);
            };
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: *const (zx_abi).zx_type_36 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_36));

                (operand_13).* = @as((zx_abi).zx_type_36, (zx_abi).zx_type_36{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_36, operand_13);
            };
        };
        const state_type_18 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_19 = struct {
            children: []const u32,
            fields: state_type_18,
            first: u32,
            kind: (zx_abi).zx_type_11,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };
        const state_type_20 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_21 = struct {
            base: state_type_20,
            delta: state_type_20,
        };

        const state_type_22 = struct {
            candidate: state_type_19,
            count: u64,
            found: bool,
            id: u32,
            index: u64,
            tables: state_type_21,
        };
        const state_type_28 = struct {
            candidate: state_type_19,
            id: u32,
            tables: state_type_21,
        };

        var state_6: state_type_22 = state_type_22{ .candidate = state_type_19{ .children = ((operand_16).candidate).children, .fields = state_type_18{ .names = (((operand_16).candidate).fields).names, .types = (((operand_16).candidate).fields).types, }, .first = ((operand_16).candidate).first, .kind = ((operand_16).candidate).kind, .label = ((operand_16).candidate).label, .names = ((operand_16).candidate).names, .second = ((operand_16).candidate).second, }, .count = (operand_16).count, .found = (operand_16).found, .id = (operand_16).id, .index = (operand_16).index, .tables = state_type_21{ .base = state_type_20{ .children = (((operand_16).tables).base).children, .field_names = (((operand_16).tables).base).field_names, .field_types = (((operand_16).tables).base).field_types, .first = (((operand_16).tables).base).first, .kinds = (((operand_16).tables).base).kinds, .labels = (((operand_16).tables).base).labels, .names = (((operand_16).tables).base).names, .second = (((operand_16).tables).base).second, }, .delta = state_type_20{ .children = (((operand_16).tables).delta).children, .field_names = (((operand_16).tables).delta).field_names, .field_types = (((operand_16).tables).delta).field_types, .first = (((operand_16).tables).delta).first, .kinds = (((operand_16).tables).delta).kinds, .labels = (((operand_16).tables).delta).labels, .names = (((operand_16).tables).delta).names, .second = (((operand_16).tables).delta).second, }, }, };
        var state_changed_17 = false;

        while (((!(state_6).found) and ((state_6).index < (state_6).count))) {
            state_6 = block_42: {
                const value_5: u32 = (try function_1(allocator, (state_6).index));

                const value_6: bool = block_41: {
                    const operand_33 = block_32: {
                        const operand_29 = (state_6).tables;
                        const operand_30 = value_5;
                        const operand_31 = (state_6).candidate;

                        break :block_32 state_type_28{ .tables = operand_29, .id = operand_30, .candidate = operand_31, };
                    };

                    const operand_34 = (zx_abi).zx_type_18{ .names = (((operand_33).candidate).fields).names, .types = (((operand_33).candidate).fields).types, };
                    const operand_35 = (zx_abi).zx_type_19{ .children = ((operand_33).candidate).children, .fields = (&operand_34), .first = ((operand_33).candidate).first, .kind = ((operand_33).candidate).kind, .label = ((operand_33).candidate).label, .names = ((operand_33).candidate).names, .second = ((operand_33).candidate).second, };
                    const operand_36 = (zx_abi).zx_type_15{ .children = (((operand_33).tables).base).children, .field_names = (((operand_33).tables).base).field_names, .field_types = (((operand_33).tables).base).field_types, .first = (((operand_33).tables).base).first, .kinds = (((operand_33).tables).base).kinds, .labels = (((operand_33).tables).base).labels, .names = (((operand_33).tables).base).names, .second = (((operand_33).tables).base).second, };
                    const operand_37 = (zx_abi).zx_type_15{ .children = (((operand_33).tables).delta).children, .field_names = (((operand_33).tables).delta).field_names, .field_types = (((operand_33).tables).delta).field_types, .first = (((operand_33).tables).delta).first, .kinds = (((operand_33).tables).delta).kinds, .labels = (((operand_33).tables).delta).labels, .names = (((operand_33).tables).delta).names, .second = (((operand_33).tables).delta).second, };
                    const operand_38 = (zx_abi).zx_type_16{ .base = (&operand_36), .delta = (&operand_37), };
                    const operand_39 = (zx_abi).zx_type_34{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_9(allocator, (&operand_39)));

                    break :block_41 operand_40;
                };
                const value_7: state_type_22 = block_27: {
                    const operand_23 = state_6;
                    const operand_24 = ((state_6).index + @as(u64, 1));
                    const operand_25 = value_6;
                    const operand_26 = value_5;

                    break :block_27 state_type_22{ .candidate = (operand_23).candidate, .count = (operand_23).count, .found = operand_25, .id = operand_26, .index = operand_24, .tables = (operand_23).tables, };
                };

                break :block_42 value_7;
            };

            state_changed_17 = true;
        }

        break :block_56 (if (state_changed_17) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_36));

            (operand_54).* = @as((zx_abi).zx_type_36, (zx_abi).zx_type_36{ .candidate = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_46).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = ((state_6).candidate).children, .fields = block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_44).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_45 @as(*const (zx_abi).zx_type_18, operand_44);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_47 @as(*const (zx_abi).zx_type_19, operand_46);
            }, .count = (state_6).count, .found = (state_6).found, .id = (state_6).id, .index = (state_6).index, .tables = block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_52).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_48).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_49 @as(*const (zx_abi).zx_type_15, operand_48);
                }, .delta = block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_50).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_51 @as(*const (zx_abi).zx_type_15, operand_50);
                }, });

                break :block_53 @as(*const (zx_abi).zx_type_16, operand_52);
            }, });

            break :block_55 @as(*const (zx_abi).zx_type_36, operand_54);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_8).found;
        const operand_2 = (value_8).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_3).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .found = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_20, operand_3);
        };
    };
}

fn function_10_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_101: {
            const operand_99 = false;
            const operand_100 = @as(u32, 0);

            break :block_101 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_99, .id = operand_100, });
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: (zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_98: {
        const operand_75 = block_74: {
            const operand_66 = (in).tables;
            const operand_67 = (in).candidate;

            const operand_68 = block_69: {
                break :block_69 value_2;
            };

            const operand_70 = @as(u64, 0);
            const operand_71 = false;

            const operand_72 = block_73: {
                break :block_73 value_1;
            };

            break :block_74 @as((zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .tables = operand_66, .candidate = operand_67, .count = operand_68, .index = operand_70, .found = operand_71, .id = operand_72, });
        };

        var state_65: (zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_96: {
                const value_5: u32 = block_95: {
                    const operand_94 = (state_65).index;

                    break :block_95 (try function_1(allocator, operand_94));
                };
                const value_6: bool = block_93: {
                    const operand_84 = (state_65).tables;
                    var state_borrow_85: (zx_abi).zx_type_16 = undefined;
                    state_borrow_85 = (zx_abi).zx_type_16{ .base = (operand_84).base, .delta = (operand_84).delta, };

                    const operand_86 = ((operand_84).zx_origin orelse (&state_borrow_85));

                    const operand_88 = block_87: {
                        break :block_87 value_5;
                    };

                    const operand_89 = (state_65).candidate;
                    const operand_90 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_86).base, .delta = (operand_86).delta, .zx_origin = operand_86, };
                    var state_borrow_91: (zx_abi).zx_type_16 = undefined;
                    state_borrow_91 = (zx_abi).zx_type_16{ .base = (operand_90).base, .delta = (operand_90).delta, };

                    const operand_92 = (zx_abi).zx_type_34{ .tables = ((operand_90).zx_origin orelse (&state_borrow_91)), .id = operand_88, .candidate = operand_89, };

                    break :block_93 (try function_9(allocator, (&operand_92)));
                };
                const value_7: (zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .candidate = (operand_77).candidate, .count = (operand_77).count, .found = operand_79, .id = operand_81, .index = operand_78, .tables = (operand_77).tables, });
                };

                break :block_96 value_7;
            };

            state_changed_76 = true;
        }

        break :block_98 (if (state_changed_76) state_65 else operand_75);
    };

    return block_64: {
        const operand_62 = (value_8).found;
        const operand_63 = (value_8).id;

        break :block_64 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_62, .id = operand_63, });
    };
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37) error{ IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_49: {
        const operand_48 = ((in).candidate).kind;

        break :block_49 (if ((operand_48 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_48 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_48 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_47: {
        const operand_46 = ((in).candidate).kind;

        break :block_47 (if ((operand_46 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_45: {
        const operand_44 = ((in).candidate).kind;

        break :block_45 (if ((operand_44 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_43: {
        const operand_1 = (block_5: {
            const operand_2 = ((in).delta).kinds;
            const operand_3 = value_1;
            const operand_4 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_2).len, 1))));

            @memcpy((operand_4)[0..(operand_2).len], operand_2);

            (operand_4)[(operand_2).len] = operand_3;

            break :block_5 @as((zx_abi).zx_type_38, .{ operand_4, {}, });
        }).@"0";

        const operand_6 = (block_10: {
            const operand_7 = ((in).delta).first;
            const operand_8 = value_3;
            const operand_9 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_7).len, 1))));

            @memcpy((operand_9)[0..(operand_7).len], operand_7);

            (operand_9)[(operand_7).len] = operand_8;

            break :block_10 @as((zx_abi).zx_type_39, .{ operand_9, {}, });
        }).@"0";

        const operand_11 = (block_15: {
            const operand_12 = ((in).delta).second;
            const operand_13 = value_4;
            const operand_14 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_12).len, 1))));

            @memcpy((operand_14)[0..(operand_12).len], operand_12);

            (operand_14)[(operand_12).len] = operand_13;

            break :block_15 @as((zx_abi).zx_type_39, .{ operand_14, {}, });
        }).@"0";
        const operand_16 = (block_20: {
            const operand_17 = ((in).delta).labels;
            const operand_18 = ((in).candidate).label;
            const operand_19 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_17).len, 1))));

            @memcpy((operand_19)[0..(operand_17).len], operand_17);

            (operand_19)[(operand_17).len] = operand_18;

            break :block_20 @as((zx_abi).zx_type_40, .{ operand_19, {}, });
        }).@"0";

        const operand_21 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) (block_25: {
            const operand_22 = ((in).delta).children;
            const operand_23 = ((in).candidate).children;
            const operand_24 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_22).len, (operand_23).len))));

            @memcpy((operand_24)[0..(operand_22).len], operand_22);
            @memcpy((operand_24)[(operand_22).len..], operand_23);

            break :block_25 @as((zx_abi).zx_type_39, .{ operand_24, {}, });
        }).@"0" else ((in).delta).children);

        const operand_26 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_30: {
            const operand_27 = ((in).delta).field_types;
            const operand_28 = (((in).candidate).fields).types;
            const operand_29 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_27).len, (operand_28).len))));

            @memcpy((operand_29)[0..(operand_27).len], operand_27);
            @memcpy((operand_29)[(operand_27).len..], operand_28);

            break :block_30 @as((zx_abi).zx_type_39, .{ operand_29, {}, });
        }).@"0" else ((in).delta).field_types);

        const operand_31 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_35: {
            const operand_32 = ((in).delta).field_names;
            const operand_33 = (((in).candidate).fields).names;
            const operand_34 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_32).len, (operand_33).len))));

            @memcpy((operand_34)[0..(operand_32).len], operand_32);
            @memcpy((operand_34)[(operand_32).len..], operand_33);

            break :block_35 @as((zx_abi).zx_type_40, .{ operand_34, {}, });
        }).@"0" else ((in).delta).field_names);

        const operand_36 = (if (value_2) (block_40: {
            const operand_37 = ((in).delta).names;
            const operand_38 = ((in).candidate).names;
            const operand_39 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_37).len, (operand_38).len))));

            @memcpy((operand_39)[0..(operand_37).len], operand_37);
            @memcpy((operand_39)[(operand_37).len..], operand_38);

            break :block_40 @as((zx_abi).zx_type_40, .{ operand_39, {}, });
        }).@"0" else ((in).delta).names);

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_41).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_1, .first = operand_6, .second = operand_11, .labels = operand_16, .children = operand_21, .field_types = operand_26, .field_names = operand_31, .names = operand_36, });

            break :block_42 @as(*const (zx_abi).zx_type_15, operand_41);
        };
    };
}

fn function_11_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_96: {
        const operand_95 = ((in).candidate).kind;

        break :block_96 (if ((operand_95 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_95 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_95 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_94: {
        const operand_93 = ((in).candidate).kind;

        break :block_94 (if ((operand_93 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_92: {
        const operand_91 = ((in).candidate).kind;

        break :block_92 (if ((operand_91 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_90: {
        const operand_50 = (block_54: {
            const operand_51 = ((in).delta).kinds;
            const operand_52 = value_1;
            const operand_53 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_51).len, 1))));

            @memcpy((operand_53)[0..(operand_51).len], operand_51);

            (operand_53)[(operand_51).len] = operand_52;

            break :block_54 @as((zx_abi).zx_type_38, .{ operand_53, {}, });
        }).@"0";

        const operand_55 = (block_59: {
            const operand_56 = ((in).delta).first;
            const operand_57 = value_3;
            const operand_58 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_56).len, 1))));

            @memcpy((operand_58)[0..(operand_56).len], operand_56);

            (operand_58)[(operand_56).len] = operand_57;

            break :block_59 @as((zx_abi).zx_type_39, .{ operand_58, {}, });
        }).@"0";

        const operand_60 = (block_64: {
            const operand_61 = ((in).delta).second;
            const operand_62 = value_4;
            const operand_63 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_61).len, 1))));

            @memcpy((operand_63)[0..(operand_61).len], operand_61);

            (operand_63)[(operand_61).len] = operand_62;

            break :block_64 @as((zx_abi).zx_type_39, .{ operand_63, {}, });
        }).@"0";
        const operand_65 = (block_69: {
            const operand_66 = ((in).delta).labels;
            const operand_67 = ((in).candidate).label;
            const operand_68 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_66).len, 1))));

            @memcpy((operand_68)[0..(operand_66).len], operand_66);

            (operand_68)[(operand_66).len] = operand_67;

            break :block_69 @as((zx_abi).zx_type_40, .{ operand_68, {}, });
        }).@"0";

        const operand_70 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) (block_74: {
            const operand_71 = ((in).delta).children;
            const operand_72 = ((in).candidate).children;
            const operand_73 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_71).len, (operand_72).len))));

            @memcpy((operand_73)[0..(operand_71).len], operand_71);
            @memcpy((operand_73)[(operand_71).len..], operand_72);

            break :block_74 @as((zx_abi).zx_type_39, .{ operand_73, {}, });
        }).@"0" else ((in).delta).children);

        const operand_75 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_79: {
            const operand_76 = ((in).delta).field_types;
            const operand_77 = (((in).candidate).fields).types;
            const operand_78 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_76).len, (operand_77).len))));

            @memcpy((operand_78)[0..(operand_76).len], operand_76);
            @memcpy((operand_78)[(operand_76).len..], operand_77);

            break :block_79 @as((zx_abi).zx_type_39, .{ operand_78, {}, });
        }).@"0" else ((in).delta).field_types);

        const operand_80 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_84: {
            const operand_81 = ((in).delta).field_names;
            const operand_82 = (((in).candidate).fields).names;
            const operand_83 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_81).len, (operand_82).len))));

            @memcpy((operand_83)[0..(operand_81).len], operand_81);
            @memcpy((operand_83)[(operand_81).len..], operand_82);

            break :block_84 @as((zx_abi).zx_type_40, .{ operand_83, {}, });
        }).@"0" else ((in).delta).field_names);

        const operand_85 = (if (value_2) (block_89: {
            const operand_86 = ((in).delta).names;
            const operand_87 = ((in).candidate).names;
            const operand_88 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_86).len, (operand_87).len))));

            @memcpy((operand_88)[0..(operand_86).len], operand_86);
            @memcpy((operand_88)[(operand_86).len..], operand_87);

            break :block_89 @as((zx_abi).zx_type_40, .{ operand_88, {}, });
        }).@"0" else ((in).delta).names);

        break :block_90 (zx_abi).zx_type_15{ .kinds = operand_50, .first = operand_55, .second = operand_60, .labels = operand_65, .children = operand_70, .field_types = operand_75, .field_names = operand_80, .names = operand_85, };
    };
}

fn function_11_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_167: {
        const operand_166 = ((in).candidate).kind;

        break :block_167 (if ((operand_166 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_166 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_166 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_165: {
        const operand_164 = ((in).candidate).kind;

        break :block_165 (if ((operand_164 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_163: {
        const operand_162 = ((in).candidate).kind;

        break :block_163 (if ((operand_162 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_161: {
        const operand_97 = @as([]const u8, (if (((buffers).lane_4 != null)) block_100: {
            const operand_98 = ((in).delta).kinds;
            const operand_99 = value_1;

            _ = (try ((std).math).add(usize, (operand_98).len, 1));

            if ((!(((buffers).lane_4.?).started).*)) {
                (try ((((buffers).lane_4.?).buffer).*).appendSlice(allocator, operand_98));
                (((buffers).lane_4.?).started).* = true;
            } else {
                (((((buffers).lane_4.?).buffer).*).items).len = (operand_98).len;
            }

            (try ((((buffers).lane_4.?).buffer).*).append(allocator, operand_99));

            break :block_100 ((((buffers).lane_4.?).buffer).*).items;
        } else (block_104: {
            const operand_101 = ((in).delta).kinds;
            const operand_102 = value_1;
            const operand_103 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_101).len, 1))));

            @memcpy((operand_103)[0..(operand_101).len], operand_101);

            (operand_103)[(operand_101).len] = operand_102;

            break :block_104 @as((zx_abi).zx_type_38, .{ operand_103, {}, });
        }).@"0"));

        const operand_105 = @as([]const u32, (if (((buffers).lane_3 != null)) block_108: {
            const operand_106 = ((in).delta).first;
            const operand_107 = value_3;

            _ = (try ((std).math).add(usize, (operand_106).len, 1));

            if ((!(((buffers).lane_3.?).started).*)) {
                (try ((((buffers).lane_3.?).buffer).*).appendSlice(allocator, operand_106));
                (((buffers).lane_3.?).started).* = true;
            } else {
                (((((buffers).lane_3.?).buffer).*).items).len = (operand_106).len;
            }

            (try ((((buffers).lane_3.?).buffer).*).append(allocator, operand_107));

            break :block_108 ((((buffers).lane_3.?).buffer).*).items;
        } else (block_112: {
            const operand_109 = ((in).delta).first;
            const operand_110 = value_3;
            const operand_111 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_109).len, 1))));

            @memcpy((operand_111)[0..(operand_109).len], operand_109);

            (operand_111)[(operand_109).len] = operand_110;

            break :block_112 @as((zx_abi).zx_type_39, .{ operand_111, {}, });
        }).@"0"));

        const operand_113 = @as([]const u32, (if (((buffers).lane_7 != null)) block_116: {
            const operand_114 = ((in).delta).second;
            const operand_115 = value_4;

            _ = (try ((std).math).add(usize, (operand_114).len, 1));

            if ((!(((buffers).lane_7.?).started).*)) {
                (try ((((buffers).lane_7.?).buffer).*).appendSlice(allocator, operand_114));
                (((buffers).lane_7.?).started).* = true;
            } else {
                (((((buffers).lane_7.?).buffer).*).items).len = (operand_114).len;
            }

            (try ((((buffers).lane_7.?).buffer).*).append(allocator, operand_115));

            break :block_116 ((((buffers).lane_7.?).buffer).*).items;
        } else (block_120: {
            const operand_117 = ((in).delta).second;
            const operand_118 = value_4;
            const operand_119 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_117).len, 1))));

            @memcpy((operand_119)[0..(operand_117).len], operand_117);

            (operand_119)[(operand_117).len] = operand_118;

            break :block_120 @as((zx_abi).zx_type_39, .{ operand_119, {}, });
        }).@"0"));

        const operand_121 = @as([]const []const u8, (if (((buffers).lane_5 != null)) block_124: {
            const operand_122 = ((in).delta).labels;
            const operand_123 = ((in).candidate).label;

            _ = (try ((std).math).add(usize, (operand_122).len, 1));

            if ((!(((buffers).lane_5.?).started).*)) {
                (try ((((buffers).lane_5.?).buffer).*).appendSlice(allocator, operand_122));
                (((buffers).lane_5.?).started).* = true;
            } else {
                (((((buffers).lane_5.?).buffer).*).items).len = (operand_122).len;
            }

            (try ((((buffers).lane_5.?).buffer).*).append(allocator, operand_123));

            break :block_124 ((((buffers).lane_5.?).buffer).*).items;
        } else (block_128: {
            const operand_125 = ((in).delta).labels;
            const operand_126 = ((in).candidate).label;
            const operand_127 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_125).len, 1))));

            @memcpy((operand_127)[0..(operand_125).len], operand_125);

            (operand_127)[(operand_125).len] = operand_126;

            break :block_128 @as((zx_abi).zx_type_40, .{ operand_127, {}, });
        }).@"0"));

        const operand_129 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) @as([]const u32, (if (((buffers).lane_0 != null)) block_132: {
            const operand_130 = ((in).delta).children;
            const operand_131 = ((in).candidate).children;

            _ = (try ((std).math).add(usize, (operand_130).len, (operand_131).len));

            if ((!(((buffers).lane_0.?).started).*)) {
                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_130));
                (((buffers).lane_0.?).started).* = true;
            } else {
                (((((buffers).lane_0.?).buffer).*).items).len = (operand_130).len;
            }

            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_131));

            break :block_132 ((((buffers).lane_0.?).buffer).*).items;
        } else (block_136: {
            const operand_133 = ((in).delta).children;
            const operand_134 = ((in).candidate).children;
            const operand_135 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_133).len, (operand_134).len))));

            @memcpy((operand_135)[0..(operand_133).len], operand_133);
            @memcpy((operand_135)[(operand_133).len..], operand_134);

            break :block_136 @as((zx_abi).zx_type_39, .{ operand_135, {}, });
        }).@"0")) else ((in).delta).children);

        const operand_137 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) @as([]const u32, (if (((buffers).lane_2 != null)) block_140: {
            const operand_138 = ((in).delta).field_types;
            const operand_139 = (((in).candidate).fields).types;

            _ = (try ((std).math).add(usize, (operand_138).len, (operand_139).len));

            if ((!(((buffers).lane_2.?).started).*)) {
                (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_138));
                (((buffers).lane_2.?).started).* = true;
            } else {
                (((((buffers).lane_2.?).buffer).*).items).len = (operand_138).len;
            }

            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_139));

            break :block_140 ((((buffers).lane_2.?).buffer).*).items;
        } else (block_144: {
            const operand_141 = ((in).delta).field_types;
            const operand_142 = (((in).candidate).fields).types;
            const operand_143 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_141).len, (operand_142).len))));

            @memcpy((operand_143)[0..(operand_141).len], operand_141);
            @memcpy((operand_143)[(operand_141).len..], operand_142);

            break :block_144 @as((zx_abi).zx_type_39, .{ operand_143, {}, });
        }).@"0")) else ((in).delta).field_types);

        const operand_145 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) @as([]const []const u8, (if (((buffers).lane_1 != null)) block_148: {
            const operand_146 = ((in).delta).field_names;
            const operand_147 = (((in).candidate).fields).names;

            _ = (try ((std).math).add(usize, (operand_146).len, (operand_147).len));

            if ((!(((buffers).lane_1.?).started).*)) {
                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_146));
                (((buffers).lane_1.?).started).* = true;
            } else {
                (((((buffers).lane_1.?).buffer).*).items).len = (operand_146).len;
            }

            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_147));

            break :block_148 ((((buffers).lane_1.?).buffer).*).items;
        } else (block_152: {
            const operand_149 = ((in).delta).field_names;
            const operand_150 = (((in).candidate).fields).names;
            const operand_151 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_149).len, (operand_150).len))));

            @memcpy((operand_151)[0..(operand_149).len], operand_149);
            @memcpy((operand_151)[(operand_149).len..], operand_150);

            break :block_152 @as((zx_abi).zx_type_40, .{ operand_151, {}, });
        }).@"0")) else ((in).delta).field_names);

        const operand_153 = (if (value_2) @as([]const []const u8, (if (((buffers).lane_6 != null)) block_156: {
            const operand_154 = ((in).delta).names;
            const operand_155 = ((in).candidate).names;

            _ = (try ((std).math).add(usize, (operand_154).len, (operand_155).len));

            if ((!(((buffers).lane_6.?).started).*)) {
                (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_154));
                (((buffers).lane_6.?).started).* = true;
            } else {
                (((((buffers).lane_6.?).buffer).*).items).len = (operand_154).len;
            }

            (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_155));

            break :block_156 ((((buffers).lane_6.?).buffer).*).items;
        } else (block_160: {
            const operand_157 = ((in).delta).names;
            const operand_158 = ((in).candidate).names;
            const operand_159 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_157).len, (operand_158).len))));

            @memcpy((operand_159)[0..(operand_157).len], operand_157);
            @memcpy((operand_159)[(operand_157).len..], operand_158);

            break :block_160 @as((zx_abi).zx_type_40, .{ operand_159, {}, });
        }).@"0")) else ((in).delta).names);

        break :block_161 (zx_abi).zx_type_15{ .kinds = operand_97, .first = operand_105, .second = operand_113, .labels = operand_121, .children = operand_129, .field_types = operand_137, .field_names = operand_145, .names = operand_153, };
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_41) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = (if ((@as(u64, ((in).left).len) < @as(u64, ((in).right).len))) @as(u64, ((in).left).len) else @as(u64, ((in).right).len));

    const value_13: (zx_abi).zx_type_42 = block_30: {
        const operand_14 = block_13: {
            const operand_8 = (in).left;
            const operand_9 = (in).right;
            const operand_10 = @as(u64, 0);
            const operand_11 = value_1;
            const operand_12 = true;

            break :block_13 (zx_abi).zx_type_42{ .left = operand_8, .right = operand_9, .index = operand_10, .limit = operand_11, .equal = operand_12, };
        };

        var state_7: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = (operand_14).equal, .index = (operand_14).index, .left = (operand_14).left, .limit = (operand_14).limit, .right = (operand_14).right, .zx_origin = (&operand_14), };

        while (((state_7).equal and ((state_7).index < (state_7).limit))) {
            state_7 = block_27: {
                const value_4: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_7;
                _ = (value_4).equal;

                const value_6: bool = (block_23: {
                    const operand_21 = (state_7).left;
                    const operand_22 = (state_7).index;

                    if ((operand_22 >= (operand_21).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_23 (operand_21)[@intCast(operand_22)];
                } == block_26: {
                    const operand_24 = (state_7).right;
                    const operand_25 = (state_7).index;

                    if ((operand_25 >= (operand_24).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_26 (operand_24)[@intCast(operand_25)];
                });

                const value_7: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = block_19: {
                        break :block_19 value_6;
                    }, .index = (value_4).index, .left = (value_4).left, .limit = (value_4).limit, .right = (value_4).right, });
                };

                const value_12: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((value_7).equal) block_18: {
                    const value_8: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_7;
                    const value_9: u64 = (value_8).index;
                    const value_10: u64 = @as(u64, 1);

                    const value_11: (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_17: {
                        break :block_17 @as((zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = (value_8).equal, .index = (block_15: {
                            break :block_15 value_9;
                        } + block_16: {
                            break :block_16 value_10;
                        }), .left = (value_8).left, .limit = (value_8).limit, .right = (value_8).right, });
                    };

                    break :block_18 value_11;
                } else value_7);

                break :block_27 value_12;
            };
        }

        break :block_30 block_29: {
            break :block_29 (if (((state_7).zx_origin != null)) ((state_7).zx_origin.?).* else block_28: {
                break :block_28 (zx_abi).zx_type_42{ .equal = (state_7).equal, .index = (state_7).index, .left = (state_7).left, .limit = (state_7).limit, .right = (state_7).right, };
            });
        };
    };

    return (if ((((&value_13)).index == ((&value_13)).limit)) (@as(u64, (((&value_13)).left).len) < @as(u64, (((&value_13)).right).len)) else (block_3: {
        const operand_1 = ((&value_13)).left;
        const operand_2 = ((&value_13)).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } < block_6: {
        const operand_4 = ((&value_13)).right;
        const operand_5 = ((&value_13)).index;

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    }));
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return in;
    }

    const value_103: *const (zx_abi).zx_type_43 = block_155: {
        const operand_17 = block_16: {
            const operand_7 = (in).names;
            const operand_8 = (in).types;
            const operand_9 = @as(u64, ((in).names).len);
            const operand_10 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_11 = @as(u64, 0);
            const operand_12 = true;
            const operand_13 = false;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_43));

                (operand_14).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{ .names = operand_7, .types = operand_8, .count = operand_9, .remaining = operand_10, .root = operand_11, .building = operand_12, .sifting = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_43, operand_14);
            };
        };

        var state_items_19: [][]const u8 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_6: (zx_abi).zx_type_43 = (operand_17).*;
        var state_changed_18 = false;

        while (((((&state_6)).building or (((&state_6)).count > @as(u64, 1))) or ((&state_6)).sifting)) {
            state_6 = block_151: {
                const value_102: (zx_abi).zx_type_43 = (if (((&state_6)).sifting) block_94: {
                    const value_45: (zx_abi).zx_type_43 = (if ((((&state_6)).root >= @divTrunc(((&state_6)).count, @as(u64, 2)))) block_24: {
                        const value_3: (zx_abi).zx_type_43 = ((&state_6)).*;

                        _ = ((&value_3)).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).zx_type_43 = block_23: {
                            break :block_23 (zx_abi).zx_type_43{ .building = ((&value_3)).building, .count = ((&value_3)).count, .names = ((&value_3)).names, .remaining = ((&value_3)).remaining, .root = ((&value_3)).root, .sifting = value_5, .types = ((&value_3)).types, };
                        };

                        break :block_24 ((&value_6)).*;
                    } else block_93: {
                        const value_7: u64 = ((((&state_6)).root * @as(u64, 2)) + @as(u64, 1));
                        const value_8: u64 = (value_7 + @as(u64, 1));

                        const value_9: u64 = (if (((value_8 < ((&state_6)).count) and block_92: {
                            const operand_86 = block_85: {
                                const operand_83 = ((&state_6)).names;
                                const operand_84 = value_7;

                                if ((operand_84 >= (operand_83).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_85 (operand_83)[@intCast(operand_84)];
                            };
                            const operand_90 = block_89: {
                                const operand_87 = ((&state_6)).names;
                                const operand_88 = value_8;

                                if ((operand_88 >= (operand_87).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_89 (operand_87)[@intCast(operand_88)];
                            };
                            const operand_91 = (zx_abi).zx_type_41{ .left = operand_86, .right = operand_90, };

                            break :block_92 (try function_12(allocator, (&operand_91)));
                        })) value_8 else value_7);

                        const value_44: (zx_abi).zx_type_43 = (if (block_34: {
                            const operand_28 = block_27: {
                                const operand_25 = ((&state_6)).names;
                                const operand_26 = ((&state_6)).root;

                                if ((operand_26 >= (operand_25).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_27 (operand_25)[@intCast(operand_26)];
                            };
                            const operand_32 = block_31: {
                                const operand_29 = ((&state_6)).names;
                                const operand_30 = value_9;

                                if ((operand_30 >= (operand_29).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_31 (operand_29)[@intCast(operand_30)];
                            };

                            const operand_33 = (zx_abi).zx_type_41{ .left = operand_28, .right = operand_32, };

                            break :block_34 (try function_12(allocator, (&operand_33)));
                        }) block_80: {
                            const value_10: []const u8 = block_79: {
                                const operand_77 = ((&state_6)).names;
                                const operand_78 = ((&state_6)).root;

                                if ((operand_78 >= (operand_77).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_79 (operand_77)[@intCast(operand_78)];
                            };
                            const value_11: u32 = block_76: {
                                const operand_74 = ((&state_6)).types;
                                const operand_75 = ((&state_6)).root;

                                if ((operand_75 >= (operand_74).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_76 (operand_74)[@intCast(operand_75)];
                            };
                            const value_12: (zx_abi).zx_type_43 = ((&state_6)).*;
                            const value_13: []const []const u8 = ((&value_12)).names;
                            const value_14: u64 = ((&state_6)).root;

                            _ = block_73: {
                                const operand_71 = value_13;
                                const operand_72 = value_14;

                                if ((operand_72 >= (operand_71).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_73 (operand_71)[@intCast(operand_72)];
                            };
                            const value_16: []const u8 = block_70: {
                                const operand_68 = ((&state_6)).names;
                                const operand_69 = value_9;

                                if ((operand_69 >= (operand_68).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_70 (operand_68)[@intCast(operand_69)];
                            };
                            const value_17: (zx_abi).zx_type_43 = block_67: {
                                break :block_67 (zx_abi).zx_type_43{ .building = ((&value_12)).building, .count = ((&value_12)).count, .names = block_66: {
                                    const operand_63 = value_13;
                                    const operand_64 = value_14;
                                    const operand_65 = value_16;

                                    if ((operand_64 >= (operand_63).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_20)) {
                                        state_items_19 = (try (allocator).dupe([]const u8, operand_63));
                                        state_items_started_20 = true;
                                    }

                                    (state_items_19)[@intCast(operand_64)] = operand_65;

                                    break :block_66 state_items_19;
                                }, .remaining = ((&value_12)).remaining, .root = ((&value_12)).root, .sifting = ((&value_12)).sifting, .types = ((&value_12)).types, };
                            };
                            const value_18: (zx_abi).zx_type_43 = ((&value_17)).*;
                            const value_19: []const u32 = ((&value_18)).types;
                            const value_20: u64 = ((&value_17)).root;

                            _ = block_62: {
                                const operand_60 = value_19;
                                const operand_61 = value_20;

                                if ((operand_61 >= (operand_60).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_62 (operand_60)[@intCast(operand_61)];
                            };
                            const value_22: u32 = block_59: {
                                const operand_57 = ((&value_17)).types;
                                const operand_58 = value_9;

                                if ((operand_58 >= (operand_57).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_59 (operand_57)[@intCast(operand_58)];
                            };
                            const value_23: (zx_abi).zx_type_43 = block_56: {
                                break :block_56 (zx_abi).zx_type_43{ .building = ((&value_18)).building, .count = ((&value_18)).count, .names = ((&value_18)).names, .remaining = ((&value_18)).remaining, .root = ((&value_18)).root, .sifting = ((&value_18)).sifting, .types = block_55: {
                                    const operand_52 = value_19;
                                    const operand_53 = value_20;
                                    const operand_54 = value_22;

                                    if ((operand_53 >= (operand_52).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_22)) {
                                        state_items_21 = (try (allocator).dupe(u32, operand_52));
                                        state_items_started_22 = true;
                                    }

                                    (state_items_21)[@intCast(operand_53)] = operand_54;

                                    break :block_55 state_items_21;
                                }, };
                            };
                            const value_24: (zx_abi).zx_type_43 = ((&value_23)).*;
                            const value_25: []const []const u8 = ((&value_24)).names;
                            const value_26: u64 = value_9;
                            _ = block_51: {
                                const operand_49 = value_25;
                                const operand_50 = value_26;

                                if ((operand_50 >= (operand_49).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_51 (operand_49)[@intCast(operand_50)];
                            };
                            const value_28: []const u8 = value_10;

                            const value_29: (zx_abi).zx_type_43 = block_48: {
                                break :block_48 (zx_abi).zx_type_43{ .building = ((&value_24)).building, .count = ((&value_24)).count, .names = block_47: {
                                    const operand_44 = value_25;
                                    const operand_45 = value_26;
                                    const operand_46 = value_28;

                                    if ((operand_45 >= (operand_44).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_20)) {
                                        state_items_19 = (try (allocator).dupe([]const u8, operand_44));
                                        state_items_started_20 = true;
                                    }

                                    (state_items_19)[@intCast(operand_45)] = operand_46;

                                    break :block_47 state_items_19;
                                }, .remaining = ((&value_24)).remaining, .root = ((&value_24)).root, .sifting = ((&value_24)).sifting, .types = ((&value_24)).types, };
                            };
                            const value_30: (zx_abi).zx_type_43 = ((&value_29)).*;
                            const value_31: []const u32 = ((&value_30)).types;
                            const value_32: u64 = value_9;
                            _ = block_43: {
                                const operand_41 = value_31;
                                const operand_42 = value_32;

                                if ((operand_42 >= (operand_41).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_43 (operand_41)[@intCast(operand_42)];
                            };
                            const value_34: u32 = value_11;

                            const value_35: (zx_abi).zx_type_43 = block_40: {
                                break :block_40 (zx_abi).zx_type_43{ .building = ((&value_30)).building, .count = ((&value_30)).count, .names = ((&value_30)).names, .remaining = ((&value_30)).remaining, .root = ((&value_30)).root, .sifting = ((&value_30)).sifting, .types = block_39: {
                                    const operand_36 = value_31;
                                    const operand_37 = value_32;
                                    const operand_38 = value_34;

                                    if ((operand_37 >= (operand_36).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_22)) {
                                        state_items_21 = (try (allocator).dupe(u32, operand_36));
                                        state_items_started_22 = true;
                                    }

                                    (state_items_21)[@intCast(operand_37)] = operand_38;

                                    break :block_39 state_items_21;
                                }, };
                            };
                            const value_36: (zx_abi).zx_type_43 = ((&value_35)).*;

                            _ = ((&value_36)).root;
                            const value_38: u64 = value_9;

                            const value_39: (zx_abi).zx_type_43 = block_35: {
                                break :block_35 (zx_abi).zx_type_43{ .building = ((&value_36)).building, .count = ((&value_36)).count, .names = ((&value_36)).names, .remaining = ((&value_36)).remaining, .root = value_38, .sifting = ((&value_36)).sifting, .types = ((&value_36)).types, };
                            };

                            break :block_80 ((&value_39)).*;
                        } else block_82: {
                            const value_40: (zx_abi).zx_type_43 = ((&state_6)).*;

                            _ = ((&value_40)).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).zx_type_43 = block_81: {
                                break :block_81 (zx_abi).zx_type_43{ .building = ((&value_40)).building, .count = ((&value_40)).count, .names = ((&value_40)).names, .remaining = ((&value_40)).remaining, .root = ((&value_40)).root, .sifting = value_42, .types = ((&value_40)).types, };
                            };

                            break :block_82 ((&value_43)).*;
                        });

                        break :block_93 ((&value_44)).*;
                    });

                    break :block_94 ((&value_45)).*;
                } else block_150: {
                    const value_101: (zx_abi).zx_type_43 = (if (((&state_6)).building) block_101: {
                        const value_62: (zx_abi).zx_type_43 = (if ((((&state_6)).remaining == @as(u64, 0))) block_96: {
                            const value_46: (zx_abi).zx_type_43 = ((&state_6)).*;
                            _ = ((&value_46)).building;
                            const value_48: bool = false;
                            const value_49: (zx_abi).zx_type_43 = block_95: {
                                break :block_95 (zx_abi).zx_type_43{ .building = value_48, .count = ((&value_46)).count, .names = ((&value_46)).names, .remaining = ((&value_46)).remaining, .root = ((&value_46)).root, .sifting = ((&value_46)).sifting, .types = ((&value_46)).types, };
                            };

                            break :block_96 ((&value_49)).*;
                        } else block_100: {
                            const value_50: (zx_abi).zx_type_43 = ((&state_6)).*;
                            const value_51: u64 = ((&value_50)).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).zx_type_43 = block_99: {
                                break :block_99 (zx_abi).zx_type_43{ .building = ((&value_50)).building, .count = ((&value_50)).count, .names = ((&value_50)).names, .remaining = (value_51 - value_52), .root = ((&value_50)).root, .sifting = ((&value_50)).sifting, .types = ((&value_50)).types, };
                            };
                            const value_54: (zx_abi).zx_type_43 = ((&value_53)).*;

                            _ = ((&value_54)).root;

                            const value_56: u64 = ((&value_53)).remaining;

                            const value_57: (zx_abi).zx_type_43 = block_98: {
                                break :block_98 (zx_abi).zx_type_43{ .building = ((&value_54)).building, .count = ((&value_54)).count, .names = ((&value_54)).names, .remaining = ((&value_54)).remaining, .root = value_56, .sifting = ((&value_54)).sifting, .types = ((&value_54)).types, };
                            };
                            const value_58: (zx_abi).zx_type_43 = ((&value_57)).*;

                            _ = ((&value_58)).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).zx_type_43 = block_97: {
                                break :block_97 (zx_abi).zx_type_43{ .building = ((&value_58)).building, .count = ((&value_58)).count, .names = ((&value_58)).names, .remaining = ((&value_58)).remaining, .root = ((&value_58)).root, .sifting = value_60, .types = ((&value_58)).types, };
                            };

                            break :block_100 ((&value_61)).*;
                        });

                        break :block_101 ((&value_62)).*;
                    } else block_149: {
                        const value_63: (zx_abi).zx_type_43 = ((&state_6)).*;
                        const value_64: u64 = ((&value_63)).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).zx_type_43 = block_148: {
                            break :block_148 (zx_abi).zx_type_43{ .building = ((&value_63)).building, .count = (value_64 - value_65), .names = ((&value_63)).names, .remaining = ((&value_63)).remaining, .root = ((&value_63)).root, .sifting = ((&value_63)).sifting, .types = ((&value_63)).types, };
                        };
                        const value_67: []const u8 = block_147: {
                            const operand_145 = ((&value_66)).names;
                            const operand_146 = @as(u64, 0);

                            if ((operand_146 >= (operand_145).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_147 (operand_145)[@intCast(operand_146)];
                        };
                        const value_68: u32 = block_144: {
                            const operand_142 = ((&value_66)).types;
                            const operand_143 = @as(u64, 0);

                            if ((operand_143 >= (operand_142).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_144 (operand_142)[@intCast(operand_143)];
                        };

                        const value_69: (zx_abi).zx_type_43 = ((&value_66)).*;
                        const value_70: []const []const u8 = ((&value_69)).names;
                        const value_71: u64 = @as(u64, 0);

                        _ = block_141: {
                            const operand_139 = value_70;
                            const operand_140 = value_71;

                            if ((operand_140 >= (operand_139).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_141 (operand_139)[@intCast(operand_140)];
                        };
                        const value_73: []const u8 = block_138: {
                            const operand_136 = ((&value_66)).names;
                            const operand_137 = ((&value_66)).count;

                            if ((operand_137 >= (operand_136).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_138 (operand_136)[@intCast(operand_137)];
                        };
                        const value_74: (zx_abi).zx_type_43 = block_135: {
                            break :block_135 (zx_abi).zx_type_43{ .building = ((&value_69)).building, .count = ((&value_69)).count, .names = block_134: {
                                const operand_131 = value_70;
                                const operand_132 = value_71;
                                const operand_133 = value_73;

                                if ((operand_132 >= (operand_131).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_20)) {
                                    state_items_19 = (try (allocator).dupe([]const u8, operand_131));
                                    state_items_started_20 = true;
                                }

                                (state_items_19)[@intCast(operand_132)] = operand_133;

                                break :block_134 state_items_19;
                            }, .remaining = ((&value_69)).remaining, .root = ((&value_69)).root, .sifting = ((&value_69)).sifting, .types = ((&value_69)).types, };
                        };

                        const value_75: (zx_abi).zx_type_43 = ((&value_74)).*;
                        const value_76: []const u32 = ((&value_75)).types;
                        const value_77: u64 = @as(u64, 0);

                        _ = block_130: {
                            const operand_128 = value_76;
                            const operand_129 = value_77;

                            if ((operand_129 >= (operand_128).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_130 (operand_128)[@intCast(operand_129)];
                        };
                        const value_79: u32 = block_127: {
                            const operand_125 = ((&value_74)).types;
                            const operand_126 = ((&value_74)).count;

                            if ((operand_126 >= (operand_125).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_127 (operand_125)[@intCast(operand_126)];
                        };
                        const value_80: (zx_abi).zx_type_43 = block_124: {
                            break :block_124 (zx_abi).zx_type_43{ .building = ((&value_75)).building, .count = ((&value_75)).count, .names = ((&value_75)).names, .remaining = ((&value_75)).remaining, .root = ((&value_75)).root, .sifting = ((&value_75)).sifting, .types = block_123: {
                                const operand_120 = value_76;
                                const operand_121 = value_77;
                                const operand_122 = value_79;

                                if ((operand_121 >= (operand_120).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_22)) {
                                    state_items_21 = (try (allocator).dupe(u32, operand_120));
                                    state_items_started_22 = true;
                                }

                                (state_items_21)[@intCast(operand_121)] = operand_122;

                                break :block_123 state_items_21;
                            }, };
                        };

                        const value_81: (zx_abi).zx_type_43 = ((&value_80)).*;
                        const value_82: []const []const u8 = ((&value_81)).names;
                        const value_83: u64 = ((&value_80)).count;

                        _ = block_119: {
                            const operand_117 = value_82;
                            const operand_118 = value_83;

                            if ((operand_118 >= (operand_117).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_119 (operand_117)[@intCast(operand_118)];
                        };
                        const value_85: []const u8 = value_67;

                        const value_86: (zx_abi).zx_type_43 = block_116: {
                            break :block_116 (zx_abi).zx_type_43{ .building = ((&value_81)).building, .count = ((&value_81)).count, .names = block_115: {
                                const operand_112 = value_82;
                                const operand_113 = value_83;
                                const operand_114 = value_85;

                                if ((operand_113 >= (operand_112).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_20)) {
                                    state_items_19 = (try (allocator).dupe([]const u8, operand_112));
                                    state_items_started_20 = true;
                                }

                                (state_items_19)[@intCast(operand_113)] = operand_114;

                                break :block_115 state_items_19;
                            }, .remaining = ((&value_81)).remaining, .root = ((&value_81)).root, .sifting = ((&value_81)).sifting, .types = ((&value_81)).types, };
                        };

                        const value_87: (zx_abi).zx_type_43 = ((&value_86)).*;
                        const value_88: []const u32 = ((&value_87)).types;
                        const value_89: u64 = ((&value_86)).count;

                        _ = block_111: {
                            const operand_109 = value_88;
                            const operand_110 = value_89;

                            if ((operand_110 >= (operand_109).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_111 (operand_109)[@intCast(operand_110)];
                        };

                        const value_91: u32 = value_68;

                        const value_92: (zx_abi).zx_type_43 = block_108: {
                            break :block_108 (zx_abi).zx_type_43{ .building = ((&value_87)).building, .count = ((&value_87)).count, .names = ((&value_87)).names, .remaining = ((&value_87)).remaining, .root = ((&value_87)).root, .sifting = ((&value_87)).sifting, .types = block_107: {
                                const operand_104 = value_88;
                                const operand_105 = value_89;
                                const operand_106 = value_91;

                                if ((operand_105 >= (operand_104).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_22)) {
                                    state_items_21 = (try (allocator).dupe(u32, operand_104));
                                    state_items_started_22 = true;
                                }

                                (state_items_21)[@intCast(operand_105)] = operand_106;

                                break :block_107 state_items_21;
                            }, };
                        };
                        const value_93: (zx_abi).zx_type_43 = ((&value_92)).*;

                        _ = ((&value_93)).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).zx_type_43 = block_103: {
                            break :block_103 (zx_abi).zx_type_43{ .building = ((&value_93)).building, .count = ((&value_93)).count, .names = ((&value_93)).names, .remaining = ((&value_93)).remaining, .root = value_95, .sifting = ((&value_93)).sifting, .types = ((&value_93)).types, };
                        };
                        const value_97: (zx_abi).zx_type_43 = ((&value_96)).*;

                        _ = ((&value_97)).sifting;

                        const value_99: bool = true;

                        const value_100: (zx_abi).zx_type_43 = block_102: {
                            break :block_102 (zx_abi).zx_type_43{ .building = ((&value_97)).building, .count = ((&value_97)).count, .names = ((&value_97)).names, .remaining = ((&value_97)).remaining, .root = ((&value_97)).root, .sifting = value_99, .types = ((&value_97)).types, };
                        };

                        break :block_149 ((&value_100)).*;
                    });

                    break :block_150 ((&value_101)).*;
                });

                break :block_151 ((&value_102)).*;
            };

            state_changed_18 = true;
        }

        break :block_155 (if (state_changed_18) block_154: {
            const operand_153 = (try (allocator).create((zx_abi).zx_type_43));

            (operand_153).* = @as((zx_abi).zx_type_43, state_6);

            break :block_154 @as(*const (zx_abi).zx_type_43, operand_153);
        } else operand_17);
    };

    return block_5: {
        const operand_1 = (value_103).names;
        const operand_2 = (value_103).types;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_3).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_1, .types = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_18, operand_3);
        };
    };
}

fn function_13_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return (in).*;
    }

    const value_103: (zx_abi).zx_type_43 = block_372: {
        const operand_168 = block_167: {
            const operand_160 = (in).names;
            const operand_161 = (in).types;
            const operand_162 = @as(u64, ((in).names).len);
            const operand_163 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_164 = @as(u64, 0);
            const operand_165 = true;
            const operand_166 = false;

            break :block_167 (zx_abi).zx_type_43{ .names = operand_160, .types = operand_161, .count = operand_162, .remaining = operand_163, .root = operand_164, .building = operand_165, .sifting = operand_166, };
        };

        var state_items_169: [][]const u8 = undefined;
        var state_items_started_170 = false;
        var state_items_171: []u32 = undefined;
        var state_items_started_172 = false;
        var state_159: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (operand_168).building, .count = (operand_168).count, .names = (operand_168).names, .remaining = (operand_168).remaining, .root = (operand_168).root, .sifting = (operand_168).sifting, .types = (operand_168).types, .zx_origin = (&operand_168), };

        while ((((state_159).building or ((state_159).count > @as(u64, 1))) or (state_159).sifting)) {
            state_159 = block_369: {
                const value_102: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).sifting) block_281: {
                    const value_45: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).root >= @divTrunc((state_159).count, @as(u64, 2)))) block_175: {
                        const value_3: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        _ = (value_3).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_174: {
                            break :block_174 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_3).building, .count = (value_3).count, .names = (value_3).names, .remaining = (value_3).remaining, .root = (value_3).root, .sifting = block_173: {
                                break :block_173 value_5;
                            }, .types = (value_3).types, });
                        };

                        break :block_175 value_6;
                    } else block_280: {
                        const value_7: u64 = (((state_159).root * @as(u64, 2)) + @as(u64, 1));

                        const value_8: u64 = (block_279: {
                            break :block_279 value_7;
                        } + @as(u64, 1));
                        const value_9: u64 = (if (((block_264: {
                            break :block_264 value_8;
                        } < (state_159).count) and block_276: {
                            const operand_269 = block_268: {
                                const operand_266 = (state_159).names;

                                const operand_267 = block_265: {
                                    break :block_265 value_7;
                                };

                                if ((operand_267 >= (operand_266).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_268 (operand_266)[@intCast(operand_267)];
                            };
                            const operand_274 = block_273: {
                                const operand_271 = (state_159).names;

                                const operand_272 = block_270: {
                                    break :block_270 value_8;
                                };

                                if ((operand_272 >= (operand_271).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_273 (operand_271)[@intCast(operand_272)];
                            };

                            const operand_275 = (zx_abi).zx_type_41{ .left = operand_269, .right = operand_274, };

                            break :block_276 (try function_12(allocator, (&operand_275)));
                        })) block_277: {
                            break :block_277 value_8;
                        } else block_278: {
                            break :block_278 value_7;
                        });

                        const value_44: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (block_186: {
                            const operand_179 = block_178: {
                                const operand_176 = (state_159).names;
                                const operand_177 = (state_159).root;

                                if ((operand_177 >= (operand_176).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_178 (operand_176)[@intCast(operand_177)];
                            };
                            const operand_184 = block_183: {
                                const operand_181 = (state_159).names;

                                const operand_182 = block_180: {
                                    break :block_180 value_9;
                                };

                                if ((operand_182 >= (operand_181).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_183 (operand_181)[@intCast(operand_182)];
                            };

                            const operand_185 = (zx_abi).zx_type_41{ .left = operand_179, .right = operand_184, };

                            break :block_186 (try function_12(allocator, (&operand_185)));
                        }) block_260: {
                            const value_10: []const u8 = block_259: {
                                const operand_257 = (state_159).names;
                                const operand_258 = (state_159).root;

                                if ((operand_258 >= (operand_257).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_259 (operand_257)[@intCast(operand_258)];
                            };
                            const value_11: u32 = block_256: {
                                const operand_254 = (state_159).types;
                                const operand_255 = (state_159).root;

                                if ((operand_255 >= (operand_254).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_256 (operand_254)[@intCast(operand_255)];
                            };
                            const value_12: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_13: []const []const u8 = (value_12).names;
                            const value_14: u64 = (state_159).root;
                            _ = block_253: {
                                const operand_251 = block_249: {
                                    break :block_249 value_13;
                                };
                                const operand_252 = block_250: {
                                    break :block_250 value_14;
                                };

                                if ((operand_252 >= (operand_251).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_253 (operand_251)[@intCast(operand_252)];
                            };
                            const value_16: []const u8 = block_248: {
                                const operand_246 = (state_159).names;

                                const operand_247 = block_245: {
                                    break :block_245 value_9;
                                };

                                if ((operand_247 >= (operand_246).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_248 (operand_246)[@intCast(operand_247)];
                            };
                            const value_17: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_244: {
                                break :block_244 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_12).building, .count = (value_12).count, .names = block_243: {
                                    const operand_238 = block_237: {
                                        break :block_237 value_13;
                                    };
                                    const operand_240 = block_239: {
                                        break :block_239 value_14;
                                    };
                                    const operand_242 = block_241: {
                                        break :block_241 value_16;
                                    };

                                    if ((operand_240 >= (operand_238).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_170)) {
                                        state_items_169 = (try (allocator).dupe([]const u8, operand_238));
                                        state_items_started_170 = true;
                                    }

                                    (state_items_169)[@intCast(operand_240)] = operand_242;
                                    break :block_243 state_items_169;
                                }, .remaining = (value_12).remaining, .root = (value_12).root, .sifting = (value_12).sifting, .types = (value_12).types, });
                            };
                            const value_18: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_17;
                            const value_19: []const u32 = (value_18).types;
                            const value_20: u64 = (value_17).root;
                            _ = block_236: {
                                const operand_234 = block_232: {
                                    break :block_232 value_19;
                                };
                                const operand_235 = block_233: {
                                    break :block_233 value_20;
                                };

                                if ((operand_235 >= (operand_234).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_236 (operand_234)[@intCast(operand_235)];
                            };
                            const value_22: u32 = block_231: {
                                const operand_229 = (value_17).types;

                                const operand_230 = block_228: {
                                    break :block_228 value_9;
                                };

                                if ((operand_230 >= (operand_229).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_231 (operand_229)[@intCast(operand_230)];
                            };
                            const value_23: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_227: {
                                break :block_227 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_18).building, .count = (value_18).count, .names = (value_18).names, .remaining = (value_18).remaining, .root = (value_18).root, .sifting = (value_18).sifting, .types = block_226: {
                                    const operand_221 = block_220: {
                                        break :block_220 value_19;
                                    };
                                    const operand_223 = block_222: {
                                        break :block_222 value_20;
                                    };
                                    const operand_225 = block_224: {
                                        break :block_224 value_22;
                                    };

                                    if ((operand_223 >= (operand_221).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_172)) {
                                        state_items_171 = (try (allocator).dupe(u32, operand_221));
                                        state_items_started_172 = true;
                                    }

                                    (state_items_171)[@intCast(operand_223)] = operand_225;

                                    break :block_226 state_items_171;
                                }, });
                            };
                            const value_24: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_23;
                            const value_25: []const []const u8 = (value_24).names;

                            const value_26: u64 = block_219: {
                                break :block_219 value_9;
                            };
                            _ = block_218: {
                                const operand_216 = block_214: {
                                    break :block_214 value_25;
                                };
                                const operand_217 = block_215: {
                                    break :block_215 value_26;
                                };

                                if ((operand_217 >= (operand_216).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_218 (operand_216)[@intCast(operand_217)];
                            };
                            const value_28: []const u8 = block_213: {
                                break :block_213 value_10;
                            };
                            const value_29: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_212: {
                                break :block_212 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_24).building, .count = (value_24).count, .names = block_211: {
                                    const operand_206 = block_205: {
                                        break :block_205 value_25;
                                    };
                                    const operand_208 = block_207: {
                                        break :block_207 value_26;
                                    };
                                    const operand_210 = block_209: {
                                        break :block_209 value_28;
                                    };

                                    if ((operand_208 >= (operand_206).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_170)) {
                                        state_items_169 = (try (allocator).dupe([]const u8, operand_206));
                                        state_items_started_170 = true;
                                    }

                                    (state_items_169)[@intCast(operand_208)] = operand_210;
                                    break :block_211 state_items_169;
                                }, .remaining = (value_24).remaining, .root = (value_24).root, .sifting = (value_24).sifting, .types = (value_24).types, });
                            };
                            const value_30: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_29;
                            const value_31: []const u32 = (value_30).types;
                            const value_32: u64 = block_204: {
                                break :block_204 value_9;
                            };
                            _ = block_203: {
                                const operand_201 = block_199: {
                                    break :block_199 value_31;
                                };
                                const operand_202 = block_200: {
                                    break :block_200 value_32;
                                };

                                if ((operand_202 >= (operand_201).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_203 (operand_201)[@intCast(operand_202)];
                            };
                            const value_34: u32 = block_198: {
                                break :block_198 value_11;
                            };
                            const value_35: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_197: {
                                break :block_197 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_30).building, .count = (value_30).count, .names = (value_30).names, .remaining = (value_30).remaining, .root = (value_30).root, .sifting = (value_30).sifting, .types = block_196: {
                                    const operand_191 = block_190: {
                                        break :block_190 value_31;
                                    };
                                    const operand_193 = block_192: {
                                        break :block_192 value_32;
                                    };
                                    const operand_195 = block_194: {
                                        break :block_194 value_34;
                                    };

                                    if ((operand_193 >= (operand_191).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_172)) {
                                        state_items_171 = (try (allocator).dupe(u32, operand_191));
                                        state_items_started_172 = true;
                                    }

                                    (state_items_171)[@intCast(operand_193)] = operand_195;

                                    break :block_196 state_items_171;
                                }, });
                            };
                            const value_36: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_35;

                            _ = (value_36).root;

                            const value_38: u64 = block_189: {
                                break :block_189 value_9;
                            };
                            const value_39: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_188: {
                                break :block_188 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_36).building, .count = (value_36).count, .names = (value_36).names, .remaining = (value_36).remaining, .root = block_187: {
                                    break :block_187 value_38;
                                }, .sifting = (value_36).sifting, .types = (value_36).types, });
                            };

                            break :block_260 value_39;
                        } else block_263: {
                            const value_40: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_40).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_262: {
                                break :block_262 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_40).building, .count = (value_40).count, .names = (value_40).names, .remaining = (value_40).remaining, .root = (value_40).root, .sifting = block_261: {
                                    break :block_261 value_42;
                                }, .types = (value_40).types, });
                            };

                            break :block_263 value_43;
                        });

                        break :block_280 value_44;
                    });

                    break :block_281 value_45;
                } else block_368: {
                    const value_101: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).building) block_293: {
                        const value_62: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).remaining == @as(u64, 0))) block_284: {
                            const value_46: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_46).building;
                            const value_48: bool = false;

                            const value_49: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_283: {
                                break :block_283 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = block_282: {
                                    break :block_282 value_48;
                                }, .count = (value_46).count, .names = (value_46).names, .remaining = (value_46).remaining, .root = (value_46).root, .sifting = (value_46).sifting, .types = (value_46).types, });
                            };

                            break :block_284 value_49;
                        } else block_292: {
                            const value_50: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_51: u64 = (value_50).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_291: {
                                break :block_291 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_50).building, .count = (value_50).count, .names = (value_50).names, .remaining = (block_289: {
                                    break :block_289 value_51;
                                } - block_290: {
                                    break :block_290 value_52;
                                }), .root = (value_50).root, .sifting = (value_50).sifting, .types = (value_50).types, });
                            };
                            const value_54: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_53;
                            _ = (value_54).root;
                            const value_56: u64 = (value_53).remaining;

                            const value_57: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_288: {
                                break :block_288 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_54).building, .count = (value_54).count, .names = (value_54).names, .remaining = (value_54).remaining, .root = block_287: {
                                    break :block_287 value_56;
                                }, .sifting = (value_54).sifting, .types = (value_54).types, });
                            };
                            const value_58: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_57;

                            _ = (value_58).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_286: {
                                break :block_286 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_58).building, .count = (value_58).count, .names = (value_58).names, .remaining = (value_58).remaining, .root = (value_58).root, .sifting = block_285: {
                                    break :block_285 value_60;
                                }, .types = (value_58).types, });
                            };

                            break :block_292 value_61;
                        });

                        break :block_293 value_62;
                    } else block_367: {
                        const value_63: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        const value_64: u64 = (value_63).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_366: {
                            break :block_366 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_63).building, .count = (block_364: {
                                break :block_364 value_64;
                            } - block_365: {
                                break :block_365 value_65;
                            }), .names = (value_63).names, .remaining = (value_63).remaining, .root = (value_63).root, .sifting = (value_63).sifting, .types = (value_63).types, });
                        };
                        const value_67: []const u8 = block_363: {
                            const operand_361 = (value_66).names;
                            const operand_362 = @as(u64, 0);

                            if ((operand_362 >= (operand_361).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_363 (operand_361)[@intCast(operand_362)];
                        };
                        const value_68: u32 = block_360: {
                            const operand_358 = (value_66).types;
                            const operand_359 = @as(u64, 0);

                            if ((operand_359 >= (operand_358).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_360 (operand_358)[@intCast(operand_359)];
                        };
                        const value_69: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_66;
                        const value_70: []const []const u8 = (value_69).names;
                        const value_71: u64 = @as(u64, 0);

                        _ = block_357: {
                            const operand_355 = block_353: {
                                break :block_353 value_70;
                            };
                            const operand_356 = block_354: {
                                break :block_354 value_71;
                            };

                            if ((operand_356 >= (operand_355).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_357 (operand_355)[@intCast(operand_356)];
                        };
                        const value_73: []const u8 = block_352: {
                            const operand_350 = (value_66).names;
                            const operand_351 = (value_66).count;

                            if ((operand_351 >= (operand_350).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_352 (operand_350)[@intCast(operand_351)];
                        };
                        const value_74: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_349: {
                            break :block_349 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_69).building, .count = (value_69).count, .names = block_348: {
                                const operand_343 = block_342: {
                                    break :block_342 value_70;
                                };
                                const operand_345 = block_344: {
                                    break :block_344 value_71;
                                };
                                const operand_347 = block_346: {
                                    break :block_346 value_73;
                                };

                                if ((operand_345 >= (operand_343).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_170)) {
                                    state_items_169 = (try (allocator).dupe([]const u8, operand_343));
                                    state_items_started_170 = true;
                                }

                                (state_items_169)[@intCast(operand_345)] = operand_347;
                                break :block_348 state_items_169;
                            }, .remaining = (value_69).remaining, .root = (value_69).root, .sifting = (value_69).sifting, .types = (value_69).types, });
                        };

                        const value_75: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_74;
                        const value_76: []const u32 = (value_75).types;
                        const value_77: u64 = @as(u64, 0);
                        _ = block_341: {
                            const operand_339 = block_337: {
                                break :block_337 value_76;
                            };
                            const operand_340 = block_338: {
                                break :block_338 value_77;
                            };

                            if ((operand_340 >= (operand_339).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_341 (operand_339)[@intCast(operand_340)];
                        };
                        const value_79: u32 = block_336: {
                            const operand_334 = (value_74).types;
                            const operand_335 = (value_74).count;

                            if ((operand_335 >= (operand_334).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_336 (operand_334)[@intCast(operand_335)];
                        };
                        const value_80: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_333: {
                            break :block_333 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_75).building, .count = (value_75).count, .names = (value_75).names, .remaining = (value_75).remaining, .root = (value_75).root, .sifting = (value_75).sifting, .types = block_332: {
                                const operand_327 = block_326: {
                                    break :block_326 value_76;
                                };
                                const operand_329 = block_328: {
                                    break :block_328 value_77;
                                };
                                const operand_331 = block_330: {
                                    break :block_330 value_79;
                                };

                                if ((operand_329 >= (operand_327).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_172)) {
                                    state_items_171 = (try (allocator).dupe(u32, operand_327));
                                    state_items_started_172 = true;
                                }

                                (state_items_171)[@intCast(operand_329)] = operand_331;

                                break :block_332 state_items_171;
                            }, });
                        };
                        const value_81: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_80;
                        const value_82: []const []const u8 = (value_81).names;
                        const value_83: u64 = (value_80).count;

                        _ = block_325: {
                            const operand_323 = block_321: {
                                break :block_321 value_82;
                            };
                            const operand_324 = block_322: {
                                break :block_322 value_83;
                            };

                            if ((operand_324 >= (operand_323).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_325 (operand_323)[@intCast(operand_324)];
                        };
                        const value_85: []const u8 = block_320: {
                            break :block_320 value_67;
                        };
                        const value_86: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_319: {
                            break :block_319 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_81).building, .count = (value_81).count, .names = block_318: {
                                const operand_313 = block_312: {
                                    break :block_312 value_82;
                                };
                                const operand_315 = block_314: {
                                    break :block_314 value_83;
                                };
                                const operand_317 = block_316: {
                                    break :block_316 value_85;
                                };

                                if ((operand_315 >= (operand_313).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_170)) {
                                    state_items_169 = (try (allocator).dupe([]const u8, operand_313));
                                    state_items_started_170 = true;
                                }

                                (state_items_169)[@intCast(operand_315)] = operand_317;

                                break :block_318 state_items_169;
                            }, .remaining = (value_81).remaining, .root = (value_81).root, .sifting = (value_81).sifting, .types = (value_81).types, });
                        };

                        const value_87: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_86;
                        const value_88: []const u32 = (value_87).types;
                        const value_89: u64 = (value_86).count;

                        _ = block_311: {
                            const operand_309 = block_307: {
                                break :block_307 value_88;
                            };
                            const operand_310 = block_308: {
                                break :block_308 value_89;
                            };

                            if ((operand_310 >= (operand_309).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_311 (operand_309)[@intCast(operand_310)];
                        };
                        const value_91: u32 = block_306: {
                            break :block_306 value_68;
                        };
                        const value_92: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_305: {
                            break :block_305 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_87).building, .count = (value_87).count, .names = (value_87).names, .remaining = (value_87).remaining, .root = (value_87).root, .sifting = (value_87).sifting, .types = block_304: {
                                const operand_299 = block_298: {
                                    break :block_298 value_88;
                                };
                                const operand_301 = block_300: {
                                    break :block_300 value_89;
                                };
                                const operand_303 = block_302: {
                                    break :block_302 value_91;
                                };

                                if ((operand_301 >= (operand_299).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_172)) {
                                    state_items_171 = (try (allocator).dupe(u32, operand_299));
                                    state_items_started_172 = true;
                                }

                                (state_items_171)[@intCast(operand_301)] = operand_303;

                                break :block_304 state_items_171;
                            }, });
                        };
                        const value_93: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_92;
                        _ = (value_93).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_297: {
                            break :block_297 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_93).building, .count = (value_93).count, .names = (value_93).names, .remaining = (value_93).remaining, .root = block_296: {
                                break :block_296 value_95;
                            }, .sifting = (value_93).sifting, .types = (value_93).types, });
                        };
                        const value_97: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_96;

                        _ = (value_97).sifting;
                        const value_99: bool = true;

                        const value_100: (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_295: {
                            break :block_295 @as((zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_97).building, .count = (value_97).count, .names = (value_97).names, .remaining = (value_97).remaining, .root = (value_97).root, .sifting = block_294: {
                                break :block_294 value_99;
                            }, .types = (value_97).types, });
                        };

                        break :block_367 value_100;
                    });

                    break :block_368 value_101;
                });

                break :block_369 value_102;
            };
        }

        break :block_372 block_371: {
            break :block_371 (if (((state_159).zx_origin != null)) ((state_159).zx_origin.?).* else block_370: {
                break :block_370 (zx_abi).zx_type_43{ .building = (state_159).building, .count = (state_159).count, .names = (state_159).names, .remaining = (state_159).remaining, .root = (state_159).root, .sifting = (state_159).sifting, .types = (state_159).types, };
            });
        };
    };

    return block_158: {
        const operand_156 = ((&value_103)).names;
        const operand_157 = ((&value_103)).types;

        break :block_158 (zx_abi).zx_type_18{ .names = operand_156, .types = operand_157, };
    };
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IntegerOverflow, }!u32 {
    @setRuntimeSafety(true);

    const value_1: u32 = (try function_1(allocator, ((@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len)) + @as(u64, 1))));

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) {
        _ = (try function_1(allocator, ((@as(u64, ((((in).tables).base).children).len) + @as(u64, ((((in).tables).delta).children).len)) + @as(u64, (((in).candidate).children).len))));
    } else {
        if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) {
            _ = (try function_1(allocator, ((@as(u64, ((((in).tables).base).field_types).len) + @as(u64, ((((in).tables).delta).field_types).len)) + @as(u64, ((((in).candidate).fields).types).len))));
            _ = (try function_1(allocator, ((@as(u64, ((((in).tables).base).field_names).len) + @as(u64, ((((in).tables).delta).field_names).len)) + @as(u64, ((((in).candidate).fields).names).len))));
        } else {
            if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)))) {
                _ = (try function_1(allocator, ((@as(u64, ((((in).tables).base).names).len) + @as(u64, ((((in).tables).delta).names).len)) + @as(u64, (((in).candidate).names).len))));
            }
        }
    }

    return (value_1 - @as(u32, 1));
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_47 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Optional)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .List)))) {
        if (((block_32: {
            const operand_26 = (in).tables;
            const operand_27 = ((in).candidate).first;
            const operand_28 = (zx_abi).zx_type_22{ .tables = operand_26, .id = operand_27, };
            const operand_29 = (&operand_28);
            const operand_30 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_29).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_29).tables).base, .delta = ((operand_29).tables).delta, .zx_origin = (operand_29).tables, }, .zx_origin = operand_29, }));

            break :block_32 (if (((operand_30).zx_origin != null)) ((operand_30).zx_origin.?).* else block_31: {
                break :block_31 (zx_abi).zx_type_17{ .delta = (operand_30).delta, .first = (operand_30).first, .kind = (operand_30).kind, .label = (operand_30).label, .second = (operand_30).second, };
            });
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return @as((zx_abi).zx_type_47, .TaskContainer);
        }

        return (if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .List)) and (((in).candidate).first == @as(u32, 0)))) @as((zx_abi).zx_type_47, .VoidList) else @as((zx_abi).zx_type_47, .None));
    }

    if (((((in).candidate).kind != @as((zx_abi).zx_type_11, .Tuple)) and (((in).candidate).kind != @as((zx_abi).zx_type_11, .Object)))) {
        return @as((zx_abi).zx_type_47, .None);
    }

    const value_1: []const u32 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) ((in).candidate).children else (((in).candidate).fields).types);

    const value_12: (zx_abi).zx_type_48 = block_25: {
        const operand_7 = block_6: {
            const operand_2 = (in).tables;
            const operand_3 = value_1;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 (zx_abi).zx_type_48{ .tables = operand_2, .children = operand_3, .index = operand_4, .found = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (operand_7).children, .found = (operand_7).found, .index = (operand_7).index, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_7).tables).base, .delta = ((operand_7).tables).delta, .zx_origin = (operand_7).tables, }, .zx_origin = (&operand_7), };

        while (((!(state_1).found) and ((state_1).index < @as(u64, ((state_1).children).len)))) {
            state_1 = block_20: {
                const value_4: (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = state_1;
                _ = (value_4).found;

                const value_6: bool = ((block_19: {
                    break :block_19 (try function_3_value(allocator, block_18: {
                        const operand_13 = (state_1).tables;

                        const operand_14 = block_17: {
                            const operand_15 = (state_1).children;
                            const operand_16 = (state_1).index;

                            if ((operand_16 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_17 (operand_15)[@intCast(operand_16)];
                        };

                        break :block_18 @as((zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_13, .id = operand_14, });
                    }));
                }).kind == @as((zx_abi).zx_type_11, .Task));

                const value_7: (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363, (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (value_4).children, .found = block_11: {
                        break :block_11 value_6;
                    }, .index = (value_4).index, .tables = (value_4).tables, });
                };

                const value_8: (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = value_7;
                const value_9: u64 = (value_8).index;
                const value_10: u64 = @as(u64, 1);

                const value_11: (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363, (zx_abi).value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (value_8).children, .found = (value_8).found, .index = (block_8: {
                        break :block_8 value_9;
                    } + block_9: {
                        break :block_9 value_10;
                    }), .tables = (value_8).tables, });
                };

                break :block_20 value_11;
            };
        }

        break :block_25 block_24: {
            break :block_24 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_23: {
                break :block_23 (zx_abi).zx_type_48{ .children = (state_1).children, .found = (state_1).found, .index = (state_1).index, .tables = (if ((((state_1).tables).zx_origin != null)) ((state_1).tables).zx_origin.? else block_22: {
                    const operand_21 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_21).* = (zx_abi).zx_type_16{ .base = ((state_1).tables).base, .delta = ((state_1).tables).delta, };

                    break :block_22 @as(*const (zx_abi).zx_type_16, operand_21);
                }), };
            });
        };
    };

    if ((!((&value_12)).found)) {
        return @as((zx_abi).zx_type_47, .None);
    }

    return (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) @as((zx_abi).zx_type_47, .TaskTuple) else @as((zx_abi).zx_type_47, .TaskObject));
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_44 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_47 = (try function_15(allocator, in));

    if ((value_1 == @as((zx_abi).zx_type_47, .TaskContainer))) {
        return block_32: {
            const operand_28 = @as([]const u8, "ownership");
            const operand_29 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_44));

                (operand_30).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_28, .message = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_44, operand_30);
            };
        };
    } else {
        if ((value_1 == @as((zx_abi).zx_type_47, .VoidList))) {
            return block_37: {
                const operand_33 = @as([]const u8, "type_mismatch");
                const operand_34 = @as([]const u8, "lists cannot contain void");

                break :block_37 block_36: {
                    const operand_35 = (try (allocator).create((zx_abi).zx_type_44));

                    (operand_35).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_33, .message = operand_34, });

                    break :block_36 @as(*const (zx_abi).zx_type_44, operand_35);
                };
            };
        } else {
            if ((value_1 == @as((zx_abi).zx_type_47, .TaskTuple))) {
                return block_42: {
                    const operand_38 = @as([]const u8, "ownership");
                    const operand_39 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_42 block_41: {
                        const operand_40 = (try (allocator).create((zx_abi).zx_type_44));

                        (operand_40).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_38, .message = operand_39, });

                        break :block_41 @as(*const (zx_abi).zx_type_44, operand_40);
                    };
                };
            } else {
                if ((value_1 == @as((zx_abi).zx_type_47, .TaskObject))) {
                    return block_47: {
                        const operand_43 = @as([]const u8, "ownership");
                        const operand_44 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_47 block_46: {
                            const operand_45 = (try (allocator).create((zx_abi).zx_type_44));

                            (operand_45).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_43, .message = operand_44, });

                            break :block_46 @as(*const (zx_abi).zx_type_44, operand_45);
                        };
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_22: {
            const operand_18 = (in).tables;
            const operand_19 = ((in).candidate).first;
            const operand_20 = true;
            const operand_21 = (zx_abi).zx_type_26{ .tables = operand_18, .id = operand_19, .native_references = operand_20, };

            break :block_22 (try function_5(allocator, (&operand_21)));
        }) {
            return block_27: {
                const operand_23 = @as([]const u8, "capability");
                const operand_24 = @as([]const u8, "tasks cannot return host references");

                break :block_27 block_26: {
                    const operand_25 = (try (allocator).create((zx_abi).zx_type_44));

                    (operand_25).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_23, .message = operand_24, });

                    break :block_26 @as(*const (zx_abi).zx_type_44, operand_25);
                };
            };
        }

        if (((block_12: {
            const operand_6 = (in).tables;
            const operand_7 = ((in).candidate).first;
            const operand_8 = (zx_abi).zx_type_22{ .tables = operand_6, .id = operand_7, };
            const operand_9 = (&operand_8);
            const operand_10 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_9).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_9).tables).base, .delta = ((operand_9).tables).delta, .zx_origin = (operand_9).tables, }, .zx_origin = operand_9, }));

            break :block_12 (if (((operand_10).zx_origin != null)) ((operand_10).zx_origin.?).* else block_11: {
                break :block_11 (zx_abi).zx_type_17{ .delta = (operand_10).delta, .first = (operand_10).first, .kind = (operand_10).kind, .label = (operand_10).label, .second = (operand_10).second, };
            });
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return block_17: {
                const operand_13 = @as([]const u8, "ownership");
                const operand_14 = @as([]const u8, "a task cannot return another task");

                break :block_17 block_16: {
                    const operand_15 = (try (allocator).create((zx_abi).zx_type_44));

                    (operand_15).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_13, .message = operand_14, });

                    break :block_16 @as(*const (zx_abi).zx_type_44, operand_15);
                };
            };
        }
    }

    return block_5: {
        const operand_1 = @as([]const u8, "");
        const operand_2 = @as([]const u8, "");

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_44));

            (operand_3).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_1, .message = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_44, operand_3);
        };
    };
}

fn function_16_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_47 = block_89: {
        const operand_86 = in;
        var state_borrow_87: (zx_abi).zx_type_16 = undefined;
        state_borrow_87 = (zx_abi).zx_type_16{ .base = ((operand_86).tables).base, .delta = ((operand_86).tables).delta, };

        var state_borrow_88: (zx_abi).zx_type_35 = undefined;

        state_borrow_88 = (zx_abi).zx_type_35{ .candidate = (operand_86).candidate, .tables = (((operand_86).tables).zx_origin orelse (&state_borrow_87)), };

        break :block_89 (try function_15(allocator, ((operand_86).zx_origin orelse (&state_borrow_88))));
    };

    if ((block_70: {
        break :block_70 value_1;
    } == @as((zx_abi).zx_type_47, .TaskContainer))) {
        return block_73: {
            const operand_71 = @as([]const u8, "ownership");
            const operand_72 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_73 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_71, .message = operand_72, });
        };
    } else {
        if ((block_74: {
            break :block_74 value_1;
        } == @as((zx_abi).zx_type_47, .VoidList))) {
            return block_77: {
                const operand_75 = @as([]const u8, "type_mismatch");
                const operand_76 = @as([]const u8, "lists cannot contain void");

                break :block_77 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_75, .message = operand_76, });
            };
        } else {
            if ((block_78: {
                break :block_78 value_1;
            } == @as((zx_abi).zx_type_47, .TaskTuple))) {
                return block_81: {
                    const operand_79 = @as([]const u8, "ownership");
                    const operand_80 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_81 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_79, .message = operand_80, });
                };
            } else {
                if ((block_82: {
                    break :block_82 value_1;
                } == @as((zx_abi).zx_type_47, .TaskObject))) {
                    return block_85: {
                        const operand_83 = @as([]const u8, "ownership");
                        const operand_84 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_85 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_83, .message = operand_84, });
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_66: {
            const operand_58 = (in).tables;
            var state_borrow_59: (zx_abi).zx_type_16 = undefined;
            state_borrow_59 = (zx_abi).zx_type_16{ .base = (operand_58).base, .delta = (operand_58).delta, };

            const operand_60 = ((operand_58).zx_origin orelse (&state_borrow_59));
            const operand_61 = ((in).candidate).first;
            const operand_62 = true;
            const operand_63 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_60).base, .delta = (operand_60).delta, .zx_origin = operand_60, };
            var state_borrow_64: (zx_abi).zx_type_16 = undefined;
            state_borrow_64 = (zx_abi).zx_type_16{ .base = (operand_63).base, .delta = (operand_63).delta, };

            const operand_65 = (zx_abi).zx_type_26{ .tables = ((operand_63).zx_origin orelse (&state_borrow_64)), .id = operand_61, .native_references = operand_62, };

            break :block_66 (try function_5(allocator, (&operand_65)));
        }) {
            return block_69: {
                const operand_67 = @as([]const u8, "capability");
                const operand_68 = @as([]const u8, "tasks cannot return host references");

                break :block_69 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_67, .message = operand_68, });
            };
        }

        if (((block_54: {
            break :block_54 (try function_3_value(allocator, block_53: {
                const operand_51 = (in).tables;
                const operand_52 = ((in).candidate).first;

                break :block_53 @as((zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_51, .id = operand_52, });
            }));
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return block_57: {
                const operand_55 = @as([]const u8, "ownership");
                const operand_56 = @as([]const u8, "a task cannot return another task");

                break :block_57 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_55, .message = operand_56, });
            };
        }
    }

    return block_50: {
        const operand_48 = @as([]const u8, "");
        const operand_49 = @as([]const u8, "");

        break :block_50 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_48, .message = operand_49, });
    };
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_46 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_44 = (try function_16(allocator, in));

    if ((!block_34: {
        const operand_32 = (value_1).message;
        const operand_33 = @as([]const u8, "");

        break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
    })) {
        return block_40: {
            const operand_35 = ((in).tables).delta;
            const operand_36 = @as(u32, 0);
            const operand_37 = value_1;

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_46));

                (operand_38).* = @as((zx_abi).zx_type_46, (zx_abi).zx_type_46{ .delta = operand_35, .id = operand_36, .diagnostic = operand_37, });

                break :block_39 @as(*const (zx_abi).zx_type_46, operand_38);
            };
        };
    }

    const value_2: *const (zx_abi).zx_type_19 = block_31: {
        const operand_23 = (in).candidate;
        const operand_24 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (try function_13(allocator, ((in).candidate).fields)) else ((in).candidate).fields);

        const operand_25 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_28: {
            const operand_26 = ((in).candidate).names;
            const operand_27 = (try (allocator).alloc([]const u8, (operand_26).len));

            @memcpy(operand_27, operand_26);
            ((std).mem).sortUnstable([]const u8, operand_27, {}, zx_compare_10);

            break :block_28 @as((zx_abi).zx_type_40, .{ operand_27, {}, });
        }).@"0" else ((in).candidate).names);

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_29).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (operand_23).children, .fields = operand_24, .first = (operand_23).first, .kind = (operand_23).kind, .label = (operand_23).label, .names = operand_25, .second = (operand_23).second, });

            break :block_30 @as(*const (zx_abi).zx_type_19, operand_29);
        };
    };

    const value_3: *const (zx_abi).zx_type_20 = (try function_10(allocator, block_22: {
        const operand_18 = (in).tables;
        const operand_19 = value_2;

        break :block_22 block_21: {
            const operand_20 = (try (allocator).create((zx_abi).zx_type_35));

            (operand_20).* = @as((zx_abi).zx_type_35, (zx_abi).zx_type_35{ .tables = operand_18, .candidate = operand_19, });

            break :block_21 @as(*const (zx_abi).zx_type_35, operand_20);
        };
    }));

    if ((value_3).found) {
        return block_17: {
            const operand_12 = ((in).tables).delta;
            const operand_13 = (value_3).id;
            const operand_14 = value_1;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_46));

                (operand_15).* = @as((zx_abi).zx_type_46, (zx_abi).zx_type_46{ .delta = operand_12, .id = operand_13, .diagnostic = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_46, operand_15);
            };
        };
    }

    const value_4: u32 = (try function_14(allocator, in));

    return block_11: {
        const operand_1 = (try function_11(allocator, block_6: {
            const operand_2 = ((in).tables).delta;
            const operand_3 = value_2;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_37));

                (operand_4).* = @as((zx_abi).zx_type_37, (zx_abi).zx_type_37{ .delta = operand_2, .candidate = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_37, operand_4);
            };
        }));

        const operand_7 = value_4;
        const operand_8 = value_1;

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_46));

            (operand_9).* = @as((zx_abi).zx_type_46, (zx_abi).zx_type_46{ .delta = operand_1, .id = operand_7, .diagnostic = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_46, operand_9);
        };
    };
}

fn function_17_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_82: {
        break :block_82 (try function_16_value(allocator, in));
    };

    if ((!block_77: {
        const operand_75 = (value_1).message;
        const operand_76 = @as([]const u8, "");

        break :block_77 ((std).mem).eql(u8, operand_75, operand_76);
    })) {
        return block_81: {
            const operand_78 = ((in).tables).delta;
            const operand_79 = @as(u32, 0);
            const operand_80 = value_1;

            break :block_81 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_78, .id = operand_79, .diagnostic = operand_80, });
        };
    }

    const value_2: (zx_abi).zx_type_19 = block_74: {
        const operand_66 = (in).candidate;

        const operand_67 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) block_69: {
            const operand_68 = ((in).candidate).fields;

            break :block_69 (try function_13(allocator, operand_68));
        } else ((in).candidate).fields);

        const operand_70 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_73: {
            const operand_71 = ((in).candidate).names;
            const operand_72 = (try (allocator).alloc([]const u8, (operand_71).len));

            @memcpy(operand_72, operand_71);
            ((std).mem).sortUnstable([]const u8, operand_72, {}, zx_compare_10);

            break :block_73 @as((zx_abi).value_zx_type_40_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_72, {}, null, });
        }).@"0" else ((in).candidate).names);

        break :block_74 (zx_abi).zx_type_19{ .children = (operand_66).children, .fields = operand_67, .first = (operand_66).first, .kind = (operand_66).kind, .label = (operand_66).label, .names = operand_70, .second = (operand_66).second, };
    };

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_65: {
        break :block_65 (try function_10_value(allocator, block_64: {
            const operand_61 = (in).tables;

            const operand_62 = block_63: {
                break :block_63 (&value_2);
            };

            break :block_64 @as((zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_61, .candidate = operand_62, });
        }));
    };

    if ((value_3).found) {
        return block_60: {
            const operand_57 = ((in).tables).delta;
            const operand_58 = (value_3).id;
            const operand_59 = value_1;

            break :block_60 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_57, .id = operand_58, .diagnostic = operand_59, });
        };
    }

    const value_4: u32 = block_56: {
        const operand_53 = in;
        var state_borrow_54: (zx_abi).zx_type_16 = undefined;
        state_borrow_54 = (zx_abi).zx_type_16{ .base = ((operand_53).tables).base, .delta = ((operand_53).tables).delta, };

        var state_borrow_55: (zx_abi).zx_type_35 = undefined;

        state_borrow_55 = (zx_abi).zx_type_35{ .candidate = (operand_53).candidate, .tables = (((operand_53).tables).zx_origin orelse (&state_borrow_54)), };

        break :block_56 (try function_14(allocator, ((operand_53).zx_origin orelse (&state_borrow_55))));
    };

    return block_52: {
        const operand_41 = block_48: {
            const operand_46 = block_45: {
                const operand_42 = ((in).tables).delta;

                const operand_43 = block_44: {
                    break :block_44 (&value_2);
                };

                break :block_45 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .delta = operand_42, .candidate = operand_43, });
            };

            var state_borrow_47: (zx_abi).zx_type_37 = undefined;

            state_borrow_47 = (zx_abi).zx_type_37{ .candidate = (operand_46).candidate, .delta = (operand_46).delta, };

            break :block_48 (try function_11(allocator, ((operand_46).zx_origin orelse (&state_borrow_47))));
        };

        const operand_49 = block_50: {
            break :block_50 value_4;
        };

        const operand_51 = value_1;

        break :block_52 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_41, .id = operand_49, .diagnostic = operand_51, });
    };
}

fn function_17_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_126: {
        break :block_126 (try function_16_value(allocator, in));
    };

    if ((!block_121: {
        const operand_119 = (value_1).message;
        const operand_120 = @as([]const u8, "");

        break :block_121 ((std).mem).eql(u8, operand_119, operand_120);
    })) {
        return block_125: {
            const operand_122 = ((in).tables).delta;
            const operand_123 = @as(u32, 0);
            const operand_124 = value_1;

            break :block_125 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_122, .id = operand_123, .diagnostic = operand_124, });
        };
    }

    const value_2: (zx_abi).zx_type_19 = block_118: {
        const operand_110 = (in).candidate;

        const operand_111 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) block_113: {
            const operand_112 = ((in).candidate).fields;

            break :block_113 (try function_13(allocator, operand_112));
        } else ((in).candidate).fields);

        const operand_114 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_117: {
            const operand_115 = ((in).candidate).names;
            const operand_116 = (try (allocator).alloc([]const u8, (operand_115).len));

            @memcpy(operand_116, operand_115);
            ((std).mem).sortUnstable([]const u8, operand_116, {}, zx_compare_10);

            break :block_117 @as((zx_abi).value_zx_type_40_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_116, {}, null, });
        }).@"0" else ((in).candidate).names);

        break :block_118 (zx_abi).zx_type_19{ .children = (operand_110).children, .fields = operand_111, .first = (operand_110).first, .kind = (operand_110).kind, .label = (operand_110).label, .names = operand_114, .second = (operand_110).second, };
    };

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_109: {
        break :block_109 (try function_10_value(allocator, block_108: {
            const operand_105 = (in).tables;

            const operand_106 = block_107: {
                break :block_107 (&value_2);
            };

            break :block_108 @as((zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_105, .candidate = operand_106, });
        }));
    };

    if ((value_3).found) {
        return block_104: {
            const operand_101 = ((in).tables).delta;
            const operand_102 = (value_3).id;
            const operand_103 = value_1;

            break :block_104 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_101, .id = operand_102, .diagnostic = operand_103, });
        };
    }

    const value_4: u32 = block_100: {
        const operand_97 = in;
        var state_borrow_98: (zx_abi).zx_type_16 = undefined;
        state_borrow_98 = (zx_abi).zx_type_16{ .base = ((operand_97).tables).base, .delta = ((operand_97).tables).delta, };

        var state_borrow_99: (zx_abi).zx_type_35 = undefined;

        state_borrow_99 = (zx_abi).zx_type_35{ .candidate = (operand_97).candidate, .tables = (((operand_97).tables).zx_origin orelse (&state_borrow_98)), };

        break :block_100 (try function_14(allocator, ((operand_97).zx_origin orelse (&state_borrow_99))));
    };

    return block_96: {
        const operand_83 = block_92: {
            const operand_91 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_91).* = @as((zx_abi).zx_type_15, block_90: {
                const operand_88 = block_87: {
                    const operand_84 = ((in).tables).delta;

                    const operand_85 = block_86: {
                        break :block_86 (&value_2);
                    };

                    break :block_87 @as((zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .delta = operand_84, .candidate = operand_85, });
                };

                var state_borrow_89: (zx_abi).zx_type_37 = undefined;

                state_borrow_89 = (zx_abi).zx_type_37{ .candidate = (operand_88).candidate, .delta = (operand_88).delta, };

                break :block_90 (try function_11_buffered(allocator, ((operand_88).zx_origin orelse (&state_borrow_89)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), }));
            });

            break :block_92 @as(*const (zx_abi).zx_type_15, operand_91);
        };

        const operand_93 = block_94: {
            break :block_94 value_4;
        };

        const operand_95 = value_1;

        break :block_96 @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_83, .id = operand_93, .diagnostic = operand_95, });
    };
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_50) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_49 {
    @setRuntimeSafety(true);

    if ((!block_27: {
        const operand_25 = (((in).state).diagnostic).message;
        const operand_26 = @as([]const u8, "");

        break :block_27 ((std).mem).eql(u8, operand_25, operand_26);
    })) {
        return (in).state;
    }

    const value_1: *const (zx_abi).zx_type_46 = (try function_17(allocator, block_24: {
        const operand_15 = block_20: {
            const operand_16 = ((in).state).base;
            const operand_17 = ((in).state).delta;

            break :block_20 block_19: {
                const operand_18 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_18).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = operand_16, .delta = operand_17, });

                break :block_19 @as(*const (zx_abi).zx_type_16, operand_18);
            };
        };

        const operand_21 = (in).candidate;

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_35));

            (operand_22).* = @as((zx_abi).zx_type_35, (zx_abi).zx_type_35{ .tables = operand_15, .candidate = operand_21, });

            break :block_23 @as(*const (zx_abi).zx_type_35, operand_22);
        };
    }));

    return block_14: {
        const operand_1 = ((in).state).base;
        const operand_2 = (value_1).delta;

        const operand_3 = (if (block_6: {
            const operand_4 = ((value_1).diagnostic).message;
            const operand_5 = @as([]const u8, "");

            break :block_6 ((std).mem).eql(u8, operand_4, operand_5);
        }) (block_10: {
            const operand_7 = ((in).state).ids;
            const operand_8 = (value_1).id;
            const operand_9 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_7).len, 1))));

            @memcpy((operand_9)[0..(operand_7).len], operand_7);

            (operand_9)[(operand_7).len] = operand_8;

            break :block_10 @as((zx_abi).zx_type_39, .{ operand_9, {}, });
        }).@"0" else ((in).state).ids);

        const operand_11 = (value_1).diagnostic;

        break :block_14 block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_49));

            (operand_12).* = @as((zx_abi).zx_type_49, (zx_abi).zx_type_49{ .base = operand_1, .delta = operand_2, .ids = operand_3, .diagnostic = operand_11, });

            break :block_13 @as(*const (zx_abi).zx_type_49, operand_12);
        };
    };
}

fn function_18_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_50_32479f9b811a64f382540596a83874e8d9ca00ed002899c5fc826fe5ec3ebd2e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f {
    @setRuntimeSafety(true);

    if ((!block_49: {
        const operand_47 = (((in).state).diagnostic).message;
        const operand_48 = @as([]const u8, "");

        break :block_49 ((std).mem).eql(u8, operand_47, operand_48);
    })) {
        return (in).state;
    }

    const value_1: (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = block_46: {
        break :block_46 (try function_17_value(allocator, block_45: {
            const operand_40 = block_43: {
                const operand_41 = ((in).state).base;
                const operand_42 = ((in).state).delta;

                break :block_43 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = operand_41, .delta = operand_42, });
            };

            const operand_44 = (in).candidate;

            break :block_45 @as((zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_40, .candidate = operand_44, });
        }));
    };

    return block_39: {
        const operand_28 = ((in).state).base;
        const operand_29 = (value_1).delta;

        const operand_30 = (if (block_33: {
            const operand_31 = ((value_1).diagnostic).message;
            const operand_32 = @as([]const u8, "");

            break :block_33 ((std).mem).eql(u8, operand_31, operand_32);
        }) (block_37: {
            const operand_34 = ((in).state).ids;
            const operand_35 = (value_1).id;
            const operand_36 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_34).len, 1))));

            @memcpy((operand_36)[0..(operand_34).len], operand_34);

            (operand_36)[(operand_34).len] = operand_35;

            break :block_37 @as((zx_abi).value_zx_type_39_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_36, {}, null, });
        }).@"0" else ((in).state).ids);

        const operand_38 = (value_1).diagnostic;

        break :block_39 @as((zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f, (zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f{ .base = operand_28, .delta = operand_29, .ids = operand_30, .diagnostic = operand_38, });
    };
}

fn function_18_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_50_32479f9b811a64f382540596a83874e8d9ca00ed002899c5fc826fe5ec3ebd2e, buffers: struct {
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f {
    @setRuntimeSafety(true);

    if ((!block_74: {
        const operand_72 = (((in).state).diagnostic).message;
        const operand_73 = @as([]const u8, "");

        break :block_74 ((std).mem).eql(u8, operand_72, operand_73);
    })) {
        return (in).state;
    }

    const value_1: (zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = @as((zx_abi).value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, block_71: {
        break :block_71 (try function_17_buffered(allocator, block_70: {
            const operand_65 = block_68: {
                const operand_66 = ((in).state).base;
                const operand_67 = ((in).state).delta;

                break :block_68 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = operand_66, .delta = operand_67, });
            };

            const operand_69 = (in).candidate;

            break :block_70 @as((zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_65, .candidate = operand_69, });
        }, .{ .lane_0 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_1 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_2 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_3 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_4 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_5 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_6 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_7 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), }));
    });

    return block_64: {
        const operand_50 = ((in).state).base;
        const operand_51 = (value_1).delta;

        const operand_52 = (if (block_55: {
            const operand_53 = ((value_1).diagnostic).message;
            const operand_54 = @as([]const u8, "");

            break :block_55 ((std).mem).eql(u8, operand_53, operand_54);
        }) @as([]const u32, (if (((buffers).lane_16 != null)) block_58: {
            const operand_56 = ((in).state).ids;
            const operand_57 = (value_1).id;

            _ = (try ((std).math).add(usize, (operand_56).len, 1));

            if ((!(((buffers).lane_16.?).started).*)) {
                (try ((((buffers).lane_16.?).buffer).*).appendSlice(allocator, operand_56));
                (((buffers).lane_16.?).started).* = true;
            } else {
                (((((buffers).lane_16.?).buffer).*).items).len = (operand_56).len;
            }

            (try ((((buffers).lane_16.?).buffer).*).append(allocator, operand_57));

            break :block_58 ((((buffers).lane_16.?).buffer).*).items;
        } else (block_62: {
            const operand_59 = ((in).state).ids;
            const operand_60 = (value_1).id;
            const operand_61 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_59).len, 1))));

            @memcpy((operand_61)[0..(operand_59).len], operand_59);

            (operand_61)[(operand_59).len] = operand_60;

            break :block_62 @as((zx_abi).value_zx_type_39_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_61, {}, null, });
        }).@"0")) else ((in).state).ids);

        const operand_63 = (value_1).diagnostic;

        break :block_64 @as((zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f, (zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f{ .base = operand_50, .delta = operand_51, .ids = operand_52, .diagnostic = operand_63, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_52) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_53 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u32 = block_93: {
        break :block_93 (try (allocator).dupe(u32, (&[_]u32{})));
    };

    const value_2: *const (zx_abi).zx_type_44 = block_92: {
        const operand_88 = @as([]const u8, "");
        const operand_89 = @as([]const u8, "");

        break :block_92 block_91: {
            const operand_90 = (try (allocator).create((zx_abi).zx_type_44));

            (operand_90).* = @as((zx_abi).zx_type_44, (zx_abi).zx_type_44{ .code = operand_88, .message = operand_89, });

            break :block_91 @as(*const (zx_abi).zx_type_44, operand_90);
        };
    };

    const value_5: *const (zx_abi).zx_type_49 = block_87: {
        const operand_24 = (in).candidates;

        const operand_32 = block_31: {
            const operand_25 = (in).base;
            const operand_26 = (in).delta;
            const operand_27 = value_1;
            const operand_28 = value_2;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_49));

                (operand_29).* = @as((zx_abi).zx_type_49, (zx_abi).zx_type_49{ .base = operand_25, .delta = operand_26, .ids = operand_27, .diagnostic = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_49, operand_29);
            };
        };

        var value_3: (zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f = (zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f{ .base = (operand_32).base, .delta = (operand_32).delta, .diagnostic = (zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = ((operand_32).diagnostic).code, .message = ((operand_32).diagnostic).message, .zx_origin = (operand_32).diagnostic, }, .ids = (operand_32).ids, .zx_origin = operand_32, };
        var state_changed_33 = false;
        var field_items_34: (std).ArrayList(u32) = .empty;
        var field_started_35 = false;

        defer (field_items_34).deinit(allocator);

        var field_items_36: (std).ArrayList([]const u8) = .empty;
        var field_started_37 = false;

        defer (field_items_36).deinit(allocator);

        var field_items_38: (std).ArrayList(u32) = .empty;
        var field_started_39 = false;

        defer (field_items_38).deinit(allocator);

        var field_items_40: (std).ArrayList(u32) = .empty;
        var field_started_41 = false;

        defer (field_items_40).deinit(allocator);

        var field_items_42: (std).ArrayList(u8) = .empty;
        var field_started_43 = false;

        defer (field_items_42).deinit(allocator);

        var field_items_44: (std).ArrayList([]const u8) = .empty;
        var field_started_45 = false;

        defer (field_items_44).deinit(allocator);

        var field_items_46: (std).ArrayList([]const u8) = .empty;
        var field_started_47 = false;

        defer (field_items_46).deinit(allocator);

        var field_items_48: (std).ArrayList(u32) = .empty;
        var field_started_49 = false;

        defer (field_items_48).deinit(allocator);

        var field_items_50: (std).ArrayList(u32) = .empty;
        var field_started_51 = false;

        defer (field_items_50).deinit(allocator);

        for (operand_24) |value_4| {
            value_3 = @as((zx_abi).value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f, block_56: {
                break :block_56 (try function_18_buffered(allocator, block_55: {
                    const operand_52 = value_3;

                    const operand_53 = block_54: {
                        break :block_54 value_4;
                    };

                    break :block_55 @as((zx_abi).value_zx_type_50_32479f9b811a64f382540596a83874e8d9ca00ed002899c5fc826fe5ec3ebd2e, (zx_abi).value_zx_type_50_32479f9b811a64f382540596a83874e8d9ca00ed002899c5fc826fe5ec3ebd2e{ .state = operand_52, .candidate = operand_53, });
                }, .{ .lane_8 = .{ .buffer = (&field_items_34), .started = (&field_started_35), }, .lane_9 = .{ .buffer = (&field_items_36), .started = (&field_started_37), }, .lane_10 = .{ .buffer = (&field_items_38), .started = (&field_started_39), }, .lane_11 = .{ .buffer = (&field_items_40), .started = (&field_started_41), }, .lane_12 = .{ .buffer = (&field_items_42), .started = (&field_started_43), }, .lane_13 = .{ .buffer = (&field_items_44), .started = (&field_started_45), }, .lane_14 = .{ .buffer = (&field_items_46), .started = (&field_started_47), }, .lane_15 = .{ .buffer = (&field_items_48), .started = (&field_started_49), }, .lane_16 = .{ .buffer = (&field_items_50), .started = (&field_started_51), }, }));
            });

            state_changed_33 = true;
        }

        var state_owned_57: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_57);

        if (field_started_35) {
            ((field_items_34).items).len = (((value_3).delta).children).len;
            state_owned_57 = (try (field_items_34).toOwnedSlice(allocator));
        }

        if (field_started_35) {
            (value_3).delta = block_59: {
                const operand_58 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_58).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_57, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_59 @as(*const (zx_abi).zx_type_15, operand_58);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_60: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_60);

        if (field_started_37) {
            ((field_items_36).items).len = (((value_3).delta).field_names).len;
            state_owned_60 = (try (field_items_36).toOwnedSlice(allocator));
        }

        if (field_started_37) {
            (value_3).delta = block_62: {
                const operand_61 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_61).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = state_owned_60, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_62 @as(*const (zx_abi).zx_type_15, operand_61);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_63: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_63);

        if (field_started_39) {
            ((field_items_38).items).len = (((value_3).delta).field_types).len;
            state_owned_63 = (try (field_items_38).toOwnedSlice(allocator));
        }

        if (field_started_39) {
            (value_3).delta = block_65: {
                const operand_64 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_64).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = state_owned_63, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_65 @as(*const (zx_abi).zx_type_15, operand_64);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_66: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_66);

        if (field_started_41) {
            ((field_items_40).items).len = (((value_3).delta).first).len;
            state_owned_66 = (try (field_items_40).toOwnedSlice(allocator));
        }

        if (field_started_41) {
            (value_3).delta = block_68: {
                const operand_67 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_67).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = state_owned_66, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_68 @as(*const (zx_abi).zx_type_15, operand_67);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_69: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_69);

        if (field_started_43) {
            ((field_items_42).items).len = (((value_3).delta).kinds).len;
            state_owned_69 = (try (field_items_42).toOwnedSlice(allocator));
        }

        if (field_started_43) {
            (value_3).delta = block_71: {
                const operand_70 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_70).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = state_owned_69, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_71 @as(*const (zx_abi).zx_type_15, operand_70);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_72: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_72);

        if (field_started_45) {
            ((field_items_44).items).len = (((value_3).delta).labels).len;
            state_owned_72 = (try (field_items_44).toOwnedSlice(allocator));
        }

        if (field_started_45) {
            (value_3).delta = block_74: {
                const operand_73 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_73).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = state_owned_72, .names = ((value_3).delta).names, .second = ((value_3).delta).second, });

                break :block_74 @as(*const (zx_abi).zx_type_15, operand_73);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_75: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_75);

        if (field_started_47) {
            ((field_items_46).items).len = (((value_3).delta).names).len;
            state_owned_75 = (try (field_items_46).toOwnedSlice(allocator));
        }

        if (field_started_47) {
            (value_3).delta = block_77: {
                const operand_76 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_76).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = state_owned_75, .second = ((value_3).delta).second, });

                break :block_77 @as(*const (zx_abi).zx_type_15, operand_76);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_78: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_78);

        if (field_started_49) {
            ((field_items_48).items).len = (((value_3).delta).second).len;
            state_owned_78 = (try (field_items_48).toOwnedSlice(allocator));
        }

        if (field_started_49) {
            (value_3).delta = block_80: {
                const operand_79 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_79).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((value_3).delta).children, .field_names = ((value_3).delta).field_names, .field_types = ((value_3).delta).field_types, .first = ((value_3).delta).first, .kinds = ((value_3).delta).kinds, .labels = ((value_3).delta).labels, .names = ((value_3).delta).names, .second = state_owned_78, });

                break :block_80 @as(*const (zx_abi).zx_type_15, operand_79);
            };

            (value_3).zx_origin = null;
        }

        var state_owned_81: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_81);

        if (field_started_51) {
            ((field_items_50).items).len = ((value_3).ids).len;
            state_owned_81 = (try (field_items_50).toOwnedSlice(allocator));
        }

        if (field_started_51) {
            (value_3).ids = state_owned_81;
            (value_3).zx_origin = null;
        }

        break :block_87 (if (state_changed_33) block_86: {
            break :block_86 (if (((value_3).zx_origin != null)) (value_3).zx_origin.? else block_85: {
                const operand_84 = (try (allocator).create((zx_abi).zx_type_49));

                (operand_84).* = (zx_abi).zx_type_49{ .base = (value_3).base, .delta = (value_3).delta, .diagnostic = (if ((((value_3).diagnostic).zx_origin != null)) ((value_3).diagnostic).zx_origin.? else block_83: {
                    const operand_82 = (try (allocator).create((zx_abi).zx_type_44));

                    (operand_82).* = (zx_abi).zx_type_44{ .code = ((value_3).diagnostic).code, .message = ((value_3).diagnostic).message, };

                    break :block_83 @as(*const (zx_abi).zx_type_44, operand_82);
                }), .ids = (value_3).ids, };

                break :block_85 @as(*const (zx_abi).zx_type_49, operand_84);
            });
        } else operand_32);
    };

    const value_6: *const (zx_abi).zx_type_16 = block_23: {
        const operand_19 = (in).base;
        const operand_20 = (value_5).delta;

        break :block_23 block_22: {
            const operand_21 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_21).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = operand_19, .delta = operand_20, });

            break :block_22 @as(*const (zx_abi).zx_type_16, operand_21);
        };
    };

    return block_18: {
        const operand_1 = (value_5).delta;
        const operand_2 = (value_5).ids;
        const operand_3 = (value_5).diagnostic;

        const operand_4 = block_9: {
            const operand_5 = value_6;
            const operand_6 = (in).query_id;
            const operand_7 = false;
            const operand_8 = (zx_abi).zx_type_26{ .tables = operand_5, .id = operand_6, .native_references = operand_7, };

            break :block_9 (try function_5(allocator, (&operand_8)));
        };

        const operand_10 = block_15: {
            const operand_11 = value_6;
            const operand_12 = (in).query_id;
            const operand_13 = true;
            const operand_14 = (zx_abi).zx_type_26{ .tables = operand_11, .id = operand_12, .native_references = operand_13, };

            break :block_15 (try function_5(allocator, (&operand_14)));
        };

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_53));

            (operand_16).* = @as((zx_abi).zx_type_53, (zx_abi).zx_type_53{ .delta = operand_1, .ids = operand_2, .diagnostic = operand_3, .contains_list = operand_4, .contains_native = operand_10, });

            break :block_17 @as(*const (zx_abi).zx_type_53, operand_16);
        };
    };
}

fn zx_compare_10(context: void, left: []const u8, right: []const u8) bool {
    _ = context;

    return ((std).mem).lessThan(u8, left, right);
}

