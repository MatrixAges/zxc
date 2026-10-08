const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const State = *const (zx_abi).zx_type_12;
pub const Input = *const (zx_abi).zx_type_15;
pub const Output = *const (zx_abi).zx_type_12;
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
const zx_shape_11 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .flag = zx_shape_1, .last = zx_shape_5, .optional = zx_shape_11, .total = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .item = zx_shape_5, .state = zx_shape_12, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .seed = zx_shape_12, .steps = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_12, .source = zx_shape_14, }, };
pub const input_shape = zx_shape_15;
pub const output_shape = zx_shape_12;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_8: {
        const operand_1 = (((in).state).count + @as(u64, 1));
        const operand_2 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_3 = ((in).state).count;
        const operand_4 = (!((in).state).flag);
        const operand_5 = @as(?u64, (((in).state).optional orelse ((in).state).count));

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_6).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .count = operand_1, .total = operand_2, .last = operand_3, .flag = operand_4, .optional = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_12, operand_6);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632) error{ OutOfMemory, }!(zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_14: {
        const operand_9 = (((in).state).count + @as(u64, 1));
        const operand_10 = ((((in).state).total + ((in).state).count) + (in).item);
        const operand_11 = ((in).state).count;
        const operand_12 = (!((in).state).flag);
        const operand_13 = @as(?u64, (((in).state).optional orelse ((in).state).count));

        break :block_14 @as((zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f, (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = operand_9, .total = operand_10, .last = operand_11, .flag = operand_12, .optional = operand_13, });
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632{ .item = (operand_1).item, .state = (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = ((operand_1).state).count, .flag = ((operand_1).state).flag, .last = ((operand_1).state).last, .optional = ((operand_1).state).optional, .total = ((operand_1).state).total, .zx_origin = (operand_1).state, }, .zx_origin = operand_1, }));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_3).* = (zx_abi).zx_type_12{ .count = (operand_2).count, .flag = (operand_2).flag, .last = (operand_2).last, .optional = (operand_2).optional, .total = (operand_2).total, };

            break :block_4 @as(*const (zx_abi).zx_type_12, operand_3);
        });
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632) error{ OutOfMemory, }!(zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f {
    @setRuntimeSafety(true);

    return block_6: {
        break :block_6 (try function_0_value(allocator, in));
    };
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_31: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_30: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = ((operand_8).result).count, .flag = ((operand_8).result).flag, .last = ((operand_8).result).last, .optional = ((operand_8).result).optional, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_24: {
                    const value_6: u64 = block_23: {
                        const operand_21 = (state_1).source;
                        const operand_22 = (state_1).index;

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_1).result;

                    const value_2: u64 = block_20: {
                        break :block_20 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (if ((block_14: {
                        break :block_14 value_2;
                    } == @as(u64, 0))) value_1 else block_19: {
                        break :block_19 (try function_1_value(allocator, block_18: {
                            const operand_15 = value_1;

                            const operand_16 = block_17: {
                                break :block_17 value_2;
                            };

                            break :block_18 @as((zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632, (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632{ .state = operand_15, .item = operand_16, });
                        }));
                    });

                    break :block_24 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_30 (if (state_changed_9) block_29: {
                break :block_29 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_28: {
                    const operand_27 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_27).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_26: {
                        const operand_25 = (try (allocator).create((zx_abi).zx_type_12));

                        (operand_25).* = (zx_abi).zx_type_12{ .count = ((state_1).result).count, .flag = ((state_1).result).flag, .last = ((state_1).result).last, .optional = ((state_1).result).optional, .total = ((state_1).result).total, };

                        break :block_26 @as(*const (zx_abi).zx_type_12, operand_25);
                    }), .source = (state_1).source, };

                    break :block_28 @as(*const (zx_abi).zx_type_16, operand_27);
                });
            } else operand_8);
        };

        break :block_31 (value_8).result;
    };
}

fn function_2_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_7da5667de74a9dcfa7ece2fe079eb3d81a57b36eab2d28a05a8c0c3dadada60c) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f {
    @setRuntimeSafety(true);

    return block_57: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = block_56: {
            const operand_38 = block_37: {
                const operand_33 = block_34: {
                    break :block_34 value_3;
                };

                const operand_35 = @as(u64, 0);
                const operand_36 = (in).seed;

                break :block_37 @as((zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_35, .result = operand_36, .source = operand_33, });
            };

            var state_32: (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = operand_38;
            var state_changed_39 = false;

            while (((state_32).index < @as(u64, ((state_32).source).len))) {
                state_32 = block_54: {
                    const value_6: u64 = block_53: {
                        const operand_51 = (state_32).source;
                        const operand_52 = (state_32).index;

                        if ((operand_52 >= (operand_51).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_53 (operand_51)[@intCast(operand_52)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_32).result;

                    const value_2: u64 = block_50: {
                        break :block_50 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (if ((block_44: {
                        break :block_44 value_2;
                    } == @as(u64, 0))) value_1 else block_49: {
                        break :block_49 (try function_1_value(allocator, block_48: {
                            const operand_45 = value_1;

                            const operand_46 = block_47: {
                                break :block_47 value_2;
                            };

                            break :block_48 @as((zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632, (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632{ .state = operand_45, .item = operand_46, });
                        }));
                    });

                    break :block_54 block_43: {
                        const operand_40 = (state_32).source;
                        const operand_41 = ((state_32).index + @as(u64, 1));
                        const operand_42 = value_7;

                        break :block_43 @as((zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_41, .result = operand_42, .source = operand_40, });
                    };
                };

                state_changed_39 = true;
            }

            break :block_56 (if (state_changed_39) state_32 else operand_38);
        };

        break :block_57 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_31: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_30: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = ((operand_8).result).count, .flag = ((operand_8).result).flag, .last = ((operand_8).result).last, .optional = ((operand_8).result).optional, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_24: {
                    const value_6: u64 = block_23: {
                        const operand_21 = (state_1).source;
                        const operand_22 = (state_1).index;

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_1).result;

                    const value_2: u64 = block_20: {
                        break :block_20 value_6;
                    };

                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (if ((block_14: {
                        break :block_14 value_2;
                    } == @as(u64, 0))) value_1 else block_19: {
                        break :block_19 (try function_1_value(allocator, block_18: {
                            const operand_15 = value_1;

                            const operand_16 = block_17: {
                                break :block_17 value_2;
                            };

                            break :block_18 @as((zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632, (zx_abi).value_zx_type_13_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632{ .state = operand_15, .item = operand_16, });
                        }));
                    });

                    break :block_24 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_16_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_30 (if (state_changed_9) block_29: {
                break :block_29 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_28: {
                    const operand_27 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_27).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_26: {
                        const operand_25 = (try (allocator).create((zx_abi).zx_type_12));

                        (operand_25).* = (zx_abi).zx_type_12{ .count = ((state_1).result).count, .flag = ((state_1).result).flag, .last = ((state_1).result).last, .optional = ((state_1).result).optional, .total = ((state_1).result).total, };

                        break :block_26 @as(*const (zx_abi).zx_type_12, operand_25);
                    }), .source = (state_1).source, };

                    break :block_28 @as(*const (zx_abi).zx_type_16, operand_27);
                });
            } else operand_8);
        };

        break :block_31 (value_8).result;
    };
}

