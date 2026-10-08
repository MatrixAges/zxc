const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const State = *const (zx_abi).zx_type_13;
pub const Input = *const (zx_abi).zx_type_16;
pub const Output = *const (zx_abi).zx_type_13;
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
const zx_shape_12 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .phase = zx_shape_11, .saved = zx_shape_12, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .item = zx_shape_1, .state = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .seed = zx_shape_13, .steps = zx_shape_15, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_15, }, };
pub const input_shape = zx_shape_16;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_6: {
        const operand_1 = (if ((in).item) (if ((((in).state).phase == @as((zx_abi).zx_type_11, .On))) @as((zx_abi).zx_type_11, .Off) else @as((zx_abi).zx_type_11, .On)) else ((in).state).phase);
        const operand_2 = @as(?(zx_abi).zx_type_11, (((in).state).saved orelse ((in).state).phase));
        const operand_3 = (((in).state).count + @as(u64, 1));

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_4).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .phase = operand_1, .saved = operand_2, .count = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_13, operand_4);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_10: {
        const operand_7 = (if ((in).item) (if ((((in).state).phase == @as((zx_abi).zx_type_11, .On))) @as((zx_abi).zx_type_11, .Off) else @as((zx_abi).zx_type_11, .On)) else ((in).state).phase);
        const operand_8 = @as(?(zx_abi).zx_type_11, (((in).state).saved orelse ((in).state).phase));
        const operand_9 = (((in).state).count + @as(u64, 1));

        break :block_10 @as((zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91, (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91{ .phase = operand_7, .saved = operand_8, .count = operand_9, });
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_30: {
        const value_3: []const bool = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_29: {
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

            var state_1: (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233 = (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91{ .count = ((operand_8).result).count, .phase = ((operand_8).result).phase, .saved = ((operand_8).result).saved, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_23: {
                    const value_6: bool = block_22: {
                        const operand_20 = (state_1).source;
                        const operand_21 = (state_1).index;

                        if ((operand_21 >= (operand_20).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_22 (operand_20)[@intCast(operand_21)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = (state_1).result;

                    const value_2: bool = block_19: {
                        break :block_19 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = block_18: {
                        break :block_18 (try function_0_value(allocator, block_17: {
                            const operand_14 = value_1;

                            const operand_15 = block_16: {
                                break :block_16 value_2;
                            };

                            break :block_17 @as((zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5, (zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5{ .state = operand_14, .item = operand_15, });
                        }));
                    };

                    break :block_23 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233, (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_29 (if (state_changed_9) block_28: {
                break :block_28 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_27: {
                    const operand_26 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_26).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_25: {
                        const operand_24 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_24).* = (zx_abi).zx_type_13{ .count = ((state_1).result).count, .phase = ((state_1).result).phase, .saved = ((state_1).result).saved, };

                        break :block_25 @as(*const (zx_abi).zx_type_13, operand_24);
                    }), .source = (state_1).source, };

                    break :block_27 @as(*const (zx_abi).zx_type_17, operand_26);
                });
            } else operand_8);
        };

        break :block_30 (value_8).result;
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_20ba4de8b3c65311b405214c8b837f27e4756ddfe17938968cad9d115f14c7db) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 {
    @setRuntimeSafety(true);

    return block_55: {
        const value_3: []const bool = (in).steps;

        const value_8: (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233 = block_54: {
            const operand_37 = block_36: {
                const operand_32 = block_33: {
                    break :block_33 value_3;
                };

                const operand_34 = @as(u64, 0);
                const operand_35 = (in).seed;

                break :block_36 @as((zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233, (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = operand_34, .result = operand_35, .source = operand_32, });
            };

            var state_31: (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233 = operand_37;
            var state_changed_38 = false;

            while (((state_31).index < @as(u64, ((state_31).source).len))) {
                state_31 = block_52: {
                    const value_6: bool = block_51: {
                        const operand_49 = (state_31).source;
                        const operand_50 = (state_31).index;

                        if ((operand_50 >= (operand_49).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_51 (operand_49)[@intCast(operand_50)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = (state_31).result;

                    const value_2: bool = block_48: {
                        break :block_48 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = block_47: {
                        break :block_47 (try function_0_value(allocator, block_46: {
                            const operand_43 = value_1;

                            const operand_44 = block_45: {
                                break :block_45 value_2;
                            };

                            break :block_46 @as((zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5, (zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5{ .state = operand_43, .item = operand_44, });
                        }));
                    };

                    break :block_52 block_42: {
                        const operand_39 = (state_31).source;
                        const operand_40 = ((state_31).index + @as(u64, 1));
                        const operand_41 = value_7;

                        break :block_42 @as((zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233, (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = operand_40, .result = operand_41, .source = operand_39, });
                    };
                };

                state_changed_38 = true;
            }

            break :block_54 (if (state_changed_38) state_31 else operand_37);
        };

        break :block_55 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_30: {
        const value_3: []const bool = (in).steps;

        const value_8: *const (zx_abi).zx_type_17 = block_29: {
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

            var state_1: (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233 = (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91{ .count = ((operand_8).result).count, .phase = ((operand_8).result).phase, .saved = ((operand_8).result).saved, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_23: {
                    const value_6: bool = block_22: {
                        const operand_20 = (state_1).source;
                        const operand_21 = (state_1).index;

                        if ((operand_21 >= (operand_20).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_22 (operand_20)[@intCast(operand_21)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = (state_1).result;

                    const value_2: bool = block_19: {
                        break :block_19 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = block_18: {
                        break :block_18 (try function_0_value(allocator, block_17: {
                            const operand_14 = value_1;

                            const operand_15 = block_16: {
                                break :block_16 value_2;
                            };

                            break :block_17 @as((zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5, (zx_abi).value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5{ .state = operand_14, .item = operand_15, });
                        }));
                    };

                    break :block_23 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233, (zx_abi).value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_29 (if (state_changed_9) block_28: {
                break :block_28 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_27: {
                    const operand_26 = (try (allocator).create((zx_abi).zx_type_17));

                    (operand_26).* = (zx_abi).zx_type_17{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_25: {
                        const operand_24 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_24).* = (zx_abi).zx_type_13{ .count = ((state_1).result).count, .phase = ((state_1).result).phase, .saved = ((state_1).result).saved, };

                        break :block_25 @as(*const (zx_abi).zx_type_13, operand_24);
                    }), .source = (state_1).source, };

                    break :block_27 @as(*const (zx_abi).zx_type_17, operand_26);
                });
            } else operand_8);
        };

        break :block_30 (value_8).result;
    };
}

