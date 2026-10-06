const std = @import("std");
const zx_native_0 = @import("integers");
const zx_native_1 = @import("type_names");
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
const zx_shape_24 = .{ .kind = .native_reference, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_24, .@"1" = zx_shape_5, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_24, .@"1" = zx_shape_5, .@"2" = zx_shape_5, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .names = zx_shape_24, .object = zx_shape_1, .table = zx_shape_15, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .names = zx_shape_24, .object = zx_shape_1, .owner = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, .values = zx_shape_13, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .names = zx_shape_24, .values = zx_shape_14, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .errors = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .names = zx_shape_24, .valid = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .index = zx_shape_5, .member = zx_shape_10, .unique = zx_shape_1, .values = zx_shape_14, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_24, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .names = zx_shape_24, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .names = zx_shape_24, .scalar_count = zx_shape_5, .table = zx_shape_15, .valid = zx_shape_1, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .maximum_count = zx_shape_5, .names = zx_shape_24, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_35, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_35, .@"1" = zx_shape_1, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_35, .@"1" = zx_shape_1, .@"2" = zx_shape_1, }, };
pub const input_shape = zx_shape_35;
pub const output_shape = zx_shape_1;
pub const Input = *const (zx_abi).zx_type_35;
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

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ }!bool {
    const native_result = (zx_native_1).validLabel((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) error{ }!bool {
    const native_result = (zx_native_1).validMember((in).@"0", (in).@"1");

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{ }!bool {
    const native_result = (zx_native_1).fieldsAscending((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{ }!bool {
    const native_result = (zx_native_1).membersAscending((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: []const u32 = (if ((in).object) ((in).table).field_types else ((in).table).children);

    const value_19: (zx_abi).zx_type_28 = block_53: {
        const operand_12 = block_11: {
            const operand_2 = (in).table;
            const operand_3 = value_1;
            const operand_4 = (in).index;
            const operand_5 = (in).first;
            const operand_6 = (in).count;
            const operand_7 = (in).object;
            const operand_8 = (in).names;
            const operand_9 = @as(u64, 0);
            const operand_10 = true;

            break :block_11 (zx_abi).zx_type_28{ .table = operand_2, .values = operand_3, .owner = operand_4, .first = operand_5, .count = operand_6, .object = operand_7, .names = operand_8, .index = operand_9, .valid = operand_10, };
        };

        var state_1: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83{ .count = (operand_12).count, .first = (operand_12).first, .index = (operand_12).index, .names = (operand_12).names, .object = (operand_12).object, .owner = (operand_12).owner, .table = (operand_12).table, .valid = (operand_12).valid, .values = (operand_12).values, .zx_origin = (&operand_12), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_50: {
                const value_4: u64 = ((state_1).first + (state_1).index);

                const value_5: u64 = block_49: {
                    const operand_48 = block_47: {
                        const operand_45 = (state_1).values;

                        const operand_46 = block_44: {
                            break :block_44 value_4;
                        };

                        if ((operand_46 >= (operand_45).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_47 (operand_45)[@intCast(operand_46)];
                    };

                    break :block_49 (try function_4(allocator, operand_48));
                };

                const value_6: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = state_1;

                _ = (value_6).valid;

                const value_8: bool = ((block_37: {
                    break :block_37 value_5;
                } < (state_1).owner) and (block_43: {
                    const operand_42 = block_41: {
                        const operand_39 = ((state_1).table).kinds;

                        const operand_40 = block_38: {
                            break :block_38 value_5;
                        };

                        if ((operand_40 >= (operand_39).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_41 (operand_39)[@intCast(operand_40)];
                    };

                    break :block_43 (try function_10(allocator, operand_42));
                } != @as((zx_abi).zx_type_11, .Task)));

                const value_9: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = block_36: {
                    break :block_36 @as((zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83, (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83{ .count = (value_6).count, .first = (value_6).first, .index = (value_6).index, .names = (value_6).names, .object = (value_6).object, .owner = (value_6).owner, .table = (value_6).table, .valid = block_35: {
                        break :block_35 value_8;
                    }, .values = (value_6).values, });
                };

                const value_14: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = (if (((value_9).valid and (value_9).object)) block_34: {
                    const value_10: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = value_9;
                    _ = (value_10).valid;

                    const value_12: bool = (((block_18: {
                        break :block_18 value_5;
                    } != @as(u64, 0)) and (!block_25: {
                        const operand_23 = block_22: {
                            const operand_20 = ((value_9).table).field_names;

                            const operand_21 = block_19: {
                                break :block_19 value_4;
                            };

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        const operand_24 = @as([]const u8, "");

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    })) and (((value_9).index == @as(u64, 0)) or block_33: {
                        const operand_32 = @as((zx_abi).zx_type_26, block_31: {
                            const operand_26 = (value_9).names;

                            const operand_28 = (block_27: {
                                break :block_27 value_4;
                            } - @as(u64, 1));
                            const operand_30 = block_29: {
                                break :block_29 value_4;
                            };

                            break :block_31 .{ operand_26, operand_28, operand_30, };
                        });

                        break :block_33 (try function_8(allocator, (&operand_32)));
                    }));

                    const value_13: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = block_17: {
                        break :block_17 @as((zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83, (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83{ .count = (value_10).count, .first = (value_10).first, .index = (value_10).index, .names = (value_10).names, .object = (value_10).object, .owner = (value_10).owner, .table = (value_10).table, .valid = block_16: {
                            break :block_16 value_12;
                        }, .values = (value_10).values, });
                    };

                    break :block_34 value_13;
                } else value_9);

                const value_15: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = value_14;
                const value_16: u64 = (value_15).index;
                const value_17: u64 = @as(u64, 1);

                const value_18: (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = block_15: {
                    break :block_15 @as((zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83, (zx_abi).value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83{ .count = (value_15).count, .first = (value_15).first, .index = (block_13: {
                        break :block_13 value_16;
                    } + block_14: {
                        break :block_14 value_17;
                    }), .names = (value_15).names, .object = (value_15).object, .owner = (value_15).owner, .table = (value_15).table, .valid = (value_15).valid, .values = (value_15).values, });
                };

                break :block_50 value_18;
            };
        }

        break :block_53 block_52: {
            break :block_52 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_51: {
                break :block_51 (zx_abi).zx_type_28{ .count = (state_1).count, .first = (state_1).first, .index = (state_1).index, .names = (state_1).names, .object = (state_1).object, .owner = (state_1).owner, .table = (state_1).table, .valid = (state_1).valid, .values = (state_1).values, };
            });
        };
    };

    return ((&value_19)).valid;
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_34: (zx_abi).zx_type_30 = block_74: {
        const operand_10 = block_9: {
            const operand_2 = (in).values;
            const operand_3 = (in).first;
            const operand_4 = (in).count;
            const operand_5 = (in).errors;
            const operand_6 = (in).names;
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_30{ .values = operand_2, .first = operand_3, .count = operand_4, .errors = operand_5, .names = operand_6, .index = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .count = (operand_10).count, .errors = (operand_10).errors, .first = (operand_10).first, .index = (operand_10).index, .names = (operand_10).names, .valid = (operand_10).valid, .values = (operand_10).values, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < (state_1).count))) {
            state_1 = block_71: {
                const value_3: u64 = ((state_1).first + (state_1).index);

                const value_4: []const u8 = block_70: {
                    const operand_68 = (state_1).values;

                    const operand_69 = block_67: {
                        break :block_67 value_3;
                    };

                    if ((operand_69 >= (operand_68).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_70 (operand_68)[@intCast(operand_69)];
                };

                const value_29: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_1).errors) block_30: {
                    const value_5: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;
                    _ = (value_5).valid;

                    const value_7: bool = (block_21: {
                        const operand_20 = @as((zx_abi).zx_type_25, block_19: {
                            const operand_16 = (state_1).names;

                            const operand_18 = block_17: {
                                break :block_17 value_3;
                            };

                            break :block_19 .{ operand_16, operand_18, };
                        });

                        break :block_21 (try function_7(allocator, (&operand_20)));
                    } and (((state_1).index == @as(u64, 0)) or block_29: {
                        const operand_28 = @as((zx_abi).zx_type_26, block_27: {
                            const operand_22 = (state_1).names;

                            const operand_24 = (block_23: {
                                break :block_23 value_3;
                            } - @as(u64, 1));
                            const operand_26 = block_25: {
                                break :block_25 value_3;
                            };

                            break :block_27 .{ operand_22, operand_24, operand_26, };
                        });

                        break :block_29 (try function_9(allocator, (&operand_28)));
                    }));

                    const value_8: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_15: {
                        break :block_15 @as((zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .count = (value_5).count, .errors = (value_5).errors, .first = (value_5).first, .index = (value_5).index, .names = (value_5).names, .valid = block_14: {
                            break :block_14 value_7;
                        }, .values = (value_5).values, });
                    };

                    break :block_30 value_8;
                } else block_66: {
                    const value_28: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (block_34: {
                        const operand_32 = block_31: {
                            break :block_31 value_4;
                        };

                        const operand_33 = @as([]const u8, "");

                        break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
                    }) block_37: {
                        const value_9: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        _ = (value_9).valid;
                        const value_11: bool = false;

                        const value_12: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_36: {
                            break :block_36 @as((zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .count = (value_9).count, .errors = (value_9).errors, .first = (value_9).first, .index = (value_9).index, .names = (value_9).names, .valid = block_35: {
                                break :block_35 value_11;
                            }, .values = (value_9).values, });
                        };

                        break :block_37 value_12;
                    } else block_65: {
                        const value_23: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_64: {
                            const operand_49 = block_48: {
                                const operand_41 = (state_1).values;
                                const operand_42 = (state_1).first;
                                const operand_43 = (state_1).index;
                                const operand_44 = block_45: {
                                    break :block_45 value_4;
                                };
                                const operand_46 = @as(u64, 0);
                                const operand_47 = true;

                                break :block_48 @as((zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .values = operand_41, .first = operand_42, .count = operand_43, .member = operand_44, .index = operand_46, .unique = operand_47, });
                            };

                            var state_40: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_49;
                            var state_changed_50 = false;

                            while (((state_40).unique and ((state_40).index < (state_40).count))) {
                                state_40 = block_62: {
                                    const value_15: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_40;
                                    _ = (value_15).unique;

                                    const value_17: bool = (!block_61: {
                                        const operand_59 = block_58: {
                                            const operand_56 = (state_40).values;
                                            const operand_57 = ((state_40).first + (state_40).index);

                                            if ((operand_57 >= (operand_56).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_58 (operand_56)[@intCast(operand_57)];
                                        };
                                        const operand_60 = (state_40).member;

                                        break :block_61 ((std).mem).eql(u8, operand_59, operand_60);
                                    });

                                    const value_18: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_55: {
                                        break :block_55 @as((zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_15).count, .first = (value_15).first, .index = (value_15).index, .member = (value_15).member, .unique = block_54: {
                                            break :block_54 value_17;
                                        }, .values = (value_15).values, });
                                    };
                                    const value_19: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_18;
                                    const value_20: u64 = (value_19).index;
                                    const value_21: u64 = @as(u64, 1);

                                    const value_22: (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_53: {
                                        break :block_53 @as((zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_19).count, .first = (value_19).first, .index = (block_51: {
                                            break :block_51 value_20;
                                        } + block_52: {
                                            break :block_52 value_21;
                                        }), .member = (value_19).member, .unique = (value_19).unique, .values = (value_19).values, });
                                    };

                                    break :block_62 value_22;
                                };

                                state_changed_50 = true;
                            }

                            break :block_64 (if (state_changed_50) state_40 else operand_49);
                        };
                        const value_24: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        _ = (value_24).valid;
                        const value_26: bool = (value_23).unique;

                        const value_27: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_39: {
                            break :block_39 @as((zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .count = (value_24).count, .errors = (value_24).errors, .first = (value_24).first, .index = (value_24).index, .names = (value_24).names, .valid = block_38: {
                                break :block_38 value_26;
                            }, .values = (value_24).values, });
                        };

                        break :block_65 value_27;
                    });

                    break :block_66 value_28;
                });

                const value_30: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_29;
                const value_31: u64 = (value_30).index;
                const value_32: u64 = @as(u64, 1);

                const value_33: (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .count = (value_30).count, .errors = (value_30).errors, .first = (value_30).first, .index = (block_11: {
                        break :block_11 value_31;
                    } + block_12: {
                        break :block_12 value_32;
                    }), .names = (value_30).names, .valid = (value_30).valid, .values = (value_30).values, });
                };

                break :block_71 value_33;
            };
        }

        break :block_74 block_73: {
            break :block_73 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_72: {
                break :block_72 (zx_abi).zx_type_30{ .count = (state_1).count, .errors = (state_1).errors, .first = (state_1).first, .index = (state_1).index, .names = (state_1).names, .valid = (state_1).valid, .values = (state_1).values, };
            });
        };
    };

    return ((&value_34)).valid;
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_32) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_11 = (try function_10(allocator, block_44: {
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
            const operand_34 = @as((zx_abi).zx_type_25, block_33: {
                const operand_31 = (in).names;
                const operand_32 = (in).index;

                break :block_33 .{ operand_31, operand_32, };
            });

            break :block_35 (try function_6(allocator, (&operand_34)));
        };
    }

    if ((value_1 == @as((zx_abi).zx_type_11, .Task))) {
        return ((((value_2 < (in).index) and (value_3 < (in).index)) and ((try function_10(allocator, block_27: {
            const operand_25 = ((in).table).kinds;
            const operand_26 = value_2;

            if ((operand_26 >= (operand_25).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_27 (operand_25)[@intCast(operand_26)];
        })) != @as((zx_abi).zx_type_11, .Task))) and ((try function_10(allocator, block_30: {
            const operand_28 = ((in).table).kinds;
            const operand_29 = value_3;

            if ((operand_29 >= (operand_28).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_30 (operand_28)[@intCast(operand_29)];
        })) == @as((zx_abi).zx_type_11, .ErrorSet)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Optional)) or (value_1 == @as((zx_abi).zx_type_11, .List)))) {
        return (((value_2 < (in).index) and ((value_1 != @as((zx_abi).zx_type_11, .List)) or (value_2 != @as(u64, 0)))) and ((try function_10(allocator, block_24: {
            const operand_22 = ((in).table).kinds;
            const operand_23 = value_2;

            if ((operand_23 >= (operand_22).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_24 (operand_22)[@intCast(operand_23)];
        })) != @as((zx_abi).zx_type_11, .Task)));
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Tuple)) or (value_1 == @as((zx_abi).zx_type_11, .Object)))) {
        return block_21: {
            const operand_14 = (in).table;
            const operand_15 = (in).index;
            const operand_16 = value_2;
            const operand_17 = value_3;
            const operand_18 = (value_1 == @as((zx_abi).zx_type_11, .Object));
            const operand_19 = (in).names;
            const operand_20 = (zx_abi).zx_type_27{ .table = operand_14, .index = operand_15, .first = operand_16, .count = operand_17, .object = operand_18, .names = operand_19, };

            break :block_21 (try function_11(allocator, (&operand_20)));
        };
    }

    if (((value_1 == @as((zx_abi).zx_type_11, .Enumeration)) and (block_13: {
        const operand_11 = block_10: {
            const operand_8 = ((in).table).labels;
            const operand_9 = (in).index;

            if ((operand_9 >= (operand_8).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_10 (operand_8)[@intCast(operand_9)];
        };

        const operand_12 = @as([]const u8, "");

        break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
    } or (value_3 == @as(u64, 0))))) {
        return false;
    }

    return block_7: {
        const operand_1 = ((in).table).names;
        const operand_2 = value_2;
        const operand_3 = value_3;
        const operand_4 = (value_1 == @as((zx_abi).zx_type_11, .ErrorSet));
        const operand_5 = (in).names;
        const operand_6 = (zx_abi).zx_type_29{ .values = operand_1, .first = operand_2, .count = operand_3, .errors = operand_4, .names = operand_5, };

        break :block_7 (try function_12(allocator, (&operand_6)));
    };
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    if ((@as(u64, (((in).table).kinds).len) < (in).scalar_count)) {
        return false;
    }

    const value_11: (zx_abi).zx_type_34 = block_23: {
        const operand_8 = block_7: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = (in).names;
            const operand_5 = @as(u64, 0);
            const operand_6 = true;

            break :block_7 (zx_abi).zx_type_34{ .table = operand_2, .scalar_count = operand_3, .names = operand_4, .index = operand_5, .valid = operand_6, };
        };

        var state_1: (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_8).index, .names = (operand_8).names, .scalar_count = (operand_8).scalar_count, .table = (operand_8).table, .valid = (operand_8).valid, .zx_origin = (&operand_8), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).table).kinds).len)))) {
            state_1 = block_20: {
                const value_3: (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;
                _ = (value_3).valid;

                const value_5: bool = block_19: {
                    const operand_14 = (state_1).table;
                    const operand_15 = (state_1).index;
                    const operand_16 = (state_1).scalar_count;
                    const operand_17 = (state_1).names;
                    const operand_18 = (zx_abi).zx_type_32{ .table = operand_14, .index = operand_15, .scalar_count = operand_16, .names = operand_17, };

                    break :block_19 (try function_13(allocator, (&operand_18)));
                };

                const value_6: (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_3).index, .names = (value_3).names, .scalar_count = (value_3).scalar_count, .table = (value_3).table, .valid = block_12: {
                        break :block_12 value_5;
                    }, });
                };

                const value_7: (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_6;
                const value_8: u64 = (value_7).index;
                const value_9: u64 = @as(u64, 1);

                const value_10: (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_11: {
                    break :block_11 @as((zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_9: {
                        break :block_9 value_8;
                    } + block_10: {
                        break :block_10 value_9;
                    }), .names = (value_7).names, .scalar_count = (value_7).scalar_count, .table = (value_7).table, .valid = (value_7).valid, });
                };

                break :block_20 value_10;
            };
        }

        break :block_23 block_22: {
            break :block_22 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_21: {
                break :block_21 (zx_abi).zx_type_34{ .index = (state_1).index, .names = (state_1).names, .scalar_count = (state_1).scalar_count, .table = (state_1).table, .valid = (state_1).valid, };
            });
        };
    };

    return ((&value_11)).valid;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_35) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: bool = block_11: {
        const operand_7 = (in).table;
        const operand_8 = (in).scalar_count;
        const operand_9 = (in).maximum_count;
        const operand_10 = (zx_abi).zx_type_22{ .table = operand_7, .scalar_count = operand_8, .maximum_count = operand_9, };

        break :block_11 (try function_3(allocator, (&operand_10)));
    };

    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: bool = block_6: {
            const operand_2 = (in).table;
            const operand_3 = (in).scalar_count;
            const operand_4 = (in).names;
            const operand_5 = (zx_abi).zx_type_33{ .table = operand_2, .scalar_count = operand_3, .names = operand_4, };

            break :block_6 (try function_14(allocator, (&operand_5)));
        };

        return value_2;
    } else {
        return false;
    }
}

