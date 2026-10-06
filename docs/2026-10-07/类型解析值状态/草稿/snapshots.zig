const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = []const u8;
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
        .bytes = zx_shape_11,
        .index = zx_shape_5,
        .names = zx_shape_12,
        .source = zx_shape_11,
    },
};

const zx_shape_14 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_12,
        .@"1" = zx_shape_0,
    },
};

pub const input_shape = zx_shape_11;
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

fn function_6(allocator: ((std).mem).Allocator, in: []const u8) error{
    InvalidUtf8,
}![]const u8 {
    @setRuntimeSafety(true);

    return (try function_5(allocator, in));
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u8) error{
    IndexOutOfBounds,
    InvalidUtf8,
    OutOfMemory,
    Overflow,
}![]const []const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u8 = block_36: {
        const operand_35 = @as(u8, 0);

        break :block_36 (try (allocator).dupe(u8, (&[_]u8{
            operand_35,
        })));
    };

    const value_2: []const []const u8 = block_34: {
        break :block_34 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_20: *const (zx_abi).zx_type_13 = block_33: {
        const operand_9 = block_8: {
            const operand_2 = in;
            const operand_3 = @as(u64, 0);
            const operand_4 = value_1;
            const operand_5 = value_2;

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_6).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{
                    .source = operand_2,
                    .index = operand_3,
                    .bytes = operand_4,
                    .names = operand_5,
                });

                break :block_7 @as(*const (zx_abi).zx_type_13, operand_6);
            };
        };

        var state_1: (zx_abi).zx_type_13 = (operand_9).*;
        var state_changed_10 = false;

        while ((((&state_1)).index < @as(u64, (((&state_1)).source).len))) {
            state_1 = block_29: {
                const value_5: (zx_abi).zx_type_13 = ((&state_1)).*;
                const value_6: []const u8 = ((&value_5)).bytes;
                const value_7: u64 = @as(u64, 0);

                _ = block_28: {
                    const operand_26 = value_6;
                    const operand_27 = value_7;

                    if ((operand_27 >= (operand_26).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_28 (operand_26)[@intCast(operand_27)];
                };
                const value_9: u8 = block_25: {
                    const operand_23 = ((&state_1)).source;
                    const operand_24 = ((&state_1)).index;

                    if ((operand_24 >= (operand_23).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_25 (operand_23)[@intCast(operand_24)];
                };
                const value_10: (zx_abi).zx_type_13 = block_22: {
                    break :block_22 (zx_abi).zx_type_13{
                        .bytes = block_21: {
                            const operand_17 = value_6;
                            const operand_18 = value_7;
                            const operand_19 = value_9;

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_20 = (try (allocator).dupe(u8, operand_17));

                            (operand_20)[@intCast(operand_18)] = operand_19;

                            break :block_21 operand_20;
                        },
                        .index = ((&value_5)).index,
                        .names = ((&value_5)).names,
                        .source = ((&value_5)).source,
                    };
                };

                const value_11: []const u8 = (try function_6(allocator, ((&value_10)).bytes));
                const value_12: (zx_abi).zx_type_13 = ((&value_10)).*;

                _ = ((&value_12)).names;

                const value_14: []const []const u8 = (block_16: {
                    const operand_13 = ((&value_10)).names;
                    const operand_14 = value_11;
                    const operand_15 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_13).len, 1))));

                    @memcpy((operand_15)[0..(operand_13).len], operand_13);
                    (operand_15)[(operand_13).len] = operand_14;

                    break :block_16 @as((zx_abi).zx_type_14, .{
                        operand_15,
                        {},
                    });
                }).@"0";
                const value_15: (zx_abi).zx_type_13 = block_12: {
                    break :block_12 (zx_abi).zx_type_13{
                        .bytes = ((&value_12)).bytes,
                        .index = ((&value_12)).index,
                        .names = value_14,
                        .source = ((&value_12)).source,
                    };
                };

                const value_16: (zx_abi).zx_type_13 = ((&value_15)).*;
                const value_17: u64 = ((&value_16)).index;
                const value_18: u64 = @as(u64, 1);

                const value_19: (zx_abi).zx_type_13 = block_11: {
                    break :block_11 (zx_abi).zx_type_13{
                        .bytes = ((&value_16)).bytes,
                        .index = (value_17 + value_18),
                        .names = ((&value_16)).names,
                        .source = ((&value_16)).source,
                    };
                };

                break :block_29 ((&value_19)).*;
            };

            state_changed_10 = true;
        }

        break :block_33 (if (state_changed_10) block_32: {
            const operand_31 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_31).* = @as((zx_abi).zx_type_13, state_1);

            break :block_32 @as(*const (zx_abi).zx_type_13, operand_31);
        } else operand_9);
    };

    return (value_20).names;
}
