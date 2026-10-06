const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_19;
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
    .kind = .object,
    .fields = .{
        .span = zx_shape_14,
        .state = zx_shape_13,
    },
};

const zx_shape_16 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_11,
        .@"1" = zx_shape_11,
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
    .kind = .list,
    .child = zx_shape_14,
};

const zx_shape_19 = .{
    .kind = .object,
    .fields = .{
        .source = zx_shape_11,
        .spans = zx_shape_18,
    },
};

pub const input_shape = zx_shape_19;
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

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{
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

            break :block_6 @as((zx_abi).zx_type_17, .{
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

fn function_6_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{
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

            break :block_24 @as((zx_abi).value_zx_type_17_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
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

fn function_6_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, buffers: struct {
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

            break :block_46 @as((zx_abi).value_zx_type_17_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{
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

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_19) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}![]const []const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const []const u8 = block_21: {
        break :block_21 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_4: *const (zx_abi).zx_type_13 = block_20: {
        const operand_1 = (in).spans;

        const operand_7 = block_6: {
            const operand_2 = (in).source;
            const operand_3 = value_1;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_4).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                    .source = operand_2,
                    .names = operand_3,
                });

                break :block_5 @as(*const (zx_abi).zx_type_13, operand_4);
            };
        };

        var value_2: (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{
            .names = (operand_7).names,
            .source = (operand_7).source,
            .zx_origin = operand_7,
        };

        var state_changed_8 = false;
        var field_items_9: (std).ArrayList([]const u8) = .empty;
        var field_started_10 = false;

        defer (field_items_9).deinit(allocator);

        for (operand_1) |value_3| {
            value_2 = @as((zx_abi).value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_15: {
                break :block_15 (try function_6_buffered(allocator, block_14: {
                    const operand_11 = value_2;

                    const operand_12 = block_13: {
                        break :block_13 value_3;
                    };

                    break :block_14 @as((zx_abi).value_zx_type_15_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_15_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{
                        .state = operand_11,
                        .span = operand_12,
                    });
                }, .{
                    .lane_0 = .{
                        .buffer = (&field_items_9),
                        .started = (&field_started_10),
                    },
                }));
            });

            state_changed_8 = true;
        }

        var state_owned_16: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_16);

        if (field_started_10) {
            ((field_items_9).items).len = ((value_2).names).len;
            state_owned_16 = (try (field_items_9).toOwnedSlice(allocator));
        }

        if (field_started_10) {
            (value_2).names = state_owned_16;
            (value_2).zx_origin = null;
        }

        break :block_20 (if (state_changed_8) block_19: {
            break :block_19 (if (((value_2).zx_origin != null)) (value_2).zx_origin.? else block_18: {
                const operand_17 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_17).* = (zx_abi).zx_type_13{
                    .names = (value_2).names,
                    .source = (value_2).source,
                };

                break :block_18 @as(*const (zx_abi).zx_type_13, operand_17);
            });
        } else operand_7);
    };

    return (value_4).names;
}
