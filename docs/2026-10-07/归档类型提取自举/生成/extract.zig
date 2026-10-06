const std = @import("std");
const zx_native_0 = @import("extract_workspace");
const zx_native_1 = @import("integers");
const zx_native_2 = @import("references");
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
const zx_shape_11 = .{ .kind = .native_reference, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_1, }, };
const zx_shape_15 = .{ .kind = .scalar, };
const zx_shape_16 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_17 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_18 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_17, .field_names = zx_shape_18, .field_types = zx_shape_17, .first = zx_shape_17, .kinds = zx_shape_16, .labels = zx_shape_18, .names = zx_shape_18, .second = zx_shape_17, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .base = zx_shape_19, .delta = zx_shape_19, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_15, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .names = zx_shape_18, .types = zx_shape_17, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .children = zx_shape_17, .fields = zx_shape_22, .first = zx_shape_4, .kind = zx_shape_15, .label = zx_shape_10, .names = zx_shape_18, .second = zx_shape_4, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .delta = zx_shape_19, .id = zx_shape_4, }, };
const zx_shape_26 = .{ .kind = .native_reference, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_26, .@"1" = zx_shape_4, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_26, .@"1" = zx_shape_5, .@"2" = zx_shape_4, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .index = zx_shape_5, .table = zx_shape_19, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .values = zx_shape_17, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_19, .workspace = zx_shape_11, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .remaining = zx_shape_5, .values = zx_shape_17, .workspace = zx_shape_11, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .ids = zx_shape_17, .kinds = zx_shape_16, .members = zx_shape_18, .owners = zx_shape_18, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .base = zx_shape_34, .delta = zx_shape_34, }, };
const zx_shape_36 = .{ .kind = .scalar, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_36, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_18, .origins = zx_shape_34, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .id = zx_shape_5, .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_18, .origins = zx_shape_34, .result = zx_shape_5, .valid = zx_shape_1, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .index = zx_shape_5, .names = zx_shape_18, .origins = zx_shape_34, .table = zx_shape_19, .workspace = zx_shape_11, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .buffer = zx_shape_26, .names = zx_shape_18, .origins = zx_shape_34, .status = zx_shape_5, .table = zx_shape_19, .workspace = zx_shape_11, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_40, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_40, .@"1" = zx_shape_5, }, };
pub const input_shape = zx_shape_40;
pub const output_shape = zx_shape_5;
pub const Input = *const (zx_abi).zx_type_40;
pub const Output = u64;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!bool {
    const native_result = (zx_native_0).hasMapping((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!u64 {
    const native_result = (zx_native_0).getMapping((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ }!void {
    const native_result = (zx_native_0).setMapping((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).push((in).@"0", (in).@"1", (in).@"2"));

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u64 {
    const native_result = (zx_native_0).length(in);

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u64 {
    const native_result = (zx_native_0).lastId(in);

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!bool {
    const native_result = (zx_native_0).lastReady(in);

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!void {
    const native_result = (zx_native_0).pop(in);

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).prepareReferences((in).@"0", (in).@"1", (in).@"2"));

    _ = allocator;

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!u64 {
    const native_result = (try (zx_native_0).appendType((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_0).appendOrigin((in).@"0", (in).@"1", (in).@"2"));

    _ = allocator;

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_1).widen(in);

    _ = allocator;

    return native_result;
}

fn function_12(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_1).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_13(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_15, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_15, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_15, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_15, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_15, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_15, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_15, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_15, .Enumeration) else @as((zx_abi).zx_type_15, .NativeReference)))))))));
    };
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ }!u32 {
    const native_result = (zx_native_2).get((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28) error{ }!void {
    const native_result = (zx_native_2).set((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_15 = (try function_13(allocator, block_79: {
        const operand_77 = ((in).table).kinds;
        const operand_78 = (in).index;

        if ((operand_78 >= (operand_77).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_79 (operand_77)[@intCast(operand_78)];
    }));

    if (((value_1 == @as((zx_abi).zx_type_15, .Optional)) or (value_1 == @as((zx_abi).zx_type_15, .List)))) {
        _ = block_14: {
            const operand_13 = @as((zx_abi).zx_type_28, block_12: {
                const operand_1 = (in).buffer;
                const operand_2 = @as(u64, 0);

                const operand_11 = block_10: {
                    const operand_9 = @as((zx_abi).zx_type_27, block_8: {
                        const operand_3 = (in).buffer;

                        const operand_7 = block_6: {
                            const operand_4 = ((in).table).first;
                            const operand_5 = (in).index;

                            if ((operand_5 >= (operand_4).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_6 (operand_4)[@intCast(operand_5)];
                        };

                        break :block_8 .{ operand_3, operand_7, };
                    });

                    break :block_10 (try function_14(allocator, (&operand_9)));
                };

                break :block_12 .{ operand_1, operand_2, operand_11, };
            });

            break :block_14 (try function_15(allocator, (&operand_13)));
        };
    } else {
        if ((value_1 == @as((zx_abi).zx_type_15, .Task))) {
            _ = block_42: {
                const operand_41 = @as((zx_abi).zx_type_28, block_40: {
                    const operand_29 = (in).buffer;
                    const operand_30 = @as(u64, 0);
                    const operand_39 = block_38: {
                        const operand_37 = @as((zx_abi).zx_type_27, block_36: {
                            const operand_31 = (in).buffer;
                            const operand_35 = block_34: {
                                const operand_32 = ((in).table).first;
                                const operand_33 = (in).index;

                                if ((operand_33 >= (operand_32).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_34 (operand_32)[@intCast(operand_33)];
                            };

                            break :block_36 .{ operand_31, operand_35, };
                        });

                        break :block_38 (try function_14(allocator, (&operand_37)));
                    };

                    break :block_40 .{ operand_29, operand_30, operand_39, };
                });

                break :block_42 (try function_15(allocator, (&operand_41)));
            };

            _ = block_28: {
                const operand_27 = @as((zx_abi).zx_type_28, block_26: {
                    const operand_15 = (in).buffer;
                    const operand_16 = @as(u64, 1);
                    const operand_25 = block_24: {
                        const operand_23 = @as((zx_abi).zx_type_27, block_22: {
                            const operand_17 = (in).buffer;
                            const operand_21 = block_20: {
                                const operand_18 = ((in).table).second;
                                const operand_19 = (in).index;

                                if ((operand_19 >= (operand_18).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_20 (operand_18)[@intCast(operand_19)];
                            };

                            break :block_22 .{ operand_17, operand_21, };
                        });

                        break :block_24 (try function_14(allocator, (&operand_23)));
                    };

                    break :block_26 .{ operand_15, operand_16, operand_25, };
                });

                break :block_28 (try function_15(allocator, (&operand_27)));
            };
        } else {
            if (((value_1 == @as((zx_abi).zx_type_15, .Tuple)) or (value_1 == @as((zx_abi).zx_type_15, .Object)))) {
                const value_2: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_15, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_3: u64 = (try function_11(allocator, block_76: {
                    const operand_74 = ((in).table).first;
                    const operand_75 = (in).index;

                    if ((operand_75 >= (operand_74).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_76 (operand_74)[@intCast(operand_75)];
                }));

                const value_4: u64 = (try function_11(allocator, block_73: {
                    const operand_71 = ((in).table).second;
                    const operand_72 = (in).index;

                    if ((operand_72 >= (operand_71).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_73 (operand_71)[@intCast(operand_72)];
                }));

                _ = block_70: {
                    const operand_50 = block_49: {
                        const operand_44 = value_2;
                        const operand_45 = value_3;
                        const operand_46 = value_4;
                        const operand_47 = @as(u64, 0);
                        const operand_48 = (in).buffer;

                        break :block_49 (zx_abi).zx_type_30{ .values = operand_44, .first = operand_45, .count = operand_46, .index = operand_47, .buffer = operand_48, };
                    };

                    var state_43: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .buffer = (operand_50).buffer, .count = (operand_50).count, .first = (operand_50).first, .index = (operand_50).index, .values = (operand_50).values, .zx_origin = (&operand_50), };

                    while (((state_43).index < (state_43).count)) {
                        state_43 = block_69: {
                            const value_7: u32 = block_68: {
                                const operand_66 = (state_43).values;
                                const operand_67 = ((state_43).first + (state_43).index);

                                if ((operand_67 >= (operand_66).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_68 (operand_66)[@intCast(operand_67)];
                            };
                            _ = block_65: {
                                const operand_64 = @as((zx_abi).zx_type_28, block_63: {
                                    const operand_54 = (state_43).buffer;
                                    const operand_55 = (state_43).index;
                                    const operand_62 = block_61: {
                                        const operand_60 = @as((zx_abi).zx_type_27, block_59: {
                                            const operand_56 = (state_43).buffer;
                                            const operand_58 = block_57: {
                                                break :block_57 value_7;
                                            };

                                            break :block_59 .{ operand_56, operand_58, };
                                        });

                                        break :block_61 (try function_14(allocator, (&operand_60)));
                                    };

                                    break :block_63 .{ operand_54, operand_55, operand_62, };
                                });

                                break :block_65 (try function_15(allocator, (&operand_64)));
                            };

                            const value_8: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_43;
                            const value_9: u64 = (value_8).index;
                            const value_10: u64 = @as(u64, 1);

                            const value_11: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_53: {
                                break :block_53 @as((zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .buffer = (value_8).buffer, .count = (value_8).count, .first = (value_8).first, .index = (block_51: {
                                    break :block_51 value_9;
                                } + block_52: {
                                    break :block_52 value_10;
                                }), .values = (value_8).values, });
                            };

                            break :block_69 value_11;
                        };
                    }

                    break :block_70 {};
                };
            }
        }
    }

    return;
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_15 = (try function_13(allocator, block_59: {
        const operand_57 = ((in).table).kinds;
        const operand_58 = (in).index;

        if ((operand_58 >= (operand_57).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_59 (operand_57)[@intCast(operand_58)];
    }));

    if ((value_1 == @as((zx_abi).zx_type_15, .Task))) {
        _ = block_18: {
            const operand_17 = @as((zx_abi).zx_type_14, block_16: {
                const operand_10 = (in).workspace;

                const operand_14 = (try function_11(allocator, block_13: {
                    const operand_11 = ((in).table).first;
                    const operand_12 = (in).index;

                    if ((operand_12 >= (operand_11).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_13 (operand_11)[@intCast(operand_12)];
                }));

                const operand_15 = false;

                break :block_16 .{ operand_10, operand_14, operand_15, };
            });

            break :block_18 (try function_3(allocator, (&operand_17)));
        };

        _ = block_9: {
            const operand_8 = @as((zx_abi).zx_type_14, block_7: {
                const operand_1 = (in).workspace;

                const operand_5 = (try function_11(allocator, block_4: {
                    const operand_2 = ((in).table).second;
                    const operand_3 = (in).index;

                    if ((operand_3 >= (operand_2).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_4 (operand_2)[@intCast(operand_3)];
                }));

                const operand_6 = false;

                break :block_7 .{ operand_1, operand_5, operand_6, };
            });

            break :block_9 (try function_3(allocator, (&operand_8)));
        };
    } else {
        if (((value_1 == @as((zx_abi).zx_type_15, .Optional)) or (value_1 == @as((zx_abi).zx_type_15, .List)))) {
            _ = block_27: {
                const operand_26 = @as((zx_abi).zx_type_14, block_25: {
                    const operand_19 = (in).workspace;

                    const operand_23 = (try function_11(allocator, block_22: {
                        const operand_20 = ((in).table).first;
                        const operand_21 = (in).index;

                        if ((operand_21 >= (operand_20).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_22 (operand_20)[@intCast(operand_21)];
                    }));

                    const operand_24 = false;

                    break :block_25 .{ operand_19, operand_23, operand_24, };
                });

                break :block_27 (try function_3(allocator, (&operand_26)));
            };
        } else {
            if (((value_1 == @as((zx_abi).zx_type_15, .Tuple)) or (value_1 == @as((zx_abi).zx_type_15, .Object)))) {
                const value_2: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_15, .Tuple))) ((in).table).children else ((in).table).field_types);

                _ = block_56: {
                    const operand_40 = block_39: {
                        const operand_29 = value_2;
                        const operand_30 = (try function_11(allocator, block_33: {
                            const operand_31 = ((in).table).first;
                            const operand_32 = (in).index;

                            if ((operand_32 >= (operand_31).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_33 (operand_31)[@intCast(operand_32)];
                        }));
                        const operand_34 = (try function_11(allocator, block_37: {
                            const operand_35 = ((in).table).second;
                            const operand_36 = (in).index;

                            if ((operand_36 >= (operand_35).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_37 (operand_35)[@intCast(operand_36)];
                        }));

                        const operand_38 = (in).workspace;

                        break :block_39 (zx_abi).zx_type_32{ .values = operand_29, .first = operand_30, .remaining = operand_34, .workspace = operand_38, };
                    };

                    var state_28: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .first = (operand_40).first, .remaining = (operand_40).remaining, .values = (operand_40).values, .workspace = (operand_40).workspace, .zx_origin = (&operand_40), };

                    while (((state_28).remaining > @as(u64, 0))) {
                        state_28 = block_55: {
                            const value_5: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_28;
                            const value_6: u64 = (value_5).remaining;
                            const value_7: u64 = @as(u64, 1);

                            const value_8: (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_54: {
                                break :block_54 @as((zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .first = (value_5).first, .remaining = (block_52: {
                                    break :block_52 value_6;
                                } - block_53: {
                                    break :block_53 value_7;
                                }), .values = (value_5).values, .workspace = (value_5).workspace, });
                            };
                            _ = block_51: {
                                const operand_50 = @as((zx_abi).zx_type_14, block_49: {
                                    const operand_41 = (value_8).workspace;
                                    const operand_47 = block_46: {
                                        const operand_45 = block_44: {
                                            const operand_42 = (value_8).values;
                                            const operand_43 = ((value_8).first + (value_8).remaining);

                                            if ((operand_43 >= (operand_42).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_44 (operand_42)[@intCast(operand_43)];
                                        };

                                        break :block_46 (try function_11(allocator, operand_45));
                                    };
                                    const operand_48 = false;

                                    break :block_49 .{ operand_41, operand_47, operand_48, };
                                });

                                break :block_51 (try function_3(allocator, (&operand_50)));
                            };

                            break :block_55 value_8;
                        };
                    }

                    break :block_56 {};
                };
            }
        }
    }

    return;
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_38) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_17: (zx_abi).zx_type_39 = block_35: {
        const operand_10 = block_9: {
            const operand_2 = (in).origins;
            const operand_3 = (in).names;
            const operand_4 = (in).index;
            const operand_5 = (in).name;
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_39{ .origins = operand_2, .names = operand_3, .id = operand_4, .name = operand_5, .index = operand_6, .result = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (operand_10).id, .index = (operand_10).index, .name = (operand_10).name, .names = (operand_10).names, .origins = (operand_10).origins, .result = (operand_10).result, .valid = (operand_10).valid, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).origins).ids).len)))) {
            state_1 = block_32: {
                const value_12: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_18: {
                    const operand_17 = block_16: {
                        const operand_14 = ((state_1).origins).ids;
                        const operand_15 = (state_1).index;

                        if ((operand_15 >= (operand_14).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_16 (operand_14)[@intCast(operand_15)];
                    };

                    break :block_18 (try function_11(allocator, operand_17));
                } == (state_1).id)) block_31: {
                    const value_11: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((((state_1).result != @as(u64, 0)) or (!block_24: {
                        const operand_22 = block_21: {
                            const operand_19 = (state_1).names;
                            const operand_20 = (state_1).index;

                            if ((operand_20 >= (operand_19).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_21 (operand_19)[@intCast(operand_20)];
                        };
                        const operand_23 = (state_1).name;

                        break :block_24 ((std).mem).eql(u8, operand_22, operand_23);
                    }))) block_27: {
                        const value_3: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        _ = (value_3).valid;
                        const value_5: bool = false;

                        const value_6: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_26: {
                            break :block_26 @as((zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_3).id, .index = (value_3).index, .name = (value_3).name, .names = (value_3).names, .origins = (value_3).origins, .result = (value_3).result, .valid = block_25: {
                                break :block_25 value_5;
                            }, });
                        };

                        break :block_27 value_6;
                    } else block_30: {
                        const value_7: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                        _ = (value_7).result;

                        const value_9: u64 = ((state_1).index + @as(u64, 2));

                        const value_10: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_29: {
                            break :block_29 @as((zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_7).id, .index = (value_7).index, .name = (value_7).name, .names = (value_7).names, .origins = (value_7).origins, .result = block_28: {
                                break :block_28 value_9;
                            }, .valid = (value_7).valid, });
                        };

                        break :block_30 value_10;
                    });

                    break :block_31 value_11;
                } else state_1);

                const value_13: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_12;
                const value_14: u64 = (value_13).index;
                const value_15: u64 = @as(u64, 1);

                const value_16: (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_13).id, .index = (block_11: {
                        break :block_11 value_14;
                    } + block_12: {
                        break :block_12 value_15;
                    }), .name = (value_13).name, .names = (value_13).names, .origins = (value_13).origins, .result = (value_13).result, .valid = (value_13).valid, });
                };

                break :block_32 value_16;
            };
        }

        break :block_35 block_34: {
            break :block_34 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_33: {
                break :block_33 (zx_abi).zx_type_39{ .id = (state_1).id, .index = (state_1).index, .name = (state_1).name, .names = (state_1).names, .origins = (state_1).origins, .result = (state_1).result, .valid = (state_1).valid, };
            });
        };
    };

    return (if (((&value_17)).valid) ((&value_17)).result else @as(u64, 1));
}

fn function_19(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_40) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).table).kinds).len))) {
        return @as(u64, 0);
    }

    if (block_134: {
        const operand_133 = @as((zx_abi).zx_type_12, block_132: {
            const operand_130 = (in).workspace;
            const operand_131 = (in).index;

            break :block_132 .{ operand_130, operand_131, };
        });

        break :block_134 (try function_0(allocator, (&operand_133)));
    }) {
        return (block_139: {
            const operand_138 = @as((zx_abi).zx_type_12, block_137: {
                const operand_135 = (in).workspace;
                const operand_136 = (in).index;

                break :block_137 .{ operand_135, operand_136, };
            });

            break :block_139 (try function_1(allocator, (&operand_138)));
        } + @as(u64, 2));
    }

    _ = block_129: {
        const operand_128 = @as((zx_abi).zx_type_14, block_127: {
            const operand_124 = (in).workspace;
            const operand_125 = (in).index;
            const operand_126 = false;

            break :block_127 .{ operand_124, operand_125, operand_126, };
        });

        break :block_129 (try function_3(allocator, (&operand_128)));
    };

    const value_22: (zx_abi).zx_type_41 = block_123: {
        const operand_14 = block_13: {
            const operand_7 = (in).table;
            const operand_8 = (in).origins;
            const operand_9 = (in).names;
            const operand_10 = (in).workspace;
            const operand_11 = (in).buffer;
            const operand_12 = @as(u64, 2);

            break :block_13 (zx_abi).zx_type_41{ .table = operand_7, .origins = operand_8, .names = operand_9, .workspace = operand_10, .buffer = operand_11, .status = operand_12, };
        };

        var state_6: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (operand_14).buffer, .names = (operand_14).names, .origins = (operand_14).origins, .status = (operand_14).status, .table = (operand_14).table, .workspace = (operand_14).workspace, .zx_origin = (&operand_14), };

        while ((((state_6).status == @as(u64, 2)) and (block_16: {
            const operand_15 = (state_6).workspace;

            break :block_16 (try function_4(allocator, operand_15));
        } > @as(u64, 0)))) {
            state_6 = block_120: {
                const value_3: u64 = block_119: {
                    const operand_118 = (state_6).workspace;

                    break :block_119 (try function_5(allocator, operand_118));
                };
                const value_4: bool = block_117: {
                    const operand_116 = (state_6).workspace;

                    break :block_117 (try function_6(allocator, operand_116));
                };
                _ = block_115: {
                    const operand_114 = (state_6).workspace;

                    break :block_115 (try function_7(allocator, operand_114));
                };

                const value_21: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((!block_22: {
                    const operand_21 = @as((zx_abi).zx_type_12, block_20: {
                        const operand_17 = (state_6).workspace;

                        const operand_19 = block_18: {
                            break :block_18 value_3;
                        };

                        break :block_20 .{ operand_17, operand_19, };
                    });

                    break :block_22 (try function_0(allocator, (&operand_21)));
                })) block_113: {
                    const value_20: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((!block_23: {
                        break :block_23 value_4;
                    })) block_37: {
                        _ = block_36: {
                            const operand_35 = @as((zx_abi).zx_type_14, block_34: {
                                const operand_30 = (state_6).workspace;

                                const operand_32 = block_31: {
                                    break :block_31 value_3;
                                };
                                const operand_33 = true;

                                break :block_34 .{ operand_30, operand_32, operand_33, };
                            });

                            break :block_36 (try function_3(allocator, (&operand_35)));
                        };
                        _ = block_29: {
                            const operand_24 = (state_6).table;

                            const operand_26 = block_25: {
                                break :block_25 value_3;
                            };
                            const operand_27 = (state_6).workspace;
                            const operand_28 = (zx_abi).zx_type_31{ .table = operand_24, .index = operand_26, .workspace = operand_27, };

                            break :block_29 (try function_17(allocator, (&operand_28)));
                        };

                        break :block_37 state_6;
                    } else block_112: {
                        const value_5: (zx_abi).zx_type_15 = block_111: {
                            const operand_110 = block_109: {
                                const operand_107 = ((state_6).table).kinds;

                                const operand_108 = block_106: {
                                    break :block_106 value_3;
                                };

                                if ((operand_108 >= (operand_107).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_109 (operand_107)[@intCast(operand_108)];
                            };

                            break :block_111 (try function_13(allocator, operand_110));
                        };
                        const value_6: bool = ((block_104: {
                            break :block_104 value_5;
                        } == @as((zx_abi).zx_type_15, .Tuple)) or (block_105: {
                            break :block_105 value_5;
                        } == @as((zx_abi).zx_type_15, .Object)));

                        _ = block_103: {
                            const operand_102 = @as((zx_abi).zx_type_14, block_101: {
                                const operand_90 = (state_6).workspace;

                                const operand_98 = (if (block_91: {
                                    break :block_91 value_6;
                                }) block_97: {
                                    const operand_96 = block_95: {
                                        const operand_93 = ((state_6).table).second;

                                        const operand_94 = block_92: {
                                            break :block_92 value_3;
                                        };

                                        if ((operand_94 >= (operand_93).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_95 (operand_93)[@intCast(operand_94)];
                                    };

                                    break :block_97 (try function_11(allocator, operand_96));
                                } else @as(u64, 0));

                                const operand_100 = block_99: {
                                    break :block_99 value_6;
                                };

                                break :block_101 .{ operand_90, operand_98, operand_100, };
                            });

                            break :block_103 (try function_8(allocator, (&operand_102)));
                        };
                        _ = block_89: {
                            const operand_84 = (state_6).table;

                            const operand_86 = block_85: {
                                break :block_85 value_3;
                            };

                            const operand_87 = (state_6).buffer;
                            const operand_88 = (zx_abi).zx_type_29{ .table = operand_84, .index = operand_86, .buffer = operand_87, };

                            break :block_89 (try function_16(allocator, (&operand_88)));
                        };
                        const value_7: u64 = block_83: {
                            const operand_82 = @as((zx_abi).zx_type_12, block_81: {
                                const operand_78 = (state_6).workspace;
                                const operand_80 = block_79: {
                                    break :block_79 value_3;
                                };

                                break :block_81 .{ operand_78, operand_80, };
                            });

                            break :block_83 (try function_9(allocator, (&operand_82)));
                        };
                        _ = block_77: {
                            const operand_76 = @as((zx_abi).zx_type_13, block_75: {
                                const operand_70 = (state_6).workspace;

                                const operand_72 = block_71: {
                                    break :block_71 value_3;
                                };
                                const operand_74 = block_73: {
                                    break :block_73 value_7;
                                };

                                break :block_75 .{ operand_70, operand_72, operand_74, };
                            });

                            break :block_77 (try function_2(allocator, (&operand_76)));
                        };

                        const value_19: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (((block_38: {
                            break :block_38 value_5;
                        } == @as((zx_abi).zx_type_15, .Enumeration)) or (block_39: {
                            break :block_39 value_5;
                        } == @as((zx_abi).zx_type_15, .NativeReference)))) block_69: {
                            const value_8: u64 = block_68: {
                                const operand_58 = (state_6).origins;
                                const operand_59 = (state_6).names;
                                const operand_61 = block_60: {
                                    break :block_60 value_3;
                                };
                                const operand_66 = block_65: {
                                    const operand_63 = ((state_6).table).labels;

                                    const operand_64 = block_62: {
                                        break :block_62 value_3;
                                    };

                                    if ((operand_64 >= (operand_63).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_65 (operand_63)[@intCast(operand_64)];
                                };
                                const operand_67 = (zx_abi).zx_type_38{ .origins = operand_58, .names = operand_59, .index = operand_61, .name = operand_66, };

                                break :block_68 (try function_18(allocator, (&operand_67)));
                            };
                            const value_18: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((block_40: {
                                break :block_40 value_8;
                            } == @as(u64, 0))) block_43: {
                                const value_9: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_6;
                                _ = (value_9).status;
                                const value_11: u64 = @as(u64, 1);

                                const value_12: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_42: {
                                    break :block_42 @as((zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (value_9).buffer, .names = (value_9).names, .origins = (value_9).origins, .status = block_41: {
                                        break :block_41 value_11;
                                    }, .table = (value_9).table, .workspace = (value_9).workspace, });
                                };

                                break :block_43 value_12;
                            } else block_57: {
                                const value_17: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((block_44: {
                                    break :block_44 value_8;
                                } == @as(u64, 1))) block_47: {
                                    const value_13: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_6;
                                    _ = (value_13).status;
                                    const value_15: u64 = @as(u64, 0);
                                    const value_16: (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_46: {
                                        break :block_46 @as((zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .buffer = (value_13).buffer, .names = (value_13).names, .origins = (value_13).origins, .status = block_45: {
                                            break :block_45 value_15;
                                        }, .table = (value_13).table, .workspace = (value_13).workspace, });
                                    };

                                    break :block_47 value_16;
                                } else block_56: {
                                    _ = block_55: {
                                        const operand_54 = @as((zx_abi).zx_type_13, block_53: {
                                            const operand_48 = (state_6).workspace;
                                            const operand_50 = block_49: {
                                                break :block_49 value_7;
                                            };
                                            const operand_52 = (block_51: {
                                                break :block_51 value_8;
                                            } - @as(u64, 2));

                                            break :block_53 .{ operand_48, operand_50, operand_52, };
                                        });

                                        break :block_55 (try function_10(allocator, (&operand_54)));
                                    };

                                    break :block_56 state_6;
                                });

                                break :block_57 value_17;
                            });

                            break :block_69 value_18;
                        } else state_6);

                        break :block_112 value_19;
                    });

                    break :block_113 value_20;
                } else state_6);

                break :block_120 value_21;
            };
        }

        break :block_123 block_122: {
            break :block_122 (if (((state_6).zx_origin != null)) ((state_6).zx_origin.?).* else block_121: {
                break :block_121 (zx_abi).zx_type_41{ .buffer = (state_6).buffer, .names = (state_6).names, .origins = (state_6).origins, .status = (state_6).status, .table = (state_6).table, .workspace = (state_6).workspace, };
            });
        };
    };

    return (if ((((&value_22)).status == @as(u64, 2))) (block_5: {
        const operand_4 = @as((zx_abi).zx_type_12, block_3: {
            const operand_1 = (in).workspace;
            const operand_2 = (in).index;

            break :block_3 .{ operand_1, operand_2, };
        });

        break :block_5 (try function_1(allocator, (&operand_4)));
    } + @as(u64, 2)) else ((&value_22)).status);
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_40) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try function_19(allocator, in));

    return value_1;
}

