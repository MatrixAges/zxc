const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_21;
pub const Output = *const (zx_abi).zx_type_22;
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
        .label = zx_shape_10,
        .value = zx_shape_5,
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
        .label = zx_shape_10,
        .seen = zx_shape_5,
        .values = zx_shape_12,
    },
};

const zx_shape_14 = .{
    .kind = .object,
    .fields = .{
        .selected = zx_shape_5,
        .values = zx_shape_12,
    },
};

const zx_shape_15 = .{
    .kind = .object,
    .fields = .{
        .item = zx_shape_5,
        .state = zx_shape_13,
    },
};

const zx_shape_16 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_10,
        .@"1" = zx_shape_5,
    },
};

const zx_shape_17 = .{
    .kind = .optional,
    .child = zx_shape_11,
};

const zx_shape_18 = .{
    .kind = .object,
    .fields = .{
        .cell = zx_shape_11,
        .length = zx_shape_5,
        .maybe = zx_shape_17,
        .pair = zx_shape_16,
    },
};

const zx_shape_19 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_12,
        .@"1" = zx_shape_0,
    },
};

const zx_shape_20 = .{
    .kind = .list,
    .child = zx_shape_5,
};

const zx_shape_21 = .{
    .kind = .object,
    .fields = .{
        .label = zx_shape_10,
        .seed = zx_shape_12,
        .steps = zx_shape_20,
    },
};

const zx_shape_22 = .{
    .kind = .object,
    .fields = .{
        .count = zx_shape_5,
        .label = zx_shape_10,
        .mirror = zx_shape_12,
        .original = zx_shape_12,
        .seen = zx_shape_5,
        .values = zx_shape_12,
    },
};

pub const input_shape = zx_shape_21;
pub const output_shape = zx_shape_22;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{
    IndexOutOfBounds,
    OutOfMemory,
}!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_11 = block_20: {
        const operand_18 = (in).values;
        const operand_19 = (in).selected;

        if ((operand_19 >= (operand_18).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_20 (operand_18)[@intCast(operand_19)];
    };

    return block_17: {
        const operand_1 = block_6: {
            const operand_2 = (value_1).value;
            const operand_3 = (value_1).label;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_4).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                    .value = operand_2,
                    .label = operand_3,
                });

                break :block_5 @as(*const (zx_abi).zx_type_11, operand_4);
            };
        };

        const operand_7 = @as(u64, ((in).values).len);

        const operand_8 = block_13: {
            const operand_9 = (value_1).label;
            const operand_10 = (value_1).value;

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_11).* = @as((zx_abi).zx_type_16, .{
                    operand_9,
                    operand_10,
                });

                break :block_12 @as(*const (zx_abi).zx_type_16, operand_11);
            };
        };

        const operand_14 = (if ((@rem((in).selected, @as(u64, 2)) == @as(u64, 0))) @as(?*const (zx_abi).zx_type_11, value_1) else @as(?*const (zx_abi).zx_type_11, null));

        break :block_17 block_16: {
            const operand_15 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_15).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{
                .cell = operand_1,
                .length = operand_7,
                .pair = operand_8,
                .maybe = operand_14,
            });

            break :block_16 @as(*const (zx_abi).zx_type_18, operand_15);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{
    IndexOutOfBounds,
    OutOfMemory,
}!(zx_abi).value_zx_type_18_16d7e2267b03d4dba1bc55f52947b317ed15ce81fce52ca74687d67ffc990304 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_11 = block_41: {
        const operand_39 = (in).values;
        const operand_40 = (in).selected;

        if ((operand_40 >= (operand_39).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_41 (operand_39)[@intCast(operand_40)];
    };

    return block_38: {
        const operand_21 = block_28: {
            const operand_22 = (block_23: {
                break :block_23 value_1;
            }).value;

            const operand_24 = (block_25: {
                break :block_25 value_1;
            }).label;

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_26).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                    .value = operand_22,
                    .label = operand_24,
                });

                break :block_27 @as(*const (zx_abi).zx_type_11, operand_26);
            };
        };

        const operand_29 = @as(u64, ((in).values).len);

        const operand_30 = block_35: {
            const operand_32 = (block_31: {
                break :block_31 value_1;
            }).label;

            const operand_34 = (block_33: {
                break :block_33 value_1;
            }).value;

            break :block_35 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_32,
                operand_34,
                null,
            });
        };

        const operand_36 = (if ((@rem((in).selected, @as(u64, 2)) == @as(u64, 0))) @as(?*const (zx_abi).zx_type_11, block_37: {
            break :block_37 value_1;
        }) else @as(?*const (zx_abi).zx_type_11, null));

        break :block_38 @as((zx_abi).value_zx_type_18_16d7e2267b03d4dba1bc55f52947b317ed15ce81fce52ca74687d67ffc990304, (zx_abi).value_zx_type_18_16d7e2267b03d4dba1bc55f52947b317ed15ce81fce52ca74687d67ffc990304{
            .cell = operand_21,
            .length = operand_29,
            .pair = operand_30,
            .maybe = operand_36,
        });
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: u64 = (if ((@as(u64, (((in).state).values).len) == @as(u64, 0))) @as(u64, 0) else @rem((in).item, @as(u64, (((in).state).values).len)));

    const value_2: *const (zx_abi).zx_type_18 = (try function_0(allocator, block_26: {
        const operand_22 = ((in).state).values;
        const operand_23 = value_1;

        break :block_26 block_25: {
            const operand_24 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_24).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{
                .values = operand_22,
                .selected = operand_23,
            });

            break :block_25 @as(*const (zx_abi).zx_type_14, operand_24);
        };
    }));

    return block_21: {
        const operand_1 = (block_10: {
            const operand_2 = ((in).state).values;

            const operand_8 = block_7: {
                const operand_3 = ((((value_2).cell).value + (in).item) + @as(u64, 1));
                const operand_4 = ((value_2).pair).@"0";

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_11));

                    (operand_5).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                        .value = operand_3,
                        .label = operand_4,
                    });

                    break :block_6 @as(*const (zx_abi).zx_type_11, operand_5);
                };
            };

            const operand_9 = (try (allocator).alloc(*const (zx_abi).zx_type_11, (try ((std).math).add(usize, (operand_2).len, 1))));

            @memcpy((operand_9)[0..(operand_2).len], operand_2);

            (operand_9)[(operand_2).len] = operand_8;

            break :block_10 @as((zx_abi).zx_type_19, .{
                operand_9,
                {},
            });
        }).@"0";

        const operand_11 = ((((((in).state).seen + ((value_2).cell).value) + (value_2).length) + ((value_2).pair).@"1") + (((value_2).maybe orelse block_16: {
            const operand_12 = @as(u64, 0);
            const operand_13 = @as([]const u8, "");

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_14).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                    .value = operand_12,
                    .label = operand_13,
                });

                break :block_15 @as(*const (zx_abi).zx_type_11, operand_14);
            };
        })).value);

        const operand_17 = ((value_2).pair).@"0";
        const operand_18 = (((in).state).count + @as(u64, 1));

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_19).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                .values = operand_1,
                .seen = operand_11,
                .label = operand_17,
                .count = operand_18,
            });

            break :block_20 @as(*const (zx_abi).zx_type_13, operand_19);
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: u64 = (if ((@as(u64, (((in).state).values).len) == @as(u64, 0))) @as(u64, 0) else @rem((in).item, @as(u64, (((in).state).values).len)));

    const value_2: (zx_abi).value_zx_type_18_16d7e2267b03d4dba1bc55f52947b317ed15ce81fce52ca74687d67ffc990304 = block_50: {
        break :block_50 (try function_0_value(allocator, block_49: {
            const operand_46 = ((in).state).values;

            const operand_47 = block_48: {
                break :block_48 value_1;
            };

            break :block_49 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                .values = operand_46,
                .selected = operand_47,
            });
        }));
    };

    return block_45: {
        const operand_27 = (block_36: {
            const operand_28 = ((in).state).values;

            const operand_34 = block_33: {
                const operand_29 = ((((value_2).cell).value + (in).item) + @as(u64, 1));
                const operand_30 = ((value_2).pair).@"0";

                break :block_33 block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_11));

                    (operand_31).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                        .value = operand_29,
                        .label = operand_30,
                    });

                    break :block_32 @as(*const (zx_abi).zx_type_11, operand_31);
                };
            };

            const operand_35 = (try (allocator).alloc(*const (zx_abi).zx_type_11, (try ((std).math).add(usize, (operand_28).len, 1))));

            @memcpy((operand_35)[0..(operand_28).len], operand_28);

            (operand_35)[(operand_28).len] = operand_34;

            break :block_36 @as((zx_abi).value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_35,
                {},
                null,
            });
        }).@"0";

        const operand_37 = ((((((in).state).seen + ((value_2).cell).value) + (value_2).length) + ((value_2).pair).@"1") + (((value_2).maybe orelse block_42: {
            const operand_38 = @as(u64, 0);
            const operand_39 = @as([]const u8, "");

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_40).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                    .value = operand_38,
                    .label = operand_39,
                });

                break :block_41 @as(*const (zx_abi).zx_type_11, operand_40);
            };
        })).value);

        const operand_43 = ((value_2).pair).@"0";
        const operand_44 = (((in).state).count + @as(u64, 1));

        break :block_45 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .values = operand_27,
            .seen = operand_37,
            .label = operand_43,
            .count = operand_44,
        });
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_11),
        started: *bool,
    },
}) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: u64 = (if ((@as(u64, (((in).state).values).len) == @as(u64, 0))) @as(u64, 0) else @rem((in).item, @as(u64, (((in).state).values).len)));

    const value_2: (zx_abi).value_zx_type_18_16d7e2267b03d4dba1bc55f52947b317ed15ce81fce52ca74687d67ffc990304 = block_82: {
        break :block_82 (try function_0_value(allocator, block_81: {
            const operand_78 = ((in).state).values;

            const operand_79 = block_80: {
                break :block_80 value_1;
            };

            break :block_81 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                .values = operand_78,
                .selected = operand_79,
            });
        }));
    };

    return block_77: {
        const operand_51 = @as([]const *const (zx_abi).zx_type_11, (if (((buffers).lane_0 != null)) block_59: {
            const operand_52 = ((in).state).values;

            const operand_58 = block_57: {
                const operand_53 = ((((value_2).cell).value + (in).item) + @as(u64, 1));
                const operand_54 = ((value_2).pair).@"0";

                break :block_57 block_56: {
                    const operand_55 = (try (allocator).create((zx_abi).zx_type_11));

                    (operand_55).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                        .value = operand_53,
                        .label = operand_54,
                    });

                    break :block_56 @as(*const (zx_abi).zx_type_11, operand_55);
                };
            };

            _ = (try ((std).math).add(usize, (operand_52).len, 1));

            if ((!(((buffers).lane_0.?).started).*)) {
                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_52));
                (((buffers).lane_0.?).started).* = true;
            } else {
                (((((buffers).lane_0.?).buffer).*).items).len = (operand_52).len;
            }

            (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_58));

            break :block_59 ((((buffers).lane_0.?).buffer).*).items;
        } else (block_68: {
            const operand_60 = ((in).state).values;

            const operand_66 = block_65: {
                const operand_61 = ((((value_2).cell).value + (in).item) + @as(u64, 1));
                const operand_62 = ((value_2).pair).@"0";

                break :block_65 block_64: {
                    const operand_63 = (try (allocator).create((zx_abi).zx_type_11));

                    (operand_63).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                        .value = operand_61,
                        .label = operand_62,
                    });

                    break :block_64 @as(*const (zx_abi).zx_type_11, operand_63);
                };
            };

            const operand_67 = (try (allocator).alloc(*const (zx_abi).zx_type_11, (try ((std).math).add(usize, (operand_60).len, 1))));

            @memcpy((operand_67)[0..(operand_60).len], operand_60);

            (operand_67)[(operand_60).len] = operand_66;

            break :block_68 @as((zx_abi).value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_67,
                {},
                null,
            });
        }).@"0"));

        const operand_69 = ((((((in).state).seen + ((value_2).cell).value) + (value_2).length) + ((value_2).pair).@"1") + (((value_2).maybe orelse block_74: {
            const operand_70 = @as(u64, 0);
            const operand_71 = @as([]const u8, "");

            break :block_74 block_73: {
                const operand_72 = (try (allocator).create((zx_abi).zx_type_11));

                (operand_72).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{
                    .value = operand_70,
                    .label = operand_71,
                });

                break :block_73 @as(*const (zx_abi).zx_type_11, operand_72);
            };
        })).value);

        const operand_75 = ((value_2).pair).@"0";
        const operand_76 = (((in).state).count + @as(u64, 1));

        break :block_77 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .values = operand_51,
            .seen = operand_69,
            .label = operand_75,
            .count = operand_76,
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_21) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_2: []const *const (zx_abi).zx_type_11 = block_35: {
        const operand_32 = (in).seed;
        const operand_33 = (try (allocator).alloc(*const (zx_abi).zx_type_11, (operand_32).len));

        for (operand_32, 0..) |value_1, index_34| {
            (operand_33)[index_34] = value_1;
        }

        break :block_35 operand_33;
    };

    const value_3: *const (zx_abi).zx_type_13 = block_31: {
        const operand_25 = value_2;
        const operand_26 = @as(u64, 0);
        const operand_27 = (in).label;
        const operand_28 = @as(u64, 0);

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                .values = operand_25,
                .seen = operand_26,
                .label = operand_27,
                .count = operand_28,
            });

            break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
        };
    };

    const value_6: *const (zx_abi).zx_type_13 = block_24: {
        const operand_10 = (in).steps;
        const operand_11 = value_3;

        var value_4: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .count = (operand_11).count,
            .label = (operand_11).label,
            .seen = (operand_11).seen,
            .values = (operand_11).values,
            .zx_origin = operand_11,
        };

        var state_changed_12 = false;
        var field_items_13: (std).ArrayList(*const (zx_abi).zx_type_11) = .empty;
        var field_started_14 = false;

        defer (field_items_13).deinit(allocator);

        for (operand_10) |value_5| {
            value_4 = @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, block_19: {
                break :block_19 (try function_1_buffered(allocator, block_18: {
                    const operand_15 = value_4;

                    const operand_16 = block_17: {
                        break :block_17 value_5;
                    };

                    break :block_18 @as((zx_abi).value_zx_type_15_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b, (zx_abi).value_zx_type_15_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b{
                        .state = operand_15,
                        .item = operand_16,
                    });
                }, .{
                    .lane_0 = .{
                        .buffer = (&field_items_13),
                        .started = (&field_started_14),
                    },
                }));
            });

            state_changed_12 = true;
        }

        var state_owned_20: []const *const (zx_abi).zx_type_11 = (&[_]*const (zx_abi).zx_type_11{});

        errdefer (allocator).free(state_owned_20);

        if (field_started_14) {
            ((field_items_13).items).len = ((value_4).values).len;

            state_owned_20 = (try (field_items_13).toOwnedSlice(allocator));
        }

        if (field_started_14) {
            (value_4).values = state_owned_20;
            (value_4).zx_origin = null;
        }

        break :block_24 (if (state_changed_12) block_23: {
            break :block_23 (if (((value_4).zx_origin != null)) (value_4).zx_origin.? else block_22: {
                const operand_21 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_21).* = (zx_abi).zx_type_13{
                    .count = (value_4).count,
                    .label = (value_4).label,
                    .seen = (value_4).seen,
                    .values = (value_4).values,
                };

                break :block_22 @as(*const (zx_abi).zx_type_13, operand_21);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (value_6).values;
        const operand_2 = (value_6).values;
        const operand_3 = (in).seed;
        const operand_4 = (value_6).seen;
        const operand_5 = (value_6).label;
        const operand_6 = (value_6).count;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_7).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{
                .values = operand_1,
                .mirror = operand_2,
                .original = operand_3,
                .seen = operand_4,
                .label = operand_5,
                .count = operand_6,
            });

            break :block_8 @as(*const (zx_abi).zx_type_22, operand_7);
        };
    };
}
