const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_30;
pub const Output = *const (zx_abi).zx_type_29;
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
const zx_shape_25 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .kinds = zx_shape_12, .members = zx_shape_14, .owners = zx_shape_14, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .base = zx_shape_26, .delta = zx_shape_26, }, };
const zx_shape_28 = .{ .kind = .scalar, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_28, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .origin = zx_shape_25, .origins = zx_shape_27, .tables = zx_shape_16, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .id = zx_shape_4, .index = zx_shape_5, .origin = zx_shape_25, .origins = zx_shape_27, .status = zx_shape_28, .tables = zx_shape_16, }, };
pub const input_shape = zx_shape_30;
pub const output_shape = zx_shape_29;

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

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_30) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_29 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (@as(u64, ((((in).origins).base).ids).len) + @as(u64, ((((in).origins).delta).ids).len));
    const value_2: u32 = @as(u32, 0);

    const value_14: *const (zx_abi).zx_type_31 = block_106: {
        const operand_18 = block_17: {
            const operand_7 = (in).tables;
            const operand_8 = (in).origins;
            const operand_9 = (in).origin;
            const operand_10 = (in).candidate;
            const operand_11 = value_1;
            const operand_12 = @as(u64, 0);
            const operand_13 = @as((zx_abi).zx_type_28, .Missing);
            const operand_14 = value_2;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_15).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .tables = operand_7, .origins = operand_8, .origin = operand_9, .candidate = operand_10, .count = operand_11, .index = operand_12, .status = operand_13, .id = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_31, operand_15);
            };
        };
        const state_type_20 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_21 = struct {
            children: []const u32,
            fields: state_type_20,
            first: u32,
            kind: (zx_abi).zx_type_11,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };

        const state_type_22 = struct {
            kind: u8,
            member: []const u8,
            owner: []const u8,
        };
        const state_type_23 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };

        const state_type_24 = struct {
            base: state_type_23,
            delta: state_type_23,
        };
        const state_type_25 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_26 = struct {
            base: state_type_25,
            delta: state_type_25,
        };

        const state_type_27 = struct {
            candidate: state_type_21,
            count: u64,
            id: u32,
            index: u64,
            origin: state_type_22,
            origins: state_type_24,
            status: (zx_abi).zx_type_28,
            tables: state_type_26,
        };
        const state_type_33 = struct {
            candidate: state_type_21,
            id: u32,
            tables: state_type_26,
        };
        const state_type_47 = struct {
            id: u32,
            tables: state_type_26,
        };

        const state_type_61 = struct {
            delta: bool,
            first: u32,
            kind: (zx_abi).zx_type_11,
            label: []const u8,
            second: u32,
        };

        var state_6: state_type_27 = state_type_27{ .candidate = state_type_21{ .children = ((operand_18).candidate).children, .fields = state_type_20{ .names = (((operand_18).candidate).fields).names, .types = (((operand_18).candidate).fields).types, }, .first = ((operand_18).candidate).first, .kind = ((operand_18).candidate).kind, .label = ((operand_18).candidate).label, .names = ((operand_18).candidate).names, .second = ((operand_18).candidate).second, }, .count = (operand_18).count, .id = (operand_18).id, .index = (operand_18).index, .origin = state_type_22{ .kind = ((operand_18).origin).kind, .member = ((operand_18).origin).member, .owner = ((operand_18).origin).owner, }, .origins = state_type_24{ .base = state_type_23{ .ids = (((operand_18).origins).base).ids, .kinds = (((operand_18).origins).base).kinds, .members = (((operand_18).origins).base).members, .owners = (((operand_18).origins).base).owners, }, .delta = state_type_23{ .ids = (((operand_18).origins).delta).ids, .kinds = (((operand_18).origins).delta).kinds, .members = (((operand_18).origins).delta).members, .owners = (((operand_18).origins).delta).owners, }, }, .status = (operand_18).status, .tables = state_type_26{ .base = state_type_25{ .children = (((operand_18).tables).base).children, .field_names = (((operand_18).tables).base).field_names, .field_types = (((operand_18).tables).base).field_types, .first = (((operand_18).tables).base).first, .kinds = (((operand_18).tables).base).kinds, .labels = (((operand_18).tables).base).labels, .names = (((operand_18).tables).base).names, .second = (((operand_18).tables).base).second, }, .delta = state_type_25{ .children = (((operand_18).tables).delta).children, .field_names = (((operand_18).tables).delta).field_names, .field_types = (((operand_18).tables).delta).field_types, .first = (((operand_18).tables).delta).first, .kinds = (((operand_18).tables).delta).kinds, .labels = (((operand_18).tables).delta).labels, .names = (((operand_18).tables).delta).names, .second = (((operand_18).tables).delta).second, }, }, };
        var state_changed_19 = false;

        while ((((state_6).status == @as((zx_abi).zx_type_28, .Missing)) and ((state_6).index < (state_6).count))) {
            state_6 = block_84: {
                const value_5: u64 = @as(u64, ((((state_6).origins).base).ids).len);
                const value_6: bool = ((state_6).index >= value_5);
                const value_7: state_type_23 = (if (value_6) ((state_6).origins).delta else ((state_6).origins).base);
                const value_8: u64 = (if (value_6) ((state_6).index - value_5) else (state_6).index);

                const value_9: u32 = block_83: {
                    const operand_81 = (value_7).ids;
                    const operand_82 = value_8;

                    if ((operand_82 >= (operand_81).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_83 (operand_81)[@intCast(operand_82)];
                };
                const value_10: bool = (((block_68: {
                    const operand_66 = (value_7).kinds;
                    const operand_67 = value_8;

                    if ((operand_67 >= (operand_66).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_68 (operand_66)[@intCast(operand_67)];
                } == ((state_6).origin).kind) and block_74: {
                    const operand_72 = block_71: {
                        const operand_69 = (value_7).owners;
                        const operand_70 = value_8;

                        if ((operand_70 >= (operand_69).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_71 (operand_69)[@intCast(operand_70)];
                    };

                    const operand_73 = ((state_6).origin).owner;

                    break :block_74 ((std).mem).eql(u8, operand_72, operand_73);
                }) and block_80: {
                    const operand_78 = block_77: {
                        const operand_75 = (value_7).members;
                        const operand_76 = value_8;

                        if ((operand_76 >= (operand_75).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_77 (operand_75)[@intCast(operand_76)];
                    };

                    const operand_79 = ((state_6).origin).member;

                    break :block_80 ((std).mem).eql(u8, operand_78, operand_79);
                });

                const value_11: bool = (value_10 and block_65: {
                    const operand_63 = (block_62: {
                        const operand_51 = block_50: {
                            const operand_48 = (state_6).tables;
                            const operand_49 = value_9;

                            break :block_50 state_type_47{ .tables = operand_48, .id = operand_49, };
                        };

                        const operand_52 = (zx_abi).zx_type_15{ .children = (((operand_51).tables).base).children, .field_names = (((operand_51).tables).base).field_names, .field_types = (((operand_51).tables).base).field_types, .first = (((operand_51).tables).base).first, .kinds = (((operand_51).tables).base).kinds, .labels = (((operand_51).tables).base).labels, .names = (((operand_51).tables).base).names, .second = (((operand_51).tables).base).second, };
                        const operand_53 = (zx_abi).zx_type_15{ .children = (((operand_51).tables).delta).children, .field_names = (((operand_51).tables).delta).field_names, .field_types = (((operand_51).tables).delta).field_types, .first = (((operand_51).tables).delta).first, .kinds = (((operand_51).tables).delta).kinds, .labels = (((operand_51).tables).delta).labels, .names = (((operand_51).tables).delta).names, .second = (((operand_51).tables).delta).second, };
                        const operand_54 = (zx_abi).zx_type_16{ .base = (&operand_52), .delta = (&operand_53), };
                        const operand_55 = (zx_abi).zx_type_22{ .id = (operand_51).id, .tables = (&operand_54), };

                        const operand_60 = block_59: {
                            const operand_56 = (&operand_55);
                            const operand_57 = (try function_3_value(allocator, (zx_abi).value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_56).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_56).tables).base, .delta = ((operand_56).tables).delta, .zx_origin = (operand_56).tables, }, .zx_origin = operand_56, }));

                            break :block_59 (if (((operand_57).zx_origin != null)) ((operand_57).zx_origin.?).* else block_58: {
                                break :block_58 (zx_abi).zx_type_17{ .delta = (operand_57).delta, .first = (operand_57).first, .kind = (operand_57).kind, .label = (operand_57).label, .second = (operand_57).second, };
                            });
                        };

                        break :block_62 state_type_61{ .delta = (operand_60).delta, .first = (operand_60).first, .kind = (operand_60).kind, .label = (operand_60).label, .second = (operand_60).second, };
                    }).label;

                    const operand_64 = ((state_6).candidate).label;

                    break :block_65 ((std).mem).eql(u8, operand_63, operand_64);
                });

                const value_12: (zx_abi).zx_type_28 = (if ((!value_11)) @as((zx_abi).zx_type_28, .Missing) else (if (block_46: {
                    const operand_38 = block_37: {
                        const operand_34 = (state_6).tables;
                        const operand_35 = value_9;
                        const operand_36 = (state_6).candidate;

                        break :block_37 state_type_33{ .tables = operand_34, .id = operand_35, .candidate = operand_36, };
                    };

                    const operand_39 = (zx_abi).zx_type_18{ .names = (((operand_38).candidate).fields).names, .types = (((operand_38).candidate).fields).types, };
                    const operand_40 = (zx_abi).zx_type_19{ .children = ((operand_38).candidate).children, .fields = (&operand_39), .first = ((operand_38).candidate).first, .kind = ((operand_38).candidate).kind, .label = ((operand_38).candidate).label, .names = ((operand_38).candidate).names, .second = ((operand_38).candidate).second, };
                    const operand_41 = (zx_abi).zx_type_15{ .children = (((operand_38).tables).base).children, .field_names = (((operand_38).tables).base).field_names, .field_types = (((operand_38).tables).base).field_types, .first = (((operand_38).tables).base).first, .kinds = (((operand_38).tables).base).kinds, .labels = (((operand_38).tables).base).labels, .names = (((operand_38).tables).base).names, .second = (((operand_38).tables).base).second, };
                    const operand_42 = (zx_abi).zx_type_15{ .children = (((operand_38).tables).delta).children, .field_names = (((operand_38).tables).delta).field_names, .field_types = (((operand_38).tables).delta).field_types, .first = (((operand_38).tables).delta).first, .kinds = (((operand_38).tables).delta).kinds, .labels = (((operand_38).tables).delta).labels, .names = (((operand_38).tables).delta).names, .second = (((operand_38).tables).delta).second, };
                    const operand_43 = (zx_abi).zx_type_16{ .base = (&operand_41), .delta = (&operand_42), };
                    const operand_44 = (zx_abi).zx_type_23{ .candidate = (&operand_40), .id = (operand_38).id, .tables = (&operand_43), };
                    const operand_45 = (try function_4(allocator, (&operand_44)));

                    break :block_46 operand_45;
                }) @as((zx_abi).zx_type_28, .Found) else @as((zx_abi).zx_type_28, .Conflict)));

                const value_13: state_type_27 = block_32: {
                    const operand_28 = state_6;
                    const operand_29 = ((state_6).index + @as(u64, 1));
                    const operand_30 = value_12;
                    const operand_31 = (if (value_11) value_9 else (state_6).id);

                    break :block_32 state_type_27{ .candidate = (operand_28).candidate, .count = (operand_28).count, .id = operand_31, .index = operand_29, .origin = (operand_28).origin, .origins = (operand_28).origins, .status = operand_30, .tables = (operand_28).tables, };
                };

                break :block_84 value_13;
            };

            state_changed_19 = true;
        }

        break :block_106 (if (state_changed_19) block_105: {
            const operand_104 = (try (allocator).create((zx_abi).zx_type_31));

            (operand_104).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .candidate = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_88).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = ((state_6).candidate).children, .fields = block_87: {
                    const operand_86 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_86).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_87 @as(*const (zx_abi).zx_type_18, operand_86);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_89 @as(*const (zx_abi).zx_type_19, operand_88);
            }, .count = (state_6).count, .id = (state_6).id, .index = (state_6).index, .origin = block_91: {
                const operand_90 = (try (allocator).create((zx_abi).zx_type_25));

                (operand_90).* = @as((zx_abi).zx_type_25, (zx_abi).zx_type_25{ .kind = ((state_6).origin).kind, .member = ((state_6).origin).member, .owner = ((state_6).origin).owner, });

                break :block_91 @as(*const (zx_abi).zx_type_25, operand_90);
            }, .origins = block_97: {
                const operand_96 = (try (allocator).create((zx_abi).zx_type_27));

                (operand_96).* = @as((zx_abi).zx_type_27, (zx_abi).zx_type_27{ .base = block_93: {
                    const operand_92 = (try (allocator).create((zx_abi).zx_type_26));

                    (operand_92).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .ids = (((state_6).origins).base).ids, .kinds = (((state_6).origins).base).kinds, .members = (((state_6).origins).base).members, .owners = (((state_6).origins).base).owners, });

                    break :block_93 @as(*const (zx_abi).zx_type_26, operand_92);
                }, .delta = block_95: {
                    const operand_94 = (try (allocator).create((zx_abi).zx_type_26));

                    (operand_94).* = @as((zx_abi).zx_type_26, (zx_abi).zx_type_26{ .ids = (((state_6).origins).delta).ids, .kinds = (((state_6).origins).delta).kinds, .members = (((state_6).origins).delta).members, .owners = (((state_6).origins).delta).owners, });

                    break :block_95 @as(*const (zx_abi).zx_type_26, operand_94);
                }, });

                break :block_97 @as(*const (zx_abi).zx_type_27, operand_96);
            }, .status = (state_6).status, .tables = block_103: {
                const operand_102 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_102).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = block_99: {
                    const operand_98 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_98).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_99 @as(*const (zx_abi).zx_type_15, operand_98);
                }, .delta = block_101: {
                    const operand_100 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_100).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_101 @as(*const (zx_abi).zx_type_15, operand_100);
                }, });

                break :block_103 @as(*const (zx_abi).zx_type_16, operand_102);
            }, });

            break :block_105 @as(*const (zx_abi).zx_type_31, operand_104);
        } else operand_18);
    };

    return block_5: {
        const operand_1 = (value_14).status;
        const operand_2 = (value_14).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_29));

            (operand_3).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .status = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_29, operand_3);
        };
    };
}
