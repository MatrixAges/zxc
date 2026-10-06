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

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_19) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}![]const []const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const []const u8 = block_13: {
        break :block_13 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_4: *const (zx_abi).zx_type_13 = block_12: {
        const operand_1 = (in).spans;

        var value_2: *const (zx_abi).zx_type_13 = block_11: {
            const operand_7 = (in).source;
            const operand_8 = value_1;

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_9).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                    .source = operand_7,
                    .names = operand_8,
                });

                break :block_10 @as(*const (zx_abi).zx_type_13, operand_9);
            };
        };

        for (operand_1) |value_3| {
            value_2 = (try function_6(allocator, block_6: {
                const operand_2 = value_2;
                const operand_3 = value_3;

                break :block_6 block_5: {
                    const operand_4 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_4).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{
                        .state = operand_2,
                        .span = operand_3,
                    });

                    break :block_5 @as(*const (zx_abi).zx_type_15, operand_4);
                };
            }));
        }

        break :block_12 value_2;
    };

    return (value_4).names;
}
