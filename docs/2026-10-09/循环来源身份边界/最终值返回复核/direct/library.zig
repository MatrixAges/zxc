const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const State = *const (zx_abi).zx_type_12;
pub const Input = *const (zx_abi).zx_type_14;
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
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .seed = zx_shape_12, .steps = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_12, .source = zx_shape_13, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_12;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_8: {
        const operand_1 = ((in).count + @as(u64, 1));
        const operand_2 = ((in).total + (in).count);
        const operand_3 = (in).count;
        const operand_4 = (!(in).flag);
        const operand_5 = @as(?u64, ((in).optional orelse (in).count));

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_6).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .count = operand_1, .total = operand_2, .last = operand_3, .flag = operand_4, .optional = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_12, operand_6);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f) error{ OutOfMemory, }!(zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_14: {
        const operand_9 = ((in).count + @as(u64, 1));
        const operand_10 = ((in).total + (in).count);
        const operand_11 = (in).count;
        const operand_12 = (!(in).flag);
        const operand_13 = @as(?u64, ((in).optional orelse (in).count));

        break :block_14 @as((zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f, (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = operand_9, .total = operand_10, .last = operand_11, .flag = operand_12, .optional = operand_13, });
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    return block_25: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_15 = block_24: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_5).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_15, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = ((operand_8).result).count, .flag = ((operand_8).result).flag, .last = ((operand_8).result).last, .optional = ((operand_8).result).optional, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_18: {
                    _ = block_17: {
                        const operand_15 = (state_1).source;
                        const operand_16 = (state_1).index;

                        if ((operand_16 >= (operand_15).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_17 (operand_15)[@intCast(operand_16)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_1).result;

                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = block_14: {
                        break :block_14 (try function_0_value(allocator, value_1));
                    };

                    break :block_18 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_24 (if (state_changed_9) block_23: {
                break :block_23 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_22: {
                    const operand_21 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_21).* = (zx_abi).zx_type_15{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_20: {
                        const operand_19 = (try (allocator).create((zx_abi).zx_type_12));

                        (operand_19).* = (zx_abi).zx_type_12{ .count = ((state_1).result).count, .flag = ((state_1).result).flag, .last = ((state_1).result).last, .optional = ((state_1).result).optional, .total = ((state_1).result).total, };

                        break :block_20 @as(*const (zx_abi).zx_type_12, operand_19);
                    }), .source = (state_1).source, };

                    break :block_22 @as(*const (zx_abi).zx_type_15, operand_21);
                });
            } else operand_8);
        };

        break :block_25 (value_8).result;
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_14_7da5667de74a9dcfa7ece2fe079eb3d81a57b36eab2d28a05a8c0c3dadada60c) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f {
    @setRuntimeSafety(true);

    return block_45: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = block_44: {
            const operand_32 = block_31: {
                const operand_27 = block_28: {
                    break :block_28 value_3;
                };

                const operand_29 = @as(u64, 0);
                const operand_30 = (in).seed;

                break :block_31 @as((zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_29, .result = operand_30, .source = operand_27, });
            };

            var state_26: (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = operand_32;
            var state_changed_33 = false;

            while (((state_26).index < @as(u64, ((state_26).source).len))) {
                state_26 = block_42: {
                    _ = block_41: {
                        const operand_39 = (state_26).source;
                        const operand_40 = (state_26).index;

                        if ((operand_40 >= (operand_39).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_41 (operand_39)[@intCast(operand_40)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_26).result;

                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = block_38: {
                        break :block_38 (try function_0_value(allocator, value_1));
                    };

                    break :block_42 block_37: {
                        const operand_34 = (state_26).source;
                        const operand_35 = ((state_26).index + @as(u64, 1));
                        const operand_36 = value_7;

                        break :block_37 @as((zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_35, .result = operand_36, .source = operand_34, });
                    };
                };

                state_changed_33 = true;
            }

            break :block_44 (if (state_changed_33) state_26 else operand_32);
        };

        break :block_45 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_25: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_15 = block_24: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_5).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_15, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f{ .count = ((operand_8).result).count, .flag = ((operand_8).result).flag, .last = ((operand_8).result).last, .optional = ((operand_8).result).optional, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_18: {
                    _ = block_17: {
                        const operand_15 = (state_1).source;
                        const operand_16 = (state_1).index;

                        if ((operand_16 >= (operand_15).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_17 (operand_15)[@intCast(operand_16)];
                    };

                    const value_1: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = (state_1).result;

                    const value_7: (zx_abi).value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = block_14: {
                        break :block_14 (try function_0_value(allocator, value_1));
                    };

                    break :block_18 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416, (zx_abi).value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_24 (if (state_changed_9) block_23: {
                break :block_23 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_22: {
                    const operand_21 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_21).* = (zx_abi).zx_type_15{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_20: {
                        const operand_19 = (try (allocator).create((zx_abi).zx_type_12));

                        (operand_19).* = (zx_abi).zx_type_12{ .count = ((state_1).result).count, .flag = ((state_1).result).flag, .last = ((state_1).result).last, .optional = ((state_1).result).optional, .total = ((state_1).result).total, };

                        break :block_20 @as(*const (zx_abi).zx_type_12, operand_19);
                    }), .source = (state_1).source, };

                    break :block_22 @as(*const (zx_abi).zx_type_15, operand_21);
                });
            } else operand_8);
        };

        break :block_25 (value_8).result;
    };
}

