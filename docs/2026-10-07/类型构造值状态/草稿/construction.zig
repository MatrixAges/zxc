const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;

const zx_shape_0 = .{
    .kind = .scalar,
};

const zx_shape_1 = .{
    .kind = .scalar,
};

const zx_shape_2 = .{
    .kind = .scalar,
};

const zx_shape_3 = .{
    .kind = .scalar,
};

const zx_shape_4 = .{
    .kind = .scalar,
};

const zx_shape_5 = .{
    .kind = .scalar,
};

const zx_shape_6 = .{
    .kind = .scalar,
};

const zx_shape_7 = .{
    .kind = .scalar,
};

const zx_shape_8 = .{
    .kind = .scalar,
};

const zx_shape_9 = .{
    .kind = .scalar,
};

const zx_shape_10 = .{
    .kind = .string,
};

const zx_shape_11 = .{
    .kind = .scalar,
};

const zx_shape_12 = .{
    .kind = .list,
    .child = zx_shape_2,
};

const zx_shape_13 = .{
    .kind = .list,
    .child = zx_shape_4,
};

const zx_shape_14 = .{
    .kind = .list,
    .child = zx_shape_10,
};

const zx_shape_15 = .{
    .kind = .object,
    .fields = .{
        .children = zx_shape_13,
        .field_names = zx_shape_14,
        .field_types = zx_shape_13,
        .first = zx_shape_13,
        .kinds = zx_shape_12,
        .labels = zx_shape_14,
        .names = zx_shape_14,
        .second = zx_shape_13,
    },
};

const zx_shape_16 = .{
    .kind = .object,
    .fields = .{
        .base = zx_shape_15,
        .delta = zx_shape_15,
    },
};

const zx_shape_17 = .{
    .kind = .object,
    .fields = .{
        .delta = zx_shape_1,
        .first = zx_shape_4,
        .kind = zx_shape_11,
        .label = zx_shape_10,
        .second = zx_shape_4,
    },
};

const zx_shape_18 = .{
    .kind = .object,
    .fields = .{
        .names = zx_shape_14,
        .types = zx_shape_13,
    },
};

const zx_shape_19 = .{
    .kind = .object,
    .fields = .{
        .children = zx_shape_13,
        .fields = zx_shape_18,
        .first = zx_shape_4,
        .kind = zx_shape_11,
        .label = zx_shape_10,
        .names = zx_shape_14,
        .second = zx_shape_4,
    },
};

const zx_shape_20 = .{
    .kind = .object,
    .fields = .{
        .found = zx_shape_1,
        .id = zx_shape_4,
    },
};

const zx_shape_21 = .{
    .kind = .object,
    .fields = .{
        .delta = zx_shape_15,
        .id = zx_shape_4,
    },
};

const zx_shape_22 = .{
    .kind = .object,
    .fields = .{
        .children = zx_shape_13,
        .count = zx_shape_5,
        .field_names = zx_shape_14,
        .field_types = zx_shape_13,
        .first = zx_shape_4,
        .kind = zx_shape_11,
        .label = zx_shape_10,
        .names = zx_shape_14,
        .offset = zx_shape_5,
        .second = zx_shape_4,
    },
};

const zx_shape_23 = .{
    .kind = .object,
    .fields = .{
        .left = zx_shape_22,
        .right = zx_shape_22,
    },
};

const zx_shape_24 = .{
    .kind = .object,
    .fields = .{
        .equal = zx_shape_1,
        .index = zx_shape_5,
        .left = zx_shape_22,
        .right = zx_shape_22,
    },
};

const zx_shape_25 = .{
    .kind = .object,
    .fields = .{
        .index = zx_shape_5,
        .table = zx_shape_15,
    },
};

const zx_shape_26 = .{
    .kind = .object,
    .fields = .{
        .candidate = zx_shape_19,
        .id = zx_shape_4,
        .tables = zx_shape_16,
    },
};

const zx_shape_27 = .{
    .kind = .object,
    .fields = .{
        .candidate = zx_shape_19,
        .tables = zx_shape_16,
    },
};

const zx_shape_28 = .{
    .kind = .object,
    .fields = .{
        .candidate = zx_shape_19,
        .count = zx_shape_5,
        .found = zx_shape_1,
        .id = zx_shape_4,
        .index = zx_shape_5,
        .tables = zx_shape_16,
    },
};

const zx_shape_29 = .{
    .kind = .object,
    .fields = .{
        .left = zx_shape_10,
        .right = zx_shape_10,
    },
};

const zx_shape_30 = .{
    .kind = .object,
    .fields = .{
        .equal = zx_shape_1,
        .index = zx_shape_5,
        .left = zx_shape_10,
        .limit = zx_shape_5,
        .right = zx_shape_10,
    },
};

const zx_shape_31 = .{
    .kind = .object,
    .fields = .{
        .building = zx_shape_1,
        .count = zx_shape_5,
        .names = zx_shape_14,
        .remaining = zx_shape_5,
        .root = zx_shape_5,
        .sifting = zx_shape_1,
        .types = zx_shape_13,
    },
};

const zx_shape_32 = .{
    .kind = .list,
    .child = zx_shape_1,
};

const zx_shape_33 = .{
    .kind = .object,
    .fields = .{
        .flags = zx_shape_32,
        .index = zx_shape_5,
        .native_references = zx_shape_1,
        .table = zx_shape_15,
    },
};

const zx_shape_34 = .{
    .kind = .object,
    .fields = .{
        .children = zx_shape_13,
        .count = zx_shape_5,
        .flags = zx_shape_32,
        .found = zx_shape_1,
        .index = zx_shape_5,
        .offset = zx_shape_5,
    },
};

const zx_shape_35 = .{
    .kind = .object,
    .fields = .{
        .id = zx_shape_4,
        .native_references = zx_shape_1,
        .table = zx_shape_15,
    },
};

const zx_shape_36 = .{
    .kind = .object,
    .fields = .{
        .found = zx_shape_1,
        .index = zx_shape_5,
        .limit = zx_shape_5,
        .table = zx_shape_15,
        .target = zx_shape_11,
    },
};

const zx_shape_37 = .{
    .kind = .object,
    .fields = .{
        .first = zx_shape_5,
        .flags = zx_shape_32,
        .index = zx_shape_5,
        .limit = zx_shape_5,
        .native_references = zx_shape_1,
        .table = zx_shape_15,
    },
};

const zx_shape_38 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_32,
        .@"1" = zx_shape_0,
    },
};

const zx_shape_39 = .{
    .kind = .scalar,
};

const zx_shape_40 = .{
    .kind = .object,
    .fields = .{
        .candidate = zx_shape_19,
        .table = zx_shape_15,
    },
};

const zx_shape_41 = .{
    .kind = .object,
    .fields = .{
        .children = zx_shape_13,
        .found = zx_shape_1,
        .index = zx_shape_5,
        .table = zx_shape_15,
    },
};

const zx_shape_42 = .{
    .kind = .object,
    .fields = .{
        .code = zx_shape_10,
        .message = zx_shape_10,
    },
};

const zx_shape_43 = .{
    .kind = .object,
    .fields = .{
        .delta = zx_shape_15,
        .diagnostic = zx_shape_42,
        .id = zx_shape_4,
    },
};

const zx_shape_44 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_14,
        .@"1" = zx_shape_0,
    },
};

const zx_shape_45 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_40,
    },
};

const zx_shape_46 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_40,
        .@"1" = zx_shape_43,
    },
};

pub const input_shape = zx_shape_40;
pub const output_shape = zx_shape_43;
pub const Input = *const (zx_abi).zx_type_40;
pub const Output = *const (zx_abi).zx_type_43;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{}!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{
    IntegerOverflow,
}!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{
    OutOfMemory,
}!*const (zx_abi).zx_type_22 {
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
            const operand_11 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_11).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{
                .kind = operand_1,
                .first = operand_2,
                .second = operand_3,
                .label = operand_4,
                .offset = operand_5,
                .count = operand_6,
                .children = operand_7,
                .field_names = operand_8,
                .field_types = operand_9,
                .names = operand_10,
            });

            break :block_12 @as(*const (zx_abi).zx_type_22, operand_11);
        };
    };
}

fn function_2_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{
    OutOfMemory,
}!(zx_abi).zx_type_22 {
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

        break :block_26 (zx_abi).zx_type_22{
            .kind = operand_16,
            .first = operand_17,
            .second = operand_18,
            .label = operand_19,
            .offset = operand_20,
            .count = operand_21,
            .children = operand_22,
            .field_names = operand_23,
            .field_types = operand_24,
            .names = operand_25,
        };
    };
}

fn function_2_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19, buffers: struct {
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
}) error{
    OutOfMemory,
}!(zx_abi).zx_type_22 {
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

        break :block_39 (zx_abi).zx_type_22{
            .kind = operand_29,
            .first = operand_30,
            .second = operand_31,
            .label = operand_32,
            .offset = operand_33,
            .count = operand_34,
            .children = operand_35,
            .field_names = operand_36,
            .field_types = operand_37,
            .names = operand_38,
        };
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_22 = ((in).left).*;
    const value_2: (zx_abi).zx_type_22 = ((in).right).*;

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

            break :block_6 (zx_abi).zx_type_24{
                .left = operand_2,
                .right = operand_3,
                .index = operand_4,
                .equal = operand_5,
            };
        };

        var state_1: (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .equal = (operand_7).equal,
            .index = (operand_7).index,
            .left = (operand_7).left,
            .right = (operand_7).right,
            .zx_origin = (&operand_7),
        };

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
                const value_8: (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };
                const value_11: (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
                        .equal = block_11: {
                            break :block_11 value_10;
                        },
                        .index = (value_8).index,
                        .left = (value_8).left,
                        .right = (value_8).right,
                    });
                };
                const value_12: (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
                        .equal = (value_12).equal,
                        .index = (block_8: {
                            break :block_8 value_13;
                        } + block_9: {
                            break :block_9 value_14;
                        }),
                        .left = (value_12).left,
                        .right = (value_12).right,
                    });
                };

                break :block_54 value_15;
            };
        }

        break :block_55 (state_1).equal;
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: u8) error{}!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{
    IndexOutOfBounds,
    OutOfMemory,
}!*const (zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_4(allocator, block_4: {
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
            const operand_29 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_29).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{
                .kind = operand_1,
                .first = operand_5,
                .second = operand_9,
                .label = operand_13,
                .offset = operand_17,
                .count = operand_21,
                .children = operand_25,
                .field_names = operand_26,
                .field_types = operand_27,
                .names = operand_28,
            });

            break :block_30 @as(*const (zx_abi).zx_type_22, operand_29);
        };
    };
}

fn function_5_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{
    IndexOutOfBounds,
    OutOfMemory,
}!(zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_4(allocator, block_35: {
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

        break :block_60 (zx_abi).zx_type_22{
            .kind = operand_32,
            .first = operand_36,
            .second = operand_40,
            .label = operand_44,
            .offset = operand_48,
            .count = operand_52,
            .children = operand_56,
            .field_names = operand_57,
            .field_types = operand_58,
            .names = operand_59,
        };
    };
}

fn function_5_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25, buffers: struct {
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
}) error{
    IndexOutOfBounds,
    OutOfMemory,
}!(zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_4(allocator, block_64: {
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

        break :block_89 (zx_abi).zx_type_22{
            .kind = operand_61,
            .first = operand_65,
            .second = operand_69,
            .label = operand_73,
            .offset = operand_77,
            .count = operand_81,
            .children = operand_85,
            .field_names = operand_86,
            .field_types = operand_87,
            .names = operand_88,
        };
    };
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_3: bool = (value_1 >= value_2);
    const value_4: (zx_abi).zx_type_15 = (if (value_3) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: u64 = (if (value_3) (value_1 - value_2) else value_1);

    return block_9: {
        const operand_1 = (&value_4);
        const operand_2 = value_5;

        const operand_3 = (zx_abi).zx_type_25{
            .table = operand_1,
            .index = operand_2,
        };

        const operand_4 = (try function_5_value(allocator, (&operand_3)));
        const operand_5 = (&operand_4);
        const operand_6 = (try function_2_value(allocator, (in).candidate));
        const operand_7 = (&operand_6);

        const operand_8 = (zx_abi).zx_type_23{
            .left = operand_5,
            .right = operand_7,
        };

        break :block_9 (try function_3(allocator, (&operand_8)));
    };
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{
    IndexOutOfBounds,
    IntegerOverflow,
    OutOfMemory,
}!*const (zx_abi).zx_type_20 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_61: {
            const operand_57 = false;
            const operand_58 = @as(u32, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_59).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{
                    .found = operand_57,
                    .id = operand_58,
                });

                break :block_60 @as(*const (zx_abi).zx_type_20, operand_59);
            };
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: *const (zx_abi).zx_type_28 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_28));

                (operand_13).* = @as((zx_abi).zx_type_28, (zx_abi).zx_type_28{
                    .tables = operand_7,
                    .candidate = operand_8,
                    .count = operand_9,
                    .index = operand_10,
                    .found = operand_11,
                    .id = operand_12,
                });

                break :block_14 @as(*const (zx_abi).zx_type_28, operand_13);
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

        var state_6: state_type_22 = state_type_22{
            .candidate = state_type_19{
                .children = ((operand_16).candidate).children,
                .fields = state_type_18{
                    .names = (((operand_16).candidate).fields).names,
                    .types = (((operand_16).candidate).fields).types,
                },
                .first = ((operand_16).candidate).first,
                .kind = ((operand_16).candidate).kind,
                .label = ((operand_16).candidate).label,
                .names = ((operand_16).candidate).names,
                .second = ((operand_16).candidate).second,
            },
            .count = (operand_16).count,
            .found = (operand_16).found,
            .id = (operand_16).id,
            .index = (operand_16).index,
            .tables = state_type_21{
                .base = state_type_20{
                    .children = (((operand_16).tables).base).children,
                    .field_names = (((operand_16).tables).base).field_names,
                    .field_types = (((operand_16).tables).base).field_types,
                    .first = (((operand_16).tables).base).first,
                    .kinds = (((operand_16).tables).base).kinds,
                    .labels = (((operand_16).tables).base).labels,
                    .names = (((operand_16).tables).base).names,
                    .second = (((operand_16).tables).base).second,
                },
                .delta = state_type_20{
                    .children = (((operand_16).tables).delta).children,
                    .field_names = (((operand_16).tables).delta).field_names,
                    .field_types = (((operand_16).tables).delta).field_types,
                    .first = (((operand_16).tables).delta).first,
                    .kinds = (((operand_16).tables).delta).kinds,
                    .labels = (((operand_16).tables).delta).labels,
                    .names = (((operand_16).tables).delta).names,
                    .second = (((operand_16).tables).delta).second,
                },
            },
        };

        var state_changed_17 = false;

        while (((!(state_6).found) and ((state_6).index < (state_6).count))) {
            state_6 = block_42: {
                const value_5: u32 = (try function_1(allocator, (state_6).index));

                const value_6: bool = block_41: {
                    const operand_33 = block_32: {
                        const operand_29 = (state_6).tables;
                        const operand_30 = value_5;
                        const operand_31 = (state_6).candidate;

                        break :block_32 state_type_28{
                            .tables = operand_29,
                            .id = operand_30,
                            .candidate = operand_31,
                        };
                    };
                    const operand_34 = (zx_abi).zx_type_18{
                        .names = (((operand_33).candidate).fields).names,
                        .types = (((operand_33).candidate).fields).types,
                    };
                    const operand_35 = (zx_abi).zx_type_19{
                        .children = ((operand_33).candidate).children,
                        .fields = (&operand_34),
                        .first = ((operand_33).candidate).first,
                        .kind = ((operand_33).candidate).kind,
                        .label = ((operand_33).candidate).label,
                        .names = ((operand_33).candidate).names,
                        .second = ((operand_33).candidate).second,
                    };

                    const operand_36 = (zx_abi).zx_type_15{
                        .children = (((operand_33).tables).base).children,
                        .field_names = (((operand_33).tables).base).field_names,
                        .field_types = (((operand_33).tables).base).field_types,
                        .first = (((operand_33).tables).base).first,
                        .kinds = (((operand_33).tables).base).kinds,
                        .labels = (((operand_33).tables).base).labels,
                        .names = (((operand_33).tables).base).names,
                        .second = (((operand_33).tables).base).second,
                    };

                    const operand_37 = (zx_abi).zx_type_15{
                        .children = (((operand_33).tables).delta).children,
                        .field_names = (((operand_33).tables).delta).field_names,
                        .field_types = (((operand_33).tables).delta).field_types,
                        .first = (((operand_33).tables).delta).first,
                        .kinds = (((operand_33).tables).delta).kinds,
                        .labels = (((operand_33).tables).delta).labels,
                        .names = (((operand_33).tables).delta).names,
                        .second = (((operand_33).tables).delta).second,
                    };

                    const operand_38 = (zx_abi).zx_type_16{
                        .base = (&operand_36),
                        .delta = (&operand_37),
                    };

                    const operand_39 = (zx_abi).zx_type_26{
                        .candidate = (&operand_35),
                        .id = (operand_33).id,
                        .tables = (&operand_38),
                    };

                    const operand_40 = (try function_6(allocator, (&operand_39)));

                    break :block_41 operand_40;
                };
                const value_7: state_type_22 = block_27: {
                    const operand_23 = state_6;
                    const operand_24 = ((state_6).index + @as(u64, 1));
                    const operand_25 = value_6;
                    const operand_26 = value_5;

                    break :block_27 state_type_22{
                        .candidate = (operand_23).candidate,
                        .count = (operand_23).count,
                        .found = operand_25,
                        .id = operand_26,
                        .index = operand_24,
                        .tables = (operand_23).tables,
                    };
                };

                break :block_42 value_7;
            };

            state_changed_17 = true;
        }

        break :block_56 (if (state_changed_17) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_28));

            (operand_54).* = @as((zx_abi).zx_type_28, (zx_abi).zx_type_28{
                .candidate = block_47: {
                    const operand_46 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_46).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{
                        .children = ((state_6).candidate).children,
                        .fields = block_45: {
                            const operand_44 = (try (allocator).create((zx_abi).zx_type_18));

                            (operand_44).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{
                                .names = (((state_6).candidate).fields).names,
                                .types = (((state_6).candidate).fields).types,
                            });

                            break :block_45 @as(*const (zx_abi).zx_type_18, operand_44);
                        },
                        .first = ((state_6).candidate).first,
                        .kind = ((state_6).candidate).kind,
                        .label = ((state_6).candidate).label,
                        .names = ((state_6).candidate).names,
                        .second = ((state_6).candidate).second,
                    });

                    break :block_47 @as(*const (zx_abi).zx_type_19, operand_46);
                },
                .count = (state_6).count,
                .found = (state_6).found,
                .id = (state_6).id,
                .index = (state_6).index,
                .tables = block_53: {
                    const operand_52 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_52).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{
                        .base = block_49: {
                            const operand_48 = (try (allocator).create((zx_abi).zx_type_15));

                            (operand_48).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                                .children = (((state_6).tables).base).children,
                                .field_names = (((state_6).tables).base).field_names,
                                .field_types = (((state_6).tables).base).field_types,
                                .first = (((state_6).tables).base).first,
                                .kinds = (((state_6).tables).base).kinds,
                                .labels = (((state_6).tables).base).labels,
                                .names = (((state_6).tables).base).names,
                                .second = (((state_6).tables).base).second,
                            });

                            break :block_49 @as(*const (zx_abi).zx_type_15, operand_48);
                        },
                        .delta = block_51: {
                            const operand_50 = (try (allocator).create((zx_abi).zx_type_15));

                            (operand_50).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                                .children = (((state_6).tables).delta).children,
                                .field_names = (((state_6).tables).delta).field_names,
                                .field_types = (((state_6).tables).delta).field_types,
                                .first = (((state_6).tables).delta).first,
                                .kinds = (((state_6).tables).delta).kinds,
                                .labels = (((state_6).tables).delta).labels,
                                .names = (((state_6).tables).delta).names,
                                .second = (((state_6).tables).delta).second,
                            });

                            break :block_51 @as(*const (zx_abi).zx_type_15, operand_50);
                        },
                    });

                    break :block_53 @as(*const (zx_abi).zx_type_16, operand_52);
                },
            });

            break :block_55 @as(*const (zx_abi).zx_type_28, operand_54);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_8).found;
        const operand_2 = (value_8).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_3).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{
                .found = operand_1,
                .id = operand_2,
            });

            break :block_4 @as(*const (zx_abi).zx_type_20, operand_3);
        };
    };
}

fn function_7_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_27_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22) error{
    IndexOutOfBounds,
    IntegerOverflow,
    OutOfMemory,
}!(zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_107: {
            const operand_105 = false;
            const operand_106 = @as(u32, 0);

            break :block_107 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                .found = operand_105,
                .id = operand_106,
            });
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: (zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_104: {
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

            break :block_74 @as((zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{
                .tables = operand_66,
                .candidate = operand_67,
                .count = operand_68,
                .index = operand_70,
                .found = operand_71,
                .id = operand_72,
            });
        };

        var state_65: (zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_102: {
                const value_5: u32 = block_101: {
                    const operand_100 = (state_65).index;

                    break :block_101 (try function_1(allocator, operand_100));
                };
                const value_6: bool = block_99: {
                    const operand_84 = (state_65).tables;
                    var state_borrow_85: (zx_abi).zx_type_16 = undefined;

                    state_borrow_85 = (zx_abi).zx_type_16{
                        .base = (operand_84).base,
                        .delta = (operand_84).delta,
                    };

                    const operand_86 = ((operand_84).zx_origin orelse (&state_borrow_85));

                    const operand_88 = block_87: {
                        break :block_87 value_5;
                    };

                    const operand_89 = (state_65).candidate;
                    var state_borrow_90: (zx_abi).zx_type_18 = undefined;

                    state_borrow_90 = (zx_abi).zx_type_18{
                        .names = ((operand_89).fields).names,
                        .types = ((operand_89).fields).types,
                    };

                    var state_borrow_91: (zx_abi).zx_type_19 = undefined;

                    state_borrow_91 = (zx_abi).zx_type_19{
                        .children = (operand_89).children,
                        .fields = (((operand_89).fields).zx_origin orelse (&state_borrow_90)),
                        .first = (operand_89).first,
                        .kind = (operand_89).kind,
                        .label = (operand_89).label,
                        .names = (operand_89).names,
                        .second = (operand_89).second,
                    };

                    const operand_92 = ((operand_89).zx_origin orelse (&state_borrow_91));

                    const operand_93 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                        .base = (operand_86).base,
                        .delta = (operand_86).delta,
                        .zx_origin = operand_86,
                    };

                    var state_borrow_94: (zx_abi).zx_type_16 = undefined;

                    state_borrow_94 = (zx_abi).zx_type_16{
                        .base = (operand_93).base,
                        .delta = (operand_93).delta,
                    };

                    const operand_95 = (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{
                        .children = (operand_92).children,
                        .fields = (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                            .names = ((operand_92).fields).names,
                            .types = ((operand_92).fields).types,
                            .zx_origin = (operand_92).fields,
                        },
                        .first = (operand_92).first,
                        .kind = (operand_92).kind,
                        .label = (operand_92).label,
                        .names = (operand_92).names,
                        .second = (operand_92).second,
                        .zx_origin = operand_92,
                    };

                    var state_borrow_96: (zx_abi).zx_type_18 = undefined;

                    state_borrow_96 = (zx_abi).zx_type_18{
                        .names = ((operand_95).fields).names,
                        .types = ((operand_95).fields).types,
                    };

                    var state_borrow_97: (zx_abi).zx_type_19 = undefined;

                    state_borrow_97 = (zx_abi).zx_type_19{
                        .children = (operand_95).children,
                        .fields = (((operand_95).fields).zx_origin orelse (&state_borrow_96)),
                        .first = (operand_95).first,
                        .kind = (operand_95).kind,
                        .label = (operand_95).label,
                        .names = (operand_95).names,
                        .second = (operand_95).second,
                    };

                    const operand_98 = (zx_abi).zx_type_26{
                        .tables = ((operand_93).zx_origin orelse (&state_borrow_94)),
                        .id = operand_88,
                        .candidate = ((operand_95).zx_origin orelse (&state_borrow_97)),
                    };

                    break :block_99 (try function_6(allocator, (&operand_98)));
                };
                const value_7: (zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{
                        .candidate = (operand_77).candidate,
                        .count = (operand_77).count,
                        .found = operand_79,
                        .id = operand_81,
                        .index = operand_78,
                        .tables = (operand_77).tables,
                    });
                };

                break :block_102 value_7;
            };

            state_changed_76 = true;
        }

        break :block_104 (if (state_changed_76) state_65 else operand_75);
    };

    return block_64: {
        const operand_62 = (value_8).found;
        const operand_63 = (value_8).id;

        break :block_64 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .found = operand_62,
            .id = operand_63,
        });
    };
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{
    IntegerOverflow,
    OutOfMemory,
}!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_27: {
        const operand_26 = (in).kind;

        break :block_27 (if ((operand_26 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_26 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_26 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_26 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_26 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_26 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_26 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_26 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = (((in).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or ((in).kind == @as((zx_abi).zx_type_11, .Enumeration)));
    const value_3: u32 = (if (((((in).kind == @as((zx_abi).zx_type_11, .Object)) or ((in).kind == @as((zx_abi).zx_type_11, .Tuple))) or value_2)) @as(u32, 0) else (in).first);

    const value_4: u32 = block_25: {
        const operand_24 = (in).kind;

        break :block_25 (if ((operand_24 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((in).fields).names).len))) else (if ((operand_24 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((in).children).len))) else (if ((operand_24 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((in).names).len))) else (if ((operand_24 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((in).names).len))) else (in).second))));
    };

    return block_23: {
        const operand_1 = block_3: {
            const operand_2 = value_1;

            break :block_3 (try (allocator).dupe(u8, (&[_]u8{
                operand_2,
            })));
        };
        const operand_4 = block_6: {
            const operand_5 = value_3;

            break :block_6 (try (allocator).dupe(u32, (&[_]u32{
                operand_5,
            })));
        };
        const operand_7 = block_9: {
            const operand_8 = value_4;

            break :block_9 (try (allocator).dupe(u32, (&[_]u32{
                operand_8,
            })));
        };
        const operand_10 = block_12: {
            const operand_11 = (in).label;

            break :block_12 (try (allocator).dupe([]const u8, (&[_][]const u8{
                operand_11,
            })));
        };

        const operand_13 = (if (((in).kind == @as((zx_abi).zx_type_11, .Tuple))) (in).children else block_14: {
            break :block_14 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_15 = (if (((in).kind == @as((zx_abi).zx_type_11, .Object))) ((in).fields).types else block_16: {
            break :block_16 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_17 = (if (((in).kind == @as((zx_abi).zx_type_11, .Object))) ((in).fields).names else block_18: {
            break :block_18 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        const operand_19 = (if (value_2) (in).names else block_20: {
            break :block_20 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        break :block_23 block_22: {
            const operand_21 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_21).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                .kinds = operand_1,
                .first = operand_4,
                .second = operand_7,
                .labels = operand_10,
                .children = operand_13,
                .field_types = operand_15,
                .field_names = operand_17,
                .names = operand_19,
            });

            break :block_22 @as(*const (zx_abi).zx_type_15, operand_21);
        };
    };
}

fn function_8_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{
    IntegerOverflow,
    OutOfMemory,
}!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_52: {
        const operand_51 = (in).kind;

        break :block_52 (if ((operand_51 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_51 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_51 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = (((in).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or ((in).kind == @as((zx_abi).zx_type_11, .Enumeration)));
    const value_3: u32 = (if (((((in).kind == @as((zx_abi).zx_type_11, .Object)) or ((in).kind == @as((zx_abi).zx_type_11, .Tuple))) or value_2)) @as(u32, 0) else (in).first);

    const value_4: u32 = block_50: {
        const operand_49 = (in).kind;

        break :block_50 (if ((operand_49 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((in).fields).names).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((in).children).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((in).names).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((in).names).len))) else (in).second))));
    };

    return block_48: {
        const operand_28 = block_30: {
            const operand_29 = value_1;

            break :block_30 (try (allocator).dupe(u8, (&[_]u8{
                operand_29,
            })));
        };
        const operand_31 = block_33: {
            const operand_32 = value_3;

            break :block_33 (try (allocator).dupe(u32, (&[_]u32{
                operand_32,
            })));
        };
        const operand_34 = block_36: {
            const operand_35 = value_4;

            break :block_36 (try (allocator).dupe(u32, (&[_]u32{
                operand_35,
            })));
        };
        const operand_37 = block_39: {
            const operand_38 = (in).label;

            break :block_39 (try (allocator).dupe([]const u8, (&[_][]const u8{
                operand_38,
            })));
        };

        const operand_40 = (if (((in).kind == @as((zx_abi).zx_type_11, .Tuple))) (in).children else block_41: {
            break :block_41 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_42 = (if (((in).kind == @as((zx_abi).zx_type_11, .Object))) ((in).fields).types else block_43: {
            break :block_43 (try (allocator).dupe(u32, (&[_]u32{})));
        });

        const operand_44 = (if (((in).kind == @as((zx_abi).zx_type_11, .Object))) ((in).fields).names else block_45: {
            break :block_45 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        const operand_46 = (if (value_2) (in).names else block_47: {
            break :block_47 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        });

        break :block_48 (zx_abi).zx_type_15{
            .kinds = operand_28,
            .first = operand_31,
            .second = operand_34,
            .labels = operand_37,
            .children = operand_40,
            .field_types = operand_42,
            .field_names = operand_44,
            .names = operand_46,
        };
    };
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = (if ((@as(u64, ((in).left).len) < @as(u64, ((in).right).len))) @as(u64, ((in).left).len) else @as(u64, ((in).right).len));

    const value_13: (zx_abi).zx_type_30 = block_30: {
        const operand_14 = block_13: {
            const operand_8 = (in).left;
            const operand_9 = (in).right;
            const operand_10 = @as(u64, 0);
            const operand_11 = value_1;
            const operand_12 = true;

            break :block_13 (zx_abi).zx_type_30{
                .left = operand_8,
                .right = operand_9,
                .index = operand_10,
                .limit = operand_11,
                .equal = operand_12,
            };
        };

        var state_7: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
            .equal = (operand_14).equal,
            .index = (operand_14).index,
            .left = (operand_14).left,
            .limit = (operand_14).limit,
            .right = (operand_14).right,
            .zx_origin = (&operand_14),
        };

        while (((state_7).equal and ((state_7).index < (state_7).limit))) {
            state_7 = block_27: {
                const value_4: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_7;
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

                const value_7: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
                        .equal = block_19: {
                            break :block_19 value_6;
                        },
                        .index = (value_4).index,
                        .left = (value_4).left,
                        .limit = (value_4).limit,
                        .right = (value_4).right,
                    });
                };
                const value_12: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((value_7).equal) block_18: {
                    const value_8: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_7;
                    const value_9: u64 = (value_8).index;
                    const value_10: u64 = @as(u64, 1);

                    const value_11: (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_17: {
                        break :block_17 @as((zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
                            .equal = (value_8).equal,
                            .index = (block_15: {
                                break :block_15 value_9;
                            } + block_16: {
                                break :block_16 value_10;
                            }),
                            .left = (value_8).left,
                            .limit = (value_8).limit,
                            .right = (value_8).right,
                        });
                    };

                    break :block_18 value_11;
                } else value_7);

                break :block_27 value_12;
            };
        }

        break :block_30 block_29: {
            break :block_29 (if (((state_7).zx_origin != null)) ((state_7).zx_origin.?).* else block_28: {
                break :block_28 (zx_abi).zx_type_30{
                    .equal = (state_7).equal,
                    .index = (state_7).index,
                    .left = (state_7).left,
                    .limit = (state_7).limit,
                    .right = (state_7).right,
                };
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

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{
    IndexOutOfBounds,
    OutOfMemory,
}!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return in;
    }

    const value_103: *const (zx_abi).zx_type_31 = block_155: {
        const operand_17 = block_16: {
            const operand_7 = (in).names;
            const operand_8 = (in).types;
            const operand_9 = @as(u64, ((in).names).len);
            const operand_10 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_11 = @as(u64, 0);
            const operand_12 = true;
            const operand_13 = false;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_14).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{
                    .names = operand_7,
                    .types = operand_8,
                    .count = operand_9,
                    .remaining = operand_10,
                    .root = operand_11,
                    .building = operand_12,
                    .sifting = operand_13,
                });

                break :block_15 @as(*const (zx_abi).zx_type_31, operand_14);
            };
        };

        var state_items_19: [][]const u8 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_6: (zx_abi).zx_type_31 = (operand_17).*;
        var state_changed_18 = false;

        while (((((&state_6)).building or (((&state_6)).count > @as(u64, 1))) or ((&state_6)).sifting)) {
            state_6 = block_151: {
                const value_102: (zx_abi).zx_type_31 = (if (((&state_6)).sifting) block_94: {
                    const value_45: (zx_abi).zx_type_31 = (if ((((&state_6)).root >= @divTrunc(((&state_6)).count, @as(u64, 2)))) block_24: {
                        const value_3: (zx_abi).zx_type_31 = ((&state_6)).*;

                        _ = ((&value_3)).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).zx_type_31 = block_23: {
                            break :block_23 (zx_abi).zx_type_31{
                                .building = ((&value_3)).building,
                                .count = ((&value_3)).count,
                                .names = ((&value_3)).names,
                                .remaining = ((&value_3)).remaining,
                                .root = ((&value_3)).root,
                                .sifting = value_5,
                                .types = ((&value_3)).types,
                            };
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

                            const operand_91 = (zx_abi).zx_type_29{
                                .left = operand_86,
                                .right = operand_90,
                            };

                            break :block_92 (try function_9(allocator, (&operand_91)));
                        })) value_8 else value_7);

                        const value_44: (zx_abi).zx_type_31 = (if (block_34: {
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

                            const operand_33 = (zx_abi).zx_type_29{
                                .left = operand_28,
                                .right = operand_32,
                            };

                            break :block_34 (try function_9(allocator, (&operand_33)));
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
                            const value_12: (zx_abi).zx_type_31 = ((&state_6)).*;
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
                            const value_17: (zx_abi).zx_type_31 = block_67: {
                                break :block_67 (zx_abi).zx_type_31{
                                    .building = ((&value_12)).building,
                                    .count = ((&value_12)).count,
                                    .names = block_66: {
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
                                    },
                                    .remaining = ((&value_12)).remaining,
                                    .root = ((&value_12)).root,
                                    .sifting = ((&value_12)).sifting,
                                    .types = ((&value_12)).types,
                                };
                            };
                            const value_18: (zx_abi).zx_type_31 = ((&value_17)).*;
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
                            const value_23: (zx_abi).zx_type_31 = block_56: {
                                break :block_56 (zx_abi).zx_type_31{
                                    .building = ((&value_18)).building,
                                    .count = ((&value_18)).count,
                                    .names = ((&value_18)).names,
                                    .remaining = ((&value_18)).remaining,
                                    .root = ((&value_18)).root,
                                    .sifting = ((&value_18)).sifting,
                                    .types = block_55: {
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
                                    },
                                };
                            };
                            const value_24: (zx_abi).zx_type_31 = ((&value_23)).*;
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

                            const value_29: (zx_abi).zx_type_31 = block_48: {
                                break :block_48 (zx_abi).zx_type_31{
                                    .building = ((&value_24)).building,
                                    .count = ((&value_24)).count,
                                    .names = block_47: {
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
                                    },
                                    .remaining = ((&value_24)).remaining,
                                    .root = ((&value_24)).root,
                                    .sifting = ((&value_24)).sifting,
                                    .types = ((&value_24)).types,
                                };
                            };
                            const value_30: (zx_abi).zx_type_31 = ((&value_29)).*;
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

                            const value_35: (zx_abi).zx_type_31 = block_40: {
                                break :block_40 (zx_abi).zx_type_31{
                                    .building = ((&value_30)).building,
                                    .count = ((&value_30)).count,
                                    .names = ((&value_30)).names,
                                    .remaining = ((&value_30)).remaining,
                                    .root = ((&value_30)).root,
                                    .sifting = ((&value_30)).sifting,
                                    .types = block_39: {
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
                                    },
                                };
                            };
                            const value_36: (zx_abi).zx_type_31 = ((&value_35)).*;

                            _ = ((&value_36)).root;
                            const value_38: u64 = value_9;

                            const value_39: (zx_abi).zx_type_31 = block_35: {
                                break :block_35 (zx_abi).zx_type_31{
                                    .building = ((&value_36)).building,
                                    .count = ((&value_36)).count,
                                    .names = ((&value_36)).names,
                                    .remaining = ((&value_36)).remaining,
                                    .root = value_38,
                                    .sifting = ((&value_36)).sifting,
                                    .types = ((&value_36)).types,
                                };
                            };

                            break :block_80 ((&value_39)).*;
                        } else block_82: {
                            const value_40: (zx_abi).zx_type_31 = ((&state_6)).*;
                            _ = ((&value_40)).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).zx_type_31 = block_81: {
                                break :block_81 (zx_abi).zx_type_31{
                                    .building = ((&value_40)).building,
                                    .count = ((&value_40)).count,
                                    .names = ((&value_40)).names,
                                    .remaining = ((&value_40)).remaining,
                                    .root = ((&value_40)).root,
                                    .sifting = value_42,
                                    .types = ((&value_40)).types,
                                };
                            };

                            break :block_82 ((&value_43)).*;
                        });

                        break :block_93 ((&value_44)).*;
                    });

                    break :block_94 ((&value_45)).*;
                } else block_150: {
                    const value_101: (zx_abi).zx_type_31 = (if (((&state_6)).building) block_101: {
                        const value_62: (zx_abi).zx_type_31 = (if ((((&state_6)).remaining == @as(u64, 0))) block_96: {
                            const value_46: (zx_abi).zx_type_31 = ((&state_6)).*;
                            _ = ((&value_46)).building;
                            const value_48: bool = false;

                            const value_49: (zx_abi).zx_type_31 = block_95: {
                                break :block_95 (zx_abi).zx_type_31{
                                    .building = value_48,
                                    .count = ((&value_46)).count,
                                    .names = ((&value_46)).names,
                                    .remaining = ((&value_46)).remaining,
                                    .root = ((&value_46)).root,
                                    .sifting = ((&value_46)).sifting,
                                    .types = ((&value_46)).types,
                                };
                            };

                            break :block_96 ((&value_49)).*;
                        } else block_100: {
                            const value_50: (zx_abi).zx_type_31 = ((&state_6)).*;
                            const value_51: u64 = ((&value_50)).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).zx_type_31 = block_99: {
                                break :block_99 (zx_abi).zx_type_31{
                                    .building = ((&value_50)).building,
                                    .count = ((&value_50)).count,
                                    .names = ((&value_50)).names,
                                    .remaining = (value_51 - value_52),
                                    .root = ((&value_50)).root,
                                    .sifting = ((&value_50)).sifting,
                                    .types = ((&value_50)).types,
                                };
                            };
                            const value_54: (zx_abi).zx_type_31 = ((&value_53)).*;

                            _ = ((&value_54)).root;

                            const value_56: u64 = ((&value_53)).remaining;

                            const value_57: (zx_abi).zx_type_31 = block_98: {
                                break :block_98 (zx_abi).zx_type_31{
                                    .building = ((&value_54)).building,
                                    .count = ((&value_54)).count,
                                    .names = ((&value_54)).names,
                                    .remaining = ((&value_54)).remaining,
                                    .root = value_56,
                                    .sifting = ((&value_54)).sifting,
                                    .types = ((&value_54)).types,
                                };
                            };
                            const value_58: (zx_abi).zx_type_31 = ((&value_57)).*;

                            _ = ((&value_58)).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).zx_type_31 = block_97: {
                                break :block_97 (zx_abi).zx_type_31{
                                    .building = ((&value_58)).building,
                                    .count = ((&value_58)).count,
                                    .names = ((&value_58)).names,
                                    .remaining = ((&value_58)).remaining,
                                    .root = ((&value_58)).root,
                                    .sifting = value_60,
                                    .types = ((&value_58)).types,
                                };
                            };

                            break :block_100 ((&value_61)).*;
                        });

                        break :block_101 ((&value_62)).*;
                    } else block_149: {
                        const value_63: (zx_abi).zx_type_31 = ((&state_6)).*;
                        const value_64: u64 = ((&value_63)).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).zx_type_31 = block_148: {
                            break :block_148 (zx_abi).zx_type_31{
                                .building = ((&value_63)).building,
                                .count = (value_64 - value_65),
                                .names = ((&value_63)).names,
                                .remaining = ((&value_63)).remaining,
                                .root = ((&value_63)).root,
                                .sifting = ((&value_63)).sifting,
                                .types = ((&value_63)).types,
                            };
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

                        const value_69: (zx_abi).zx_type_31 = ((&value_66)).*;
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
                        const value_74: (zx_abi).zx_type_31 = block_135: {
                            break :block_135 (zx_abi).zx_type_31{
                                .building = ((&value_69)).building,
                                .count = ((&value_69)).count,
                                .names = block_134: {
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
                                },
                                .remaining = ((&value_69)).remaining,
                                .root = ((&value_69)).root,
                                .sifting = ((&value_69)).sifting,
                                .types = ((&value_69)).types,
                            };
                        };

                        const value_75: (zx_abi).zx_type_31 = ((&value_74)).*;
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
                        const value_80: (zx_abi).zx_type_31 = block_124: {
                            break :block_124 (zx_abi).zx_type_31{
                                .building = ((&value_75)).building,
                                .count = ((&value_75)).count,
                                .names = ((&value_75)).names,
                                .remaining = ((&value_75)).remaining,
                                .root = ((&value_75)).root,
                                .sifting = ((&value_75)).sifting,
                                .types = block_123: {
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
                                },
                            };
                        };

                        const value_81: (zx_abi).zx_type_31 = ((&value_80)).*;
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

                        const value_86: (zx_abi).zx_type_31 = block_116: {
                            break :block_116 (zx_abi).zx_type_31{
                                .building = ((&value_81)).building,
                                .count = ((&value_81)).count,
                                .names = block_115: {
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
                                },
                                .remaining = ((&value_81)).remaining,
                                .root = ((&value_81)).root,
                                .sifting = ((&value_81)).sifting,
                                .types = ((&value_81)).types,
                            };
                        };
                        const value_87: (zx_abi).zx_type_31 = ((&value_86)).*;
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

                        const value_92: (zx_abi).zx_type_31 = block_108: {
                            break :block_108 (zx_abi).zx_type_31{
                                .building = ((&value_87)).building,
                                .count = ((&value_87)).count,
                                .names = ((&value_87)).names,
                                .remaining = ((&value_87)).remaining,
                                .root = ((&value_87)).root,
                                .sifting = ((&value_87)).sifting,
                                .types = block_107: {
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
                                },
                            };
                        };
                        const value_93: (zx_abi).zx_type_31 = ((&value_92)).*;

                        _ = ((&value_93)).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).zx_type_31 = block_103: {
                            break :block_103 (zx_abi).zx_type_31{
                                .building = ((&value_93)).building,
                                .count = ((&value_93)).count,
                                .names = ((&value_93)).names,
                                .remaining = ((&value_93)).remaining,
                                .root = value_95,
                                .sifting = ((&value_93)).sifting,
                                .types = ((&value_93)).types,
                            };
                        };
                        const value_97: (zx_abi).zx_type_31 = ((&value_96)).*;

                        _ = ((&value_97)).sifting;
                        const value_99: bool = true;

                        const value_100: (zx_abi).zx_type_31 = block_102: {
                            break :block_102 (zx_abi).zx_type_31{
                                .building = ((&value_97)).building,
                                .count = ((&value_97)).count,
                                .names = ((&value_97)).names,
                                .remaining = ((&value_97)).remaining,
                                .root = ((&value_97)).root,
                                .sifting = value_99,
                                .types = ((&value_97)).types,
                            };
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
            const operand_153 = (try (allocator).create((zx_abi).zx_type_31));

            (operand_153).* = @as((zx_abi).zx_type_31, state_6);

            break :block_154 @as(*const (zx_abi).zx_type_31, operand_153);
        } else operand_17);
    };

    return block_5: {
        const operand_1 = (value_103).names;
        const operand_2 = (value_103).types;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_3).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{
                .names = operand_1,
                .types = operand_2,
            });

            break :block_4 @as(*const (zx_abi).zx_type_18, operand_3);
        };
    };
}

fn function_10_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{
    IndexOutOfBounds,
    OutOfMemory,
}!(zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return in;
    }

    const value_103: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_372: {
        const operand_168 = block_167: {
            const operand_160 = (in).names;
            const operand_161 = (in).types;
            const operand_162 = @as(u64, ((in).names).len);
            const operand_163 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_164 = @as(u64, 0);
            const operand_165 = true;
            const operand_166 = false;

            break :block_167 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                .names = operand_160,
                .types = operand_161,
                .count = operand_162,
                .remaining = operand_163,
                .root = operand_164,
                .building = operand_165,
                .sifting = operand_166,
            });
        };

        var state_items_170: [][]const u8 = undefined;
        var state_items_started_171 = false;
        var state_items_172: []u32 = undefined;
        var state_items_started_173 = false;
        var state_159: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = operand_168;
        var state_changed_169 = false;

        while ((((state_159).building or ((state_159).count > @as(u64, 1))) or (state_159).sifting)) {
            state_159 = block_370: {
                const value_102: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).sifting) block_282: {
                    const value_45: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).root >= @divTrunc((state_159).count, @as(u64, 2)))) block_176: {
                        const value_3: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        _ = (value_3).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_175: {
                            break :block_175 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_3).building,
                                .count = (value_3).count,
                                .names = (value_3).names,
                                .remaining = (value_3).remaining,
                                .root = (value_3).root,
                                .sifting = block_174: {
                                    break :block_174 value_5;
                                },
                                .types = (value_3).types,
                            });
                        };

                        break :block_176 value_6;
                    } else block_281: {
                        const value_7: u64 = (((state_159).root * @as(u64, 2)) + @as(u64, 1));

                        const value_8: u64 = (block_280: {
                            break :block_280 value_7;
                        } + @as(u64, 1));
                        const value_9: u64 = (if (((block_265: {
                            break :block_265 value_8;
                        } < (state_159).count) and block_277: {
                            const operand_270 = block_269: {
                                const operand_267 = (state_159).names;

                                const operand_268 = block_266: {
                                    break :block_266 value_7;
                                };

                                if ((operand_268 >= (operand_267).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_269 (operand_267)[@intCast(operand_268)];
                            };
                            const operand_275 = block_274: {
                                const operand_272 = (state_159).names;

                                const operand_273 = block_271: {
                                    break :block_271 value_8;
                                };

                                if ((operand_273 >= (operand_272).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_274 (operand_272)[@intCast(operand_273)];
                            };

                            const operand_276 = (zx_abi).zx_type_29{
                                .left = operand_270,
                                .right = operand_275,
                            };

                            break :block_277 (try function_9(allocator, (&operand_276)));
                        })) block_278: {
                            break :block_278 value_8;
                        } else block_279: {
                            break :block_279 value_7;
                        });
                        const value_44: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (block_187: {
                            const operand_180 = block_179: {
                                const operand_177 = (state_159).names;
                                const operand_178 = (state_159).root;

                                if ((operand_178 >= (operand_177).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_179 (operand_177)[@intCast(operand_178)];
                            };
                            const operand_185 = block_184: {
                                const operand_182 = (state_159).names;

                                const operand_183 = block_181: {
                                    break :block_181 value_9;
                                };

                                if ((operand_183 >= (operand_182).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_184 (operand_182)[@intCast(operand_183)];
                            };
                            const operand_186 = (zx_abi).zx_type_29{
                                .left = operand_180,
                                .right = operand_185,
                            };

                            break :block_187 (try function_9(allocator, (&operand_186)));
                        }) block_261: {
                            const value_10: []const u8 = block_260: {
                                const operand_258 = (state_159).names;
                                const operand_259 = (state_159).root;

                                if ((operand_259 >= (operand_258).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_260 (operand_258)[@intCast(operand_259)];
                            };
                            const value_11: u32 = block_257: {
                                const operand_255 = (state_159).types;
                                const operand_256 = (state_159).root;

                                if ((operand_256 >= (operand_255).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_257 (operand_255)[@intCast(operand_256)];
                            };
                            const value_12: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_13: []const []const u8 = (value_12).names;
                            const value_14: u64 = (state_159).root;
                            _ = block_254: {
                                const operand_252 = block_250: {
                                    break :block_250 value_13;
                                };
                                const operand_253 = block_251: {
                                    break :block_251 value_14;
                                };

                                if ((operand_253 >= (operand_252).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_254 (operand_252)[@intCast(operand_253)];
                            };
                            const value_16: []const u8 = block_249: {
                                const operand_247 = (state_159).names;

                                const operand_248 = block_246: {
                                    break :block_246 value_9;
                                };

                                if ((operand_248 >= (operand_247).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_249 (operand_247)[@intCast(operand_248)];
                            };
                            const value_17: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_245: {
                                break :block_245 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_12).building,
                                    .count = (value_12).count,
                                    .names = block_244: {
                                        const operand_239 = block_238: {
                                            break :block_238 value_13;
                                        };
                                        const operand_241 = block_240: {
                                            break :block_240 value_14;
                                        };
                                        const operand_243 = block_242: {
                                            break :block_242 value_16;
                                        };

                                        if ((operand_241 >= (operand_239).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        if ((!state_items_started_171)) {
                                            state_items_170 = (try (allocator).dupe([]const u8, operand_239));
                                            state_items_started_171 = true;
                                        }

                                        (state_items_170)[@intCast(operand_241)] = operand_243;

                                        break :block_244 state_items_170;
                                    },
                                    .remaining = (value_12).remaining,
                                    .root = (value_12).root,
                                    .sifting = (value_12).sifting,
                                    .types = (value_12).types,
                                });
                            };
                            const value_18: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_17;
                            const value_19: []const u32 = (value_18).types;
                            const value_20: u64 = (value_17).root;

                            _ = block_237: {
                                const operand_235 = block_233: {
                                    break :block_233 value_19;
                                };
                                const operand_236 = block_234: {
                                    break :block_234 value_20;
                                };

                                if ((operand_236 >= (operand_235).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_237 (operand_235)[@intCast(operand_236)];
                            };
                            const value_22: u32 = block_232: {
                                const operand_230 = (value_17).types;

                                const operand_231 = block_229: {
                                    break :block_229 value_9;
                                };

                                if ((operand_231 >= (operand_230).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_232 (operand_230)[@intCast(operand_231)];
                            };
                            const value_23: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_228: {
                                break :block_228 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_18).building,
                                    .count = (value_18).count,
                                    .names = (value_18).names,
                                    .remaining = (value_18).remaining,
                                    .root = (value_18).root,
                                    .sifting = (value_18).sifting,
                                    .types = block_227: {
                                        const operand_222 = block_221: {
                                            break :block_221 value_19;
                                        };
                                        const operand_224 = block_223: {
                                            break :block_223 value_20;
                                        };
                                        const operand_226 = block_225: {
                                            break :block_225 value_22;
                                        };

                                        if ((operand_224 >= (operand_222).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        if ((!state_items_started_173)) {
                                            state_items_172 = (try (allocator).dupe(u32, operand_222));
                                            state_items_started_173 = true;
                                        }

                                        (state_items_172)[@intCast(operand_224)] = operand_226;

                                        break :block_227 state_items_172;
                                    },
                                });
                            };
                            const value_24: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_23;
                            const value_25: []const []const u8 = (value_24).names;

                            const value_26: u64 = block_220: {
                                break :block_220 value_9;
                            };
                            _ = block_219: {
                                const operand_217 = block_215: {
                                    break :block_215 value_25;
                                };
                                const operand_218 = block_216: {
                                    break :block_216 value_26;
                                };

                                if ((operand_218 >= (operand_217).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_219 (operand_217)[@intCast(operand_218)];
                            };
                            const value_28: []const u8 = block_214: {
                                break :block_214 value_10;
                            };
                            const value_29: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_213: {
                                break :block_213 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_24).building,
                                    .count = (value_24).count,
                                    .names = block_212: {
                                        const operand_207 = block_206: {
                                            break :block_206 value_25;
                                        };
                                        const operand_209 = block_208: {
                                            break :block_208 value_26;
                                        };
                                        const operand_211 = block_210: {
                                            break :block_210 value_28;
                                        };

                                        if ((operand_209 >= (operand_207).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        if ((!state_items_started_171)) {
                                            state_items_170 = (try (allocator).dupe([]const u8, operand_207));
                                            state_items_started_171 = true;
                                        }

                                        (state_items_170)[@intCast(operand_209)] = operand_211;
                                        break :block_212 state_items_170;
                                    },
                                    .remaining = (value_24).remaining,
                                    .root = (value_24).root,
                                    .sifting = (value_24).sifting,
                                    .types = (value_24).types,
                                });
                            };
                            const value_30: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_29;
                            const value_31: []const u32 = (value_30).types;

                            const value_32: u64 = block_205: {
                                break :block_205 value_9;
                            };
                            _ = block_204: {
                                const operand_202 = block_200: {
                                    break :block_200 value_31;
                                };
                                const operand_203 = block_201: {
                                    break :block_201 value_32;
                                };

                                if ((operand_203 >= (operand_202).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_204 (operand_202)[@intCast(operand_203)];
                            };
                            const value_34: u32 = block_199: {
                                break :block_199 value_11;
                            };
                            const value_35: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_198: {
                                break :block_198 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_30).building,
                                    .count = (value_30).count,
                                    .names = (value_30).names,
                                    .remaining = (value_30).remaining,
                                    .root = (value_30).root,
                                    .sifting = (value_30).sifting,
                                    .types = block_197: {
                                        const operand_192 = block_191: {
                                            break :block_191 value_31;
                                        };
                                        const operand_194 = block_193: {
                                            break :block_193 value_32;
                                        };
                                        const operand_196 = block_195: {
                                            break :block_195 value_34;
                                        };

                                        if ((operand_194 >= (operand_192).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        if ((!state_items_started_173)) {
                                            state_items_172 = (try (allocator).dupe(u32, operand_192));
                                            state_items_started_173 = true;
                                        }

                                        (state_items_172)[@intCast(operand_194)] = operand_196;

                                        break :block_197 state_items_172;
                                    },
                                });
                            };
                            const value_36: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_35;
                            _ = (value_36).root;
                            const value_38: u64 = block_190: {
                                break :block_190 value_9;
                            };
                            const value_39: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_189: {
                                break :block_189 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_36).building,
                                    .count = (value_36).count,
                                    .names = (value_36).names,
                                    .remaining = (value_36).remaining,
                                    .root = block_188: {
                                        break :block_188 value_38;
                                    },
                                    .sifting = (value_36).sifting,
                                    .types = (value_36).types,
                                });
                            };

                            break :block_261 value_39;
                        } else block_264: {
                            const value_40: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_40).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_263: {
                                break :block_263 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_40).building,
                                    .count = (value_40).count,
                                    .names = (value_40).names,
                                    .remaining = (value_40).remaining,
                                    .root = (value_40).root,
                                    .sifting = block_262: {
                                        break :block_262 value_42;
                                    },
                                    .types = (value_40).types,
                                });
                            };

                            break :block_264 value_43;
                        });

                        break :block_281 value_44;
                    });

                    break :block_282 value_45;
                } else block_369: {
                    const value_101: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).building) block_294: {
                        const value_62: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).remaining == @as(u64, 0))) block_285: {
                            const value_46: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_46).building;
                            const value_48: bool = false;

                            const value_49: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_284: {
                                break :block_284 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = block_283: {
                                        break :block_283 value_48;
                                    },
                                    .count = (value_46).count,
                                    .names = (value_46).names,
                                    .remaining = (value_46).remaining,
                                    .root = (value_46).root,
                                    .sifting = (value_46).sifting,
                                    .types = (value_46).types,
                                });
                            };

                            break :block_285 value_49;
                        } else block_293: {
                            const value_50: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_51: u64 = (value_50).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_292: {
                                break :block_292 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_50).building,
                                    .count = (value_50).count,
                                    .names = (value_50).names,
                                    .remaining = (block_290: {
                                        break :block_290 value_51;
                                    } - block_291: {
                                        break :block_291 value_52;
                                    }),
                                    .root = (value_50).root,
                                    .sifting = (value_50).sifting,
                                    .types = (value_50).types,
                                });
                            };
                            const value_54: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_53;
                            _ = (value_54).root;
                            const value_56: u64 = (value_53).remaining;

                            const value_57: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_289: {
                                break :block_289 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_54).building,
                                    .count = (value_54).count,
                                    .names = (value_54).names,
                                    .remaining = (value_54).remaining,
                                    .root = block_288: {
                                        break :block_288 value_56;
                                    },
                                    .sifting = (value_54).sifting,
                                    .types = (value_54).types,
                                });
                            };
                            const value_58: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_57;

                            _ = (value_58).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_287: {
                                break :block_287 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                    .building = (value_58).building,
                                    .count = (value_58).count,
                                    .names = (value_58).names,
                                    .remaining = (value_58).remaining,
                                    .root = (value_58).root,
                                    .sifting = block_286: {
                                        break :block_286 value_60;
                                    },
                                    .types = (value_58).types,
                                });
                            };

                            break :block_293 value_61;
                        });

                        break :block_294 value_62;
                    } else block_368: {
                        const value_63: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        const value_64: u64 = (value_63).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_367: {
                            break :block_367 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_63).building,
                                .count = (block_365: {
                                    break :block_365 value_64;
                                } - block_366: {
                                    break :block_366 value_65;
                                }),
                                .names = (value_63).names,
                                .remaining = (value_63).remaining,
                                .root = (value_63).root,
                                .sifting = (value_63).sifting,
                                .types = (value_63).types,
                            });
                        };
                        const value_67: []const u8 = block_364: {
                            const operand_362 = (value_66).names;
                            const operand_363 = @as(u64, 0);

                            if ((operand_363 >= (operand_362).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_364 (operand_362)[@intCast(operand_363)];
                        };
                        const value_68: u32 = block_361: {
                            const operand_359 = (value_66).types;
                            const operand_360 = @as(u64, 0);

                            if ((operand_360 >= (operand_359).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_361 (operand_359)[@intCast(operand_360)];
                        };
                        const value_69: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_66;
                        const value_70: []const []const u8 = (value_69).names;
                        const value_71: u64 = @as(u64, 0);

                        _ = block_358: {
                            const operand_356 = block_354: {
                                break :block_354 value_70;
                            };
                            const operand_357 = block_355: {
                                break :block_355 value_71;
                            };

                            if ((operand_357 >= (operand_356).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_358 (operand_356)[@intCast(operand_357)];
                        };
                        const value_73: []const u8 = block_353: {
                            const operand_351 = (value_66).names;
                            const operand_352 = (value_66).count;

                            if ((operand_352 >= (operand_351).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_353 (operand_351)[@intCast(operand_352)];
                        };
                        const value_74: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_350: {
                            break :block_350 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_69).building,
                                .count = (value_69).count,
                                .names = block_349: {
                                    const operand_344 = block_343: {
                                        break :block_343 value_70;
                                    };
                                    const operand_346 = block_345: {
                                        break :block_345 value_71;
                                    };
                                    const operand_348 = block_347: {
                                        break :block_347 value_73;
                                    };

                                    if ((operand_346 >= (operand_344).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_171)) {
                                        state_items_170 = (try (allocator).dupe([]const u8, operand_344));
                                        state_items_started_171 = true;
                                    }

                                    (state_items_170)[@intCast(operand_346)] = operand_348;

                                    break :block_349 state_items_170;
                                },
                                .remaining = (value_69).remaining,
                                .root = (value_69).root,
                                .sifting = (value_69).sifting,
                                .types = (value_69).types,
                            });
                        };
                        const value_75: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_74;
                        const value_76: []const u32 = (value_75).types;
                        const value_77: u64 = @as(u64, 0);
                        _ = block_342: {
                            const operand_340 = block_338: {
                                break :block_338 value_76;
                            };
                            const operand_341 = block_339: {
                                break :block_339 value_77;
                            };

                            if ((operand_341 >= (operand_340).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_342 (operand_340)[@intCast(operand_341)];
                        };
                        const value_79: u32 = block_337: {
                            const operand_335 = (value_74).types;
                            const operand_336 = (value_74).count;

                            if ((operand_336 >= (operand_335).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_337 (operand_335)[@intCast(operand_336)];
                        };
                        const value_80: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_334: {
                            break :block_334 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_75).building,
                                .count = (value_75).count,
                                .names = (value_75).names,
                                .remaining = (value_75).remaining,
                                .root = (value_75).root,
                                .sifting = (value_75).sifting,
                                .types = block_333: {
                                    const operand_328 = block_327: {
                                        break :block_327 value_76;
                                    };
                                    const operand_330 = block_329: {
                                        break :block_329 value_77;
                                    };
                                    const operand_332 = block_331: {
                                        break :block_331 value_79;
                                    };

                                    if ((operand_330 >= (operand_328).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_173)) {
                                        state_items_172 = (try (allocator).dupe(u32, operand_328));
                                        state_items_started_173 = true;
                                    }

                                    (state_items_172)[@intCast(operand_330)] = operand_332;

                                    break :block_333 state_items_172;
                                },
                            });
                        };
                        const value_81: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_80;
                        const value_82: []const []const u8 = (value_81).names;
                        const value_83: u64 = (value_80).count;

                        _ = block_326: {
                            const operand_324 = block_322: {
                                break :block_322 value_82;
                            };
                            const operand_325 = block_323: {
                                break :block_323 value_83;
                            };

                            if ((operand_325 >= (operand_324).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_326 (operand_324)[@intCast(operand_325)];
                        };
                        const value_85: []const u8 = block_321: {
                            break :block_321 value_67;
                        };
                        const value_86: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_320: {
                            break :block_320 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_81).building,
                                .count = (value_81).count,
                                .names = block_319: {
                                    const operand_314 = block_313: {
                                        break :block_313 value_82;
                                    };
                                    const operand_316 = block_315: {
                                        break :block_315 value_83;
                                    };
                                    const operand_318 = block_317: {
                                        break :block_317 value_85;
                                    };

                                    if ((operand_316 >= (operand_314).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_171)) {
                                        state_items_170 = (try (allocator).dupe([]const u8, operand_314));
                                        state_items_started_171 = true;
                                    }

                                    (state_items_170)[@intCast(operand_316)] = operand_318;

                                    break :block_319 state_items_170;
                                },
                                .remaining = (value_81).remaining,
                                .root = (value_81).root,
                                .sifting = (value_81).sifting,
                                .types = (value_81).types,
                            });
                        };
                        const value_87: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_86;
                        const value_88: []const u32 = (value_87).types;
                        const value_89: u64 = (value_86).count;

                        _ = block_312: {
                            const operand_310 = block_308: {
                                break :block_308 value_88;
                            };
                            const operand_311 = block_309: {
                                break :block_309 value_89;
                            };

                            if ((operand_311 >= (operand_310).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_312 (operand_310)[@intCast(operand_311)];
                        };
                        const value_91: u32 = block_307: {
                            break :block_307 value_68;
                        };
                        const value_92: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_306: {
                            break :block_306 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_87).building,
                                .count = (value_87).count,
                                .names = (value_87).names,
                                .remaining = (value_87).remaining,
                                .root = (value_87).root,
                                .sifting = (value_87).sifting,
                                .types = block_305: {
                                    const operand_300 = block_299: {
                                        break :block_299 value_88;
                                    };
                                    const operand_302 = block_301: {
                                        break :block_301 value_89;
                                    };
                                    const operand_304 = block_303: {
                                        break :block_303 value_91;
                                    };

                                    if ((operand_302 >= (operand_300).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_173)) {
                                        state_items_172 = (try (allocator).dupe(u32, operand_300));
                                        state_items_started_173 = true;
                                    }

                                    (state_items_172)[@intCast(operand_302)] = operand_304;

                                    break :block_305 state_items_172;
                                },
                            });
                        };
                        const value_93: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_92;
                        _ = (value_93).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_298: {
                            break :block_298 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_93).building,
                                .count = (value_93).count,
                                .names = (value_93).names,
                                .remaining = (value_93).remaining,
                                .root = block_297: {
                                    break :block_297 value_95;
                                },
                                .sifting = (value_93).sifting,
                                .types = (value_93).types,
                            });
                        };
                        const value_97: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_96;

                        _ = (value_97).sifting;
                        const value_99: bool = true;

                        const value_100: (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_296: {
                            break :block_296 @as((zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{
                                .building = (value_97).building,
                                .count = (value_97).count,
                                .names = (value_97).names,
                                .remaining = (value_97).remaining,
                                .root = (value_97).root,
                                .sifting = block_295: {
                                    break :block_295 value_99;
                                },
                                .types = (value_97).types,
                            });
                        };

                        break :block_368 value_100;
                    });

                    break :block_369 value_101;
                });

                break :block_370 value_102;
            };

            state_changed_169 = true;
        }

        break :block_372 (if (state_changed_169) state_159 else operand_168);
    };

    return block_158: {
        const operand_156 = (value_103).names;
        const operand_157 = (value_103).types;

        break :block_158 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .names = operand_156,
            .types = operand_157,
        });
    };
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_11 = (try function_4(allocator, block_39: {
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

            break :block_14 (zx_abi).zx_type_34{
                .flags = operand_2,
                .children = operand_3,
                .offset = operand_4,
                .count = operand_8,
                .index = operand_12,
                .found = operand_13,
            };
        };

        var state_1: (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
            .children = (operand_15).children,
            .count = (operand_15).count,
            .flags = (operand_15).flags,
            .found = (operand_15).found,
            .index = (operand_15).index,
            .offset = (operand_15).offset,
            .zx_origin = (&operand_15),
        };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_29: {
                const value_6: (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

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

                const value_9: (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
                        .children = (value_6).children,
                        .count = (value_6).count,
                        .flags = (value_6).flags,
                        .found = block_19: {
                            break :block_19 value_8;
                        },
                        .index = (value_6).index,
                        .offset = (value_6).offset,
                    });
                };

                const value_10: (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
                        .children = (value_10).children,
                        .count = (value_10).count,
                        .flags = (value_10).flags,
                        .found = (value_10).found,
                        .index = (block_16: {
                            break :block_16 value_11;
                        } + block_17: {
                            break :block_17 value_12;
                        }),
                        .offset = (value_10).offset,
                    });
                };

                break :block_29 value_13;
            };
        }

        break :block_30 (state_1).found;
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, (in).id));
    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if (((try function_4(allocator, block_57: {
        const operand_55 = ((in).table).kinds;
        const operand_56 = value_1;

        if ((operand_56 >= (operand_55).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_57 (operand_55)[@intCast(operand_56)];
    })) == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_36 = block_54: {
        const operand_40 = block_39: {
            const operand_34 = (in).table;
            const operand_35 = value_1;
            const operand_36 = value_2;
            const operand_37 = @as(u64, 0);
            const operand_38 = false;

            break :block_39 (zx_abi).zx_type_36{
                .table = operand_34,
                .limit = operand_35,
                .target = operand_36,
                .index = operand_37,
                .found = operand_38,
            };
        };

        var state_33: (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
            .found = (operand_40).found,
            .index = (operand_40).index,
            .limit = (operand_40).limit,
            .table = (operand_40).table,
            .target = (operand_40).target,
            .zx_origin = (&operand_40),
        };

        while (((!(state_33).found) and ((state_33).index < (state_33).limit))) {
            state_33 = block_51: {
                const value_5: (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_33;

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

                    break :block_50 (try function_4(allocator, operand_49));
                } == (state_33).target);

                const value_8: (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_45: {
                    break :block_45 @as((zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
                        .found = block_44: {
                            break :block_44 value_7;
                        },
                        .index = (value_5).index,
                        .limit = (value_5).limit,
                        .table = (value_5).table,
                        .target = (value_5).target,
                    });
                };
                const value_9: (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_43: {
                    break :block_43 @as((zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
                        .found = (value_9).found,
                        .index = (block_41: {
                            break :block_41 value_10;
                        } + block_42: {
                            break :block_42 value_11;
                        }),
                        .limit = (value_9).limit,
                        .table = (value_9).table,
                        .target = (value_9).target,
                    });
                };

                break :block_51 value_12;
            };
        }

        break :block_54 block_53: {
            break :block_53 (if (((state_33).zx_origin != null)) ((state_33).zx_origin.?).* else block_52: {
                break :block_52 (zx_abi).zx_type_36{
                    .found = (state_33).found,
                    .index = (state_33).index,
                    .limit = (state_33).limit,
                    .table = (state_33).table,
                    .target = (state_33).target,
                };
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

            break :block_8 (zx_abi).zx_type_37{
                .table = operand_2,
                .index = operand_3,
                .first = operand_4,
                .limit = operand_5,
                .flags = operand_6,
                .native_references = operand_7,
            };
        };

        var state_capacity_10: (std).ArrayList(bool) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
            .first = (operand_9).first,
            .flags = (operand_9).flags,
            .index = (operand_9).index,
            .limit = (operand_9).limit,
            .native_references = (operand_9).native_references,
            .table = (operand_9).table,
            .zx_origin = (&operand_9),
        };

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_27: {
                const value_17: bool = (((state_1).index >= (state_1).first) and block_26: {
                    const operand_21 = (state_1).table;
                    const operand_22 = (state_1).index;
                    const operand_23 = (state_1).flags;
                    const operand_24 = (state_1).native_references;

                    const operand_25 = (zx_abi).zx_type_33{
                        .table = operand_21,
                        .index = operand_22,
                        .flags = operand_23,
                        .native_references = operand_24,
                    };

                    break :block_26 (try function_11(allocator, (&operand_25)));
                });

                const value_18: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

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

                    break :block_20 @as((zx_abi).value_zx_type_38_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                        (state_capacity_10).items,
                        {},
                        null,
                    });
                }).@"0";

                const value_21: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
                        .first = (value_18).first,
                        .flags = block_15: {
                            break :block_15 value_20;
                        },
                        .index = (value_18).index,
                        .limit = (value_18).limit,
                        .native_references = (value_18).native_references,
                        .table = (value_18).table,
                    });
                };
                const value_22: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_21;
                const value_23: u64 = (value_22).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{
                        .first = (value_22).first,
                        .flags = (value_22).flags,
                        .index = (block_12: {
                            break :block_12 value_23;
                        } + block_13: {
                            break :block_13 value_24;
                        }),
                        .limit = (value_22).limit,
                        .native_references = (value_22).native_references,
                        .table = (value_22).table,
                    });
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

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_40) error{
    IndexOutOfBounds,
    OutOfMemory,
}!(zx_abi).zx_type_39 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Optional)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .List)))) {
        if (((try function_4(allocator, block_29: {
            const operand_27 = ((in).table).kinds;
            const operand_28 = (try function_0(allocator, ((in).candidate).first));

            if ((operand_28 >= (operand_27).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_29 (operand_27)[@intCast(operand_28)];
        })) == @as((zx_abi).zx_type_11, .Task))) {
            return @as((zx_abi).zx_type_39, .TaskContainer);
        }

        return (if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .List)) and (((in).candidate).first == @as(u32, 0)))) @as((zx_abi).zx_type_39, .VoidList) else @as((zx_abi).zx_type_39, .None));
    }

    if (((((in).candidate).kind != @as((zx_abi).zx_type_11, .Tuple)) and (((in).candidate).kind != @as((zx_abi).zx_type_11, .Object)))) {
        return @as((zx_abi).zx_type_39, .None);
    }

    const value_1: []const u32 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) ((in).candidate).children else (((in).candidate).fields).types);

    const value_12: (zx_abi).zx_type_41 = block_26: {
        const operand_7 = block_6: {
            const operand_2 = (in).table;
            const operand_3 = value_1;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 (zx_abi).zx_type_41{
                .table = operand_2,
                .children = operand_3,
                .index = operand_4,
                .found = operand_5,
            };
        };

        var state_1: (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .children = (operand_7).children,
            .found = (operand_7).found,
            .index = (operand_7).index,
            .table = (operand_7).table,
            .zx_origin = (&operand_7),
        };

        while (((!(state_1).found) and ((state_1).index < @as(u64, ((state_1).children).len)))) {
            state_1 = block_23: {
                const value_4: (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;
                _ = (value_4).found;

                const value_6: bool = (block_22: {
                    const operand_21 = block_20: {
                        const operand_18 = ((state_1).table).kinds;

                        const operand_19 = block_17: {
                            const operand_16 = block_15: {
                                const operand_13 = (state_1).children;
                                const operand_14 = (state_1).index;

                                if ((operand_14 >= (operand_13).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_15 (operand_13)[@intCast(operand_14)];
                            };

                            break :block_17 (try function_0(allocator, operand_16));
                        };

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };

                    break :block_22 (try function_4(allocator, operand_21));
                } == @as((zx_abi).zx_type_11, .Task));

                const value_7: (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
                        .children = (value_4).children,
                        .found = block_11: {
                            break :block_11 value_6;
                        },
                        .index = (value_4).index,
                        .table = (value_4).table,
                    });
                };
                const value_8: (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_7;
                const value_9: u64 = (value_8).index;
                const value_10: u64 = @as(u64, 1);

                const value_11: (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
                        .children = (value_8).children,
                        .found = (value_8).found,
                        .index = (block_8: {
                            break :block_8 value_9;
                        } + block_9: {
                            break :block_9 value_10;
                        }),
                        .table = (value_8).table,
                    });
                };

                break :block_23 value_11;
            };
        }

        break :block_26 block_25: {
            break :block_25 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_24: {
                break :block_24 (zx_abi).zx_type_41{
                    .children = (state_1).children,
                    .found = (state_1).found,
                    .index = (state_1).index,
                    .table = (state_1).table,
                };
            });
        };
    };

    if ((!((&value_12)).found)) {
        return @as((zx_abi).zx_type_39, .None);
    }

    return (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) @as((zx_abi).zx_type_39, .TaskTuple) else @as((zx_abi).zx_type_39, .TaskObject));
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_40) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_42 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_39 = (try function_13(allocator, in));

    if ((value_1 == @as((zx_abi).zx_type_39, .TaskContainer))) {
        return block_28: {
            const operand_24 = @as([]const u8, "ownership");
            const operand_25 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_42));

                (operand_26).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                    .code = operand_24,
                    .message = operand_25,
                });

                break :block_27 @as(*const (zx_abi).zx_type_42, operand_26);
            };
        };
    } else {
        if ((value_1 == @as((zx_abi).zx_type_39, .VoidList))) {
            return block_33: {
                const operand_29 = @as([]const u8, "type_mismatch");
                const operand_30 = @as([]const u8, "lists cannot contain void");

                break :block_33 block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_42));

                    (operand_31).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                        .code = operand_29,
                        .message = operand_30,
                    });

                    break :block_32 @as(*const (zx_abi).zx_type_42, operand_31);
                };
            };
        } else {
            if ((value_1 == @as((zx_abi).zx_type_39, .TaskTuple))) {
                return block_38: {
                    const operand_34 = @as([]const u8, "ownership");
                    const operand_35 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_38 block_37: {
                        const operand_36 = (try (allocator).create((zx_abi).zx_type_42));

                        (operand_36).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                            .code = operand_34,
                            .message = operand_35,
                        });

                        break :block_37 @as(*const (zx_abi).zx_type_42, operand_36);
                    };
                };
            } else {
                if ((value_1 == @as((zx_abi).zx_type_39, .TaskObject))) {
                    return block_43: {
                        const operand_39 = @as([]const u8, "ownership");
                        const operand_40 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_43 block_42: {
                            const operand_41 = (try (allocator).create((zx_abi).zx_type_42));

                            (operand_41).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                                .code = operand_39,
                                .message = operand_40,
                            });

                            break :block_42 @as(*const (zx_abi).zx_type_42, operand_41);
                        };
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_18: {
            const operand_14 = (in).table;
            const operand_15 = ((in).candidate).first;
            const operand_16 = true;

            const operand_17 = (zx_abi).zx_type_35{
                .table = operand_14,
                .id = operand_15,
                .native_references = operand_16,
            };

            break :block_18 (try function_12(allocator, (&operand_17)));
        }) {
            return block_23: {
                const operand_19 = @as([]const u8, "capability");
                const operand_20 = @as([]const u8, "tasks cannot return host references");

                break :block_23 block_22: {
                    const operand_21 = (try (allocator).create((zx_abi).zx_type_42));

                    (operand_21).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                        .code = operand_19,
                        .message = operand_20,
                    });

                    break :block_22 @as(*const (zx_abi).zx_type_42, operand_21);
                };
            };
        }

        if (((try function_4(allocator, block_8: {
            const operand_6 = ((in).table).kinds;
            const operand_7 = (try function_0(allocator, ((in).candidate).first));

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        })) == @as((zx_abi).zx_type_11, .Task))) {
            return block_13: {
                const operand_9 = @as([]const u8, "ownership");
                const operand_10 = @as([]const u8, "a task cannot return another task");

                break :block_13 block_12: {
                    const operand_11 = (try (allocator).create((zx_abi).zx_type_42));

                    (operand_11).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                        .code = operand_9,
                        .message = operand_10,
                    });

                    break :block_12 @as(*const (zx_abi).zx_type_42, operand_11);
                };
            };
        }
    }

    return block_5: {
        const operand_1 = @as([]const u8, "");
        const operand_2 = @as([]const u8, "");

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_42));

            (operand_3).* = @as((zx_abi).zx_type_42, (zx_abi).zx_type_42{
                .code = operand_1,
                .message = operand_2,
            });

            break :block_4 @as(*const (zx_abi).zx_type_42, operand_3);
        };
    };
}

fn function_14_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_40_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_39 = block_85: {
        const operand_81 = in;
        var state_borrow_82: (zx_abi).zx_type_18 = undefined;

        state_borrow_82 = (zx_abi).zx_type_18{
            .names = (((operand_81).candidate).fields).names,
            .types = (((operand_81).candidate).fields).types,
        };

        var state_borrow_83: (zx_abi).zx_type_19 = undefined;

        state_borrow_83 = (zx_abi).zx_type_19{
            .children = ((operand_81).candidate).children,
            .fields = ((((operand_81).candidate).fields).zx_origin orelse (&state_borrow_82)),
            .first = ((operand_81).candidate).first,
            .kind = ((operand_81).candidate).kind,
            .label = ((operand_81).candidate).label,
            .names = ((operand_81).candidate).names,
            .second = ((operand_81).candidate).second,
        };

        var state_borrow_84: (zx_abi).zx_type_40 = undefined;

        state_borrow_84 = (zx_abi).zx_type_40{
            .candidate = (((operand_81).candidate).zx_origin orelse (&state_borrow_83)),
            .table = (operand_81).table,
        };

        break :block_85 (try function_13(allocator, ((operand_81).zx_origin orelse (&state_borrow_84))));
    };

    if ((block_65: {
        break :block_65 value_1;
    } == @as((zx_abi).zx_type_39, .TaskContainer))) {
        return block_68: {
            const operand_66 = @as([]const u8, "ownership");
            const operand_67 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_68 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                .code = operand_66,
                .message = operand_67,
            });
        };
    } else {
        if ((block_69: {
            break :block_69 value_1;
        } == @as((zx_abi).zx_type_39, .VoidList))) {
            return block_72: {
                const operand_70 = @as([]const u8, "type_mismatch");
                const operand_71 = @as([]const u8, "lists cannot contain void");

                break :block_72 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .code = operand_70,
                    .message = operand_71,
                });
            };
        } else {
            if ((block_73: {
                break :block_73 value_1;
            } == @as((zx_abi).zx_type_39, .TaskTuple))) {
                return block_76: {
                    const operand_74 = @as([]const u8, "ownership");
                    const operand_75 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_76 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                        .code = operand_74,
                        .message = operand_75,
                    });
                };
            } else {
                if ((block_77: {
                    break :block_77 value_1;
                } == @as((zx_abi).zx_type_39, .TaskObject))) {
                    return block_80: {
                        const operand_78 = @as([]const u8, "ownership");
                        const operand_79 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_80 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                            .code = operand_78,
                            .message = operand_79,
                        });
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_61: {
            const operand_57 = (in).table;
            const operand_58 = ((in).candidate).first;
            const operand_59 = true;

            const operand_60 = (zx_abi).zx_type_35{
                .table = operand_57,
                .id = operand_58,
                .native_references = operand_59,
            };

            break :block_61 (try function_12(allocator, (&operand_60)));
        }) {
            return block_64: {
                const operand_62 = @as([]const u8, "capability");
                const operand_63 = @as([]const u8, "tasks cannot return host references");

                break :block_64 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .code = operand_62,
                    .message = operand_63,
                });
            };
        }

        if ((block_53: {
            const operand_52 = block_51: {
                const operand_49 = ((in).table).kinds;

                const operand_50 = block_48: {
                    const operand_47 = ((in).candidate).first;

                    break :block_48 (try function_0(allocator, operand_47));
                };

                if ((operand_50 >= (operand_49).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_51 (operand_49)[@intCast(operand_50)];
            };

            break :block_53 (try function_4(allocator, operand_52));
        } == @as((zx_abi).zx_type_11, .Task))) {
            return block_56: {
                const operand_54 = @as([]const u8, "ownership");
                const operand_55 = @as([]const u8, "a task cannot return another task");

                break :block_56 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .code = operand_54,
                    .message = operand_55,
                });
            };
        }
    }

    return block_46: {
        const operand_44 = @as([]const u8, "");
        const operand_45 = @as([]const u8, "");

        break :block_46 @as((zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .code = operand_44,
            .message = operand_45,
        });
    };
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_40) error{
    IndexOutOfBounds,
    IntegerOverflow,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_43 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_59: {
        const operand_41 = block_42: {
            break :block_42 (try (allocator).dupe(u8, (&[_]u8{})));
        };
        const operand_43 = block_44: {
            break :block_44 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_45 = block_46: {
            break :block_46 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_47 = block_48: {
            break :block_48 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_49 = block_50: {
            break :block_50 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_51 = block_52: {
            break :block_52 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_53 = block_54: {
            break :block_54 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_55 = block_56: {
            break :block_56 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_59 block_58: {
            const operand_57 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_57).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                .kinds = operand_41,
                .first = operand_43,
                .second = operand_45,
                .labels = operand_47,
                .children = operand_49,
                .field_types = operand_51,
                .field_names = operand_53,
                .names = operand_55,
            });

            break :block_58 @as(*const (zx_abi).zx_type_15, operand_57);
        };
    };

    const value_2: *const (zx_abi).zx_type_42 = (try function_14(allocator, in));

    if ((!block_34: {
        const operand_32 = (value_2).message;
        const operand_33 = @as([]const u8, "");

        break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
    })) {
        return block_40: {
            const operand_35 = value_1;
            const operand_36 = @as(u32, 0);
            const operand_37 = value_2;

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_43));

                (operand_38).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{
                    .delta = operand_35,
                    .id = operand_36,
                    .diagnostic = operand_37,
                });

                break :block_39 @as(*const (zx_abi).zx_type_43, operand_38);
            };
        };
    }

    const value_3: *const (zx_abi).zx_type_19 = block_31: {
        const operand_23 = (in).candidate;
        const operand_24 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (try function_10(allocator, ((in).candidate).fields)) else ((in).candidate).fields);

        const operand_25 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_28: {
            const operand_26 = ((in).candidate).names;
            const operand_27 = (try (allocator).alloc([]const u8, (operand_26).len));

            @memcpy(operand_27, operand_26);
            ((std).mem).sortUnstable([]const u8, operand_27, {}, zx_compare_10);

            break :block_28 @as((zx_abi).zx_type_44, .{
                operand_27,
                {},
            });
        }).@"0" else ((in).candidate).names);

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_29).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{
                .children = (operand_23).children,
                .fields = operand_24,
                .first = (operand_23).first,
                .kind = (operand_23).kind,
                .label = (operand_23).label,
                .names = operand_25,
                .second = (operand_23).second,
            });

            break :block_30 @as(*const (zx_abi).zx_type_19, operand_29);
        };
    };

    const value_4: *const (zx_abi).zx_type_20 = (try function_7(allocator, block_22: {
        const operand_13 = block_18: {
            const operand_14 = (in).table;
            const operand_15 = value_1;

            break :block_18 block_17: {
                const operand_16 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_16).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{
                    .base = operand_14,
                    .delta = operand_15,
                });

                break :block_17 @as(*const (zx_abi).zx_type_16, operand_16);
            };
        };

        const operand_19 = value_3;

        break :block_22 block_21: {
            const operand_20 = (try (allocator).create((zx_abi).zx_type_27));

            (operand_20).* = @as((zx_abi).zx_type_27, (zx_abi).zx_type_27{
                .tables = operand_13,
                .candidate = operand_19,
            });

            break :block_21 @as(*const (zx_abi).zx_type_27, operand_20);
        };
    }));

    if ((value_4).found) {
        return block_12: {
            const operand_7 = value_1;
            const operand_8 = (value_4).id;
            const operand_9 = value_2;

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_43));

                (operand_10).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{
                    .delta = operand_7,
                    .id = operand_8,
                    .diagnostic = operand_9,
                });

                break :block_11 @as(*const (zx_abi).zx_type_43, operand_10);
            };
        };
    }

    return block_6: {
        const operand_1 = (try function_8(allocator, value_3));
        const operand_2 = (try function_1(allocator, @as(u64, (((in).table).kinds).len)));
        const operand_3 = value_2;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_43));

            (operand_4).* = @as((zx_abi).zx_type_43, (zx_abi).zx_type_43{
                .delta = operand_1,
                .id = operand_2,
                .diagnostic = operand_3,
            });

            break :block_5 @as(*const (zx_abi).zx_type_43, operand_4);
        };
    };
}

fn function_15_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_40_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85) error{
    IndexOutOfBounds,
    IntegerOverflow,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_118: {
        const operand_100 = block_101: {
            break :block_101 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_102 = block_103: {
            break :block_103 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_104 = block_105: {
            break :block_105 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_106 = block_107: {
            break :block_107 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_108 = block_109: {
            break :block_109 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_110 = block_111: {
            break :block_111 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_112 = block_113: {
            break :block_113 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_114 = block_115: {
            break :block_115 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_118 block_117: {
            const operand_116 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_116).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                .kinds = operand_100,
                .first = operand_102,
                .second = operand_104,
                .labels = operand_106,
                .children = operand_108,
                .field_types = operand_110,
                .field_names = operand_112,
                .names = operand_114,
            });

            break :block_117 @as(*const (zx_abi).zx_type_15, operand_116);
        };
    };

    const value_2: (zx_abi).value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_99: {
        break :block_99 (try function_14_value(allocator, in));
    };

    if ((!block_93: {
        const operand_91 = (value_2).message;
        const operand_92 = @as([]const u8, "");

        break :block_93 ((std).mem).eql(u8, operand_91, operand_92);
    })) {
        return block_98: {
            const operand_94 = block_95: {
                break :block_95 value_1;
            };

            const operand_96 = @as(u32, 0);
            const operand_97 = value_2;

            break :block_98 @as((zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{
                .delta = operand_94,
                .id = operand_96,
                .diagnostic = operand_97,
            });
        };
    }

    const value_3: (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = block_90: {
        const operand_83 = (in).candidate;

        const operand_84 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) block_85: {
            break :block_85 (try function_10_value(allocator, ((in).candidate).fields));
        } else ((in).candidate).fields);

        const operand_86 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_89: {
            const operand_87 = ((in).candidate).names;
            const operand_88 = (try (allocator).alloc([]const u8, (operand_87).len));

            @memcpy(operand_88, operand_87);
            ((std).mem).sortUnstable([]const u8, operand_88, {}, zx_compare_10);

            break :block_89 @as((zx_abi).value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_88,
                {},
                null,
            });
        }).@"0" else ((in).candidate).names);

        break :block_90 @as((zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384, (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{
            .children = (operand_83).children,
            .fields = operand_84,
            .first = (operand_83).first,
            .kind = (operand_83).kind,
            .label = (operand_83).label,
            .names = operand_86,
            .second = (operand_83).second,
        });
    };

    const value_4: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_82: {
        break :block_82 (try function_7_value(allocator, block_81: {
            const operand_75 = block_79: {
                const operand_76 = (in).table;

                const operand_77 = block_78: {
                    break :block_78 value_1;
                };

                break :block_79 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .base = operand_76,
                    .delta = operand_77,
                });
            };

            const operand_80 = value_3;

            break :block_81 @as((zx_abi).value_zx_type_27_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22, (zx_abi).value_zx_type_27_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22{
                .tables = operand_75,
                .candidate = operand_80,
            });
        }));
    };

    if ((value_4).found) {
        return block_74: {
            const operand_70 = block_71: {
                break :block_71 value_1;
            };

            const operand_72 = (value_4).id;
            const operand_73 = value_2;

            break :block_74 @as((zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{
                .delta = operand_70,
                .id = operand_72,
                .diagnostic = operand_73,
            });
        };
    }

    return block_69: {
        const operand_60 = block_64: {
            const operand_61 = value_3;
            var state_borrow_62: (zx_abi).zx_type_18 = undefined;

            state_borrow_62 = (zx_abi).zx_type_18{
                .names = ((operand_61).fields).names,
                .types = ((operand_61).fields).types,
            };

            var state_borrow_63: (zx_abi).zx_type_19 = undefined;

            state_borrow_63 = (zx_abi).zx_type_19{
                .children = (operand_61).children,
                .fields = (((operand_61).fields).zx_origin orelse (&state_borrow_62)),
                .first = (operand_61).first,
                .kind = (operand_61).kind,
                .label = (operand_61).label,
                .names = (operand_61).names,
                .second = (operand_61).second,
            };

            break :block_64 (try function_8(allocator, ((operand_61).zx_origin orelse (&state_borrow_63))));
        };
        const operand_65 = block_67: {
            const operand_66 = @as(u64, (((in).table).kinds).len);

            break :block_67 (try function_1(allocator, operand_66));
        };

        const operand_68 = value_2;

        break :block_69 @as((zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{
            .delta = operand_60,
            .id = operand_65,
            .diagnostic = operand_68,
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_40) error{
    IndexOutOfBounds,
    IntegerOverflow,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_43 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_43 = (try function_15(allocator, in));

    return value_1;
}

fn zx_compare_10(context: void, left: []const u8, right: []const u8) bool {
    _ = context;

    return ((std).mem).lessThan(u8, left, right);
}
