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
const zx_shape_22 = .{ .kind = .object, .fields = .{ .maximum_count = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .child_end = zx_shape_5, .field_end = zx_shape_5, .index = zx_shape_5, .name_end = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_24 = .{ .kind = .scalar, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .kind = zx_shape_24, .name = zx_shape_10, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .after_underscore = zx_shape_1, .index = zx_shape_5, .kind = zx_shape_24, .name = zx_shape_10, .valid = zx_shape_1, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .ascending = zx_shape_1, .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .object = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .object = zx_shape_1, .owner = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, .values = zx_shape_13, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .values = zx_shape_14, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .valid = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .member = zx_shape_10, .unique = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .scalar_count = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_22, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_22, .@"1" = zx_shape_1, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_22, .@"1" = zx_shape_1, .@"2" = zx_shape_1, }, };
pub const input_shape = zx_shape_22;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_22;
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

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, (((in).table).kinds).len);

    if (((((((((value_1 > (in).maximum_count) or (@as(u64, (((in).table).first).len) != value_1)) or (@as(u64, (((in).table).second).len) != value_1)) or (@as(u64, (((in).table).labels).len) != value_1)) or (@as(u64, (((in).table).field_names).len) != @as(u64, (((in).table).field_types).len))) or (@as(u64, (((in).table).children).len) > (in).maximum_count)) or (@as(u64, (((in).table).field_types).len) > (in).maximum_count)) or (@as(u64, (((in).table).names).len) > (in).maximum_count))) {
        return false;
    }

    const value_62: (zx_abi).zx_type_23 = block_109: {
        const operand_10 = block_9: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = @as(u64, 0);
            const operand_5 = @as(u64, 0);
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_23{ .table = operand_2, .scalar_count = operand_3, .index = operand_4, .child_end = operand_5, .field_end = operand_6, .name_end = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (operand_10).child_end, .field_end = (operand_10).field_end, .index = (operand_10).index, .name_end = (operand_10).name_end, .scalar_count = (operand_10).scalar_count, .table = (operand_10).table, .valid = (operand_10).valid, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).table).kinds).len)))) {
            state_1 = block_106: {
                const value_4: u8 = block_105: {
                    const operand_103 = ((state_1).table).kinds;
                    const operand_104 = (state_1).index;

                    if ((operand_104 >= (operand_103).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_105 (operand_103)[@intCast(operand_104)];
                };
                const value_5: u64 = block_102: {
                    const operand_101 = block_100: {
                        const operand_98 = ((state_1).table).first;
                        const operand_99 = (state_1).index;

                        if ((operand_99 >= (operand_98).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_100 (operand_98)[@intCast(operand_99)];
                    };

                    break :block_102 (try function_0(allocator, operand_101));
                };
                const value_6: u64 = block_97: {
                    const operand_96 = block_95: {
                        const operand_93 = ((state_1).table).second;
                        const operand_94 = (state_1).index;

                        if ((operand_94 >= (operand_93).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_95 (operand_93)[@intCast(operand_94)];
                    };

                    break :block_97 (try function_0(allocator, operand_96));
                };

                const value_7: (zx_abi).zx_type_11 = block_92: {
                    const operand_91 = block_90: {
                        break :block_90 value_4;
                    };

                    break :block_92 (try function_2(allocator, operand_91));
                };

                const value_57: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_14: {
                    break :block_14 value_4;
                } > @as(u8, 8)) or (((block_15: {
                    break :block_15 value_7;
                } != @as((zx_abi).zx_type_11, .Enumeration)) and (block_16: {
                    break :block_16 value_7;
                } != @as((zx_abi).zx_type_11, .NativeReference))) and (!block_22: {
                    const operand_20 = block_19: {
                        const operand_17 = ((state_1).table).labels;
                        const operand_18 = (state_1).index;

                        if ((operand_18 >= (operand_17).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_19 (operand_17)[@intCast(operand_18)];
                    };

                    const operand_21 = @as([]const u8, "");

                    break :block_22 ((std).mem).eql(u8, operand_20, operand_21);
                })))) block_25: {
                    const value_8: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                    _ = (value_8).valid;
                    const value_10: bool = false;

                    const value_11: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_24: {
                        break :block_24 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_8).child_end, .field_end = (value_8).field_end, .index = (value_8).index, .name_end = (value_8).name_end, .scalar_count = (value_8).scalar_count, .table = (value_8).table, .valid = block_23: {
                            break :block_23 value_10;
                        }, });
                    };

                    break :block_25 value_11;
                } else block_89: {
                    const value_56: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_26: {
                        break :block_26 value_7;
                    } == @as((zx_abi).zx_type_11, .Object))) block_38: {
                        const value_12: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                        _ = (value_12).valid;

                        const value_14: bool = (((block_34: {
                            break :block_34 value_5;
                        } == (state_1).field_end) and (block_35: {
                            break :block_35 value_5;
                        } <= @as(u64, (((state_1).table).field_types).len))) and (block_36: {
                            break :block_36 value_6;
                        } <= (@as(u64, (((state_1).table).field_types).len) - block_37: {
                            break :block_37 value_5;
                        })));

                        const value_15: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_33: {
                            break :block_33 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_12).child_end, .field_end = (value_12).field_end, .index = (value_12).index, .name_end = (value_12).name_end, .scalar_count = (value_12).scalar_count, .table = (value_12).table, .valid = block_32: {
                                break :block_32 value_14;
                            }, });
                        };

                        const value_20: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_15).valid) block_31: {
                            const value_16: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_15;
                            const value_17: u64 = (value_16).field_end;

                            const value_18: u64 = block_30: {
                                break :block_30 value_6;
                            };
                            const value_19: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_29: {
                                break :block_29 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_16).child_end, .field_end = (block_27: {
                                    break :block_27 value_17;
                                } + block_28: {
                                    break :block_28 value_18;
                                }), .index = (value_16).index, .name_end = (value_16).name_end, .scalar_count = (value_16).scalar_count, .table = (value_16).table, .valid = (value_16).valid, });
                            };

                            break :block_31 value_19;
                        } else value_15);

                        break :block_38 value_20;
                    } else block_88: {
                        const value_55: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_39: {
                            break :block_39 value_7;
                        } == @as((zx_abi).zx_type_11, .Tuple))) block_51: {
                            const value_21: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                            _ = (value_21).valid;

                            const value_23: bool = (((block_47: {
                                break :block_47 value_5;
                            } == (state_1).child_end) and (block_48: {
                                break :block_48 value_5;
                            } <= @as(u64, (((state_1).table).children).len))) and (block_49: {
                                break :block_49 value_6;
                            } <= (@as(u64, (((state_1).table).children).len) - block_50: {
                                break :block_50 value_5;
                            })));

                            const value_24: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_46: {
                                break :block_46 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_21).child_end, .field_end = (value_21).field_end, .index = (value_21).index, .name_end = (value_21).name_end, .scalar_count = (value_21).scalar_count, .table = (value_21).table, .valid = block_45: {
                                    break :block_45 value_23;
                                }, });
                            };
                            const value_29: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_24).valid) block_44: {
                                const value_25: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_24;
                                const value_26: u64 = (value_25).child_end;
                                const value_27: u64 = block_43: {
                                    break :block_43 value_6;
                                };
                                const value_28: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_42: {
                                    break :block_42 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (block_40: {
                                        break :block_40 value_26;
                                    } + block_41: {
                                        break :block_41 value_27;
                                    }), .field_end = (value_25).field_end, .index = (value_25).index, .name_end = (value_25).name_end, .scalar_count = (value_25).scalar_count, .table = (value_25).table, .valid = (value_25).valid, });
                                };

                                break :block_44 value_28;
                            } else value_24);

                            break :block_51 value_29;
                        } else block_87: {
                            const value_54: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_52: {
                                break :block_52 value_7;
                            } == @as((zx_abi).zx_type_11, .Enumeration)) or (block_53: {
                                break :block_53 value_7;
                            } == @as((zx_abi).zx_type_11, .ErrorSet)))) block_65: {
                                const value_30: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                                _ = (value_30).valid;

                                const value_32: bool = (((block_61: {
                                    break :block_61 value_5;
                                } == (state_1).name_end) and (block_62: {
                                    break :block_62 value_5;
                                } <= @as(u64, (((state_1).table).names).len))) and (block_63: {
                                    break :block_63 value_6;
                                } <= (@as(u64, (((state_1).table).names).len) - block_64: {
                                    break :block_64 value_5;
                                })));

                                const value_33: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_60: {
                                    break :block_60 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_30).child_end, .field_end = (value_30).field_end, .index = (value_30).index, .name_end = (value_30).name_end, .scalar_count = (value_30).scalar_count, .table = (value_30).table, .valid = block_59: {
                                        break :block_59 value_32;
                                    }, });
                                };
                                const value_38: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((value_33).valid) block_58: {
                                    const value_34: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_33;
                                    const value_35: u64 = (value_34).name_end;
                                    const value_36: u64 = block_57: {
                                        break :block_57 value_6;
                                    };
                                    const value_37: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_56: {
                                        break :block_56 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_34).child_end, .field_end = (value_34).field_end, .index = (value_34).index, .name_end = (block_54: {
                                            break :block_54 value_35;
                                        } + block_55: {
                                            break :block_55 value_36;
                                        }), .scalar_count = (value_34).scalar_count, .table = (value_34).table, .valid = (value_34).valid, });
                                    };

                                    break :block_58 value_37;
                                } else value_33);

                                break :block_65 value_38;
                            } else block_86: {
                                const value_53: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_66: {
                                    break :block_66 value_7;
                                } == @as((zx_abi).zx_type_11, .Scalar))) block_71: {
                                    const value_39: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                                    _ = (value_39).valid;

                                    const value_41: bool = ((block_69: {
                                        break :block_69 value_5;
                                    } < (state_1).scalar_count) and (block_70: {
                                        break :block_70 value_6;
                                    } == @as(u64, 0)));

                                    const value_42: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_68: {
                                        break :block_68 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_39).child_end, .field_end = (value_39).field_end, .index = (value_39).index, .name_end = (value_39).name_end, .scalar_count = (value_39).scalar_count, .table = (value_39).table, .valid = block_67: {
                                            break :block_67 value_41;
                                        }, });
                                    };

                                    break :block_71 value_42;
                                } else block_85: {
                                    const value_52: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((block_72: {
                                        break :block_72 value_7;
                                    } == @as((zx_abi).zx_type_11, .Optional)) or (block_73: {
                                        break :block_73 value_7;
                                    } == @as((zx_abi).zx_type_11, .List)))) block_77: {
                                        const value_43: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                                        _ = (value_43).valid;

                                        const value_45: bool = (block_76: {
                                            break :block_76 value_6;
                                        } == @as(u64, 0));
                                        const value_46: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_75: {
                                            break :block_75 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_43).child_end, .field_end = (value_43).field_end, .index = (value_43).index, .name_end = (value_43).name_end, .scalar_count = (value_43).scalar_count, .table = (value_43).table, .valid = block_74: {
                                                break :block_74 value_45;
                                            }, });
                                        };

                                        break :block_77 value_46;
                                    } else block_84: {
                                        const value_51: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_78: {
                                            break :block_78 value_7;
                                        } == @as((zx_abi).zx_type_11, .NativeReference))) block_83: {
                                            const value_47: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                                            _ = (value_47).valid;

                                            const value_49: bool = ((block_81: {
                                                break :block_81 value_5;
                                            } == @as(u64, 0)) and (block_82: {
                                                break :block_82 value_6;
                                            } == @as(u64, 0)));

                                            const value_50: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_80: {
                                                break :block_80 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_47).child_end, .field_end = (value_47).field_end, .index = (value_47).index, .name_end = (value_47).name_end, .scalar_count = (value_47).scalar_count, .table = (value_47).table, .valid = block_79: {
                                                    break :block_79 value_49;
                                                }, });
                                            };

                                            break :block_83 value_50;
                                        } else state_1);

                                        break :block_84 value_51;
                                    });

                                    break :block_85 value_52;
                                });

                                break :block_86 value_53;
                            });

                            break :block_87 value_54;
                        });

                        break :block_88 value_55;
                    });

                    break :block_89 value_56;
                });

                const value_58: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_57;
                const value_59: u64 = (value_58).index;
                const value_60: u64 = @as(u64, 1);

                const value_61: (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .child_end = (value_58).child_end, .field_end = (value_58).field_end, .index = (block_11: {
                        break :block_11 value_59;
                    } + block_12: {
                        break :block_12 value_60;
                    }), .name_end = (value_58).name_end, .scalar_count = (value_58).scalar_count, .table = (value_58).table, .valid = (value_58).valid, });
                };

                break :block_106 value_61;
            };
        }

        break :block_109 block_108: {
            break :block_108 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_107: {
                break :block_107 (zx_abi).zx_type_23{ .child_end = (state_1).child_end, .field_end = (state_1).field_end, .index = (state_1).index, .name_end = (state_1).name_end, .scalar_count = (state_1).scalar_count, .table = (state_1).table, .valid = (state_1).valid, };
            });
        };
    };

    return (((((&value_62)).valid and (((&value_62)).child_end == @as(u64, (((in).table).children).len))) and (((&value_62)).field_end == @as(u64, (((in).table).field_types).len))) and (((&value_62)).name_end == @as(u64, (((in).table).names).len)));
}

fn function_4(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    if ((@as(u64, ((in).name).len) == @as(u64, 0))) {
        return false;
    }

    const value_1: u8 = block_42: {
        const operand_40 = (in).name;
        const operand_41 = @as(u64, 0);

        if ((operand_41 >= (operand_40).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_42 (operand_40)[@intCast(operand_41)];
    };

    const value_2: bool = (if (((in).kind == @as((zx_abi).zx_type_24, .TypeDecl))) ((value_1 >= @as(u8, 65)) and (value_1 <= @as(u8, 90))) else ((value_1 >= @as(u8, 97)) and (value_1 <= @as(u8, 122))));

    if ((!value_2)) {
        return false;
    }

    const value_30: (zx_abi).zx_type_26 = block_39: {
        const operand_8 = block_7: {
            const operand_2 = (in).name;
            const operand_3 = (in).kind;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;
            const operand_6 = true;

            break :block_7 (zx_abi).zx_type_26{ .name = operand_2, .kind = operand_3, .index = operand_4, .after_underscore = operand_5, .valid = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (operand_8).after_underscore, .index = (operand_8).index, .kind = (operand_8).kind, .name = (operand_8).name, .valid = (operand_8).valid, .zx_origin = (&operand_8), };

        while (((state_1).valid and ((state_1).index < @as(u64, ((state_1).name).len)))) {
            state_1 = block_36: {
                const value_5: u8 = block_35: {
                    const operand_33 = (state_1).name;
                    const operand_34 = (state_1).index;

                    if ((operand_34 >= (operand_33).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_35 (operand_33)[@intCast(operand_34)];
                };

                const value_6: bool = ((block_31: {
                    break :block_31 value_5;
                } >= @as(u8, 65)) and (block_32: {
                    break :block_32 value_5;
                } <= @as(u8, 90)));

                const value_7: bool = ((block_29: {
                    break :block_29 value_5;
                } >= @as(u8, 97)) and (block_30: {
                    break :block_30 value_5;
                } <= @as(u8, 122)));

                const value_8: bool = ((block_27: {
                    break :block_27 value_5;
                } >= @as(u8, 48)) and (block_28: {
                    break :block_28 value_5;
                } <= @as(u8, 57)));

                const value_25: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((((state_1).kind == @as((zx_abi).zx_type_24, .Value)) and (block_12: {
                    break :block_12 value_5;
                } == @as(u8, 95)))) block_17: {
                    const value_9: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                    _ = (value_9).valid;

                    const value_11: bool = (!(state_1).after_underscore);

                    const value_12: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                        break :block_16 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_9).after_underscore, .index = (value_9).index, .kind = (value_9).kind, .name = (value_9).name, .valid = block_15: {
                            break :block_15 value_11;
                        }, });
                    };
                    const value_13: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                    _ = (value_13).after_underscore;
                    const value_15: bool = true;

                    const value_16: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_14: {
                        break :block_14 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = block_13: {
                            break :block_13 value_15;
                        }, .index = (value_13).index, .kind = (value_13).kind, .name = (value_13).name, .valid = (value_13).valid, });
                    };

                    break :block_17 value_16;
                } else block_26: {
                    const value_17: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;
                    _ = (value_17).valid;

                    const value_19: bool = (((block_22: {
                        break :block_22 value_6;
                    } or block_23: {
                        break :block_23 value_7;
                    }) or block_24: {
                        break :block_24 value_8;
                    }) and (((state_1).kind != @as((zx_abi).zx_type_24, .Value)) or (!block_25: {
                        break :block_25 value_6;
                    })));

                    const value_20: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_21: {
                        break :block_21 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_17).after_underscore, .index = (value_17).index, .kind = (value_17).kind, .name = (value_17).name, .valid = block_20: {
                            break :block_20 value_19;
                        }, });
                    };
                    const value_21: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_20;

                    _ = (value_21).after_underscore;
                    const value_23: bool = false;

                    const value_24: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_19: {
                        break :block_19 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = block_18: {
                            break :block_18 value_23;
                        }, .index = (value_21).index, .kind = (value_21).kind, .name = (value_21).name, .valid = (value_21).valid, });
                    };

                    break :block_26 value_24;
                });

                const value_26: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_25;
                const value_27: u64 = (value_26).index;
                const value_28: u64 = @as(u64, 1);

                const value_29: (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_11: {
                    break :block_11 @as((zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_26).after_underscore, .index = (block_9: {
                        break :block_9 value_27;
                    } + block_10: {
                        break :block_10 value_28;
                    }), .kind = (value_26).kind, .name = (value_26).name, .valid = (value_26).valid, });
                };

                break :block_36 value_29;
            };
        }

        break :block_39 block_38: {
            break :block_38 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_37: {
                break :block_37 (zx_abi).zx_type_26{ .after_underscore = (state_1).after_underscore, .index = (state_1).index, .kind = (state_1).kind, .name = (state_1).name, .valid = (state_1).valid, };
            });
        };
    };

    return (((&value_30)).valid and (!((&value_30)).after_underscore));
}

fn function_7(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_17: (zx_abi).zx_type_28 = block_29: {
        const operand_8 = block_7: {
            const operand_2 = (in).left;
            const operand_3 = (in).right;
            const operand_4 = @as(u64, 0);
            const operand_5 = true;
            const operand_6 = false;

            break :block_7 (zx_abi).zx_type_28{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, .ascending = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (operand_8).ascending, .equal = (operand_8).equal, .index = (operand_8).index, .left = (operand_8).left, .right = (operand_8).right, .zx_origin = (&operand_8), };

        while ((((state_1).equal and ((state_1).index < @as(u64, ((state_1).left).len))) and ((state_1).index < @as(u64, ((state_1).right).len)))) {
            state_1 = block_26: {
                const value_3: u8 = block_25: {
                    const operand_23 = (state_1).left;
                    const operand_24 = (state_1).index;

                    if ((operand_24 >= (operand_23).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_25 (operand_23)[@intCast(operand_24)];
                };
                const value_4: u8 = block_22: {
                    const operand_20 = (state_1).right;
                    const operand_21 = (state_1).index;

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };

                const value_5: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;

                _ = (value_5).equal;

                const value_7: bool = (block_18: {
                    break :block_18 value_3;
                } == block_19: {
                    break :block_19 value_4;
                });

                const value_8: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_17: {
                    break :block_17 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (value_5).ascending, .equal = block_16: {
                        break :block_16 value_7;
                    }, .index = (value_5).index, .left = (value_5).left, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;

                _ = (value_9).ascending;

                const value_11: bool = (block_14: {
                    break :block_14 value_3;
                } < block_15: {
                    break :block_15 value_4;
                });

                const value_12: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = block_12: {
                        break :block_12 value_11;
                    }, .equal = (value_9).equal, .index = (value_9).index, .left = (value_9).left, .right = (value_9).right, });
                };
                const value_13: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;
                const value_14: u64 = (value_13).index;
                const value_15: u64 = @as(u64, 1);

                const value_16: (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_11: {
                    break :block_11 @as((zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .ascending = (value_13).ascending, .equal = (value_13).equal, .index = (block_9: {
                        break :block_9 value_14;
                    } + block_10: {
                        break :block_10 value_15;
                    }), .left = (value_13).left, .right = (value_13).right, });
                };

                break :block_26 value_16;
            };
        }

        break :block_29 block_28: {
            break :block_28 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_27: {
                break :block_27 (zx_abi).zx_type_28{ .ascending = (state_1).ascending, .equal = (state_1).equal, .index = (state_1).index, .left = (state_1).left, .right = (state_1).right, };
            });
        };
    };

    return (if (((&value_17)).equal) (@as(u64, ((in).left).len) < @as(u64, ((in).right).len)) else ((&value_17)).ascending);
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: []const u32 = (if ((in).object) ((in).table).field_types else ((in).table).children);

    const value_19: (zx_abi).zx_type_30 = block_56: {
        const operand_11 = block_10: {
            const operand_2 = (in).table;
            const operand_3 = value_1;
            const operand_4 = (in).index;
            const operand_5 = (in).first;
            const operand_6 = (in).count;
            const operand_7 = (in).object;
            const operand_8 = @as(u64, 0);
            const operand_9 = true;

            break :block_10 (zx_abi).zx_type_30{ .table = operand_2, .values = operand_3, .owner = operand_4, .first = operand_5, .count = operand_6, .object = operand_7, .index = operand_8, .valid = operand_9, };
        };

        var state_1: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (operand_11).count, .first = (operand_11).first, .index = (operand_11).index, .object = (operand_11).object, .owner = (operand_11).owner, .table = (operand_11).table, .valid = (operand_11).valid, .values = (operand_11).values, .zx_origin = (&operand_11), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_53: {
                const value_4: u64 = ((state_1).first + (state_1).index);

                const value_5: u64 = block_52: {
                    const operand_51 = block_50: {
                        const operand_48 = (state_1).values;

                        const operand_49 = block_47: {
                            break :block_47 value_4;
                        };

                        if ((operand_49 >= (operand_48).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_50 (operand_48)[@intCast(operand_49)];
                    };

                    break :block_52 (try function_4(allocator, operand_51));
                };

                const value_6: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = state_1;

                _ = (value_6).valid;

                const value_8: bool = ((block_40: {
                    break :block_40 value_5;
                } < (state_1).owner) and (block_46: {
                    const operand_45 = block_44: {
                        const operand_42 = ((state_1).table).kinds;

                        const operand_43 = block_41: {
                            break :block_41 value_5;
                        };

                        if ((operand_43 >= (operand_42).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_44 (operand_42)[@intCast(operand_43)];
                    };

                    break :block_46 (try function_7(allocator, operand_45));
                } != @as((zx_abi).zx_type_11, .Task)));

                const value_9: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_39: {
                    break :block_39 @as((zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_6).count, .first = (value_6).first, .index = (value_6).index, .object = (value_6).object, .owner = (value_6).owner, .table = (value_6).table, .valid = block_38: {
                        break :block_38 value_8;
                    }, .values = (value_6).values, });
                };

                const value_14: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if (((value_9).valid and (value_9).object)) block_37: {
                    const value_10: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = value_9;
                    _ = (value_10).valid;

                    const value_12: bool = (((block_17: {
                        break :block_17 value_5;
                    } != @as(u64, 0)) and (!block_24: {
                        const operand_22 = block_21: {
                            const operand_19 = ((value_9).table).field_names;

                            const operand_20 = block_18: {
                                break :block_18 value_4;
                            };

                            if ((operand_20 >= (operand_19).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_21 (operand_19)[@intCast(operand_20)];
                        };
                        const operand_23 = @as([]const u8, "");

                        break :block_24 ((std).mem).eql(u8, operand_22, operand_23);
                    })) and (((value_9).index == @as(u64, 0)) or block_36: {
                        const operand_29 = block_28: {
                            const operand_26 = ((value_9).table).field_names;

                            const operand_27 = (block_25: {
                                break :block_25 value_4;
                            } - @as(u64, 1));

                            if ((operand_27 >= (operand_26).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_28 (operand_26)[@intCast(operand_27)];
                        };
                        const operand_34 = block_33: {
                            const operand_31 = ((value_9).table).field_names;

                            const operand_32 = block_30: {
                                break :block_30 value_4;
                            };

                            if ((operand_32 >= (operand_31).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_33 (operand_31)[@intCast(operand_32)];
                        };

                        const operand_35 = (zx_abi).zx_type_27{ .left = operand_29, .right = operand_34, };

                        break :block_36 (try function_8(allocator, (&operand_35)));
                    }));

                    const value_13: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_16: {
                        break :block_16 @as((zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_10).count, .first = (value_10).first, .index = (value_10).index, .object = (value_10).object, .owner = (value_10).owner, .table = (value_10).table, .valid = block_15: {
                            break :block_15 value_12;
                        }, .values = (value_10).values, });
                    };

                    break :block_37 value_13;
                } else value_9);

                const value_15: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = value_14;
                const value_16: u64 = (value_15).index;
                const value_17: u64 = @as(u64, 1);

                const value_18: (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_30_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .count = (value_15).count, .first = (value_15).first, .index = (block_12: {
                        break :block_12 value_16;
                    } + block_13: {
                        break :block_13 value_17;
                    }), .object = (value_15).object, .owner = (value_15).owner, .table = (value_15).table, .valid = (value_15).valid, .values = (value_15).values, });
                };

                break :block_53 value_18;
            };
        }

        break :block_56 block_55: {
            break :block_55 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_54: {
                break :block_54 (zx_abi).zx_type_30{ .count = (state_1).count, .first = (state_1).first, .index = (state_1).index, .object = (state_1).object, .owner = (state_1).owner, .table = (state_1).table, .valid = (state_1).valid, .values = (state_1).values, };
            });
        };
    };

    return ((&value_19)).valid;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_34: (zx_abi).zx_type_32 = block_73: {
        const operand_9 = block_8: {
            const operand_2 = (in).values;
            const operand_3 = (in).first;
            const operand_4 = (in).count;
            const operand_5 = (in).errors;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_32{ .values = operand_2, .first = operand_3, .count = operand_4, .errors = operand_5, .index = operand_6, .valid = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (operand_9).count, .errors = (operand_9).errors, .first = (operand_9).first, .index = (operand_9).index, .valid = (operand_9).valid, .values = (operand_9).values, .zx_origin = (&operand_9), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_70: {
                const value_3: u64 = ((state_1).first + (state_1).index);

                const value_4: []const u8 = block_69: {
                    const operand_67 = (state_1).values;

                    const operand_68 = block_66: {
                        break :block_66 value_3;
                    };

                    if ((operand_68 >= (operand_67).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_69 (operand_67)[@intCast(operand_68)];
                };
                const value_29: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if ((state_1).errors) block_29: {
                    const value_5: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;
                    _ = (value_5).valid;

                    const value_7: bool = (block_19: {
                        const operand_16 = block_15: {
                            break :block_15 value_4;
                        };

                        const operand_17 = @as((zx_abi).zx_type_24, .TypeDecl);
                        const operand_18 = (zx_abi).zx_type_25{ .name = operand_16, .kind = operand_17, };

                        break :block_19 (try function_6(allocator, (&operand_18)));
                    } and (((state_1).index == @as(u64, 0)) or block_28: {
                        const operand_24 = block_23: {
                            const operand_21 = (state_1).values;

                            const operand_22 = (block_20: {
                                break :block_20 value_3;
                            } - @as(u64, 1));

                            if ((operand_22 >= (operand_21).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_23 (operand_21)[@intCast(operand_22)];
                        };
                        const operand_26 = block_25: {
                            break :block_25 value_4;
                        };

                        const operand_27 = (zx_abi).zx_type_27{ .left = operand_24, .right = operand_26, };

                        break :block_28 (try function_8(allocator, (&operand_27)));
                    }));

                    const value_8: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                        break :block_14 @as((zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_5).count, .errors = (value_5).errors, .first = (value_5).first, .index = (value_5).index, .valid = block_13: {
                            break :block_13 value_7;
                        }, .values = (value_5).values, });
                    };

                    break :block_29 value_8;
                } else block_65: {
                    const value_28: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_33: {
                        const operand_31 = block_30: {
                            break :block_30 value_4;
                        };

                        const operand_32 = @as([]const u8, "");

                        break :block_33 ((std).mem).eql(u8, operand_31, operand_32);
                    }) block_36: {
                        const value_9: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;
                        _ = (value_9).valid;
                        const value_11: bool = false;

                        const value_12: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_35: {
                            break :block_35 @as((zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_9).count, .errors = (value_9).errors, .first = (value_9).first, .index = (value_9).index, .valid = block_34: {
                                break :block_34 value_11;
                            }, .values = (value_9).values, });
                        };

                        break :block_36 value_12;
                    } else block_64: {
                        const value_23: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_63: {
                            const operand_48 = block_47: {
                                const operand_40 = (state_1).values;
                                const operand_41 = (state_1).first;
                                const operand_42 = (state_1).index;
                                const operand_43 = block_44: {
                                    break :block_44 value_4;
                                };
                                const operand_45 = @as(u64, 0);
                                const operand_46 = true;

                                break :block_47 @as((zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .values = operand_40, .first = operand_41, .count = operand_42, .member = operand_43, .index = operand_45, .unique = operand_46, });
                            };
                            var state_39: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_48;
                            var state_changed_49 = false;

                            while (((state_39).unique and ((state_39).index < (state_39).count))) {
                                state_39 = block_61: {
                                    const value_15: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_39;
                                    _ = (value_15).unique;

                                    const value_17: bool = (!block_60: {
                                        const operand_58 = block_57: {
                                            const operand_55 = (state_39).values;
                                            const operand_56 = ((state_39).first + (state_39).index);

                                            if ((operand_56 >= (operand_55).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_57 (operand_55)[@intCast(operand_56)];
                                        };
                                        const operand_59 = (state_39).member;

                                        break :block_60 ((std).mem).eql(u8, operand_58, operand_59);
                                    });
                                    const value_18: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_54: {
                                        break :block_54 @as((zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_15).count, .first = (value_15).first, .index = (value_15).index, .member = (value_15).member, .unique = block_53: {
                                            break :block_53 value_17;
                                        }, .values = (value_15).values, });
                                    };
                                    const value_19: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_18;
                                    const value_20: u64 = (value_19).index;
                                    const value_21: u64 = @as(u64, 1);
                                    const value_22: (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_52: {
                                        break :block_52 @as((zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_33_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_19).count, .first = (value_19).first, .index = (block_50: {
                                            break :block_50 value_20;
                                        } + block_51: {
                                            break :block_51 value_21;
                                        }), .member = (value_19).member, .unique = (value_19).unique, .values = (value_19).values, });
                                    };

                                    break :block_61 value_22;
                                };

                                state_changed_49 = true;
                            }

                            break :block_63 (if (state_changed_49) state_39 else operand_48);
                        };
                        const value_24: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;

                        _ = (value_24).valid;
                        const value_26: bool = (value_23).unique;

                        const value_27: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_38: {
                            break :block_38 @as((zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_24).count, .errors = (value_24).errors, .first = (value_24).first, .index = (value_24).index, .valid = block_37: {
                                break :block_37 value_26;
                            }, .values = (value_24).values, });
                        };

                        break :block_64 value_27;
                    });

                    break :block_65 value_28;
                });

                const value_30: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_29;
                const value_31: u64 = (value_30).index;
                const value_32: u64 = @as(u64, 1);

                const value_33: (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_32_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_30).count, .errors = (value_30).errors, .first = (value_30).first, .index = (block_10: {
                        break :block_10 value_31;
                    } + block_11: {
                        break :block_11 value_32;
                    }), .valid = (value_30).valid, .values = (value_30).values, });
                };

                break :block_70 value_33;
            };
        }

        break :block_73 block_72: {
            break :block_72 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_71: {
                break :block_71 (zx_abi).zx_type_32{ .count = (state_1).count, .errors = (state_1).errors, .first = (state_1).first, .index = (state_1).index, .valid = (state_1).valid, .values = (state_1).values, };
            });
        };
    };

    return ((&value_34)).valid;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_11 = (try function_7(allocator, block_44: {
        const operand_42 = ((in).table).kinds;
        const operand_43 = (in).index;

        if ((operand_43 >= (operand_42).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_44 (operand_42)[@intCast(operand_43)];
    }));

    const value_2: u64 = (try function_4(allocator, block_41: {
        const operand_39 = ((in).table).first;
        const operand_40 = (in).index;

        if ((operand_40 >= (operand_39).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_41 (operand_39)[@intCast(operand_40)];
    }));

    const value_3: u64 = (try function_4(allocator, block_38: {
        const operand_36 = ((in).table).second;
        const operand_37 = (in).index;

        if ((operand_37 >= (operand_36).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_38 (operand_36)[@intCast(operand_37)];
    }));

    if (((in).index < (in).scalar_count)) {
        return ((value_1 == @as((zx_abi).zx_type_11, .Scalar)) and (value_2 == (in).index));
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .Scalar))) {
        return false;
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .NativeReference))) {
        return block_35: {
            const operand_32 = block_31: {
                const operand_29 = ((in).table).labels;
                const operand_30 = (in).index;

                if ((operand_30 >= (operand_29).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_31 (operand_29)[@intCast(operand_30)];
            };

            const operand_33 = @as((zx_abi).zx_type_24, .TypeDecl);
            const operand_34 = (zx_abi).zx_type_25{ .name = operand_32, .kind = operand_33, };

            break :block_35 (try function_6(allocator, (&operand_34)));
        };
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .Task))) {
        return ((((value_2 < (in).index) and (value_3 < (in).index)) and ((try function_7(allocator, block_25: {
            const operand_23 = ((in).table).kinds;
            const operand_24 = value_2;

            if ((operand_24 >= (operand_23).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_25 (operand_23)[@intCast(operand_24)];
        })) != @as((zx_abi).zx_type_11, .Task))) and ((try function_7(allocator, block_28: {
            const operand_26 = ((in).table).kinds;
            const operand_27 = value_3;

            if ((operand_27 >= (operand_26).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_28 (operand_26)[@intCast(operand_27)];
        })) == @as((zx_abi).zx_type_11, .ErrorSet)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Optional)) or (value_1 == @as((zx_abi).zx_type_11, .List)))) {
        return (((value_2 < (in).index) and ((value_1 != @as((zx_abi).zx_type_11, .List)) or (value_2 != @as(u64, 0)))) and ((try function_7(allocator, block_22: {
            const operand_20 = ((in).table).kinds;
            const operand_21 = value_2;

            if ((operand_21 >= (operand_20).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_22 (operand_20)[@intCast(operand_21)];
        })) != @as((zx_abi).zx_type_11, .Task)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Tuple)) or (value_1 == @as((zx_abi).zx_type_11, .Object)))) {
        return block_19: {
            const operand_13 = (in).table;
            const operand_14 = (in).index;
            const operand_15 = value_2;
            const operand_16 = value_3;
            const operand_17 = (value_1 == @as((zx_abi).zx_type_11, .Object));
            const operand_18 = (zx_abi).zx_type_29{ .table = operand_13, .index = operand_14, .first = operand_15, .count = operand_16, .object = operand_17, };

            break :block_19 (try function_9(allocator, (&operand_18)));
        };
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Enumeration)) and (block_12: {
        const operand_10 = block_9: {
            const operand_7 = ((in).table).labels;
            const operand_8 = (in).index;

            if ((operand_8 >= (operand_7).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_9 (operand_7)[@intCast(operand_8)];
        };

        const operand_11 = @as([]const u8, "");

        break :block_12 ((std).mem).eql(u8, operand_10, operand_11);
    } or (value_3 == @as(u64, 0))))) {
        return false;
    }

    return block_6: {
        const operand_1 = ((in).table).names;
        const operand_2 = value_2;
        const operand_3 = value_3;
        const operand_4 = (value_1 == @as((zx_abi).zx_type_11, .ErrorSet));
        const operand_5 = (zx_abi).zx_type_31{ .values = operand_1, .first = operand_2, .count = operand_3, .errors = operand_4, };

        break :block_6 (try function_10(allocator, (&operand_5)));
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    if ((@as(u64, (((in).table).kinds).len) < (in).scalar_count)) {
        return false;
    }

    const value_11: (zx_abi).zx_type_36 = block_21: {
        const operand_7 = block_6: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_36{ .table = operand_2, .scalar_count = operand_3, .index = operand_4, .valid = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_7).index, .scalar_count = (operand_7).scalar_count, .table = (operand_7).table, .valid = (operand_7).valid, .zx_origin = (&operand_7), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).table).kinds).len)))) {
            state_1 = block_18: {
                const value_3: (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;
                _ = (value_3).valid;

                const value_5: bool = block_17: {
                    const operand_13 = (state_1).table;
                    const operand_14 = (state_1).index;
                    const operand_15 = (state_1).scalar_count;
                    const operand_16 = (zx_abi).zx_type_34{ .table = operand_13, .index = operand_14, .scalar_count = operand_15, };

                    break :block_17 (try function_11(allocator, (&operand_16)));
                };

                const value_6: (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_3).index, .scalar_count = (value_3).scalar_count, .table = (value_3).table, .valid = block_11: {
                        break :block_11 value_5;
                    }, });
                };

                const value_7: (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_6;
                const value_8: u64 = (value_7).index;
                const value_9: u64 = @as(u64, 1);

                const value_10: (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_8: {
                        break :block_8 value_8;
                    } + block_9: {
                        break :block_9 value_9;
                    }), .scalar_count = (value_7).scalar_count, .table = (value_7).table, .valid = (value_7).valid, });
                };

                break :block_18 value_10;
            };
        }

        break :block_21 block_20: {
            break :block_20 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_19: {
                break :block_19 (zx_abi).zx_type_36{ .index = (state_1).index, .scalar_count = (state_1).scalar_count, .table = (state_1).table, .valid = (state_1).valid, };
            });
        };
    };

    return ((&value_11)).valid;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: bool = block_10: {
        const operand_6 = (in).table;
        const operand_7 = (in).scalar_count;
        const operand_8 = (in).maximum_count;
        const operand_9 = (zx_abi).zx_type_22{ .table = operand_6, .scalar_count = operand_7, .maximum_count = operand_8, };

        break :block_10 (try function_3(allocator, (&operand_9)));
    };

    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: bool = block_5: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = (zx_abi).zx_type_35{ .table = operand_2, .scalar_count = operand_3, };

            break :block_5 (try function_12(allocator, (&operand_4)));
        };

        return value_2;
    } else {
        return false;
    }
}
