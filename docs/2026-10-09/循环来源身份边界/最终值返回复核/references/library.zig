const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Cell = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_14;
pub const Input = *const (zx_abi).zx_type_16;
pub const Output = *const (zx_abi).zx_type_14;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_13 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .cell = zx_shape_11, .count = zx_shape_5, .items = zx_shape_12, .saved = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .item = zx_shape_5, .state = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .seed = zx_shape_14, .steps = zx_shape_12, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_14, .source = zx_shape_12, }, };
pub const input_shape = zx_shape_16;
pub const output_shape = zx_shape_14;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_14 = block_7: {
        const operand_1 = (((in).state).count + (in).item);
        const operand_2 = ((in).state).items;
        const operand_3 = ((in).state).cell;
        const operand_4 = ((in).state).saved;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_5).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .count = operand_1, .items = operand_2, .cell = operand_3, .saved = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_14, operand_5);
        };
    };

    return value_1;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2) error{ OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = block_12: {
        const operand_8 = (((in).state).count + (in).item);
        const operand_9 = ((in).state).items;
        const operand_10 = ((in).state).cell;
        const operand_11 = ((in).state).saved;

        break :block_12 @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .count = operand_8, .items = operand_9, .cell = operand_10, .saved = operand_11, });
    };

    return value_1;
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = block_17: {
        const operand_13 = (((in).state).count + (in).item);
        const operand_14 = ((in).state).items;
        const operand_15 = ((in).state).cell;
        const operand_16 = ((in).state).saved;

        break :block_17 @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .count = operand_13, .items = operand_14, .cell = operand_15, .saved = operand_16, });
    };

    return value_1;
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = buffers;

    const value_1: *const (zx_abi).zx_type_14 = block_24: {
        const operand_18 = (((in).state).count + (in).item);
        const operand_19 = ((in).state).items;
        const operand_20 = ((in).state).cell;
        const operand_21 = ((in).state).saved;

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_22).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .count = operand_18, .items = operand_19, .cell = operand_20, .saved = operand_21, });

            break :block_23 @as(*const (zx_abi).zx_type_14, operand_22);
        };
    };

    return value_1;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_33: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_32: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_5).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_17, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(u64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((operand_8).result).cell, .count = ((operand_8).result).count, .items = ((operand_8).result).items, .saved = ((operand_8).result).saved, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_25: {
                    const value_6: u64 = block_24: {
                        const operand_22 = (state_1).source;
                        const operand_23 = (state_1).index;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_1).result;

                    const value_2: u64 = block_21: {
                        break :block_21 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_20: {
                        break :block_20 (try function_0_buffered(allocator, block_19: {
                            const operand_16 = value_1;

                            const operand_17 = block_18: {
                                break :block_18 value_2;
                            };

                            break :block_19 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_16, .item = operand_17, });
                        }, .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, }));
                    });

                    break :block_25 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_7;

                        break :block_15 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_26: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_26);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).items).len;
                state_owned_26 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = state_owned_26, .saved = ((state_1).result).saved, }), .source = (state_1).source, };
            }

            break :block_32 (if (state_changed_9) block_31: {
                break :block_31 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_29).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_27).* = (zx_abi).zx_type_14{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = ((state_1).result).items, .saved = ((state_1).result).saved, };

                        break :block_28 @as(*const (zx_abi).zx_type_14, operand_27);
                    }), .source = (state_1).source, };

                    break :block_30 @as(*const (zx_abi).zx_type_17, operand_29);
                });
            } else operand_8);
        };

        break :block_33 (value_8).result;
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_16878eaf6a964b7c2766c5dc980126bf394a0a5ef441d5fb3c790a3d6ada087c) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    return block_61: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = block_60: {
            const operand_40 = block_39: {
                const operand_35 = block_36: {
                    break :block_36 value_3;
                };

                const operand_37 = @as(u64, 0);
                const operand_38 = (in).seed;

                break :block_39 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_37, .result = operand_38, .source = operand_35, });
            };

            var state_capacity_42: (std).ArrayList(u64) = .empty;
            var state_capacity_started_43 = false;

            defer (state_capacity_42).deinit(allocator);

            var state_34: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = operand_40;
            var state_changed_41 = false;

            while (((state_34).index < @as(u64, ((state_34).source).len))) {
                state_34 = block_57: {
                    const value_6: u64 = block_56: {
                        const operand_54 = (state_34).source;
                        const operand_55 = (state_34).index;

                        if ((operand_55 >= (operand_54).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_56 (operand_54)[@intCast(operand_55)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_34).result;

                    const value_2: u64 = block_53: {
                        break :block_53 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_52: {
                        break :block_52 (try function_0_buffered(allocator, block_51: {
                            const operand_48 = value_1;

                            const operand_49 = block_50: {
                                break :block_50 value_2;
                            };

                            break :block_51 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_48, .item = operand_49, });
                        }, .{ .lane_0 = .{ .buffer = (&state_capacity_42), .started = (&state_capacity_started_43), }, }));
                    });

                    break :block_57 block_47: {
                        const operand_44 = (state_34).source;
                        const operand_45 = ((state_34).index + @as(u64, 1));
                        const operand_46 = value_7;

                        break :block_47 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_45, .result = operand_46, .source = operand_44, });
                    };
                };

                state_changed_41 = true;
            }

            var state_owned_58: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_58);

            if (state_capacity_started_43) {
                ((state_capacity_42).items).len = (((state_34).result).items).len;
                state_owned_58 = (try (state_capacity_42).toOwnedSlice(allocator));
            }

            if (state_capacity_started_43) {
                state_34 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (state_34).index, .result = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((state_34).result).cell, .count = ((state_34).result).count, .items = state_owned_58, .saved = ((state_34).result).saved, }), .source = (state_34).source, };
            }

            break :block_60 (if (state_changed_41) state_34 else operand_40);
        };

        break :block_61 (value_8).result;
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_16878eaf6a964b7c2766c5dc980126bf394a0a5ef441d5fb3c790a3d6ada087c, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 {
    @setRuntimeSafety(true);

    return block_86: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = block_85: {
            const operand_68 = block_67: {
                const operand_63 = block_64: {
                    break :block_64 value_3;
                };

                const operand_65 = @as(u64, 0);
                const operand_66 = (in).seed;

                break :block_67 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_65, .result = operand_66, .source = operand_63, });
            };

            var state_62: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = operand_68;
            var state_changed_69 = false;

            while (((state_62).index < @as(u64, ((state_62).source).len))) {
                state_62 = block_83: {
                    const value_6: u64 = block_82: {
                        const operand_80 = (state_62).source;
                        const operand_81 = (state_62).index;

                        if ((operand_81 >= (operand_80).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_82 (operand_80)[@intCast(operand_81)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_62).result;

                    const value_2: u64 = block_79: {
                        break :block_79 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_78: {
                        break :block_78 (try function_0_buffered(allocator, block_77: {
                            const operand_74 = value_1;

                            const operand_75 = block_76: {
                                break :block_76 value_2;
                            };

                            break :block_77 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_74, .item = operand_75, });
                        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                    });

                    break :block_83 block_73: {
                        const operand_70 = (state_62).source;
                        const operand_71 = ((state_62).index + @as(u64, 1));
                        const operand_72 = value_7;

                        break :block_73 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_71, .result = operand_72, .source = operand_70, });
                    };
                };

                state_changed_69 = true;
            }

            break :block_85 (if (state_changed_69) state_62 else operand_68);
        };

        break :block_86 (value_8).result;
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_116: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_115: {
            const operand_94 = block_93: {
                const operand_88 = value_3;
                const operand_89 = @as(u64, 0);
                const operand_90 = (in).seed;

                break :block_93 block_92: {
                    const operand_91 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_91).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_89, .result = operand_90, .source = operand_88, });

                    break :block_92 @as(*const (zx_abi).zx_type_17, operand_91);
                };
            };

            var state_87: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (operand_94).index, .result = (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((operand_94).result).cell, .count = ((operand_94).result).count, .items = ((operand_94).result).items, .saved = ((operand_94).result).saved, .zx_origin = (operand_94).result, }, .source = (operand_94).source, .zx_origin = operand_94, };
            var state_changed_95 = false;

            while (((state_87).index < @as(u64, ((state_87).source).len))) {
                state_87 = block_109: {
                    const value_6: u64 = block_108: {
                        const operand_106 = (state_87).source;
                        const operand_107 = (state_87).index;

                        if ((operand_107 >= (operand_106).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_108 (operand_106)[@intCast(operand_107)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_87).result;

                    const value_2: u64 = block_105: {
                        break :block_105 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_104: {
                        break :block_104 (try function_0_buffered(allocator, block_103: {
                            const operand_100 = value_1;

                            const operand_101 = block_102: {
                                break :block_102 value_2;
                            };

                            break :block_103 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_100, .item = operand_101, });
                        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), }));
                    });

                    break :block_109 block_99: {
                        const operand_96 = (state_87).source;
                        const operand_97 = ((state_87).index + @as(u64, 1));
                        const operand_98 = value_7;

                        break :block_99 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_97, .result = operand_98, .source = operand_96, });
                    };
                };

                state_changed_95 = true;
            }

            break :block_115 (if (state_changed_95) block_114: {
                break :block_114 (if (((state_87).zx_origin != null)) (state_87).zx_origin.? else block_113: {
                    const operand_112 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_112).* = (zx_abi).zx_type_17{ .index = (state_87).index, .result = (if ((((state_87).result).zx_origin != null)) ((state_87).result).zx_origin.? else block_111: {
                        const operand_110 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_110).* = (zx_abi).zx_type_14{ .cell = ((state_87).result).cell, .count = ((state_87).result).count, .items = ((state_87).result).items, .saved = ((state_87).result).saved, };

                        break :block_111 @as(*const (zx_abi).zx_type_14, operand_110);
                    }), .source = (state_87).source, };

                    break :block_113 @as(*const (zx_abi).zx_type_17, operand_112);
                });
            } else operand_94);
        };

        break :block_116 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_33: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_32: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_5).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_17, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(u64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((operand_8).result).cell, .count = ((operand_8).result).count, .items = ((operand_8).result).items, .saved = ((operand_8).result).saved, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_25: {
                    const value_6: u64 = block_24: {
                        const operand_22 = (state_1).source;
                        const operand_23 = (state_1).index;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };

                    const value_1: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = (state_1).result;

                    const value_2: u64 = block_21: {
                        break :block_21 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, block_20: {
                        break :block_20 (try function_0_buffered(allocator, block_19: {
                            const operand_16 = value_1;

                            const operand_17 = block_18: {
                                break :block_18 value_2;
                            };

                            break :block_19 @as((zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2, (zx_abi).value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2{ .state = operand_16, .item = operand_17, });
                        }, .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, }));
                    });

                    break :block_25 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_7;

                        break :block_15 @as((zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438, (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_26: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_26);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).items).len;
                state_owned_26 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745, (zx_abi).value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = state_owned_26, .saved = ((state_1).result).saved, }), .source = (state_1).source, };
            }

            break :block_32 (if (state_changed_9) block_31: {
                break :block_31 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_30: {
                    const operand_29 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_29).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_28: {
                        const operand_27 = (try (allocator).create((zx_abi).zx_type_14));

                        (operand_27).* = (zx_abi).zx_type_14{ .cell = ((state_1).result).cell, .count = ((state_1).result).count, .items = ((state_1).result).items, .saved = ((state_1).result).saved, };

                        break :block_28 @as(*const (zx_abi).zx_type_14, operand_27);
                    }), .source = (state_1).source, };

                    break :block_30 @as(*const (zx_abi).zx_type_17, operand_29);
                });
            } else operand_8);
        };

        break :block_33 (value_8).result;
    };
}

