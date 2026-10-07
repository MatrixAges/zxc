const std = @import("std");
const zx_type_11 = enum { Invalid, Module, Import, Call, Task, Parallel, Switch, Case, Default, Emit, Return, Gateway, Group, Route, Store, StoreRef, Object, Field, };
const zx_type_12 = enum { String, OptionalString, Unsigned, Protocol, Method, };

const zx_type_13 = struct {
    count: u64,
    empty: bool,
    fallback: u64,
    kind: zx_type_12,
    minimum: u64,
    name: []const u8,
    required: bool,
};

const zx_type_14 = struct {
    index: u64,
    role: zx_type_11,
};

pub const Input = *const zx_type_14;
pub const Output = *const zx_type_13;
pub const consumes_input = false;
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
const zx_shape_12 = .{ .kind = .scalar, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .empty = zx_shape_1, .fallback = zx_shape_5, .kind = zx_shape_12, .minimum = zx_shape_5, .name = zx_shape_10, .required = zx_shape_1, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .role = zx_shape_11, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_51: {
            const operand_42 = @as(u64, 4);
            const operand_43 = @as(u64, 0);
            const operand_44 = true;
            const operand_45 = @as([]const u8, "fn");
            const operand_46 = @as(zx_type_12, .OptionalString);
            const operand_47 = false;
            const operand_48 = @as(u64, 0);

            break :block_51 block_50: {
                const operand_49 = (try (allocator).create(zx_type_13));
                (operand_49).* = @as(zx_type_13, zx_type_13{ .count = operand_42, .minimum = operand_43, .empty = operand_44, .name = operand_45, .kind = operand_46, .required = operand_47, .fallback = operand_48, });

                break :block_50 @as(*const zx_type_13, operand_49);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_41: {
                const operand_32 = @as(u64, 4);
                const operand_33 = @as(u64, 0);
                const operand_34 = true;
                const operand_35 = @as([]const u8, "module");
                const operand_36 = @as(zx_type_12, .OptionalString);
                const operand_37 = false;
                const operand_38 = @as(u64, 0);

                break :block_41 block_40: {
                    const operand_39 = (try (allocator).create(zx_type_13));
                    (operand_39).* = @as(zx_type_13, zx_type_13{ .count = operand_32, .minimum = operand_33, .empty = operand_34, .name = operand_35, .kind = operand_36, .required = operand_37, .fallback = operand_38, });

                    break :block_40 @as(*const zx_type_13, operand_39);
                };
            };
        } else {
            if ((switch_1 == @as(u64, 2))) {
                return block_31: {
                    const operand_22 = @as(u64, 4);
                    const operand_23 = @as(u64, 0);
                    const operand_24 = true;
                    const operand_25 = @as([]const u8, "in");
                    const operand_26 = @as(zx_type_12, .OptionalString);
                    const operand_27 = false;
                    const operand_28 = @as(u64, 0);

                    break :block_31 block_30: {
                        const operand_29 = (try (allocator).create(zx_type_13));

                        (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                        break :block_30 @as(*const zx_type_13, operand_29);
                    };
                };
            } else {
                if ((switch_1 == @as(u64, 3))) {
                    return block_21: {
                        const operand_12 = @as(u64, 4);
                        const operand_13 = @as(u64, 0);
                        const operand_14 = true;
                        const operand_15 = @as([]const u8, "setter");
                        const operand_16 = @as(zx_type_12, .OptionalString);
                        const operand_17 = false;
                        const operand_18 = @as(u64, 0);

                        break :block_21 block_20: {
                            const operand_19 = (try (allocator).create(zx_type_13));

                            (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                            break :block_20 @as(*const zx_type_13, operand_19);
                        };
                    };
                } else {
                    return block_11: {
                        const operand_2 = @as(u64, 4);
                        const operand_3 = @as(u64, 0);
                        const operand_4 = true;
                        const operand_5 = @as([]const u8, "");
                        const operand_6 = @as(zx_type_12, .OptionalString);
                        const operand_7 = false;
                        const operand_8 = @as(u64, 0);

                        break :block_11 block_10: {
                            const operand_9 = (try (allocator).create(zx_type_13));
                            (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                            break :block_10 @as(*const zx_type_13, operand_9);
                        };
                    };
                }
            }
        }
    }
}

fn function_0_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_52 = in;

    if ((switch_52 == @as(u64, 0))) {
        return block_92: {
            const operand_85 = @as(u64, 4);
            const operand_86 = @as(u64, 0);
            const operand_87 = true;
            const operand_88 = @as([]const u8, "fn");
            const operand_89 = @as(zx_type_12, .OptionalString);
            const operand_90 = false;
            const operand_91 = @as(u64, 0);

            break :block_92 zx_type_13{ .count = operand_85, .minimum = operand_86, .empty = operand_87, .name = operand_88, .kind = operand_89, .required = operand_90, .fallback = operand_91, };
        };
    } else {
        if ((switch_52 == @as(u64, 1))) {
            return block_84: {
                const operand_77 = @as(u64, 4);
                const operand_78 = @as(u64, 0);
                const operand_79 = true;
                const operand_80 = @as([]const u8, "module");
                const operand_81 = @as(zx_type_12, .OptionalString);
                const operand_82 = false;
                const operand_83 = @as(u64, 0);

                break :block_84 zx_type_13{ .count = operand_77, .minimum = operand_78, .empty = operand_79, .name = operand_80, .kind = operand_81, .required = operand_82, .fallback = operand_83, };
            };
        } else {
            if ((switch_52 == @as(u64, 2))) {
                return block_76: {
                    const operand_69 = @as(u64, 4);
                    const operand_70 = @as(u64, 0);
                    const operand_71 = true;
                    const operand_72 = @as([]const u8, "in");
                    const operand_73 = @as(zx_type_12, .OptionalString);
                    const operand_74 = false;
                    const operand_75 = @as(u64, 0);

                    break :block_76 zx_type_13{ .count = operand_69, .minimum = operand_70, .empty = operand_71, .name = operand_72, .kind = operand_73, .required = operand_74, .fallback = operand_75, };
                };
            } else {
                if ((switch_52 == @as(u64, 3))) {
                    return block_68: {
                        const operand_61 = @as(u64, 4);
                        const operand_62 = @as(u64, 0);
                        const operand_63 = true;
                        const operand_64 = @as([]const u8, "setter");
                        const operand_65 = @as(zx_type_12, .OptionalString);
                        const operand_66 = false;
                        const operand_67 = @as(u64, 0);

                        break :block_68 zx_type_13{ .count = operand_61, .minimum = operand_62, .empty = operand_63, .name = operand_64, .kind = operand_65, .required = operand_66, .fallback = operand_67, };
                    };
                } else {
                    return block_60: {
                        const operand_53 = @as(u64, 4);
                        const operand_54 = @as(u64, 0);
                        const operand_55 = true;
                        const operand_56 = @as([]const u8, "");
                        const operand_57 = @as(zx_type_12, .OptionalString);
                        const operand_58 = false;
                        const operand_59 = @as(u64, 0);

                        break :block_60 zx_type_13{ .count = operand_53, .minimum = operand_54, .empty = operand_55, .name = operand_56, .kind = operand_57, .required = operand_58, .fallback = operand_59, };
                    };
                }
            }
        }
    }
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 1);
            const operand_14 = false;
            const operand_15 = @as([]const u8, "value");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 1);
            const operand_4 = false;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_1_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 1);
            const operand_33 = false;
            const operand_34 = @as([]const u8, "value");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 1);
            const operand_25 = false;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_2(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    _ = in;

    return block_10: {
        const operand_1 = @as(u64, 0);
        const operand_2 = @as(u64, 1);
        const operand_3 = false;
        const operand_4 = @as([]const u8, "");
        const operand_5 = @as(zx_type_12, .OptionalString);
        const operand_6 = false;
        const operand_7 = @as(u64, 0);

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create(zx_type_13));
            (operand_8).* = @as(zx_type_13, zx_type_13{ .count = operand_1, .minimum = operand_2, .empty = operand_3, .name = operand_4, .kind = operand_5, .required = operand_6, .fallback = operand_7, });

            break :block_9 @as(*const zx_type_13, operand_8);
        };
    };
}

fn function_2_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = in;

    return block_18: {
        const operand_11 = @as(u64, 0);
        const operand_12 = @as(u64, 1);
        const operand_13 = false;
        const operand_14 = @as([]const u8, "");
        const operand_15 = @as(zx_type_12, .OptionalString);
        const operand_16 = false;
        const operand_17 = @as(u64, 0);

        break :block_18 zx_type_13{ .count = operand_11, .minimum = operand_12, .empty = operand_13, .name = operand_14, .kind = operand_15, .required = operand_16, .fallback = operand_17, };
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_31: {
            const operand_22 = @as(u64, 2);
            const operand_23 = @as(u64, 0);
            const operand_24 = true;
            const operand_25 = @as([]const u8, "event");
            const operand_26 = @as(zx_type_12, .String);
            const operand_27 = true;
            const operand_28 = @as(u64, 0);

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                break :block_30 @as(*const zx_type_13, operand_29);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_21: {
                const operand_12 = @as(u64, 2);
                const operand_13 = @as(u64, 0);
                const operand_14 = true;
                const operand_15 = @as([]const u8, "value");
                const operand_16 = @as(zx_type_12, .String);
                const operand_17 = true;
                const operand_18 = @as(u64, 0);

                break :block_21 block_20: {
                    const operand_19 = (try (allocator).create(zx_type_13));

                    (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                    break :block_20 @as(*const zx_type_13, operand_19);
                };
            };
        } else {
            return block_11: {
                const operand_2 = @as(u64, 2);
                const operand_3 = @as(u64, 0);
                const operand_4 = true;
                const operand_5 = @as([]const u8, "");
                const operand_6 = @as(zx_type_12, .OptionalString);
                const operand_7 = false;
                const operand_8 = @as(u64, 0);

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create(zx_type_13));
                    (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                    break :block_10 @as(*const zx_type_13, operand_9);
                };
            };
        }
    }
}

fn function_3_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_32 = in;

    if ((switch_32 == @as(u64, 0))) {
        return block_56: {
            const operand_49 = @as(u64, 2);
            const operand_50 = @as(u64, 0);
            const operand_51 = true;
            const operand_52 = @as([]const u8, "event");
            const operand_53 = @as(zx_type_12, .String);
            const operand_54 = true;
            const operand_55 = @as(u64, 0);

            break :block_56 zx_type_13{ .count = operand_49, .minimum = operand_50, .empty = operand_51, .name = operand_52, .kind = operand_53, .required = operand_54, .fallback = operand_55, };
        };
    } else {
        if ((switch_32 == @as(u64, 1))) {
            return block_48: {
                const operand_41 = @as(u64, 2);
                const operand_42 = @as(u64, 0);
                const operand_43 = true;
                const operand_44 = @as([]const u8, "value");
                const operand_45 = @as(zx_type_12, .String);
                const operand_46 = true;
                const operand_47 = @as(u64, 0);

                break :block_48 zx_type_13{ .count = operand_41, .minimum = operand_42, .empty = operand_43, .name = operand_44, .kind = operand_45, .required = operand_46, .fallback = operand_47, };
            };
        } else {
            return block_40: {
                const operand_33 = @as(u64, 2);
                const operand_34 = @as(u64, 0);
                const operand_35 = true;
                const operand_36 = @as([]const u8, "");
                const operand_37 = @as(zx_type_12, .OptionalString);
                const operand_38 = false;
                const operand_39 = @as(u64, 0);

                break :block_40 zx_type_13{ .count = operand_33, .minimum = operand_34, .empty = operand_35, .name = operand_36, .kind = operand_37, .required = operand_38, .fallback = operand_39, };
            };
        }
    }
}

fn function_4(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_41: {
            const operand_32 = @as(u64, 3);
            const operand_33 = @as(u64, 0);
            const operand_34 = true;
            const operand_35 = @as([]const u8, "name");
            const operand_36 = @as(zx_type_12, .String);
            const operand_37 = true;
            const operand_38 = @as(u64, 0);

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create(zx_type_13));
                (operand_39).* = @as(zx_type_13, zx_type_13{ .count = operand_32, .minimum = operand_33, .empty = operand_34, .name = operand_35, .kind = operand_36, .required = operand_37, .fallback = operand_38, });

                break :block_40 @as(*const zx_type_13, operand_39);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_31: {
                const operand_22 = @as(u64, 3);
                const operand_23 = @as(u64, 0);
                const operand_24 = true;
                const operand_25 = @as([]const u8, "type");
                const operand_26 = @as(zx_type_12, .String);
                const operand_27 = true;
                const operand_28 = @as(u64, 0);

                break :block_31 block_30: {
                    const operand_29 = (try (allocator).create(zx_type_13));

                    (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                    break :block_30 @as(*const zx_type_13, operand_29);
                };
            };
        } else {
            if ((switch_1 == @as(u64, 2))) {
                return block_21: {
                    const operand_12 = @as(u64, 3);
                    const operand_13 = @as(u64, 0);
                    const operand_14 = true;
                    const operand_15 = @as([]const u8, "value");
                    const operand_16 = @as(zx_type_12, .String);
                    const operand_17 = true;
                    const operand_18 = @as(u64, 0);

                    break :block_21 block_20: {
                        const operand_19 = (try (allocator).create(zx_type_13));

                        (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                        break :block_20 @as(*const zx_type_13, operand_19);
                    };
                };
            } else {
                return block_11: {
                    const operand_2 = @as(u64, 3);
                    const operand_3 = @as(u64, 0);
                    const operand_4 = true;
                    const operand_5 = @as([]const u8, "");
                    const operand_6 = @as(zx_type_12, .OptionalString);
                    const operand_7 = false;
                    const operand_8 = @as(u64, 0);

                    break :block_11 block_10: {
                        const operand_9 = (try (allocator).create(zx_type_13));
                        (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                        break :block_10 @as(*const zx_type_13, operand_9);
                    };
                };
            }
        }
    }
}

fn function_4_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_42 = in;

    if ((switch_42 == @as(u64, 0))) {
        return block_74: {
            const operand_67 = @as(u64, 3);
            const operand_68 = @as(u64, 0);
            const operand_69 = true;
            const operand_70 = @as([]const u8, "name");
            const operand_71 = @as(zx_type_12, .String);
            const operand_72 = true;
            const operand_73 = @as(u64, 0);

            break :block_74 zx_type_13{ .count = operand_67, .minimum = operand_68, .empty = operand_69, .name = operand_70, .kind = operand_71, .required = operand_72, .fallback = operand_73, };
        };
    } else {
        if ((switch_42 == @as(u64, 1))) {
            return block_66: {
                const operand_59 = @as(u64, 3);
                const operand_60 = @as(u64, 0);
                const operand_61 = true;
                const operand_62 = @as([]const u8, "type");
                const operand_63 = @as(zx_type_12, .String);
                const operand_64 = true;
                const operand_65 = @as(u64, 0);

                break :block_66 zx_type_13{ .count = operand_59, .minimum = operand_60, .empty = operand_61, .name = operand_62, .kind = operand_63, .required = operand_64, .fallback = operand_65, };
            };
        } else {
            if ((switch_42 == @as(u64, 2))) {
                return block_58: {
                    const operand_51 = @as(u64, 3);
                    const operand_52 = @as(u64, 0);
                    const operand_53 = true;
                    const operand_54 = @as([]const u8, "value");
                    const operand_55 = @as(zx_type_12, .String);
                    const operand_56 = true;
                    const operand_57 = @as(u64, 0);

                    break :block_58 zx_type_13{ .count = operand_51, .minimum = operand_52, .empty = operand_53, .name = operand_54, .kind = operand_55, .required = operand_56, .fallback = operand_57, };
                };
            } else {
                return block_50: {
                    const operand_43 = @as(u64, 3);
                    const operand_44 = @as(u64, 0);
                    const operand_45 = true;
                    const operand_46 = @as([]const u8, "");
                    const operand_47 = @as(zx_type_12, .OptionalString);
                    const operand_48 = false;
                    const operand_49 = @as(u64, 0);

                    break :block_50 zx_type_13{ .count = operand_43, .minimum = operand_44, .empty = operand_45, .name = operand_46, .kind = operand_47, .required = operand_48, .fallback = operand_49, };
                };
            }
        }
    }
}

fn function_5(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_61: {
            const operand_52 = @as(u64, 5);
            const operand_53 = @as(u64, 0);
            const operand_54 = false;
            const operand_55 = @as([]const u8, "name");
            const operand_56 = @as(zx_type_12, .String);
            const operand_57 = true;
            const operand_58 = @as(u64, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create(zx_type_13));

                (operand_59).* = @as(zx_type_13, zx_type_13{ .count = operand_52, .minimum = operand_53, .empty = operand_54, .name = operand_55, .kind = operand_56, .required = operand_57, .fallback = operand_58, });

                break :block_60 @as(*const zx_type_13, operand_59);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_51: {
                const operand_42 = @as(u64, 5);
                const operand_43 = @as(u64, 0);
                const operand_44 = false;
                const operand_45 = @as([]const u8, "protocol");
                const operand_46 = @as(zx_type_12, .Protocol);
                const operand_47 = false;
                const operand_48 = @as(u64, 0);

                break :block_51 block_50: {
                    const operand_49 = (try (allocator).create(zx_type_13));
                    (operand_49).* = @as(zx_type_13, zx_type_13{ .count = operand_42, .minimum = operand_43, .empty = operand_44, .name = operand_45, .kind = operand_46, .required = operand_47, .fallback = operand_48, });

                    break :block_50 @as(*const zx_type_13, operand_49);
                };
            };
        } else {
            if ((switch_1 == @as(u64, 2))) {
                return block_41: {
                    const operand_32 = @as(u64, 5);
                    const operand_33 = @as(u64, 0);
                    const operand_34 = false;
                    const operand_35 = @as([]const u8, "listen");
                    const operand_36 = @as(zx_type_12, .OptionalString);
                    const operand_37 = false;
                    const operand_38 = @as(u64, 0);

                    break :block_41 block_40: {
                        const operand_39 = (try (allocator).create(zx_type_13));
                        (operand_39).* = @as(zx_type_13, zx_type_13{ .count = operand_32, .minimum = operand_33, .empty = operand_34, .name = operand_35, .kind = operand_36, .required = operand_37, .fallback = operand_38, });

                        break :block_40 @as(*const zx_type_13, operand_39);
                    };
                };
            } else {
                if ((switch_1 == @as(u64, 3))) {
                    return block_31: {
                        const operand_22 = @as(u64, 5);
                        const operand_23 = @as(u64, 0);
                        const operand_24 = false;
                        const operand_25 = @as([]const u8, "max_header_bytes");
                        const operand_26 = @as(zx_type_12, .Unsigned);
                        const operand_27 = false;
                        const operand_28 = @as(u64, 8192);

                        break :block_31 block_30: {
                            const operand_29 = (try (allocator).create(zx_type_13));

                            (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                            break :block_30 @as(*const zx_type_13, operand_29);
                        };
                    };
                } else {
                    if ((switch_1 == @as(u64, 4))) {
                        return block_21: {
                            const operand_12 = @as(u64, 5);
                            const operand_13 = @as(u64, 0);
                            const operand_14 = false;
                            const operand_15 = @as([]const u8, "max_body_bytes");
                            const operand_16 = @as(zx_type_12, .Unsigned);
                            const operand_17 = false;
                            const operand_18 = @as(u64, 1048576);

                            break :block_21 block_20: {
                                const operand_19 = (try (allocator).create(zx_type_13));

                                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                                break :block_20 @as(*const zx_type_13, operand_19);
                            };
                        };
                    } else {
                        return block_11: {
                            const operand_2 = @as(u64, 5);
                            const operand_3 = @as(u64, 0);
                            const operand_4 = false;
                            const operand_5 = @as([]const u8, "");
                            const operand_6 = @as(zx_type_12, .OptionalString);
                            const operand_7 = false;
                            const operand_8 = @as(u64, 0);

                            break :block_11 block_10: {
                                const operand_9 = (try (allocator).create(zx_type_13));
                                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                                break :block_10 @as(*const zx_type_13, operand_9);
                            };
                        };
                    }
                }
            }
        }
    }
}

fn function_5_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_62 = in;

    if ((switch_62 == @as(u64, 0))) {
        return block_110: {
            const operand_103 = @as(u64, 5);
            const operand_104 = @as(u64, 0);
            const operand_105 = false;
            const operand_106 = @as([]const u8, "name");
            const operand_107 = @as(zx_type_12, .String);
            const operand_108 = true;
            const operand_109 = @as(u64, 0);

            break :block_110 zx_type_13{ .count = operand_103, .minimum = operand_104, .empty = operand_105, .name = operand_106, .kind = operand_107, .required = operand_108, .fallback = operand_109, };
        };
    } else {
        if ((switch_62 == @as(u64, 1))) {
            return block_102: {
                const operand_95 = @as(u64, 5);
                const operand_96 = @as(u64, 0);
                const operand_97 = false;
                const operand_98 = @as([]const u8, "protocol");
                const operand_99 = @as(zx_type_12, .Protocol);
                const operand_100 = false;
                const operand_101 = @as(u64, 0);

                break :block_102 zx_type_13{ .count = operand_95, .minimum = operand_96, .empty = operand_97, .name = operand_98, .kind = operand_99, .required = operand_100, .fallback = operand_101, };
            };
        } else {
            if ((switch_62 == @as(u64, 2))) {
                return block_94: {
                    const operand_87 = @as(u64, 5);
                    const operand_88 = @as(u64, 0);
                    const operand_89 = false;
                    const operand_90 = @as([]const u8, "listen");
                    const operand_91 = @as(zx_type_12, .OptionalString);
                    const operand_92 = false;
                    const operand_93 = @as(u64, 0);

                    break :block_94 zx_type_13{ .count = operand_87, .minimum = operand_88, .empty = operand_89, .name = operand_90, .kind = operand_91, .required = operand_92, .fallback = operand_93, };
                };
            } else {
                if ((switch_62 == @as(u64, 3))) {
                    return block_86: {
                        const operand_79 = @as(u64, 5);
                        const operand_80 = @as(u64, 0);
                        const operand_81 = false;
                        const operand_82 = @as([]const u8, "max_header_bytes");
                        const operand_83 = @as(zx_type_12, .Unsigned);
                        const operand_84 = false;
                        const operand_85 = @as(u64, 8192);

                        break :block_86 zx_type_13{ .count = operand_79, .minimum = operand_80, .empty = operand_81, .name = operand_82, .kind = operand_83, .required = operand_84, .fallback = operand_85, };
                    };
                } else {
                    if ((switch_62 == @as(u64, 4))) {
                        return block_78: {
                            const operand_71 = @as(u64, 5);
                            const operand_72 = @as(u64, 0);
                            const operand_73 = false;
                            const operand_74 = @as([]const u8, "max_body_bytes");
                            const operand_75 = @as(zx_type_12, .Unsigned);
                            const operand_76 = false;
                            const operand_77 = @as(u64, 1048576);

                            break :block_78 zx_type_13{ .count = operand_71, .minimum = operand_72, .empty = operand_73, .name = operand_74, .kind = operand_75, .required = operand_76, .fallback = operand_77, };
                        };
                    } else {
                        return block_70: {
                            const operand_63 = @as(u64, 5);
                            const operand_64 = @as(u64, 0);
                            const operand_65 = false;
                            const operand_66 = @as([]const u8, "");
                            const operand_67 = @as(zx_type_12, .OptionalString);
                            const operand_68 = false;
                            const operand_69 = @as(u64, 0);

                            break :block_70 zx_type_13{ .count = operand_63, .minimum = operand_64, .empty = operand_65, .name = operand_66, .kind = operand_67, .required = operand_68, .fallback = operand_69, };
                        };
                    }
                }
            }
        }
    }
}

fn function_6(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 1);
            const operand_14 = false;
            const operand_15 = @as([]const u8, "prefix");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 1);
            const operand_4 = false;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_6_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 1);
            const operand_33 = false;
            const operand_34 = @as([]const u8, "prefix");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 1);
            const operand_25 = false;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_7(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 0);
            const operand_14 = true;
            const operand_15 = @as([]const u8, "from");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 0);
            const operand_4 = true;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_7_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 0);
            const operand_33 = true;
            const operand_34 = @as([]const u8, "from");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 0);
            const operand_25 = true;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_8(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_31: {
            const operand_22 = @as(u64, 2);
            const operand_23 = @as(u64, 0);
            const operand_24 = false;
            const operand_25 = @as([]const u8, "in");
            const operand_26 = @as(zx_type_12, .OptionalString);
            const operand_27 = false;
            const operand_28 = @as(u64, 0);

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                break :block_30 @as(*const zx_type_13, operand_29);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_21: {
                const operand_12 = @as(u64, 2);
                const operand_13 = @as(u64, 0);
                const operand_14 = false;
                const operand_15 = @as([]const u8, "out");
                const operand_16 = @as(zx_type_12, .OptionalString);
                const operand_17 = false;
                const operand_18 = @as(u64, 0);

                break :block_21 block_20: {
                    const operand_19 = (try (allocator).create(zx_type_13));

                    (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                    break :block_20 @as(*const zx_type_13, operand_19);
                };
            };
        } else {
            return block_11: {
                const operand_2 = @as(u64, 2);
                const operand_3 = @as(u64, 0);
                const operand_4 = false;
                const operand_5 = @as([]const u8, "");
                const operand_6 = @as(zx_type_12, .OptionalString);
                const operand_7 = false;
                const operand_8 = @as(u64, 0);

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create(zx_type_13));
                    (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                    break :block_10 @as(*const zx_type_13, operand_9);
                };
            };
        }
    }
}

fn function_8_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_32 = in;

    if ((switch_32 == @as(u64, 0))) {
        return block_56: {
            const operand_49 = @as(u64, 2);
            const operand_50 = @as(u64, 0);
            const operand_51 = false;
            const operand_52 = @as([]const u8, "in");
            const operand_53 = @as(zx_type_12, .OptionalString);
            const operand_54 = false;
            const operand_55 = @as(u64, 0);

            break :block_56 zx_type_13{ .count = operand_49, .minimum = operand_50, .empty = operand_51, .name = operand_52, .kind = operand_53, .required = operand_54, .fallback = operand_55, };
        };
    } else {
        if ((switch_32 == @as(u64, 1))) {
            return block_48: {
                const operand_41 = @as(u64, 2);
                const operand_42 = @as(u64, 0);
                const operand_43 = false;
                const operand_44 = @as([]const u8, "out");
                const operand_45 = @as(zx_type_12, .OptionalString);
                const operand_46 = false;
                const operand_47 = @as(u64, 0);

                break :block_48 zx_type_13{ .count = operand_41, .minimum = operand_42, .empty = operand_43, .name = operand_44, .kind = operand_45, .required = operand_46, .fallback = operand_47, };
            };
        } else {
            return block_40: {
                const operand_33 = @as(u64, 2);
                const operand_34 = @as(u64, 0);
                const operand_35 = false;
                const operand_36 = @as([]const u8, "");
                const operand_37 = @as(zx_type_12, .OptionalString);
                const operand_38 = false;
                const operand_39 = @as(u64, 0);

                break :block_40 zx_type_13{ .count = operand_33, .minimum = operand_34, .empty = operand_35, .name = operand_36, .kind = operand_37, .required = operand_38, .fallback = operand_39, };
            };
        }
    }
}

fn function_9(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 1);
            const operand_14 = false;
            const operand_15 = @as([]const u8, "name");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 1);
            const operand_4 = false;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_9_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 1);
            const operand_33 = false;
            const operand_34 = @as([]const u8, "name");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 1);
            const operand_25 = false;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_10(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    _ = in;

    return block_10: {
        const operand_1 = @as(u64, 0);
        const operand_2 = @as(u64, 1);
        const operand_3 = false;
        const operand_4 = @as([]const u8, "");
        const operand_5 = @as(zx_type_12, .OptionalString);
        const operand_6 = false;
        const operand_7 = @as(u64, 0);

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create(zx_type_13));
            (operand_8).* = @as(zx_type_13, zx_type_13{ .count = operand_1, .minimum = operand_2, .empty = operand_3, .name = operand_4, .kind = operand_5, .required = operand_6, .fallback = operand_7, });

            break :block_9 @as(*const zx_type_13, operand_8);
        };
    };
}

fn function_10_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = in;

    return block_18: {
        const operand_11 = @as(u64, 0);
        const operand_12 = @as(u64, 1);
        const operand_13 = false;
        const operand_14 = @as([]const u8, "");
        const operand_15 = @as(zx_type_12, .OptionalString);
        const operand_16 = false;
        const operand_17 = @as(u64, 0);

        break :block_18 zx_type_13{ .count = operand_11, .minimum = operand_12, .empty = operand_13, .name = operand_14, .kind = operand_15, .required = operand_16, .fallback = operand_17, };
    };
}

fn function_11(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 0);
            const operand_14 = true;
            const operand_15 = @as([]const u8, "value");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 0);
            const operand_4 = true;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_11_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 0);
            const operand_33 = true;
            const operand_34 = @as([]const u8, "value");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 0);
            const operand_25 = true;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_12(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_41: {
            const operand_32 = @as(u64, 3);
            const operand_33 = @as(u64, 0);
            const operand_34 = true;
            const operand_35 = @as([]const u8, "path");
            const operand_36 = @as(zx_type_12, .String);
            const operand_37 = true;
            const operand_38 = @as(u64, 0);

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create(zx_type_13));
                (operand_39).* = @as(zx_type_13, zx_type_13{ .count = operand_32, .minimum = operand_33, .empty = operand_34, .name = operand_35, .kind = operand_36, .required = operand_37, .fallback = operand_38, });

                break :block_40 @as(*const zx_type_13, operand_39);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_31: {
                const operand_22 = @as(u64, 3);
                const operand_23 = @as(u64, 0);
                const operand_24 = true;
                const operand_25 = @as([]const u8, "service");
                const operand_26 = @as(zx_type_12, .String);
                const operand_27 = true;
                const operand_28 = @as(u64, 0);

                break :block_31 block_30: {
                    const operand_29 = (try (allocator).create(zx_type_13));

                    (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                    break :block_30 @as(*const zx_type_13, operand_29);
                };
            };
        } else {
            if ((switch_1 == @as(u64, 2))) {
                return block_21: {
                    const operand_12 = @as(u64, 3);
                    const operand_13 = @as(u64, 0);
                    const operand_14 = true;
                    const operand_15 = @as([]const u8, "method");
                    const operand_16 = @as(zx_type_12, .Method);
                    const operand_17 = false;
                    const operand_18 = @as(u64, 0);

                    break :block_21 block_20: {
                        const operand_19 = (try (allocator).create(zx_type_13));

                        (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                        break :block_20 @as(*const zx_type_13, operand_19);
                    };
                };
            } else {
                return block_11: {
                    const operand_2 = @as(u64, 3);
                    const operand_3 = @as(u64, 0);
                    const operand_4 = true;
                    const operand_5 = @as([]const u8, "");
                    const operand_6 = @as(zx_type_12, .OptionalString);
                    const operand_7 = false;
                    const operand_8 = @as(u64, 0);

                    break :block_11 block_10: {
                        const operand_9 = (try (allocator).create(zx_type_13));
                        (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                        break :block_10 @as(*const zx_type_13, operand_9);
                    };
                };
            }
        }
    }
}

fn function_12_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_42 = in;

    if ((switch_42 == @as(u64, 0))) {
        return block_74: {
            const operand_67 = @as(u64, 3);
            const operand_68 = @as(u64, 0);
            const operand_69 = true;
            const operand_70 = @as([]const u8, "path");
            const operand_71 = @as(zx_type_12, .String);
            const operand_72 = true;
            const operand_73 = @as(u64, 0);

            break :block_74 zx_type_13{ .count = operand_67, .minimum = operand_68, .empty = operand_69, .name = operand_70, .kind = operand_71, .required = operand_72, .fallback = operand_73, };
        };
    } else {
        if ((switch_42 == @as(u64, 1))) {
            return block_66: {
                const operand_59 = @as(u64, 3);
                const operand_60 = @as(u64, 0);
                const operand_61 = true;
                const operand_62 = @as([]const u8, "service");
                const operand_63 = @as(zx_type_12, .String);
                const operand_64 = true;
                const operand_65 = @as(u64, 0);

                break :block_66 zx_type_13{ .count = operand_59, .minimum = operand_60, .empty = operand_61, .name = operand_62, .kind = operand_63, .required = operand_64, .fallback = operand_65, };
            };
        } else {
            if ((switch_42 == @as(u64, 2))) {
                return block_58: {
                    const operand_51 = @as(u64, 3);
                    const operand_52 = @as(u64, 0);
                    const operand_53 = true;
                    const operand_54 = @as([]const u8, "method");
                    const operand_55 = @as(zx_type_12, .Method);
                    const operand_56 = false;
                    const operand_57 = @as(u64, 0);

                    break :block_58 zx_type_13{ .count = operand_51, .minimum = operand_52, .empty = operand_53, .name = operand_54, .kind = operand_55, .required = operand_56, .fallback = operand_57, };
                };
            } else {
                return block_50: {
                    const operand_43 = @as(u64, 3);
                    const operand_44 = @as(u64, 0);
                    const operand_45 = true;
                    const operand_46 = @as([]const u8, "");
                    const operand_47 = @as(zx_type_12, .OptionalString);
                    const operand_48 = false;
                    const operand_49 = @as(u64, 0);

                    break :block_50 zx_type_13{ .count = operand_43, .minimum = operand_44, .empty = operand_45, .name = operand_46, .kind = operand_47, .required = operand_48, .fallback = operand_49, };
                };
            }
        }
    }
}

fn function_13(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_31: {
            const operand_22 = @as(u64, 2);
            const operand_23 = @as(u64, 1);
            const operand_24 = false;
            const operand_25 = @as([]const u8, "name");
            const operand_26 = @as(zx_type_12, .String);
            const operand_27 = true;
            const operand_28 = @as(u64, 0);

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                break :block_30 @as(*const zx_type_13, operand_29);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_21: {
                const operand_12 = @as(u64, 2);
                const operand_13 = @as(u64, 1);
                const operand_14 = false;
                const operand_15 = @as([]const u8, "version");
                const operand_16 = @as(zx_type_12, .Unsigned);
                const operand_17 = true;
                const operand_18 = @as(u64, 0);

                break :block_21 block_20: {
                    const operand_19 = (try (allocator).create(zx_type_13));

                    (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                    break :block_20 @as(*const zx_type_13, operand_19);
                };
            };
        } else {
            return block_11: {
                const operand_2 = @as(u64, 2);
                const operand_3 = @as(u64, 1);
                const operand_4 = false;
                const operand_5 = @as([]const u8, "");
                const operand_6 = @as(zx_type_12, .OptionalString);
                const operand_7 = false;
                const operand_8 = @as(u64, 0);

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create(zx_type_13));
                    (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                    break :block_10 @as(*const zx_type_13, operand_9);
                };
            };
        }
    }
}

fn function_13_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_32 = in;

    if ((switch_32 == @as(u64, 0))) {
        return block_56: {
            const operand_49 = @as(u64, 2);
            const operand_50 = @as(u64, 1);
            const operand_51 = false;
            const operand_52 = @as([]const u8, "name");
            const operand_53 = @as(zx_type_12, .String);
            const operand_54 = true;
            const operand_55 = @as(u64, 0);

            break :block_56 zx_type_13{ .count = operand_49, .minimum = operand_50, .empty = operand_51, .name = operand_52, .kind = operand_53, .required = operand_54, .fallback = operand_55, };
        };
    } else {
        if ((switch_32 == @as(u64, 1))) {
            return block_48: {
                const operand_41 = @as(u64, 2);
                const operand_42 = @as(u64, 1);
                const operand_43 = false;
                const operand_44 = @as([]const u8, "version");
                const operand_45 = @as(zx_type_12, .Unsigned);
                const operand_46 = true;
                const operand_47 = @as(u64, 0);

                break :block_48 zx_type_13{ .count = operand_41, .minimum = operand_42, .empty = operand_43, .name = operand_44, .kind = operand_45, .required = operand_46, .fallback = operand_47, };
            };
        } else {
            return block_40: {
                const operand_33 = @as(u64, 2);
                const operand_34 = @as(u64, 1);
                const operand_35 = false;
                const operand_36 = @as([]const u8, "");
                const operand_37 = @as(zx_type_12, .OptionalString);
                const operand_38 = false;
                const operand_39 = @as(u64, 0);

                break :block_40 zx_type_13{ .count = operand_33, .minimum = operand_34, .empty = operand_35, .name = operand_36, .kind = operand_37, .required = operand_38, .fallback = operand_39, };
            };
        }
    }
}

fn function_14(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_31: {
            const operand_22 = @as(u64, 2);
            const operand_23 = @as(u64, 0);
            const operand_24 = true;
            const operand_25 = @as([]const u8, "from");
            const operand_26 = @as(zx_type_12, .String);
            const operand_27 = true;
            const operand_28 = @as(u64, 0);

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                break :block_30 @as(*const zx_type_13, operand_29);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_21: {
                const operand_12 = @as(u64, 2);
                const operand_13 = @as(u64, 0);
                const operand_14 = true;
                const operand_15 = @as([]const u8, "as");
                const operand_16 = @as(zx_type_12, .OptionalString);
                const operand_17 = false;
                const operand_18 = @as(u64, 0);

                break :block_21 block_20: {
                    const operand_19 = (try (allocator).create(zx_type_13));

                    (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                    break :block_20 @as(*const zx_type_13, operand_19);
                };
            };
        } else {
            return block_11: {
                const operand_2 = @as(u64, 2);
                const operand_3 = @as(u64, 0);
                const operand_4 = true;
                const operand_5 = @as([]const u8, "");
                const operand_6 = @as(zx_type_12, .OptionalString);
                const operand_7 = false;
                const operand_8 = @as(u64, 0);

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create(zx_type_13));
                    (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                    break :block_10 @as(*const zx_type_13, operand_9);
                };
            };
        }
    }
}

fn function_14_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_32 = in;

    if ((switch_32 == @as(u64, 0))) {
        return block_56: {
            const operand_49 = @as(u64, 2);
            const operand_50 = @as(u64, 0);
            const operand_51 = true;
            const operand_52 = @as([]const u8, "from");
            const operand_53 = @as(zx_type_12, .String);
            const operand_54 = true;
            const operand_55 = @as(u64, 0);

            break :block_56 zx_type_13{ .count = operand_49, .minimum = operand_50, .empty = operand_51, .name = operand_52, .kind = operand_53, .required = operand_54, .fallback = operand_55, };
        };
    } else {
        if ((switch_32 == @as(u64, 1))) {
            return block_48: {
                const operand_41 = @as(u64, 2);
                const operand_42 = @as(u64, 0);
                const operand_43 = true;
                const operand_44 = @as([]const u8, "as");
                const operand_45 = @as(zx_type_12, .OptionalString);
                const operand_46 = false;
                const operand_47 = @as(u64, 0);

                break :block_48 zx_type_13{ .count = operand_41, .minimum = operand_42, .empty = operand_43, .name = operand_44, .kind = operand_45, .required = operand_46, .fallback = operand_47, };
            };
        } else {
            return block_40: {
                const operand_33 = @as(u64, 2);
                const operand_34 = @as(u64, 0);
                const operand_35 = true;
                const operand_36 = @as([]const u8, "");
                const operand_37 = @as(zx_type_12, .OptionalString);
                const operand_38 = false;
                const operand_39 = @as(u64, 0);

                break :block_40 zx_type_13{ .count = operand_33, .minimum = operand_34, .empty = operand_35, .name = operand_36, .kind = operand_37, .required = operand_38, .fallback = operand_39, };
            };
        }
    }
}

fn function_15(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_21: {
            const operand_12 = @as(u64, 1);
            const operand_13 = @as(u64, 1);
            const operand_14 = false;
            const operand_15 = @as([]const u8, "on");
            const operand_16 = @as(zx_type_12, .String);
            const operand_17 = true;
            const operand_18 = @as(u64, 0);

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create(zx_type_13));

                (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                break :block_20 @as(*const zx_type_13, operand_19);
            };
        };
    } else {
        return block_11: {
            const operand_2 = @as(u64, 1);
            const operand_3 = @as(u64, 1);
            const operand_4 = false;
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(zx_type_12, .OptionalString);
            const operand_7 = false;
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create(zx_type_13));
                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                break :block_10 @as(*const zx_type_13, operand_9);
            };
        };
    }
}

fn function_15_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_22 = in;

    if ((switch_22 == @as(u64, 0))) {
        return block_38: {
            const operand_31 = @as(u64, 1);
            const operand_32 = @as(u64, 1);
            const operand_33 = false;
            const operand_34 = @as([]const u8, "on");
            const operand_35 = @as(zx_type_12, .String);
            const operand_36 = true;
            const operand_37 = @as(u64, 0);

            break :block_38 zx_type_13{ .count = operand_31, .minimum = operand_32, .empty = operand_33, .name = operand_34, .kind = operand_35, .required = operand_36, .fallback = operand_37, };
        };
    } else {
        return block_30: {
            const operand_23 = @as(u64, 1);
            const operand_24 = @as(u64, 1);
            const operand_25 = false;
            const operand_26 = @as([]const u8, "");
            const operand_27 = @as(zx_type_12, .OptionalString);
            const operand_28 = false;
            const operand_29 = @as(u64, 0);

            break :block_30 zx_type_13{ .count = operand_23, .minimum = operand_24, .empty = operand_25, .name = operand_26, .kind = operand_27, .required = operand_28, .fallback = operand_29, };
        };
    }
}

fn function_16(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const switch_1 = in;

    if ((switch_1 == @as(u64, 0))) {
        return block_31: {
            const operand_22 = @as(u64, 2);
            const operand_23 = @as(u64, 1);
            const operand_24 = false;
            const operand_25 = @as([]const u8, "name");
            const operand_26 = @as(zx_type_12, .String);
            const operand_27 = true;
            const operand_28 = @as(u64, 0);

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .count = operand_22, .minimum = operand_23, .empty = operand_24, .name = operand_25, .kind = operand_26, .required = operand_27, .fallback = operand_28, });

                break :block_30 @as(*const zx_type_13, operand_29);
            };
        };
    } else {
        if ((switch_1 == @as(u64, 1))) {
            return block_21: {
                const operand_12 = @as(u64, 2);
                const operand_13 = @as(u64, 1);
                const operand_14 = false;
                const operand_15 = @as([]const u8, "out");
                const operand_16 = @as(zx_type_12, .OptionalString);
                const operand_17 = false;
                const operand_18 = @as(u64, 0);

                break :block_21 block_20: {
                    const operand_19 = (try (allocator).create(zx_type_13));

                    (operand_19).* = @as(zx_type_13, zx_type_13{ .count = operand_12, .minimum = operand_13, .empty = operand_14, .name = operand_15, .kind = operand_16, .required = operand_17, .fallback = operand_18, });

                    break :block_20 @as(*const zx_type_13, operand_19);
                };
            };
        } else {
            return block_11: {
                const operand_2 = @as(u64, 2);
                const operand_3 = @as(u64, 1);
                const operand_4 = false;
                const operand_5 = @as([]const u8, "");
                const operand_6 = @as(zx_type_12, .OptionalString);
                const operand_7 = false;
                const operand_8 = @as(u64, 0);

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create(zx_type_13));
                    (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                    break :block_10 @as(*const zx_type_13, operand_9);
                };
            };
        }
    }
}

fn function_16_value(allocator: ((std).mem).Allocator, in: u64) error{ OutOfMemory, }!zx_type_13 {
    @setRuntimeSafety(true);

    _ = allocator;

    const switch_32 = in;

    if ((switch_32 == @as(u64, 0))) {
        return block_56: {
            const operand_49 = @as(u64, 2);
            const operand_50 = @as(u64, 1);
            const operand_51 = false;
            const operand_52 = @as([]const u8, "name");
            const operand_53 = @as(zx_type_12, .String);
            const operand_54 = true;
            const operand_55 = @as(u64, 0);

            break :block_56 zx_type_13{ .count = operand_49, .minimum = operand_50, .empty = operand_51, .name = operand_52, .kind = operand_53, .required = operand_54, .fallback = operand_55, };
        };
    } else {
        if ((switch_32 == @as(u64, 1))) {
            return block_48: {
                const operand_41 = @as(u64, 2);
                const operand_42 = @as(u64, 1);
                const operand_43 = false;
                const operand_44 = @as([]const u8, "out");
                const operand_45 = @as(zx_type_12, .OptionalString);
                const operand_46 = false;
                const operand_47 = @as(u64, 0);

                break :block_48 zx_type_13{ .count = operand_41, .minimum = operand_42, .empty = operand_43, .name = operand_44, .kind = operand_45, .required = operand_46, .fallback = operand_47, };
            };
        } else {
            return block_40: {
                const operand_33 = @as(u64, 2);
                const operand_34 = @as(u64, 1);
                const operand_35 = false;
                const operand_36 = @as([]const u8, "");
                const operand_37 = @as(zx_type_12, .OptionalString);
                const operand_38 = false;
                const operand_39 = @as(u64, 0);

                break :block_40 zx_type_13{ .count = operand_33, .minimum = operand_34, .empty = operand_35, .name = operand_36, .kind = operand_37, .required = operand_38, .fallback = operand_39, };
            };
        }
    }
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_14) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const switch_1 = (in).role;

    if ((switch_1 == @as(zx_type_11, .Module))) {
        return (try function_8(allocator, (in).index));
    } else {
        if ((switch_1 == @as(zx_type_11, .Import))) {
            return (try function_7(allocator, (in).index));
        } else {
            if ((switch_1 == @as(zx_type_11, .Call))) {
                return (try function_0(allocator, (in).index));
            } else {
                if ((switch_1 == @as(zx_type_11, .Task))) {
                    return (try function_16(allocator, (in).index));
                } else {
                    if ((switch_1 == @as(zx_type_11, .Parallel))) {
                        return (try function_10(allocator, (in).index));
                    } else {
                        if ((switch_1 == @as(zx_type_11, .Switch))) {
                            return (try function_15(allocator, (in).index));
                        } else {
                            if ((switch_1 == @as(zx_type_11, .Case))) {
                                return (try function_1(allocator, (in).index));
                            } else {
                                if ((switch_1 == @as(zx_type_11, .Default))) {
                                    return (try function_2(allocator, (in).index));
                                } else {
                                    if ((switch_1 == @as(zx_type_11, .Emit))) {
                                        return (try function_3(allocator, (in).index));
                                    } else {
                                        if ((switch_1 == @as(zx_type_11, .Return))) {
                                            return (try function_11(allocator, (in).index));
                                        } else {
                                            if ((switch_1 == @as(zx_type_11, .Gateway))) {
                                                return (try function_5(allocator, (in).index));
                                            } else {
                                                if ((switch_1 == @as(zx_type_11, .Group))) {
                                                    return (try function_6(allocator, (in).index));
                                                } else {
                                                    if ((switch_1 == @as(zx_type_11, .Route))) {
                                                        return (try function_12(allocator, (in).index));
                                                    } else {
                                                        if ((switch_1 == @as(zx_type_11, .Store))) {
                                                            return (try function_13(allocator, (in).index));
                                                        } else {
                                                            if ((switch_1 == @as(zx_type_11, .StoreRef))) {
                                                                return (try function_14(allocator, (in).index));
                                                            } else {
                                                                if ((switch_1 == @as(zx_type_11, .Object))) {
                                                                    return (try function_9(allocator, (in).index));
                                                                } else {
                                                                    if ((switch_1 == @as(zx_type_11, .Field))) {
                                                                        return (try function_4(allocator, (in).index));
                                                                    } else {
                                                                        return block_11: {
                                                                            const operand_2 = @as(u64, 0);
                                                                            const operand_3 = @as(u64, 0);
                                                                            const operand_4 = true;
                                                                            const operand_5 = @as([]const u8, "");
                                                                            const operand_6 = @as(zx_type_12, .OptionalString);
                                                                            const operand_7 = false;
                                                                            const operand_8 = @as(u64, 0);

                                                                            break :block_11 block_10: {
                                                                                const operand_9 = (try (allocator).create(zx_type_13));
                                                                                (operand_9).* = @as(zx_type_13, zx_type_13{ .count = operand_2, .minimum = operand_3, .empty = operand_4, .name = operand_5, .kind = operand_6, .required = operand_7, .fallback = operand_8, });

                                                                                break :block_10 @as(*const zx_type_13, operand_9);
                                                                            };
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

