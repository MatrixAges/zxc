const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
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
const zx_shape_22 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .kinds = zx_shape_12, .members = zx_shape_14, .owners = zx_shape_14, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .base = zx_shape_23, .delta = zx_shape_23, }, };
const zx_shape_25 = .{ .kind = .scalar, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_25, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .previous = zx_shape_5, .unique = zx_shape_1, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .table = zx_shape_15, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .names = zx_shape_14, .origins = zx_shape_23, .table = zx_shape_15, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_1, }, };
pub const input_shape = zx_shape_30;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_30;
pub const Output = bool;

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

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_15: (zx_abi).zx_type_28 = block_68: {
        const operand_8 = block_7: {
            const operand_2 = (in).origins;
            const operand_3 = (in).names;
            const operand_4 = (in).index;
            const operand_5 = @as(u64, 0);
            const operand_6 = true;

            break :block_7 (zx_abi).zx_type_28{ .origins = operand_2, .names = operand_3, .index = operand_4, .previous = operand_5, .unique = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_8).index, .names = (operand_8).names, .origins = (operand_8).origins, .previous = (operand_8).previous, .unique = (operand_8).unique, .zx_origin = (&operand_8), };

        while (((state_1).unique and ((state_1).previous < (state_1).index))) {
            state_1 = block_65: {
                const value_3: u64 = (state_1).previous;
                const value_4: u64 = (state_1).index;

                const value_5: bool = (block_60: {
                    const operand_58 = ((state_1).origins).ids;

                    const operand_59 = block_57: {
                        break :block_57 value_3;
                    };

                    if ((operand_59 >= (operand_58).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_60 (operand_58)[@intCast(operand_59)];
                } == block_64: {
                    const operand_62 = ((state_1).origins).ids;

                    const operand_63 = block_61: {
                        break :block_61 value_4;
                    };

                    if ((operand_63 >= (operand_62).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_64 (operand_62)[@intCast(operand_63)];
                });

                const value_6: bool = (((block_30: {
                    const operand_28 = ((state_1).origins).kinds;

                    const operand_29 = block_27: {
                        break :block_27 value_3;
                    };

                    if ((operand_29 >= (operand_28).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_30 (operand_28)[@intCast(operand_29)];
                } == block_34: {
                    const operand_32 = ((state_1).origins).kinds;

                    const operand_33 = block_31: {
                        break :block_31 value_4;
                    };

                    if ((operand_33 >= (operand_32).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_34 (operand_32)[@intCast(operand_33)];
                }) and block_45: {
                    const operand_43 = block_38: {
                        const operand_36 = ((state_1).origins).owners;

                        const operand_37 = block_35: {
                            break :block_35 value_3;
                        };

                        if ((operand_37 >= (operand_36).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_38 (operand_36)[@intCast(operand_37)];
                    };
                    const operand_44 = block_42: {
                        const operand_40 = ((state_1).origins).owners;

                        const operand_41 = block_39: {
                            break :block_39 value_4;
                        };

                        if ((operand_41 >= (operand_40).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_42 (operand_40)[@intCast(operand_41)];
                    };

                    break :block_45 ((std).mem).eql(u8, operand_43, operand_44);
                }) and block_56: {
                    const operand_54 = block_49: {
                        const operand_47 = ((state_1).origins).members;

                        const operand_48 = block_46: {
                            break :block_46 value_3;
                        };

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    };
                    const operand_55 = block_53: {
                        const operand_51 = ((state_1).origins).members;

                        const operand_52 = block_50: {
                            break :block_50 value_4;
                        };

                        if ((operand_52 >= (operand_51).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_53 (operand_51)[@intCast(operand_52)];
                    };

                    break :block_56 ((std).mem).eql(u8, operand_54, operand_55);
                });

                const value_7: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                _ = (value_7).unique;

                const value_9: bool = ((!block_14: {
                    break :block_14 value_5;
                }) and (!(block_15: {
                    break :block_15 value_6;
                } and block_26: {
                    const operand_24 = block_19: {
                        const operand_17 = (state_1).names;

                        const operand_18 = block_16: {
                            break :block_16 value_3;
                        };

                        if ((operand_18 >= (operand_17).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_19 (operand_17)[@intCast(operand_18)];
                    };
                    const operand_25 = block_23: {
                        const operand_21 = (state_1).names;

                        const operand_22 = block_20: {
                            break :block_20 value_4;
                        };

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    break :block_26 ((std).mem).eql(u8, operand_24, operand_25);
                })));

                const value_10: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_7).index, .names = (value_7).names, .origins = (value_7).origins, .previous = (value_7).previous, .unique = block_12: {
                        break :block_12 value_9;
                    }, });
                };

                const value_11: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_10;
                const value_12: u64 = (value_11).previous;
                const value_13: u64 = @as(u64, 1);

                const value_14: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_11: {
                    break :block_11 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_11).index, .names = (value_11).names, .origins = (value_11).origins, .previous = (block_9: {
                        break :block_9 value_12;
                    } + block_10: {
                        break :block_10 value_13;
                    }), .unique = (value_11).unique, });
                };

                break :block_65 value_14;
            };
        }

        break :block_68 block_67: {
            break :block_67 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_66: {
                break :block_66 (zx_abi).zx_type_28{ .index = (state_1).index, .names = (state_1).names, .origins = (state_1).origins, .previous = (state_1).previous, .unique = (state_1).unique, };
            });
        };
    };

    return ((&value_15)).unique;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u8 = block_30: {
        const operand_28 = ((in).origins).kinds;
        const operand_29 = (in).index;

        if ((operand_29 >= (operand_28).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_30 (operand_28)[@intCast(operand_29)];
    };

    if (((value_1 > @as(u8, 2)) or ((value_1 != @as(u8, 2)) and (!block_27: {
        const operand_25 = block_24: {
            const operand_22 = ((in).origins).members;
            const operand_23 = (in).index;

            if ((operand_23 >= (operand_22).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_24 (operand_22)[@intCast(operand_23)];
        };

        const operand_26 = @as([]const u8, "");

        break :block_27 ((std).mem).eql(u8, operand_25, operand_26);
    })))) {
        return false;
    }

    const value_2: u64 = (try function_0(allocator, block_21: {
        const operand_19 = ((in).origins).ids;
        const operand_20 = (in).index;

        if ((operand_20 >= (operand_19).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_21 (operand_19)[@intCast(operand_20)];
    }));

    if ((value_2 >= @as(u64, (((in).table).kinds).len))) {
        return false;
    }

    const value_3: (zx_abi).zx_type_11 = (try function_2(allocator, block_18: {
        const operand_16 = ((in).table).kinds;
        const operand_17 = value_2;

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    }));

    if ((((value_3 != @as((zx_abi).zx_type_11, .Enumeration)) and (value_3 != @as((zx_abi).zx_type_11, .NativeReference))) or ((value_3 == @as((zx_abi).zx_type_11, .NativeReference)) and (value_1 != @as(u8, 1))))) {
        return false;
    }

    return (block_9: {
        const operand_7 = block_3: {
            const operand_1 = ((in).table).labels;
            const operand_2 = value_2;

            if ((operand_2 >= (operand_1).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_3 (operand_1)[@intCast(operand_2)];
        };

        const operand_8 = block_6: {
            const operand_4 = (in).names;
            const operand_5 = (in).index;

            if ((operand_5 >= (operand_4).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_6 (operand_4)[@intCast(operand_5)];
        };

        break :block_9 ((std).mem).eql(u8, operand_7, operand_8);
    } and block_15: {
        const operand_14 = block_13: {
            const operand_10 = (in).origins;
            const operand_11 = (in).names;
            const operand_12 = (in).index;

            break :block_13 (zx_abi).zx_type_27{ .origins = operand_10, .names = operand_11, .index = operand_12, };
        };

        break :block_15 (try function_3(allocator, (&operand_14)));
    });
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_30) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, (((in).origins).ids).len);

    if (((((@as(u64, (((in).origins).kinds).len) != value_1) or (@as(u64, (((in).origins).owners).len) != value_1)) or (@as(u64, (((in).origins).members).len) != value_1)) or (@as(u64, ((in).names).len) != value_1))) {
        return false;
    }

    const value_12: (zx_abi).zx_type_31 = block_26: {
        const operand_9 = block_8: {
            const operand_2 = (in).table;
            const operand_3 = (in).origins;
            const operand_4 = (in).names;
            const operand_5 = @as(u64, 0);
            const operand_6 = value_1;
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_31{ .table = operand_2, .origins = operand_3, .names = operand_4, .index = operand_5, .count = operand_6, .valid = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (operand_9).count, .index = (operand_9).index, .names = (operand_9).names, .origins = (operand_9).origins, .table = (operand_9).table, .valid = (operand_9).valid, .zx_origin = (&operand_9), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_23: {
                const value_4: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;
                _ = (value_4).valid;

                const value_6: bool = block_22: {
                    const operand_20 = block_19: {
                        const operand_15 = (state_1).table;
                        const operand_16 = (state_1).origins;
                        const operand_17 = (state_1).names;
                        const operand_18 = (state_1).index;

                        break :block_19 @as((zx_abi).value_zx_type_29_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_29_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .table = operand_15, .origins = operand_16, .names = operand_17, .index = operand_18, });
                    };

                    var state_borrow_21: (zx_abi).zx_type_29 = undefined;

                    state_borrow_21 = (zx_abi).zx_type_29{ .index = (operand_20).index, .names = (operand_20).names, .origins = (operand_20).origins, .table = (operand_20).table, };

                    break :block_22 (try function_4(allocator, ((operand_20).zx_origin orelse (&state_borrow_21))));
                };

                const value_7: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_4).count, .index = (value_4).index, .names = (value_4).names, .origins = (value_4).origins, .table = (value_4).table, .valid = block_13: {
                        break :block_13 value_6;
                    }, });
                };

                const value_8: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_7;
                const value_9: u64 = (value_8).index;
                const value_10: u64 = @as(u64, 1);

                const value_11: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_8).count, .index = (block_10: {
                        break :block_10 value_9;
                    } + block_11: {
                        break :block_11 value_10;
                    }), .names = (value_8).names, .origins = (value_8).origins, .table = (value_8).table, .valid = (value_8).valid, });
                };

                break :block_23 value_11;
            };
        }

        break :block_26 block_25: {
            break :block_25 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_24: {
                break :block_24 (zx_abi).zx_type_31{ .count = (state_1).count, .index = (state_1).index, .names = (state_1).names, .origins = (state_1).origins, .table = (state_1).table, .valid = (state_1).valid, };
            });
        };
    };

    return ((&value_12)).valid;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_30) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_5(allocator, in));

    return value_1;
}

