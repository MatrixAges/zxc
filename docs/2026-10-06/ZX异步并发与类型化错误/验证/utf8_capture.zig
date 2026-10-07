const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = []const u8;
pub const Output = []const u8;
pub const consumes_input = false;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_12 = .{ .kind = .scalar, };
const zx_shape_13 = .{ .kind = .optional, .child = zx_shape_12, };
const zx_shape_14 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_14, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_10;

fn function_0(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeBase64(allocator, in));

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidPadding, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeBase64(allocator, in));

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, Overflow, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeHex(allocator, in));

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidHex, InvalidLength, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeHex(allocator, in));

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeUtf8(in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u8) error{ }![]const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const tuple_1 = zx_capture_3: {
        break :zx_capture_3 @as((zx_abi).zx_type_15, .{ null, @as(?[]const u8, (function_5(allocator, in) catch |zx_error_2| break :zx_capture_3 @as((zx_abi).zx_type_15, .{ zx_error_2, null, }))), });
    };

    const value_1 = (tuple_1).@"0";
    const value_2 = (tuple_1).@"1";

    if ((value_1 != null)) {
        return (if ((value_1.? == @as(error{ InvalidUtf8, }, error.InvalidUtf8))) @as([]const u8, "invalid") else @as([]const u8, "unexpected"));
    }

    return value_2.?;
}

