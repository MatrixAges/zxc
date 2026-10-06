const std = @import("std");
const zx_native_0 = @import("field_columns");
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, .@"2" = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .columns = zx_shape_11, .count = zx_shape_5, .start = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .active = zx_shape_1, .columns = zx_shape_11, .count = zx_shape_5, .root = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .columns = zx_shape_11, .count = zx_shape_5, .remaining = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .columns = zx_shape_11, .remaining = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_0;
pub const Input = *const (zx_abi).zx_type_11;
pub const Output = void;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ }!u64 {
    const native_result = (zx_native_0).length(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!bool {
    const native_result = (zx_native_0).less((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ }!void {
    const native_result = (zx_native_0).swap((in).@"0", (in).@"1", (in).@"2");

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }!void {
    @setRuntimeSafety(true);

    _ = block_44: {
        const operand_7 = block_6: {
            const operand_2 = (in).columns;
            const operand_3 = (in).start;
            const operand_4 = (in).count;
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_14{ .columns = operand_2, .root = operand_3, .count = operand_4, .active = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .active = (operand_7).active, .columns = (operand_7).columns, .count = (operand_7).count, .root = (operand_7).root, .zx_origin = (&operand_7), };

        while (((state_1).active and ((state_1).root < @divTrunc((state_1).count, @as(u64, 2))))) {
            state_1 = block_41: {
                const value_3: u64 = (((state_1).root * @as(u64, 2)) + @as(u64, 1));

                const value_4: u64 = (block_40: {
                    break :block_40 value_3;
                } + @as(u64, 1));

                const value_5: u64 = (if (((block_29: {
                    break :block_29 value_4;
                } < (state_1).count) and block_37: {
                    const operand_36 = @as((zx_abi).zx_type_12, block_35: {
                        const operand_30 = (state_1).columns;

                        const operand_32 = block_31: {
                            break :block_31 value_3;
                        };
                        const operand_34 = block_33: {
                            break :block_33 value_4;
                        };

                        break :block_35 .{ operand_30, operand_32, operand_34, };
                    });

                    break :block_37 (try function_1(allocator, (&operand_36)));
                })) block_38: {
                    break :block_38 value_4;
                } else block_39: {
                    break :block_39 value_3;
                });

                const value_14: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if (block_14: {
                    const operand_13 = @as((zx_abi).zx_type_12, block_12: {
                        const operand_8 = (state_1).columns;
                        const operand_9 = (state_1).root;

                        const operand_11 = block_10: {
                            break :block_10 value_5;
                        };

                        break :block_12 .{ operand_8, operand_9, operand_11, };
                    });

                    break :block_14 (try function_1(allocator, (&operand_13)));
                }) block_25: {
                    block_24: {
                        const operand_23 = @as((zx_abi).zx_type_12, block_22: {
                            const operand_18 = (state_1).columns;
                            const operand_19 = (state_1).root;

                            const operand_21 = block_20: {
                                break :block_20 value_5;
                            };

                            break :block_22 .{ operand_18, operand_19, operand_21, };
                        });

                        break :block_24 (try function_2(allocator, (&operand_23)));
                    }

                    const value_6: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                    _ = (value_6).root;

                    const value_8: u64 = block_17: {
                        break :block_17 value_5;
                    };

                    const value_9: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_16: {
                        break :block_16 @as((zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .active = (value_6).active, .columns = (value_6).columns, .count = (value_6).count, .root = block_15: {
                            break :block_15 value_8;
                        }, });
                    };

                    break :block_25 value_9;
                } else block_28: {
                    const value_10: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                    _ = (value_10).active;
                    const value_12: bool = false;

                    const value_13: (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_27: {
                        break :block_27 @as((zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .active = block_26: {
                            break :block_26 value_12;
                        }, .columns = (value_10).columns, .count = (value_10).count, .root = (value_10).root, });
                    };

                    break :block_28 value_13;
                });

                break :block_41 value_14;
            };
        }

        break :block_44 block_43: {
            break :block_43 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_42: {
                break :block_42 (zx_abi).zx_type_14{ .active = (state_1).active, .columns = (state_1).columns, .count = (state_1).count, .root = (state_1).root, };
            });
        };
    };

    return;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_0(allocator, in));

    const value_8: (zx_abi).zx_type_15 = block_45: {
        const operand_31 = block_30: {
            const operand_27 = in;
            const operand_28 = value_1;
            const operand_29 = @divTrunc(value_1, @as(u64, 2));

            break :block_30 (zx_abi).zx_type_15{ .columns = operand_27, .count = operand_28, .remaining = operand_29, };
        };

        var state_26: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .columns = (operand_31).columns, .count = (operand_31).count, .remaining = (operand_31).remaining, .zx_origin = (&operand_31), };

        while (((state_26).remaining > @as(u64, 0))) {
            state_26 = block_42: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_26;
                const value_5: u64 = (value_4).remaining;
                const value_6: u64 = @as(u64, 1);

                const value_7: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_41: {
                    break :block_41 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .columns = (value_4).columns, .count = (value_4).count, .remaining = (block_39: {
                        break :block_39 value_5;
                    } - block_40: {
                        break :block_40 value_6;
                    }), });
                };
                block_38: {
                    const operand_36 = block_35: {
                        const operand_32 = (value_7).columns;
                        const operand_33 = (value_7).remaining;
                        const operand_34 = (value_7).count;

                        break :block_35 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .columns = operand_32, .start = operand_33, .count = operand_34, });
                    };

                    var state_borrow_37: (zx_abi).zx_type_13 = undefined;

                    state_borrow_37 = (zx_abi).zx_type_13{ .columns = (operand_36).columns, .count = (operand_36).count, .start = (operand_36).start, };

                    break :block_38 (try function_3(allocator, ((operand_36).zx_origin orelse (&state_borrow_37))));
                }

                break :block_42 value_7;
            };
        }

        break :block_45 block_44: {
            break :block_44 (if (((state_26).zx_origin != null)) ((state_26).zx_origin.?).* else block_43: {
                break :block_43 (zx_abi).zx_type_15{ .columns = (state_26).columns, .count = (state_26).count, .remaining = (state_26).remaining, };
            });
        };
    };

    _ = block_25: {
        const operand_5 = block_4: {
            const operand_2 = ((&value_8)).columns;
            const operand_3 = value_1;

            break :block_4 (zx_abi).zx_type_16{ .columns = operand_2, .remaining = operand_3, };
        };

        var state_1: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .columns = (operand_5).columns, .remaining = (operand_5).remaining, .zx_origin = (&operand_5), };

        while (((state_1).remaining > @as(u64, 1))) {
            state_1 = block_22: {
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = state_1;
                const value_12: u64 = (value_11).remaining;
                const value_13: u64 = @as(u64, 1);

                const value_14: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_21: {
                    break :block_21 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .columns = (value_11).columns, .remaining = (block_19: {
                        break :block_19 value_12;
                    } - block_20: {
                        break :block_20 value_13;
                    }), });
                };
                block_18: {
                    const operand_17 = @as((zx_abi).zx_type_12, block_16: {
                        const operand_13 = (value_14).columns;
                        const operand_14 = @as(u64, 0);
                        const operand_15 = (value_14).remaining;

                        break :block_16 .{ operand_13, operand_14, operand_15, };
                    });

                    break :block_18 (try function_2(allocator, (&operand_17)));
                }
                block_12: {
                    const operand_10 = block_9: {
                        const operand_6 = (value_14).columns;
                        const operand_7 = @as(u64, 0);
                        const operand_8 = (value_14).remaining;

                        break :block_9 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .columns = operand_6, .start = operand_7, .count = operand_8, });
                    };

                    var state_borrow_11: (zx_abi).zx_type_13 = undefined;

                    state_borrow_11 = (zx_abi).zx_type_13{ .columns = (operand_10).columns, .count = (operand_10).count, .start = (operand_10).start, };

                    break :block_12 (try function_3(allocator, ((operand_10).zx_origin orelse (&state_borrow_11))));
                }

                break :block_22 value_14;
            };
        }

        break :block_25 block_24: {
            break :block_24 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_23: {
                break :block_23 (zx_abi).zx_type_16{ .columns = (state_1).columns, .remaining = (state_1).remaining, };
            });
        };
    };

    return;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!void {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = (try function_4(allocator, in));

    return;
}
