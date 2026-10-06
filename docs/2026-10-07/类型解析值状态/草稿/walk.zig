const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_20;
pub const Output = []const []const u8;
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
    .kind = .list,
    .child = zx_shape_2,
};

const zx_shape_12 = .{
    .kind = .list,
    .child = zx_shape_10,
};

const zx_shape_13 = .{
    .kind = .object,
    .fields = .{
        .names = zx_shape_12,
        .source = zx_shape_11,
    },
};

const zx_shape_14 = .{
    .kind = .object,
    .fields = .{
        .end = zx_shape_5,
        .start = zx_shape_5,
    },
};

const zx_shape_15 = .{
    .kind = .list,
    .child = zx_shape_14,
};

const zx_shape_16 = .{
    .kind = .object,
    .fields = .{
        .index = zx_shape_5,
        .names = zx_shape_12,
        .source = zx_shape_11,
        .spans = zx_shape_15,
    },
};

const zx_shape_17 = .{
    .kind = .object,
    .fields = .{
        .span = zx_shape_14,
        .state = zx_shape_13,
    },
};

const zx_shape_18 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_11,
        .@"1" = zx_shape_11,
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
    .kind = .object,
    .fields = .{
        .source = zx_shape_11,
        .spans = zx_shape_15,
    },
};

pub const input_shape = zx_shape_20;
pub const output_shape = zx_shape_12;

fn function_0(allocator: ((std).mem).Allocator, in: []const u8) error{
    OutOfMemory,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeBase64(allocator, in));

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: []const u8) error{
    InvalidCharacter,
    InvalidPadding,
    NoSpaceLeft,
    OutOfMemory,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeBase64(allocator, in));

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: []const u8) error{
    OutOfMemory,
    Overflow,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeHex(allocator, in));

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: []const u8) error{
    InvalidCharacter,
    InvalidHex,
    InvalidLength,
    NoSpaceLeft,
    OutOfMemory,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeHex(allocator, in));

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: []const u8) error{
    InvalidUtf8,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: []const u8) error{
    InvalidUtf8,
}![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = (try function_5(allocator, block_17: {
        const operand_10 = ((in).state).source;
        const operand_11 = ((in).span).start;
        const operand_12 = (((in).span).end - ((in).span).start);

        const operand_14 = block_13: {
            break :block_13 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        if (((operand_11 > (operand_10).len) or (operand_12 > ((operand_10).len - operand_11)))) {
            return error.IndexOutOfBounds;
        }

        const operand_15 = @as(usize, @intCast(operand_11));
        const operand_16 = @as(usize, @intCast(operand_12));
        _ = (try ((std).math).add(usize, ((operand_10).len - operand_16), (operand_14).len));

        break :block_17 (operand_10)[operand_15..(operand_15 + operand_16)];
    }));

    return block_9: {
        const operand_1 = ((in).state).source;

        const operand_2 = (block_6: {
            const operand_3 = ((in).state).names;
            const operand_4 = value_1;
            const operand_5 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_3).len, 1))));

            @memcpy((operand_5)[0..(operand_3).len], operand_3);

            (operand_5)[(operand_3).len] = operand_4;

            break :block_6 @as((zx_abi).zx_type_19, .{
                operand_5,
                {},
            });
        }).@"0";

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                .source = operand_1,
                .names = operand_2,
            });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

fn function_6_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_35: {
        const operand_34 = block_33: {
            const operand_26 = ((in).state).source;
            const operand_27 = ((in).span).start;
            const operand_28 = (((in).span).end - ((in).span).start);

            const operand_30 = block_29: {
                break :block_29 (try (allocator).dupe(u8, (&[_]u8{})));
            };

            if (((operand_27 > (operand_26).len) or (operand_28 > ((operand_26).len - operand_27)))) {
                return error.IndexOutOfBounds;
            }

            const operand_31 = @as(usize, @intCast(operand_27));
            const operand_32 = @as(usize, @intCast(operand_28));

            _ = (try ((std).math).add(usize, ((operand_26).len - operand_32), (operand_30).len));

            break :block_33 (operand_26)[operand_31..(operand_31 + operand_32)];
        };

        break :block_35 (try function_5(allocator, operand_34));
    };

    return block_25: {
        const operand_18 = ((in).state).source;

        const operand_19 = (block_24: {
            const operand_20 = ((in).state).names;

            const operand_22 = block_21: {
                break :block_21 value_1;
            };

            const operand_23 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_20).len, 1))));

            @memcpy((operand_23)[0..(operand_20).len], operand_20);

            (operand_23)[(operand_20).len] = operand_22;

            break :block_24 @as((zx_abi).value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_23,
                {},
                null,
            });
        }).@"0";

        break :block_25 @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .source = operand_18,
            .names = operand_19,
        });
    };
}

fn function_6_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_57: {
        const operand_56 = block_55: {
            const operand_48 = ((in).state).source;
            const operand_49 = ((in).span).start;
            const operand_50 = (((in).span).end - ((in).span).start);

            const operand_52 = block_51: {
                break :block_51 (try (allocator).dupe(u8, (&[_]u8{})));
            };

            if (((operand_49 > (operand_48).len) or (operand_50 > ((operand_48).len - operand_49)))) {
                return error.IndexOutOfBounds;
            }

            const operand_53 = @as(usize, @intCast(operand_49));
            const operand_54 = @as(usize, @intCast(operand_50));

            _ = (try ((std).math).add(usize, ((operand_48).len - operand_54), (operand_52).len));

            break :block_55 (operand_48)[operand_53..(operand_53 + operand_54)];
        };

        break :block_57 (try function_5(allocator, operand_56));
    };

    return block_47: {
        const operand_36 = ((in).state).source;

        const operand_37 = @as([]const []const u8, (if (((buffers).lane_0 != null)) block_41: {
            const operand_38 = ((in).state).names;

            const operand_40 = block_39: {
                break :block_39 value_1;
            };

            _ = (try ((std).math).add(usize, (operand_38).len, 1));

            if ((!(((buffers).lane_0.?).started).*)) {
                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_38));
                (((buffers).lane_0.?).started).* = true;
            } else {
                (((((buffers).lane_0.?).buffer).*).items).len = (operand_38).len;
            }

            (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_40));

            break :block_41 ((((buffers).lane_0.?).buffer).*).items;
        } else (block_46: {
            const operand_42 = ((in).state).names;

            const operand_44 = block_43: {
                break :block_43 value_1;
            };

            const operand_45 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_42).len, 1))));

            @memcpy((operand_45)[0..(operand_42).len], operand_42);

            (operand_45)[(operand_42).len] = operand_44;

            break :block_46 @as((zx_abi).value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
                operand_45,
                {},
                null,
            });
        }).@"0"));

        break :block_47 @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .source = operand_36,
            .names = operand_37,
        });
    };
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_13 = (try function_6(allocator, block_19: {
        const operand_7 = block_12: {
            const operand_8 = (in).source;
            const operand_9 = (in).names;

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_10).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                    .source = operand_8,
                    .names = operand_9,
                });

                break :block_11 @as(*const (zx_abi).zx_type_13, operand_10);
            };
        };
        const operand_13 = block_16: {
            const operand_14 = (in).spans;
            const operand_15 = (in).index;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        break :block_19 block_18: {
            const operand_17 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_17).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{
                .state = operand_7,
                .span = operand_13,
            });

            break :block_18 @as(*const (zx_abi).zx_type_17, operand_17);
        };
    }));

    return block_6: {
        const operand_1 = in;
        const operand_2 = (value_1).names;
        const operand_3 = ((in).index + @as(u64, 1));

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_4).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{
                .index = operand_3,
                .names = operand_2,
                .source = (operand_1).source,
                .spans = (operand_1).spans,
            });

            break :block_5 @as(*const (zx_abi).zx_type_16, operand_4);
        };
    };
}

fn function_7_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_33: {
        break :block_33 (try function_6_value(allocator, block_32: {
            const operand_24 = block_27: {
                const operand_25 = (in).source;
                const operand_26 = (in).names;

                break :block_27 @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .source = operand_25,
                    .names = operand_26,
                });
            };

            const operand_28 = block_31: {
                const operand_29 = (in).spans;
                const operand_30 = (in).index;

                if ((operand_30 >= (operand_29).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_31 (operand_29)[@intCast(operand_30)];
            };

            break :block_32 @as((zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{
                .state = operand_24,
                .span = operand_28,
            });
        }));
    };

    return block_23: {
        const operand_20 = in;
        const operand_21 = (value_1).names;
        const operand_22 = ((in).index + @as(u64, 1));

        break :block_23 @as((zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .index = operand_22,
            .names = operand_21,
            .source = (operand_20).source,
            .spans = (operand_20).spans,
        });
    };
}

fn function_7_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_47: {
        break :block_47 (try function_6_buffered(allocator, block_46: {
            const operand_38 = block_41: {
                const operand_39 = (in).source;
                const operand_40 = (in).names;

                break :block_41 @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
                    .source = operand_39,
                    .names = operand_40,
                });
            };

            const operand_42 = block_45: {
                const operand_43 = (in).spans;
                const operand_44 = (in).index;

                if ((operand_44 >= (operand_43).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_45 (operand_43)[@intCast(operand_44)];
            };

            break :block_46 @as((zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{
                .state = operand_38,
                .span = operand_42,
            });
        }, .{
            .lane_0 = (if (((buffers).lane_0 != null)) .{
                .buffer = (&(((buffers).lane_0.?).buffer).*),
                .started = (&(((buffers).lane_0.?).started).*),
            } else null),
        }));
    });

    return block_37: {
        const operand_34 = in;
        const operand_35 = (value_1).names;
        const operand_36 = ((in).index + @as(u64, 1));

        break :block_37 @as((zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .index = operand_36,
            .names = operand_35,
            .source = (operand_34).source,
            .spans = (operand_34).spans,
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_20) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}![]const []const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const []const u8 = block_19: {
        break :block_19 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_5: *const (zx_abi).zx_type_16 = block_18: {
        const operand_9 = block_8: {
            const operand_2 = (in).source;
            const operand_3 = (in).spans;
            const operand_4 = value_1;
            const operand_5 = @as(u64, 0);

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_6).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{
                    .source = operand_2,
                    .spans = operand_3,
                    .names = operand_4,
                    .index = operand_5,
                });

                break :block_7 @as(*const (zx_abi).zx_type_16, operand_6);
            };
        };

        var state_capacity_11: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_12 = false;

        defer (state_capacity_11).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
            .index = (operand_9).index,
            .names = (operand_9).names,
            .source = (operand_9).source,
            .spans = (operand_9).spans,
            .zx_origin = operand_9,
        };

        var state_changed_10 = false;

        while (((state_1).index < @as(u64, ((state_1).spans).len))) {
            state_1 = @as((zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, block_13: {
                break :block_13 (try function_7_buffered(allocator, state_1, .{
                    .lane_0 = .{
                        .buffer = (&state_capacity_11),
                        .started = (&state_capacity_started_12),
                    },
                }));
            });

            state_changed_10 = true;
        }

        var state_owned_14: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_14);

        if (state_capacity_started_12) {
            ((state_capacity_11).items).len = ((state_1).names).len;
            state_owned_14 = (try (state_capacity_11).toOwnedSlice(allocator));
        }

        if (state_capacity_started_12) {
            state_1 = (zx_abi).value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{
                .index = (state_1).index,
                .names = state_owned_14,
                .source = (state_1).source,
                .spans = (state_1).spans,
            };
        }

        break :block_18 (if (state_changed_10) block_17: {
            break :block_17 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_15).* = (zx_abi).zx_type_16{
                    .index = (state_1).index,
                    .names = (state_1).names,
                    .source = (state_1).source,
                    .spans = (state_1).spans,
                };

                break :block_16 @as(*const (zx_abi).zx_type_16, operand_15);
            });
        } else operand_9);
    };

    return (value_5).names;
}
