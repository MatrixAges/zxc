const std = @import("std");
const zx_native_0 = @import("integers");
const zx_native_1 = @import("type_flags");
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_1, }, };
const zx_shape_14 = .{ .kind = .scalar, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_16 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_17 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .children = zx_shape_16, .field_names = zx_shape_17, .field_types = zx_shape_16, .first = zx_shape_16, .kinds = zx_shape_15, .labels = zx_shape_17, .names = zx_shape_17, .second = zx_shape_16, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .base = zx_shape_18, .delta = zx_shape_18, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_14, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .names = zx_shape_17, .types = zx_shape_16, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .children = zx_shape_16, .fields = zx_shape_21, .first = zx_shape_4, .kind = zx_shape_14, .label = zx_shape_10, .names = zx_shape_17, .second = zx_shape_4, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .delta = zx_shape_18, .id = zx_shape_4, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .flags = zx_shape_11, .index = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_18, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .children = zx_shape_16, .count = zx_shape_5, .flags = zx_shape_11, .found = zx_shape_1, .index = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .flags = zx_shape_11, .id = zx_shape_4, .native_references = zx_shape_1, .table = zx_shape_18, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .table = zx_shape_18, .target = zx_shape_14, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .flags = zx_shape_11, .index = zx_shape_5, .limit = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_18, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_27, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_27, .@"1" = zx_shape_1, }, };
pub const input_shape = zx_shape_27;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_27;
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

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_1).allocate((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!bool {
    const native_result = (zx_native_1).get((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ }!void {
    const native_result = (zx_native_1).set((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!void {
    const native_result = (zx_native_1).release(in);

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_14, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_14, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_14, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_14, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_14, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_14, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_14, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_14, .Enumeration) else @as((zx_abi).zx_type_14, .NativeReference)))))))));
    };
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_14 = (try function_6(allocator, block_45: {
        const operand_43 = ((in).table).kinds;
        const operand_44 = (in).index;

        if ((operand_44 >= (operand_43).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_45 (operand_43)[@intCast(operand_44)];
    }));

    const value_2: (zx_abi).zx_type_14 = (if ((in).native_references) @as((zx_abi).zx_type_14, .NativeReference) else @as((zx_abi).zx_type_14, .List));

    if ((value_1 == value_2)) {
        return true;
    }

    if (((value_1 == @as((zx_abi).zx_type_14, .Optional)) or ((in).native_references and ((value_1 == @as((zx_abi).zx_type_14, .List)) or (value_1 == @as((zx_abi).zx_type_14, .Task)))))) {
        return block_42: {
            const operand_41 = @as((zx_abi).zx_type_12, block_40: {
                const operand_35 = (in).flags;

                const operand_39 = (try function_0(allocator, block_38: {
                    const operand_36 = ((in).table).first;
                    const operand_37 = (in).index;

                    if ((operand_37 >= (operand_36).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_38 (operand_36)[@intCast(operand_37)];
                }));

                break :block_40 .{ operand_35, operand_39, };
            });

            break :block_42 (try function_3(allocator, (&operand_41)));
        };
    }

    if (((value_1 != @as((zx_abi).zx_type_14, .Tuple)) and (value_1 != @as((zx_abi).zx_type_14, .Object)))) {
        return false;
    }

    const value_3: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_14, .Tuple))) ((in).table).children else ((in).table).field_types);

    const value_14: (zx_abi).zx_type_26 = block_34: {
        const operand_15 = block_14: {
            const operand_2 = (in).flags;
            const operand_3 = value_3;

            const operand_4 = (try function_0(allocator, block_7: {
                const operand_5 = ((in).table).first;
                const operand_6 = (in).index;

                if ((operand_6 >= (operand_5).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_7 (operand_5)[@intCast(operand_6)];
            }));

            const operand_8 = (try function_0(allocator, block_11: {
                const operand_9 = ((in).table).second;
                const operand_10 = (in).index;

                if ((operand_10 >= (operand_9).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_11 (operand_9)[@intCast(operand_10)];
            }));

            const operand_12 = @as(u64, 0);
            const operand_13 = false;

            break :block_14 (zx_abi).zx_type_26{ .flags = operand_2, .children = operand_3, .offset = operand_4, .count = operand_8, .index = operand_12, .found = operand_13, };
        };

        var state_1: (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (operand_15).children, .count = (operand_15).count, .flags = (operand_15).flags, .found = (operand_15).found, .index = (operand_15).index, .offset = (operand_15).offset, .zx_origin = (&operand_15), };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_31: {
                const value_6: (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                _ = (value_6).found;

                const value_8: bool = block_30: {
                    const operand_29 = @as((zx_abi).zx_type_12, block_28: {
                        const operand_21 = (state_1).flags;

                        const operand_27 = block_26: {
                            const operand_25 = block_24: {
                                const operand_22 = (state_1).children;
                                const operand_23 = ((state_1).offset + (state_1).index);

                                if ((operand_23 >= (operand_22).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_24 (operand_22)[@intCast(operand_23)];
                            };

                            break :block_26 (try function_0(allocator, operand_25));
                        };

                        break :block_28 .{ operand_21, operand_27, };
                    });

                    break :block_30 (try function_3(allocator, (&operand_29)));
                };

                const value_9: (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_6).children, .count = (value_6).count, .flags = (value_6).flags, .found = block_19: {
                        break :block_19 value_8;
                    }, .index = (value_6).index, .offset = (value_6).offset, });
                };

                const value_10: (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_10).children, .count = (value_10).count, .flags = (value_10).flags, .found = (value_10).found, .index = (block_16: {
                        break :block_16 value_11;
                    } + block_17: {
                        break :block_17 value_12;
                    }), .offset = (value_10).offset, });
                };

                break :block_31 value_13;
            };
        }

        break :block_34 block_33: {
            break :block_33 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_32: {
                break :block_32 (zx_abi).zx_type_26{ .children = (state_1).children, .count = (state_1).count, .flags = (state_1).flags, .found = (state_1).found, .index = (state_1).index, .offset = (state_1).offset, };
            });
        };
    };

    return ((&value_14)).found;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: (zx_abi).zx_type_14 = (if ((in).native_references) @as((zx_abi).zx_type_14, .NativeReference) else @as((zx_abi).zx_type_14, .List));

    if (((try function_6(allocator, block_61: {
        const operand_59 = ((in).table).kinds;
        const operand_60 = value_1;

        if ((operand_60 >= (operand_59).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_61 (operand_59)[@intCast(operand_60)];
    })) == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_28 = block_58: {
        const operand_44 = block_43: {
            const operand_38 = (in).table;
            const operand_39 = value_1;
            const operand_40 = value_2;
            const operand_41 = @as(u64, 0);
            const operand_42 = false;

            break :block_43 (zx_abi).zx_type_28{ .table = operand_38, .limit = operand_39, .target = operand_40, .index = operand_41, .found = operand_42, };
        };

        var state_37: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (operand_44).found, .index = (operand_44).index, .limit = (operand_44).limit, .table = (operand_44).table, .target = (operand_44).target, .zx_origin = (&operand_44), };

        while (((!(state_37).found) and ((state_37).index < (state_37).limit))) {
            state_37 = block_55: {
                const value_5: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_37;
                _ = (value_5).found;

                const value_7: bool = (block_54: {
                    const operand_53 = block_52: {
                        const operand_50 = ((state_37).table).kinds;
                        const operand_51 = (state_37).index;

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    };

                    break :block_54 (try function_6(allocator, operand_53));
                } == (state_37).target);

                const value_8: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_49: {
                    break :block_49 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = block_48: {
                        break :block_48 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .table = (value_5).table, .target = (value_5).target, });
                };

                const value_9: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_47: {
                    break :block_47 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (value_9).found, .index = (block_45: {
                        break :block_45 value_10;
                    } + block_46: {
                        break :block_46 value_11;
                    }), .limit = (value_9).limit, .table = (value_9).table, .target = (value_9).target, });
                };

                break :block_55 value_12;
            };
        }

        break :block_58 block_57: {
            break :block_57 (if (((state_37).zx_origin != null)) ((state_37).zx_origin.?).* else block_56: {
                break :block_56 (zx_abi).zx_type_28{ .found = (state_37).found, .index = (state_37).index, .limit = (state_37).limit, .table = (state_37).table, .target = (state_37).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    _ = block_36: {
        const operand_35 = @as((zx_abi).zx_type_12, block_34: {
            const operand_32 = (in).flags;
            const operand_33 = (value_1 + @as(u64, 1));

            break :block_34 .{ operand_32, operand_33, };
        });

        break :block_36 (try function_2(allocator, (&operand_35)));
    };

    _ = block_31: {
        const operand_13 = block_12: {
            const operand_7 = (in).table;
            const operand_8 = (((&value_13)).index - @as(u64, 1));
            const operand_9 = (value_1 + @as(u64, 1));
            const operand_10 = (in).flags;
            const operand_11 = (in).native_references;

            break :block_12 (zx_abi).zx_type_29{ .table = operand_7, .index = operand_8, .limit = operand_9, .flags = operand_10, .native_references = operand_11, };
        };

        var state_6: (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .flags = (operand_13).flags, .index = (operand_13).index, .limit = (operand_13).limit, .native_references = (operand_13).native_references, .table = (operand_13).table, .zx_origin = (&operand_13), };

        while (((state_6).index < (state_6).limit)) {
            state_6 = block_30: {
                const value_16: bool = block_29: {
                    const operand_24 = (state_6).table;
                    const operand_25 = (state_6).index;
                    const operand_26 = (state_6).flags;
                    const operand_27 = (state_6).native_references;
                    const operand_28 = (zx_abi).zx_type_25{ .table = operand_24, .index = operand_25, .flags = operand_26, .native_references = operand_27, };

                    break :block_29 (try function_7(allocator, (&operand_28)));
                };
                _ = block_23: {
                    const operand_22 = @as((zx_abi).zx_type_13, block_21: {
                        const operand_17 = (state_6).flags;
                        const operand_18 = (state_6).index;

                        const operand_20 = block_19: {
                            break :block_19 value_16;
                        };

                        break :block_21 .{ operand_17, operand_18, operand_20, };
                    });

                    break :block_23 (try function_4(allocator, (&operand_22)));
                };

                const value_17: (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_6;
                const value_18: u64 = (value_17).index;
                const value_19: u64 = @as(u64, 1);

                const value_20: (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .flags = (value_17).flags, .index = (block_14: {
                        break :block_14 value_18;
                    } + block_15: {
                        break :block_15 value_19;
                    }), .limit = (value_17).limit, .native_references = (value_17).native_references, .table = (value_17).table, });
                };

                break :block_30 value_20;
            };
        }

        break :block_31 {};
    };

    const value_21: bool = block_5: {
        const operand_4 = @as((zx_abi).zx_type_12, block_3: {
            const operand_1 = (in).flags;
            const operand_2 = value_1;

            break :block_3 .{ operand_1, operand_2, };
        });

        break :block_5 (try function_3(allocator, (&operand_4)));
    };

    _ = (try function_5(allocator, (in).flags));

    return value_21;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_8(allocator, in));

    return value_1;
}
