const std = @import("std");

const zx_type_11 = struct {
    count: u64,
    position: u64,
};

const zx_type_13 = struct {
    count: u64,
    frames: []const *const zx_type_11,
};

const zx_type_15 = struct {
    columns: []const u64,
    count: u64,
    frames: []const *const zx_type_11,
    index: u64,
    total: u64,
};

const zx_type_16 = struct {
    columns: []const u64,
    total: u64,
};

const zx_type_17 = struct {
    []const *const zx_type_11,
    void,
};

const zx_type_19 = struct {
    []const *const zx_type_11,
    ?*const zx_type_11,
};

const zx_type_20 = struct {
    []const u64,
    void,
};

const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    count: u64,
    frames: []const *const zx_type_11,
    zx_origin: ?*const zx_type_13 = null,
};

const value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    columns: []const u64,
    count: u64,
    frames: []const *const zx_type_11,
    index: u64,
    total: u64,
    zx_origin: ?*const zx_type_15 = null,
};

const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    columns: []const u64,
    total: u64,
    zx_origin: ?*const zx_type_16 = null,
};

const value_zx_type_17_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const *const zx_type_11,
    void,
    ?*const zx_type_17,
};

const value_zx_type_19_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct {
    []const *const zx_type_11,
    ?*const zx_type_11,
    ?*const zx_type_19,
};

const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const u64,
    void,
    ?*const zx_type_20,
};

pub const Input = *const zx_type_13;
pub const Output = *const zx_type_16;
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
    .kind = .object,
    .fields = .{
        .count = zx_shape_5,
        .position = zx_shape_5,
    },
};

const zx_shape_12 = .{
    .kind = .list,
    .child = zx_shape_11,
};

const zx_shape_13 = .{
    .kind = .object,
    .fields = .{
        .count = zx_shape_5,
        .frames = zx_shape_12,
    },
};

const zx_shape_14 = .{
    .kind = .list,
    .child = zx_shape_5,
};

const zx_shape_15 = .{
    .kind = .object,
    .fields = .{
        .columns = zx_shape_14,
        .count = zx_shape_5,
        .frames = zx_shape_12,
        .index = zx_shape_5,
        .total = zx_shape_5,
    },
};

const zx_shape_16 = .{
    .kind = .object,
    .fields = .{
        .columns = zx_shape_14,
        .total = zx_shape_5,
    },
};

const zx_shape_17 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_12,
        .@"1" = zx_shape_0,
    },
};

const zx_shape_18 = .{
    .kind = .optional,
    .child = zx_shape_11,
};

const zx_shape_19 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_12,
        .@"1" = zx_shape_18,
    },
};

const zx_shape_20 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_14,
        .@"1" = zx_shape_0,
    },
};

pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_16;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_15) error{
    OutOfMemory,
    Overflow,
}!*const zx_type_15 {
    @setRuntimeSafety(true);

    const tuple_24 = block_35: {
        const operand_25 = (in).frames;

        const operand_31 = block_30: {
            const operand_26 = (in).index;
            const operand_27 = (in).total;

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create(zx_type_11));

                (operand_28).* = @as(zx_type_11, zx_type_11{
                    .position = operand_26,
                    .count = operand_27,
                });

                break :block_29 @as(*const zx_type_11, operand_28);
            };
        };

        const operand_32 = (try (allocator).alloc(*const zx_type_11, (try ((std).math).add(usize, (operand_25).len, 1))));

        @memcpy((operand_32)[0..(operand_25).len], operand_25);

        (operand_32)[(operand_25).len] = operand_31;

        break :block_35 block_34: {
            const operand_33 = (try (allocator).create(zx_type_17));

            (operand_33).* = @as(zx_type_17, .{
                operand_32,
                {},
            });

            break :block_34 @as(*const zx_type_17, operand_33);
        };
    };

    const value_1 = (tuple_24).@"0";

    const tuple_19 = block_23: {
        const operand_20 = value_1;

        break :block_23 block_22: {
            const operand_21 = (try (allocator).create(zx_type_19));

            (operand_21).* = @as(zx_type_19, (if (((operand_20).len == 0)) .{
                operand_20,
                null,
            } else .{
                (operand_20)[0..((operand_20).len - 1)],
                (operand_20)[((operand_20).len - 1)],
            }));

            break :block_22 @as(*const zx_type_19, operand_21);
        };
    };

    const value_2 = (tuple_19).@"0";
    const value_3 = (tuple_19).@"1";

    if ((value_3 == null)) {
        return block_18: {
            const operand_13 = in;
            const operand_14 = value_2;
            const operand_15 = ((in).index + @as(u64, 1));

            break :block_18 block_17: {
                const operand_16 = (try (allocator).create(zx_type_15));

                (operand_16).* = @as(zx_type_15, zx_type_15{
                    .columns = (operand_13).columns,
                    .count = (operand_13).count,
                    .frames = operand_14,
                    .index = operand_15,
                    .total = (operand_13).total,
                });

                break :block_17 @as(*const zx_type_15, operand_16);
            };
        };
    }

    const value_4: u64 = (((in).total + (value_3.?).count) + @as(u64, 1));

    return block_12: {
        const operand_1 = in;
        const operand_2 = value_2;

        const operand_3 = (block_7: {
            const operand_4 = (in).columns;
            const operand_5 = value_4;
            const operand_6 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_4).len, 1))));

            @memcpy((operand_6)[0..(operand_4).len], operand_4);

            (operand_6)[(operand_4).len] = operand_5;

            break :block_7 @as(zx_type_20, .{
                operand_6,
                {},
            });
        }).@"0";

        const operand_8 = ((in).index + @as(u64, 1));
        const operand_9 = value_4;

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create(zx_type_15));

            (operand_10).* = @as(zx_type_15, zx_type_15{
                .columns = operand_3,
                .count = (operand_1).count,
                .frames = operand_2,
                .index = operand_8,
                .total = operand_9,
            });

            break :block_11 @as(*const zx_type_15, operand_10);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce) error{
    OutOfMemory,
    Overflow,
}!value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const tuple_60 = block_69: {
        const operand_61 = (in).frames;

        const operand_67 = block_66: {
            const operand_62 = (in).index;
            const operand_63 = (in).total;

            break :block_66 block_65: {
                const operand_64 = (try (allocator).create(zx_type_11));

                (operand_64).* = @as(zx_type_11, zx_type_11{
                    .position = operand_62,
                    .count = operand_63,
                });

                break :block_65 @as(*const zx_type_11, operand_64);
            };
        };

        const operand_68 = (try (allocator).alloc(*const zx_type_11, (try ((std).math).add(usize, (operand_61).len, 1))));

        @memcpy((operand_68)[0..(operand_61).len], operand_61);

        (operand_68)[(operand_61).len] = operand_67;

        break :block_69 @as(value_zx_type_17_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
            operand_68,
            {},
            null,
        });
    };

    const value_1 = (tuple_60).@"0";

    const tuple_56 = block_59: {
        const operand_58 = block_57: {
            break :block_57 value_1;
        };

        break :block_59 @as(value_zx_type_19_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_58).len == 0)) .{
            operand_58,
            null,
            null,
        } else .{
            (operand_58)[0..((operand_58).len - 1)],
            (operand_58)[((operand_58).len - 1)],
            null,
        }));
    };

    const value_2 = (tuple_56).@"0";
    const value_3 = (tuple_56).@"1";

    if ((block_50: {
        break :block_50 value_3;
    } == null)) {
        return block_55: {
            const operand_51 = in;

            const operand_52 = block_53: {
                break :block_53 value_2;
            };

            const operand_54 = ((in).index + @as(u64, 1));

            break :block_55 @as(value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
                .columns = (operand_51).columns,
                .count = (operand_51).count,
                .frames = operand_52,
                .index = operand_54,
                .total = (operand_51).total,
            });
        };
    }

    const value_4: u64 = (((in).total + (block_49: {
        break :block_49 value_3;
    }.?).count) + @as(u64, 1));

    return block_48: {
        const operand_36 = in;

        const operand_37 = block_38: {
            break :block_38 value_2;
        };
        const operand_39 = (block_44: {
            const operand_40 = (in).columns;

            const operand_42 = block_41: {
                break :block_41 value_4;
            };

            const operand_43 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_40).len, 1))));

            @memcpy((operand_43)[0..(operand_40).len], operand_40);

            (operand_43)[(operand_40).len] = operand_42;

            break :block_44 @as(value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_43,
                {},
                null,
            });
        }).@"0";

        const operand_45 = ((in).index + @as(u64, 1));

        const operand_46 = block_47: {
            break :block_47 value_4;
        };

        break :block_48 @as(value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_15_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{
            .columns = operand_39,
            .count = (operand_36).count,
            .frames = operand_37,
            .index = operand_45,
            .total = operand_46,
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_13) error{
    OutOfMemory,
    Overflow,
}!*const zx_type_16 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_15 = block_54: {
        const operand_46 = (in).frames;

        const operand_47 = block_48: {
            break :block_48 (try (allocator).dupe(u64, (&[_]u64{})));
        };

        const operand_49 = (in).count;
        const operand_50 = @as(u64, 0);
        const operand_51 = @as(u64, 0);

        break :block_54 block_53: {
            const operand_52 = (try (allocator).create(zx_type_15));

            (operand_52).* = @as(zx_type_15, zx_type_15{
                .frames = operand_46,
                .columns = operand_47,
                .count = operand_49,
                .index = operand_50,
                .total = operand_51,
            });

            break :block_53 @as(*const zx_type_15, operand_52);
        };
    };

    return block_45: {
        const operand_1 = value_1;
        var state_capacity_3: (std).ArrayList(u64) = .empty;
        var state_capacity_started_4 = false;

        defer (state_capacity_3).deinit(allocator);

        const state_type_5 = struct {
            count: u64,
            position: u64,
        };

        var state_capacity_6: (std).ArrayList(state_type_5) = .empty;
        var state_capacity_started_7 = false;

        defer (state_capacity_6).deinit(allocator);

        const state_type_8 = struct {
            columns: []const u64,
            count: u64,
            frames: []const state_type_5,
            index: u64,
            total: u64,
        };

        const operand_9 = (operand_1).frames;

        (try (state_capacity_6).ensureTotalCapacity(allocator, (operand_9).len));
        ((state_capacity_6).items).len = (operand_9).len;

        for (operand_9, 0..) |initial_element_10, initial_index_11| {
            ((state_capacity_6).items)[initial_index_11] = state_type_5{
                .count = (initial_element_10).count,
                .position = (initial_element_10).position,
            };
        }

        state_capacity_started_7 = true;

        var local_state_2: state_type_8 = state_type_8{
            .columns = (operand_1).columns,
            .count = (operand_1).count,
            .frames = @as([]const state_type_5, (state_capacity_6).items),
            .index = (operand_1).index,
            .total = (operand_1).total,
        };
        const state_type_18 = struct {
            []const u64,
            void,
        };
        const state_type_27 = struct {
            []const state_type_5,
            ?state_type_5,
        };
        const state_type_30 = struct {
            []const state_type_5,
            void,
        };

        while (((local_state_2).index < (local_state_2).count)) {
            local_state_2 = block_38: {
                const value_4: state_type_8 = block_37: {
                    const value_6: state_type_8 = local_state_2;
                    const value_12: state_type_30 = block_36: {
                        const operand_31 = (value_6).frames;

                        const operand_35 = block_34: {
                            const operand_32 = (value_6).index;
                            const operand_33 = (value_6).total;

                            break :block_34 state_type_5{
                                .position = operand_32,
                                .count = operand_33,
                            };
                        };

                        _ = (try ((std).math).add(usize, (operand_31).len, 1));

                        if ((!state_capacity_started_7)) {
                            (try (state_capacity_6).appendSlice(allocator, operand_31));

                            state_capacity_started_7 = true;
                        } else {
                            ((state_capacity_6).items).len = (operand_31).len;
                        }

                        (try (state_capacity_6).append(allocator, operand_35));

                        break :block_36 @as(state_type_30, .{
                            (state_capacity_6).items,
                            {},
                        });
                    };
                    const value_7: []const state_type_5 = (value_12).@"0";

                    const value_11: state_type_27 = block_29: {
                        const operand_28 = value_7;

                        break :block_29 @as(state_type_27, (if (((operand_28).len == 0)) .{
                            operand_28,
                            null,
                        } else .{
                            (operand_28)[0..((operand_28).len - 1)],
                            (operand_28)[((operand_28).len - 1)],
                        }));
                    };
                    const value_8: []const state_type_5 = (value_11).@"0";
                    const value_9: ?state_type_5 = (value_11).@"1";

                    break :block_37 (if ((value_9 == null)) block_15: {
                        const operand_12 = value_6;
                        const operand_13 = value_8;
                        const operand_14 = ((value_6).index + @as(u64, 1));

                        break :block_15 state_type_8{
                            .columns = (operand_12).columns,
                            .count = (operand_12).count,
                            .frames = operand_13,
                            .index = operand_14,
                            .total = (operand_12).total,
                        };
                    } else block_26: {
                        const value_10: u64 = (((value_6).total + (value_9.?).count) + @as(u64, 1));

                        break :block_26 block_25: {
                            const operand_16 = value_6;
                            const operand_17 = value_8;
                            const operand_22 = (block_21: {
                                const operand_19 = (value_6).columns;
                                const operand_20 = value_10;
                                _ = (try ((std).math).add(usize, (operand_19).len, 1));

                                if ((!state_capacity_started_4)) {
                                    (try (state_capacity_3).appendSlice(allocator, operand_19));

                                    state_capacity_started_4 = true;
                                } else {
                                    ((state_capacity_3).items).len = (operand_19).len;
                                }

                                (try (state_capacity_3).append(allocator, operand_20));

                                break :block_21 @as(state_type_18, .{
                                    (state_capacity_3).items,
                                    {},
                                });
                            }).@"0";

                            const operand_23 = ((value_6).index + @as(u64, 1));
                            const operand_24 = value_10;

                            break :block_25 state_type_8{
                                .columns = operand_22,
                                .count = (operand_16).count,
                                .frames = operand_17,
                                .index = operand_23,
                                .total = operand_24,
                            };
                        };
                    });
                };

                break :block_38 value_4;
            };
        }

        var state_owned_39: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_39);

        if (state_capacity_started_4) {
            ((state_capacity_3).items).len = ((local_state_2).columns).len;
            state_owned_39 = (try (state_capacity_3).toOwnedSlice(allocator));
        }

        if (state_capacity_started_4) {
            (local_state_2).columns = state_owned_39;
        }

        break :block_45 block_44: {
            const operand_40 = (local_state_2).columns;
            const operand_41 = (local_state_2).total;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create(zx_type_16));

                (operand_42).* = @as(zx_type_16, zx_type_16{
                    .columns = operand_40,
                    .total = operand_41,
                });

                break :block_43 @as(*const zx_type_16, operand_42);
            };
        };
    };
}
