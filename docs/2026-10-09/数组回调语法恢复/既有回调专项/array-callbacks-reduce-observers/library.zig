const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_15;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, .seed = zx_shape_7, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .current = zx_shape_7, .previous = zx_shape_7, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_13, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .value = zx_shape_7, .visits = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_15, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_15;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_47: {
        const operand_42 = (in).seed;

        const operand_43 = block_44: {
            break :block_44 (try (allocator).dupe(*const (zx_abi).zx_type_13, (&[_]*const (zx_abi).zx_type_13{})));
        };

        break :block_47 block_46: {
            const operand_45 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_45).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .value = operand_42, .visits = operand_43, });

            break :block_46 @as(*const (zx_abi).zx_type_15, operand_45);
        };
    };

    return block_41: {
        const value_4: []const i64 = (in).items;

        const value_9: *const (zx_abi).zx_type_17 = block_40: {
            const operand_8 = block_7: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);
                const operand_4 = value_1;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_5).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_17, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(*const (zx_abi).zx_type_13) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = ((operand_8).result).value, .visits = ((operand_8).result).visits, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_33: {
                    const value_7: i64 = block_32: {
                        const operand_30 = (state_1).source;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    };

                    const value_2: (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (state_1).result;

                    const value_3: i64 = block_29: {
                        break :block_29 value_7;
                    };
                    const value_8: (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_28: {
                        const operand_16 = block_17: {
                            break :block_17 value_3;
                        };
                        const operand_18 = (block_27: {
                            const operand_19 = (value_2).visits;

                            const operand_26 = block_25: {
                                const operand_20 = (value_2).value;

                                const operand_21 = block_22: {
                                    break :block_22 value_3;
                                };
                                break :block_25 block_24: {
                                    const operand_23 = (try (allocator).create((zx_abi).zx_type_13));

                                    (operand_23).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .previous = operand_20, .current = operand_21, });

                                    break :block_24 @as(*const (zx_abi).zx_type_13, operand_23);
                                };
                            };

                            _ = (try ((std).math).add(usize, (operand_19).len, 1));

                            if ((!state_capacity_started_11)) {
                                (try (state_capacity_10).appendSlice(allocator, operand_19));
                                state_capacity_started_11 = true;
                            } else {
                                ((state_capacity_10).items).len = (operand_19).len;
                            }

                            (try (state_capacity_10).append(allocator, operand_26));

                            break :block_27 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                        }).@"0";

                        break :block_28 @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = operand_16, .visits = operand_18, });
                    };

                    break :block_33 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_8;

                        break :block_15 @as((zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_34: []const *const (zx_abi).zx_type_13 = (&[_]*const (zx_abi).zx_type_13{});

            errdefer (allocator).free(state_owned_34);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).visits).len;
                state_owned_34 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = ((state_1).result).value, .visits = state_owned_34, }), .source = (state_1).source, };
            }

            break :block_40 (if (state_changed_9) block_39: {
                break :block_39 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_38: {
                    const operand_37 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_37).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_36: {
                        const operand_35 = (try (allocator).create((zx_abi).zx_type_15));

                        (operand_35).* = (zx_abi).zx_type_15{ .value = ((state_1).result).value, .visits = ((state_1).result).visits, };

                        break :block_36 @as(*const (zx_abi).zx_type_15, operand_35);
                    }), .source = (state_1).source, };

                    break :block_38 @as(*const (zx_abi).zx_type_17, operand_37);
                });
            } else operand_8);
        };

        break :block_41 (value_9).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_87: {
        const operand_84 = (in).seed;

        const operand_85 = block_86: {
            break :block_86 (try (allocator).dupe(*const (zx_abi).zx_type_13, (&[_]*const (zx_abi).zx_type_13{})));
        };

        break :block_87 @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = operand_84, .visits = operand_85, });
    };

    return block_83: {
        const value_4: []const i64 = (in).items;

        const value_9: (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = block_82: {
            const operand_54 = block_53: {
                const operand_49 = block_50: {
                    break :block_50 value_4;
                };

                const operand_51 = @as(u64, 0);
                const operand_52 = value_1;

                break :block_53 @as((zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = operand_51, .result = operand_52, .source = operand_49, });
            };

            var state_capacity_56: (std).ArrayList(*const (zx_abi).zx_type_13) = .empty;
            var state_capacity_started_57 = false;

            defer (state_capacity_56).deinit(allocator);

            var state_48: (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = operand_54;
            var state_changed_55 = false;

            while (((state_48).index < @as(u64, ((state_48).source).len))) {
                state_48 = block_79: {
                    const value_7: i64 = block_78: {
                        const operand_76 = (state_48).source;
                        const operand_77 = (state_48).index;

                        if ((operand_77 >= (operand_76).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_78 (operand_76)[@intCast(operand_77)];
                    };

                    const value_2: (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (state_48).result;

                    const value_3: i64 = block_75: {
                        break :block_75 value_7;
                    };
                    const value_8: (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_74: {
                        const operand_62 = block_63: {
                            break :block_63 value_3;
                        };
                        const operand_64 = (block_73: {
                            const operand_65 = (value_2).visits;

                            const operand_72 = block_71: {
                                const operand_66 = (value_2).value;

                                const operand_67 = block_68: {
                                    break :block_68 value_3;
                                };
                                break :block_71 block_70: {
                                    const operand_69 = (try (allocator).create((zx_abi).zx_type_13));

                                    (operand_69).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .previous = operand_66, .current = operand_67, });

                                    break :block_70 @as(*const (zx_abi).zx_type_13, operand_69);
                                };
                            };

                            _ = (try ((std).math).add(usize, (operand_65).len, 1));

                            if ((!state_capacity_started_57)) {
                                (try (state_capacity_56).appendSlice(allocator, operand_65));

                                state_capacity_started_57 = true;
                            } else {
                                ((state_capacity_56).items).len = (operand_65).len;
                            }

                            (try (state_capacity_56).append(allocator, operand_72));

                            break :block_73 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_56).items, {}, null, });
                        }).@"0";

                        break :block_74 @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = operand_62, .visits = operand_64, });
                    };

                    break :block_79 block_61: {
                        const operand_58 = (state_48).source;
                        const operand_59 = ((state_48).index + @as(u64, 1));
                        const operand_60 = value_8;

                        break :block_61 @as((zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = operand_59, .result = operand_60, .source = operand_58, });
                    };
                };

                state_changed_55 = true;
            }

            var state_owned_80: []const *const (zx_abi).zx_type_13 = (&[_]*const (zx_abi).zx_type_13{});

            errdefer (allocator).free(state_owned_80);

            if (state_capacity_started_57) {
                ((state_capacity_56).items).len = (((state_48).result).visits).len;
                state_owned_80 = (try (state_capacity_56).toOwnedSlice(allocator));
            }

            if (state_capacity_started_57) {
                state_48 = (zx_abi).value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (state_48).index, .result = @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .value = ((state_48).result).value, .visits = state_owned_80, }), .source = (state_48).source, };
            }

            break :block_82 (if (state_changed_55) state_48 else operand_54);
        };

        break :block_83 (value_9).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .items = (operand_1).items, .seed = (operand_1).seed, .zx_origin = operand_1, }));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_3).* = (zx_abi).zx_type_15{ .value = (operand_2).value, .visits = (operand_2).visits, };

            break :block_4 @as(*const (zx_abi).zx_type_15, operand_3);
        });
    };
}

