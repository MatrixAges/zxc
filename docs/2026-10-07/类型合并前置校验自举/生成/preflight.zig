const std = @import("std");
const zx_native_0 = @import("integers");
const zx_native_1 = @import("merge_workspace");
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
const zx_shape_25 = .{ .kind = .object, .fields = .{ .children = zx_shape_16, .count = zx_shape_5, .field_names = zx_shape_17, .field_types = zx_shape_16, .first = zx_shape_4, .kind = zx_shape_14, .label = zx_shape_10, .names = zx_shape_17, .offset = zx_shape_5, .second = zx_shape_4, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .left = zx_shape_25, .right = zx_shape_25, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_25, .right = zx_shape_25, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_18, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .ids = zx_shape_16, .kinds = zx_shape_15, .members = zx_shape_17, .owners = zx_shape_17, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .base = zx_shape_30, .delta = zx_shape_30, }, };
const zx_shape_32 = .{ .kind = .scalar, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_32, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .names = zx_shape_17, .origins = zx_shape_30, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .origins = zx_shape_30, .valid = zx_shape_1, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_17, .origins = zx_shape_30, .table = zx_shape_18, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .names = zx_shape_17, .origins = zx_shape_30, .source = zx_shape_18, .target = zx_shape_18, .workspace = zx_shape_11, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_17, .origins = zx_shape_30, .source = zx_shape_18, .valid = zx_shape_1, .workspace = zx_shape_11, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .index = zx_shape_5, .source = zx_shape_18, .target = zx_shape_18, .valid = zx_shape_1, .workspace = zx_shape_11, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_37, }, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_37, .@"1" = zx_shape_1, }, };
pub const input_shape = zx_shape_37;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_37;
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
    const native_result = (try (zx_native_1).allocateOrigins((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!void {
    const native_result = (try (zx_native_1).allocateMapping((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!bool {
    const native_result = (zx_native_1).hasOrigin((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ }!void {
    const native_result = (zx_native_1).setOrigin((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!void {
    const native_result = (zx_native_1).setIdentity((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_25 = ((in).left).*;
    const value_2: (zx_abi).zx_type_25 = ((in).right).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_14, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_14, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_14, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_14, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_14, .NativeReference))) {
        return block_63: {
            const operand_61 = ((&value_1)).label;
            const operand_62 = ((&value_2)).label;

            break :block_63 ((std).mem).eql(u8, operand_61, operand_62);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_14, .Enumeration)) and (!block_60: {
        const operand_58 = ((&value_1)).label;
        const operand_59 = ((&value_2)).label;

        break :block_60 ((std).mem).eql(u8, operand_58, operand_59);
    }))) {
        return false;
    }

    if ((((&value_1)).count != ((&value_2)).count)) {
        return false;
    }

    const value_16: (zx_abi).zx_type_27 = block_57: {
        const operand_7 = block_6: {
            const operand_2 = (&value_1);
            const operand_3 = (&value_2);
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_27{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (operand_7).equal, .index = (operand_7).index, .left = (operand_7).left, .right = (operand_7).right, .zx_origin = (&operand_7), };

        while (((state_1).equal and ((state_1).index < ((state_1).left).count))) {
            state_1 = block_54: {
                const value_5: u64 = (((state_1).left).offset + (state_1).index);
                const value_6: u64 = (((state_1).right).offset + (state_1).index);

                const value_7: bool = block_53: {
                    const operand_14 = ((state_1).left).kind;

                    break :block_53 (if ((operand_14 == @as((zx_abi).zx_type_14, .Object))) (block_44: {
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
                    })) else (if ((operand_14 == @as((zx_abi).zx_type_14, .Tuple))) (block_29: {
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
                const value_8: (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };
                const value_11: (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = block_11: {
                        break :block_11 value_10;
                    }, .index = (value_8).index, .left = (value_8).left, .right = (value_8).right, });
                };

                const value_12: (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (value_12).equal, .index = (block_8: {
                        break :block_8 value_13;
                    } + block_9: {
                        break :block_9 value_14;
                    }), .left = (value_12).left, .right = (value_12).right, });
                };

                break :block_54 value_15;
            };
        }

        break :block_57 block_56: {
            break :block_56 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_55: {
                break :block_55 (zx_abi).zx_type_27{ .equal = (state_1).equal, .index = (state_1).index, .left = (state_1).left, .right = (state_1).right, };
            });
        };
    };

    return ((&value_16)).equal;
}

fn function_8(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_14, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_14, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_14, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_14, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_14, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_14, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_14, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_14, .Enumeration) else @as((zx_abi).zx_type_14, .NativeReference)))))))));
    };
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_25 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_8(allocator, block_4: {
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
            const operand_29 = (try (allocator).create((zx_abi).zx_type_25));

            (operand_29).* = @as((zx_abi).zx_type_25, (zx_abi).zx_type_25{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .offset = operand_17, .count = operand_21, .children = operand_25, .field_names = operand_26, .field_types = operand_27, .names = operand_28, });

            break :block_30 @as(*const (zx_abi).zx_type_25, operand_29);
        };
    };
}

fn function_9_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_25 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_8(allocator, block_35: {
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

        break :block_60 (zx_abi).zx_type_25{ .kind = operand_32, .first = operand_36, .second = operand_40, .label = operand_44, .offset = operand_48, .count = operand_52, .children = operand_56, .field_names = operand_57, .field_types = operand_58, .names = operand_59, };
    };
}

fn function_9_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28, buffers: struct {
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
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_25 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_8(allocator, block_64: {
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

        break :block_89 (zx_abi).zx_type_25{ .kind = operand_61, .first = operand_65, .second = operand_69, .label = operand_73, .offset = operand_77, .count = operand_81, .children = operand_85, .field_names = operand_86, .field_types = operand_87, .names = operand_88, };
    };
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = @as(u64, (((in).origins).ids).len);

    if (((((@as(u64, (((in).origins).kinds).len) != value_1) or (@as(u64, (((in).origins).owners).len) != value_1)) or (@as(u64, (((in).origins).members).len) != value_1)) or (@as(u64, ((in).names).len) != value_1))) {
        return false;
    }

    const value_13: (zx_abi).zx_type_35 = block_27: {
        const operand_7 = block_6: {
            const operand_2 = (in).origins;
            const operand_3 = value_1;
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_35{ .origins = operand_2, .count = operand_3, .index = operand_4, .valid = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .count = (operand_7).count, .index = (operand_7).index, .origins = (operand_7).origins, .valid = (operand_7).valid, .zx_origin = (&operand_7), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_24: {
                const value_4: u8 = block_23: {
                    const operand_21 = ((state_1).origins).kinds;
                    const operand_22 = (state_1).index;

                    if ((operand_22 >= (operand_21).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_23 (operand_21)[@intCast(operand_22)];
                };

                const value_5: (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_5).valid;

                const value_7: bool = ((block_13: {
                    break :block_13 value_4;
                } <= @as(u8, 2)) and ((block_14: {
                    break :block_14 value_4;
                } == @as(u8, 2)) or block_20: {
                    const operand_18 = block_17: {
                        const operand_15 = ((state_1).origins).members;
                        const operand_16 = (state_1).index;

                        if ((operand_16 >= (operand_15).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_17 (operand_15)[@intCast(operand_16)];
                    };

                    const operand_19 = @as([]const u8, "");

                    break :block_20 ((std).mem).eql(u8, operand_18, operand_19);
                }));

                const value_8: (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .count = (value_5).count, .index = (value_5).index, .origins = (value_5).origins, .valid = block_11: {
                        break :block_11 value_7;
                    }, });
                };
                const value_9: (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .count = (value_9).count, .index = (block_8: {
                        break :block_8 value_10;
                    } + block_9: {
                        break :block_9 value_11;
                    }), .origins = (value_9).origins, .valid = (value_9).valid, });
                };

                break :block_24 value_12;
            };
        }

        break :block_27 block_26: {
            break :block_26 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_25: {
                break :block_25 (zx_abi).zx_type_35{ .count = (state_1).count, .index = (state_1).index, .origins = (state_1).origins, .valid = (state_1).valid, };
            });
        };
    };

    return ((&value_13)).valid;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36) error{ IndexOutOfBounds, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, block_18: {
        const operand_16 = ((in).origins).ids;
        const operand_17 = (in).index;

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    }));

    if ((value_1 >= @as(u64, (((in).table).kinds).len))) {
        return false;
    }

    const value_2: (zx_abi).zx_type_14 = (try function_8(allocator, block_15: {
        const operand_13 = ((in).table).kinds;
        const operand_14 = value_1;

        if ((operand_14 >= (operand_13).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_15 (operand_13)[@intCast(operand_14)];
    }));

    if ((((value_2 != @as((zx_abi).zx_type_14, .Enumeration)) and (value_2 != @as((zx_abi).zx_type_14, .NativeReference))) or ((value_2 == @as((zx_abi).zx_type_14, .NativeReference)) and (block_12: {
        const operand_10 = ((in).origins).kinds;
        const operand_11 = (in).index;

        if ((operand_11 >= (operand_10).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_12 (operand_10)[@intCast(operand_11)];
    } != @as(u8, 1))))) {
        return false;
    }

    return block_9: {
        const operand_7 = block_3: {
            const operand_1 = ((in).table).labels;
            const operand_2 = value_1;

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
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    if ((!block_100: {
        const operand_97 = (in).origins;
        const operand_98 = (in).names;
        const operand_99 = (zx_abi).zx_type_34{ .origins = operand_97, .names = operand_98, };

        break :block_100 (try function_10(allocator, (&operand_99)));
    })) {
        return false;
    }

    _ = block_96: {
        const operand_95 = @as((zx_abi).zx_type_12, block_94: {
            const operand_92 = (in).workspace;
            const operand_93 = @as(u64, (((in).source).kinds).len);

            break :block_94 .{ operand_92, operand_93, };
        });

        break :block_96 (try function_2(allocator, (&operand_95)));
    };

    const value_14: (zx_abi).zx_type_38 = block_91: {
        const operand_54 = block_53: {
            const operand_47 = (in).source;
            const operand_48 = (in).origins;
            const operand_49 = (in).names;
            const operand_50 = (in).workspace;
            const operand_51 = @as(u64, 0);
            const operand_52 = true;

            break :block_53 (zx_abi).zx_type_38{ .source = operand_47, .origins = operand_48, .names = operand_49, .workspace = operand_50, .index = operand_51, .valid = operand_52, };
        };

        var state_46: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .index = (operand_54).index, .names = (operand_54).names, .origins = (operand_54).origins, .source = (operand_54).source, .valid = (operand_54).valid, .workspace = (operand_54).workspace, .zx_origin = (&operand_54), };

        while (((state_46).valid and ((state_46).index < @as(u64, (((state_46).origins).ids).len)))) {
            state_46 = block_88: {
                const value_3: u64 = block_87: {
                    const operand_86 = block_85: {
                        const operand_83 = ((state_46).origins).ids;
                        const operand_84 = (state_46).index;

                        if ((operand_84 >= (operand_83).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_85 (operand_83)[@intCast(operand_84)];
                    };

                    break :block_87 (try function_0(allocator, operand_86));
                };
                const value_4: bool = (((block_70: {
                    break :block_70 value_3;
                } < @as(u64, (((state_46).source).kinds).len)) and (!block_76: {
                    const operand_75 = @as((zx_abi).zx_type_12, block_74: {
                        const operand_71 = (state_46).workspace;

                        const operand_73 = block_72: {
                            break :block_72 value_3;
                        };

                        break :block_74 .{ operand_71, operand_73, };
                    });

                    break :block_76 (try function_4(allocator, (&operand_75)));
                })) and block_82: {
                    const operand_77 = (state_46).source;
                    const operand_78 = (state_46).origins;
                    const operand_79 = (state_46).names;
                    const operand_80 = (state_46).index;
                    const operand_81 = (zx_abi).zx_type_36{ .table = operand_77, .origins = operand_78, .names = operand_79, .index = operand_80, };

                    break :block_82 (try function_11(allocator, (&operand_81)));
                });

                const value_5: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_61: {
                    break :block_61 value_4;
                }) block_69: {
                    block_68: {
                        const operand_67 = @as((zx_abi).zx_type_13, block_66: {
                            const operand_62 = (state_46).workspace;

                            const operand_64 = block_63: {
                                break :block_63 value_3;
                            };

                            const operand_65 = (state_46).index;

                            break :block_66 .{ operand_62, operand_64, operand_65, };
                        });

                        break :block_68 (try function_5(allocator, (&operand_67)));
                    }

                    break :block_69 state_46;
                } else state_46);

                const value_6: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_5;

                _ = (value_6).valid;

                const value_8: bool = block_60: {
                    break :block_60 value_4;
                };

                const value_9: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_59: {
                    break :block_59 @as((zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .index = (value_6).index, .names = (value_6).names, .origins = (value_6).origins, .source = (value_6).source, .valid = block_58: {
                        break :block_58 value_8;
                    }, .workspace = (value_6).workspace, });
                };

                const value_10: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_57: {
                    break :block_57 @as((zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_38_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .index = (block_55: {
                        break :block_55 value_11;
                    } + block_56: {
                        break :block_56 value_12;
                    }), .names = (value_10).names, .origins = (value_10).origins, .source = (value_10).source, .valid = (value_10).valid, .workspace = (value_10).workspace, });
                };

                break :block_88 value_13;
            };
        }

        break :block_91 block_90: {
            break :block_90 (if (((state_46).zx_origin != null)) ((state_46).zx_origin.?).* else block_89: {
                break :block_89 (zx_abi).zx_type_38{ .index = (state_46).index, .names = (state_46).names, .origins = (state_46).origins, .source = (state_46).source, .valid = (state_46).valid, .workspace = (state_46).workspace, };
            });
        };
    };

    if ((!((&value_14)).valid)) {
        return false;
    }

    if ((((in).first > @as(u64, (((in).source).kinds).len)) or (((in).first != @as(u64, 0)) and ((in).first != @as(u64, (((in).target).kinds).len))))) {
        return false;
    }

    _ = block_45: {
        const operand_44 = @as((zx_abi).zx_type_12, block_43: {
            const operand_41 = (in).workspace;
            const operand_42 = @as(u64, (((in).source).kinds).len);

            break :block_43 .{ operand_41, operand_42, };
        });

        break :block_45 (try function_3(allocator, (&operand_44)));
    };

    const value_27: (zx_abi).zx_type_39 = block_40: {
        const operand_9 = block_8: {
            const operand_2 = (in).source;
            const operand_3 = (in).target;
            const operand_4 = (in).first;
            const operand_5 = (in).workspace;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_39{ .source = operand_2, .target = operand_3, .first = operand_4, .workspace = operand_5, .index = operand_6, .valid = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (operand_9).first, .index = (operand_9).index, .source = (operand_9).source, .target = (operand_9).target, .valid = (operand_9).valid, .workspace = (operand_9).workspace, .zx_origin = (&operand_9), };

        while (((state_1).valid and ((state_1).index < (state_1).first))) {
            state_1 = block_37: {
                const value_17: bool = block_36: {
                    const operand_23 = (state_1).source;
                    const operand_24 = (state_1).index;
                    const operand_25 = (zx_abi).zx_type_28{ .table = operand_23, .index = operand_24, };

                    const operand_27 = block_26: {
                        break :block_26 (try function_9_value(allocator, (&operand_25)));
                    };

                    const operand_28 = (&operand_27);
                    const operand_29 = (state_1).target;
                    const operand_30 = (state_1).index;
                    const operand_31 = (zx_abi).zx_type_28{ .table = operand_29, .index = operand_30, };

                    const operand_33 = block_32: {
                        break :block_32 (try function_9_value(allocator, (&operand_31)));
                    };

                    const operand_34 = (&operand_33);
                    const operand_35 = (zx_abi).zx_type_26{ .left = operand_28, .right = operand_34, };

                    break :block_36 (try function_7(allocator, (&operand_35)));
                };

                const value_18: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_16: {
                    break :block_16 value_17;
                }) block_22: {
                    block_21: {
                        const operand_20 = @as((zx_abi).zx_type_12, block_19: {
                            const operand_17 = (state_1).workspace;
                            const operand_18 = (state_1).index;

                            break :block_19 .{ operand_17, operand_18, };
                        });

                        break :block_21 (try function_6(allocator, (&operand_20)));
                    }

                    break :block_22 state_1;
                } else state_1);

                const value_19: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_18;

                _ = (value_19).valid;

                const value_21: bool = block_15: {
                    break :block_15 value_17;
                };

                const value_22: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_19).first, .index = (value_19).index, .source = (value_19).source, .target = (value_19).target, .valid = block_13: {
                        break :block_13 value_21;
                    }, .workspace = (value_19).workspace, });
                };

                const value_23: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_22;
                const value_24: u64 = (value_23).index;
                const value_25: u64 = @as(u64, 1);

                const value_26: (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_39_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .first = (value_23).first, .index = (block_10: {
                        break :block_10 value_24;
                    } + block_11: {
                        break :block_11 value_25;
                    }), .source = (value_23).source, .target = (value_23).target, .valid = (value_23).valid, .workspace = (value_23).workspace, });
                };

                break :block_37 value_26;
            };
        }

        break :block_40 block_39: {
            break :block_39 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_38: {
                break :block_38 (zx_abi).zx_type_39{ .first = (state_1).first, .index = (state_1).index, .source = (state_1).source, .target = (state_1).target, .valid = (state_1).valid, .workspace = (state_1).workspace, };
            });
        };
    };

    return ((&value_27)).valid;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_37) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_12(allocator, in));

    return value_1;
}

