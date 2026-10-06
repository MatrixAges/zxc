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
const zx_shape_22 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .flags = zx_shape_22, .index = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .flags = zx_shape_22, .found = zx_shape_1, .index = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .native_references = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .table = zx_shape_15, .target = zx_shape_11, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .flags = zx_shape_22, .index = zx_shape_5, .limit = zx_shape_5, .native_references = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_22, .@"1" = zx_shape_0, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_25, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_25, .@"1" = zx_shape_1, }, };
pub const input_shape = zx_shape_25;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_25;
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

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_11 = (try function_2(allocator, block_41: {
        const operand_39 = ((in).table).kinds;
        const operand_40 = (in).index;

        if ((operand_40 >= (operand_39).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_41 (operand_39)[@intCast(operand_40)];
    }));

    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if ((value_1 == value_2)) {
        return true;
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Optional)) or ((in).native_references and ((value_1 == @as((zx_abi).zx_type_11, .List)) or (value_1 == @as((zx_abi).zx_type_11, .Task)))))) {
        return block_38: {
            const operand_36 = (in).flags;

            const operand_37 = (try function_0(allocator, block_35: {
                const operand_33 = ((in).table).first;
                const operand_34 = (in).index;

                if ((operand_34 >= (operand_33).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_35 (operand_33)[@intCast(operand_34)];
            }));

            if ((operand_37 >= (operand_36).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_38 (operand_36)[@intCast(operand_37)];
        };
    }

    if (((value_1 != @as((zx_abi).zx_type_11, .Tuple)) and (value_1 != @as((zx_abi).zx_type_11, .Object)))) {
        return false;
    }

    const value_3: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

    const value_14: (zx_abi).zx_type_24 = block_32: {
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

            break :block_14 (zx_abi).zx_type_24{ .flags = operand_2, .children = operand_3, .offset = operand_4, .count = operand_8, .index = operand_12, .found = operand_13, };
        };

        var state_1: (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (operand_15).children, .count = (operand_15).count, .flags = (operand_15).flags, .found = (operand_15).found, .index = (operand_15).index, .offset = (operand_15).offset, .zx_origin = (&operand_15), };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_29: {
                const value_6: (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                _ = (value_6).found;

                const value_8: bool = block_28: {
                    const operand_26 = (state_1).flags;

                    const operand_27 = block_25: {
                        const operand_24 = block_23: {
                            const operand_21 = (state_1).children;
                            const operand_22 = ((state_1).offset + (state_1).index);

                            if ((operand_22 >= (operand_21).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_23 (operand_21)[@intCast(operand_22)];
                        };

                        break :block_25 (try function_0(allocator, operand_24));
                    };

                    if ((operand_27 >= (operand_26).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_28 (operand_26)[@intCast(operand_27)];
                };

                const value_9: (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_6).children, .count = (value_6).count, .flags = (value_6).flags, .found = block_19: {
                        break :block_19 value_8;
                    }, .index = (value_6).index, .offset = (value_6).offset, });
                };

                const value_10: (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_24_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_10).children, .count = (value_10).count, .flags = (value_10).flags, .found = (value_10).found, .index = (block_16: {
                        break :block_16 value_11;
                    } + block_17: {
                        break :block_17 value_12;
                    }), .offset = (value_10).offset, });
                };

                break :block_29 value_13;
            };
        }

        break :block_32 block_31: {
            break :block_31 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_30: {
                break :block_30 (zx_abi).zx_type_24{ .children = (state_1).children, .count = (state_1).count, .flags = (state_1).flags, .found = (state_1).found, .index = (state_1).index, .offset = (state_1).offset, };
            });
        };
    };

    return ((&value_14)).found;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if (((try function_2(allocator, block_59: {
        const operand_57 = ((in).table).kinds;
        const operand_58 = value_1;

        if ((operand_58 >= (operand_57).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_59 (operand_57)[@intCast(operand_58)];
    })) == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_26 = block_56: {
        const operand_42 = block_41: {
            const operand_36 = (in).table;
            const operand_37 = value_1;
            const operand_38 = value_2;
            const operand_39 = @as(u64, 0);
            const operand_40 = false;

            break :block_41 (zx_abi).zx_type_26{ .table = operand_36, .limit = operand_37, .target = operand_38, .index = operand_39, .found = operand_40, };
        };

        var state_35: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (operand_42).found, .index = (operand_42).index, .limit = (operand_42).limit, .table = (operand_42).table, .target = (operand_42).target, .zx_origin = (&operand_42), };

        while (((!(state_35).found) and ((state_35).index < (state_35).limit))) {
            state_35 = block_53: {
                const value_5: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_35;
                _ = (value_5).found;

                const value_7: bool = (block_52: {
                    const operand_51 = block_50: {
                        const operand_48 = ((state_35).table).kinds;
                        const operand_49 = (state_35).index;

                        if ((operand_49 >= (operand_48).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_50 (operand_48)[@intCast(operand_49)];
                    };

                    break :block_52 (try function_2(allocator, operand_51));
                } == (state_35).target);

                const value_8: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_47: {
                    break :block_47 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = block_46: {
                        break :block_46 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .table = (value_5).table, .target = (value_5).target, });
                };

                const value_9: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_45: {
                    break :block_45 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (value_9).found, .index = (block_43: {
                        break :block_43 value_10;
                    } + block_44: {
                        break :block_44 value_11;
                    }), .limit = (value_9).limit, .table = (value_9).table, .target = (value_9).target, });
                };

                break :block_53 value_12;
            };
        }

        break :block_56 block_55: {
            break :block_55 (if (((state_35).zx_origin != null)) ((state_35).zx_origin.?).* else block_54: {
                break :block_54 (zx_abi).zx_type_26{ .found = (state_35).found, .index = (state_35).index, .limit = (state_35).limit, .table = (state_35).table, .target = (state_35).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    const value_14: []const bool = @as([]const bool, (comptime (&[_]bool{})));

    const value_26: (zx_abi).zx_type_27 = block_34: {
        const operand_12 = block_11: {
            const operand_5 = (in).table;
            const operand_6 = @as(u64, 0);
            const operand_7 = (((&value_13)).index - @as(u64, 1));
            const operand_8 = (value_1 + @as(u64, 1));
            const operand_9 = value_14;
            const operand_10 = (in).native_references;

            break :block_11 (zx_abi).zx_type_27{ .table = operand_5, .index = operand_6, .first = operand_7, .limit = operand_8, .flags = operand_9, .native_references = operand_10, };
        };

        var state_capacity_13: (std).ArrayList(bool) = .empty;
        var state_capacity_started_14 = false;

        defer (state_capacity_13).deinit(allocator);

        var state_4: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (operand_12).first, .flags = (operand_12).flags, .index = (operand_12).index, .limit = (operand_12).limit, .native_references = (operand_12).native_references, .table = (operand_12).table, .zx_origin = (&operand_12), };

        while (((state_4).index < (state_4).limit)) {
            state_4 = block_30: {
                const value_17: bool = (((state_4).index >= (state_4).first) and block_29: {
                    const operand_24 = (state_4).table;
                    const operand_25 = (state_4).index;
                    const operand_26 = (state_4).flags;
                    const operand_27 = (state_4).native_references;
                    const operand_28 = (zx_abi).zx_type_23{ .table = operand_24, .index = operand_25, .flags = operand_26, .native_references = operand_27, };

                    break :block_29 (try function_3(allocator, (&operand_28)));
                });

                const value_18: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_4;

                _ = (value_18).flags;

                const value_20: []const bool = (block_23: {
                    const operand_20 = (state_4).flags;

                    const operand_22 = block_21: {
                        break :block_21 value_17;
                    };

                    _ = (try ((std).math).add(usize, (operand_20).len, 1));

                    if ((!state_capacity_started_14)) {
                        (try (state_capacity_13).appendSlice(allocator, operand_20));

                        state_capacity_started_14 = true;
                    } else {
                        ((state_capacity_13).items).len = (operand_20).len;
                    }

                    (try (state_capacity_13).append(allocator, operand_22));

                    break :block_23 @as((zx_abi).value_zx_type_28_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_13).items, {}, null, });
                }).@"0";

                const value_21: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_19: {
                    break :block_19 @as((zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_18).first, .flags = block_18: {
                        break :block_18 value_20;
                    }, .index = (value_18).index, .limit = (value_18).limit, .native_references = (value_18).native_references, .table = (value_18).table, });
                };

                const value_22: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_21;
                const value_23: u64 = (value_22).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_17: {
                    break :block_17 @as((zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_22).first, .flags = (value_22).flags, .index = (block_15: {
                        break :block_15 value_23;
                    } + block_16: {
                        break :block_16 value_24;
                    }), .limit = (value_22).limit, .native_references = (value_22).native_references, .table = (value_22).table, });
                };

                break :block_30 value_25;
            };
        }

        var state_owned_31: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_31);

        if (state_capacity_started_14) {
            ((state_capacity_13).items).len = ((state_4).flags).len;
            state_owned_31 = (try (state_capacity_13).toOwnedSlice(allocator));
        }

        if (state_capacity_started_14) {
            (state_4).flags = state_owned_31;
        }

        if (state_capacity_started_14) {
            (state_4).zx_origin = null;
        }

        break :block_34 block_33: {
            break :block_33 (if (((state_4).zx_origin != null)) ((state_4).zx_origin.?).* else block_32: {
                break :block_32 (zx_abi).zx_type_27{ .first = (state_4).first, .flags = (state_4).flags, .index = (state_4).index, .limit = (state_4).limit, .native_references = (state_4).native_references, .table = (state_4).table, };
            });
        };
    };

    return block_3: {
        const operand_1 = ((&value_26)).flags;
        const operand_2 = value_1;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_4(allocator, in));

    return value_1;
}
