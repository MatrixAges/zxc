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

    const value_1: (zx_abi).zx_type_11 = (try function_2(allocator, block_39: {
        const operand_37 = ((in).table).kinds;
        const operand_38 = (in).index;

        if ((operand_38 >= (operand_37).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_39 (operand_37)[@intCast(operand_38)];
    }));

    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if ((value_1 == value_2)) {
        return true;
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Optional)) or ((in).native_references and ((value_1 == @as((zx_abi).zx_type_11, .List)) or (value_1 == @as((zx_abi).zx_type_11, .Task)))))) {
        return block_36: {
            const operand_34 = (in).flags;

            const operand_35 = (try function_0(allocator, block_33: {
                const operand_31 = ((in).table).first;
                const operand_32 = (in).index;

                if ((operand_32 >= (operand_31).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_33 (operand_31)[@intCast(operand_32)];
            }));

            if ((operand_35 >= (operand_34).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_36 (operand_34)[@intCast(operand_35)];
        };
    }

    if (((value_1 != @as((zx_abi).zx_type_11, .Tuple)) and (value_1 != @as((zx_abi).zx_type_11, .Object)))) {
        return false;
    }

    const value_3: []const u32 = (if ((value_1 == @as((zx_abi).zx_type_11, .Tuple))) ((in).table).children else ((in).table).field_types);

    return block_30: {
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

        break :block_30 (state_1).found;
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if (((try function_2(allocator, block_57: {
        const operand_55 = ((in).table).kinds;
        const operand_56 = value_1;

        if ((operand_56 >= (operand_55).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_57 (operand_55)[@intCast(operand_56)];
    })) == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_26 = block_54: {
        const operand_40 = block_39: {
            const operand_34 = (in).table;
            const operand_35 = value_1;
            const operand_36 = value_2;
            const operand_37 = @as(u64, 0);
            const operand_38 = false;

            break :block_39 (zx_abi).zx_type_26{ .table = operand_34, .limit = operand_35, .target = operand_36, .index = operand_37, .found = operand_38, };
        };

        var state_33: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (operand_40).found, .index = (operand_40).index, .limit = (operand_40).limit, .table = (operand_40).table, .target = (operand_40).target, .zx_origin = (&operand_40), };

        while (((!(state_33).found) and ((state_33).index < (state_33).limit))) {
            state_33 = block_51: {
                const value_5: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_33;

                _ = (value_5).found;

                const value_7: bool = (block_50: {
                    const operand_49 = block_48: {
                        const operand_46 = ((state_33).table).kinds;
                        const operand_47 = (state_33).index;

                        if ((operand_47 >= (operand_46).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_48 (operand_46)[@intCast(operand_47)];
                    };

                    break :block_50 (try function_2(allocator, operand_49));
                } == (state_33).target);

                const value_8: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_45: {
                    break :block_45 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = block_44: {
                        break :block_44 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .table = (value_5).table, .target = (value_5).target, });
                };

                const value_9: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_43: {
                    break :block_43 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .found = (value_9).found, .index = (block_41: {
                        break :block_41 value_10;
                    } + block_42: {
                        break :block_42 value_11;
                    }), .limit = (value_9).limit, .table = (value_9).table, .target = (value_9).target, });
                };

                break :block_51 value_12;
            };
        }

        break :block_54 block_53: {
            break :block_53 (if (((state_33).zx_origin != null)) ((state_33).zx_origin.?).* else block_52: {
                break :block_52 (zx_abi).zx_type_26{ .found = (state_33).found, .index = (state_33).index, .limit = (state_33).limit, .table = (state_33).table, .target = (state_33).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    const value_14: []const bool = @as([]const bool, (comptime (&[_]bool{})));

    return block_32: {
        const operand_9 = block_8: {
            const operand_2 = (in).table;
            const operand_3 = @as(u64, 0);
            const operand_4 = (((&value_13)).index - @as(u64, 1));
            const operand_5 = (value_1 + @as(u64, 1));
            const operand_6 = value_14;
            const operand_7 = (in).native_references;

            break :block_8 (zx_abi).zx_type_27{ .table = operand_2, .index = operand_3, .first = operand_4, .limit = operand_5, .flags = operand_6, .native_references = operand_7, };
        };

        var state_capacity_10: (std).ArrayList(bool) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (operand_9).first, .flags = (operand_9).flags, .index = (operand_9).index, .limit = (operand_9).limit, .native_references = (operand_9).native_references, .table = (operand_9).table, .zx_origin = (&operand_9), };

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_27: {
                const value_17: bool = (((state_1).index >= (state_1).first) and block_26: {
                    const operand_21 = (state_1).table;
                    const operand_22 = (state_1).index;
                    const operand_23 = (state_1).flags;
                    const operand_24 = (state_1).native_references;
                    const operand_25 = (zx_abi).zx_type_23{ .table = operand_21, .index = operand_22, .flags = operand_23, .native_references = operand_24, };

                    break :block_26 (try function_3(allocator, (&operand_25)));
                });

                const value_18: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

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

                    break :block_20 @as((zx_abi).value_zx_type_28_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                }).@"0";

                const value_21: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_18).first, .flags = block_15: {
                        break :block_15 value_20;
                    }, .index = (value_18).index, .limit = (value_18).limit, .native_references = (value_18).native_references, .table = (value_18).table, });
                };

                const value_22: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_21;
                const value_23: u64 = (value_22).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_22).first, .flags = (value_22).flags, .index = (block_12: {
                        break :block_12 value_23;
                    } + block_13: {
                        break :block_13 value_24;
                    }), .limit = (value_22).limit, .native_references = (value_22).native_references, .table = (value_22).table, });
                };

                break :block_27 value_25;
            };
        }

        break :block_32 block_31: {
            const operand_29 = (state_1).flags;

            const operand_30 = block_28: {
                break :block_28 value_1;
            };

            if ((operand_30 >= (operand_29).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_31 (operand_29)[@intCast(operand_30)];
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_4(allocator, in));

    return value_1;
}
