const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_25;
pub const Output = *const (zx_abi).zx_type_20;
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
const zx_shape_23 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .equal = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .tables = zx_shape_16, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_16, }, };
pub const input_shape = zx_shape_25;
pub const output_shape = zx_shape_20;

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

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_17 = block_74: {
        const operand_70 = block_69: {
            const operand_67 = (in).tables;
            const operand_68 = (in).id;

            break :block_69 (zx_abi).zx_type_22{ .tables = operand_67, .id = operand_68, };
        };

        const operand_71 = (&operand_70);
        const operand_72 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_71).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_71).tables).base, .delta = ((operand_71).tables).delta, .zx_origin = (operand_71).tables, }, .zx_origin = operand_71, }));

        break :block_74 (if (((operand_72).zx_origin != null)) ((operand_72).zx_origin.?).* else block_73: {
            break :block_73 (zx_abi).zx_type_17{ .delta = (operand_72).delta, .first = (operand_72).first, .kind = (operand_72).kind, .label = (operand_72).label, .second = (operand_72).second, };
        });
    };

    const value_2: (zx_abi).zx_type_19 = ((in).candidate).*;

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
        return block_66: {
            const operand_64 = ((&value_1)).label;
            const operand_65 = ((&value_2)).label;

            break :block_66 ((std).mem).eql(u8, operand_64, operand_65);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_11, .Enumeration)) and (!block_63: {
        const operand_61 = ((&value_1)).label;
        const operand_62 = ((&value_2)).label;

        break :block_63 ((std).mem).eql(u8, operand_61, operand_62);
    }))) {
        return false;
    }

    const value_3: (zx_abi).zx_type_15 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_4: u64 = (try function_0(allocator, ((&value_1)).first));
    const value_5: u64 = (try function_0(allocator, ((&value_1)).second));

    const value_6: u64 = block_60: {
        const operand_59 = ((&value_1)).kind;

        break :block_60 (if ((operand_59 == @as((zx_abi).zx_type_11, .Object))) @as(u64, ((((&value_2)).fields).names).len) else (if ((operand_59 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, (((&value_2)).children).len) else @as(u64, (((&value_2)).names).len)));
    };

    if ((value_5 != value_6)) {
        return false;
    }

    const value_12: (zx_abi).zx_type_24 = block_58: {
        const operand_9 = block_8: {
            const operand_2 = (&value_3);
            const operand_3 = (&value_2);
            const operand_4 = value_4;
            const operand_5 = value_5;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_24{ .table = operand_2, .candidate = operand_3, .first = operand_4, .count = operand_5, .index = operand_6, .equal = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_24_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = (zx_abi).value_zx_type_24_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_9).candidate).children, .fields = (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_9).candidate).fields).names, .types = (((operand_9).candidate).fields).types, .zx_origin = ((operand_9).candidate).fields, }, .first = ((operand_9).candidate).first, .kind = ((operand_9).candidate).kind, .label = ((operand_9).candidate).label, .names = ((operand_9).candidate).names, .second = ((operand_9).candidate).second, .zx_origin = (operand_9).candidate, }, .count = (operand_9).count, .equal = (operand_9).equal, .first = (operand_9).first, .index = (operand_9).index, .table = (operand_9).table, .zx_origin = (&operand_9), };

        while (((state_1).equal and ((state_1).index < (state_1).count))) {
            state_1 = block_51: {
                const value_9: u64 = ((state_1).first + (state_1).index);

                const value_10: bool = block_50: {
                    const operand_15 = ((state_1).candidate).kind;

                    break :block_50 (if ((operand_15 == @as((zx_abi).zx_type_11, .Object))) (block_42: {
                        const operand_40 = block_36: {
                            const operand_34 = ((state_1).table).field_names;

                            const operand_35 = block_33: {
                                break :block_33 value_9;
                            };

                            if ((operand_35 >= (operand_34).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_36 (operand_34)[@intCast(operand_35)];
                        };
                        const operand_41 = block_39: {
                            const operand_37 = (((state_1).candidate).fields).names;
                            const operand_38 = (state_1).index;

                            if ((operand_38 >= (operand_37).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_39 (operand_37)[@intCast(operand_38)];
                        };

                        break :block_42 ((std).mem).eql(u8, operand_40, operand_41);
                    } and (block_46: {
                        const operand_44 = ((state_1).table).field_types;

                        const operand_45 = block_43: {
                            break :block_43 value_9;
                        };

                        if ((operand_45 >= (operand_44).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_46 (operand_44)[@intCast(operand_45)];
                    } == block_49: {
                        const operand_47 = (((state_1).candidate).fields).types;
                        const operand_48 = (state_1).index;

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    })) else (if ((operand_15 == @as((zx_abi).zx_type_11, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).table).children;

                        const operand_28 = block_26: {
                            break :block_26 value_9;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_32: {
                        const operand_30 = ((state_1).candidate).children;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    }) else block_25: {
                        const operand_23 = block_19: {
                            const operand_17 = ((state_1).table).names;

                            const operand_18 = block_16: {
                                break :block_16 value_9;
                            };

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_19 (operand_17)[@intCast(operand_18)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).candidate).names;
                            const operand_21 = (state_1).index;

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_11: (zx_abi).value_zx_type_24_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = block_14: {
                    const operand_10 = state_1;
                    const operand_11 = ((state_1).index + @as(u64, 1));

                    const operand_12 = block_13: {
                        break :block_13 value_10;
                    };

                    break :block_14 @as((zx_abi).value_zx_type_24_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf, (zx_abi).value_zx_type_24_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (operand_10).candidate, .count = (operand_10).count, .equal = operand_12, .first = (operand_10).first, .index = operand_11, .table = (operand_10).table, });
                };

                break :block_51 value_11;
            };
        }

        break :block_58 block_57: {
            break :block_57 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_56: {
                break :block_56 (zx_abi).zx_type_24{ .candidate = (if ((((state_1).candidate).zx_origin != null)) ((state_1).candidate).zx_origin.? else block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_54).* = (zx_abi).zx_type_19{ .children = ((state_1).candidate).children, .fields = (if (((((state_1).candidate).fields).zx_origin != null)) (((state_1).candidate).fields).zx_origin.? else block_53: {
                        const operand_52 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_52).* = (zx_abi).zx_type_18{ .names = (((state_1).candidate).fields).names, .types = (((state_1).candidate).fields).types, };

                        break :block_53 @as(*const (zx_abi).zx_type_18, operand_52);
                    }), .first = ((state_1).candidate).first, .kind = ((state_1).candidate).kind, .label = ((state_1).candidate).label, .names = ((state_1).candidate).names, .second = ((state_1).candidate).second, };

                    break :block_55 @as(*const (zx_abi).zx_type_19, operand_54);
                }), .count = (state_1).count, .equal = (state_1).equal, .first = (state_1).first, .index = (state_1).index, .table = (state_1).table, };
            });
        };
    };

    return ((&value_12)).equal;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_20 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

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

    const value_8: *const (zx_abi).zx_type_26 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_26));

                (operand_13).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_26, operand_13);
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
                    const operand_39 = (zx_abi).zx_type_23{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_4(allocator, (&operand_39)));

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
            const operand_54 = (try (allocator).create((zx_abi).zx_type_26));

            (operand_54).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .candidate = block_47: {
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

            break :block_55 @as(*const (zx_abi).zx_type_26, operand_54);
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
