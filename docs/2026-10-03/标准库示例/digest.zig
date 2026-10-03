const std = @import("std");
const runtime = @import("zx_runtime");

const zx_type_12 = struct {
    base64: []const u8,
    decoded: []const u8,
    hex: []const u8,
    sha256: []const u8,
    sha512: []const u8,
};

pub const Input = []const u8;
pub const Output = zx_type_12;

fn function_0(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).encodeBase64(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).encodeBase64, 1, allocator, in))))));
}

fn function_1(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).decodeBase64(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).decodeBase64, 1, allocator, in))))));
}

fn function_2(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).encodeHex(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).encodeHex, 1, allocator, in))))));
}

fn function_3(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).decodeHex(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).decodeHex, 1, allocator, in))))));
}

fn function_4(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).encodeUtf8(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).encodeUtf8, 1, allocator, in))))));
}

fn function_5(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).encoding).decodeUtf8(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).encoding).decodeUtf8, 1, allocator, in))))));
}

fn function_6(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).crypto).sha256(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).crypto).sha256, 1, allocator, in))))));
}

fn function_7(allocator: (runtime).Allocator, in: []const u8) anyerror![]const u8 {
    return (try (runtime).nativeResult([]const u8, allocator, (try (((@import("zx_runtime")).standard).crypto).sha512(allocator, (try (runtime).nativeArgument((((@import("zx_runtime")).standard).crypto).sha512, 1, allocator, in))))));
}

pub fn execute(arena: *(runtime).Arena, in: []const u8) anyerror!zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: []const u8 = (try function_4(allocator, in));
    const value_2: []const u8 = (try function_0(allocator, value_1));
    const value_3: []const u8 = (try function_2(allocator, value_1));
    const value_4: []const u8 = (try function_2(allocator, (try function_6(allocator, value_1))));
    const value_5: []const u8 = (try function_2(allocator, (try function_7(allocator, value_1))));
    const value_6: []const u8 = (try function_5(allocator, (try function_1(allocator, value_2))));

    return block_6: {
        const operand_1 = value_2;
        const operand_2 = value_3;
        const operand_3 = value_4;
        const operand_4 = value_5;
        const operand_5 = value_6;

        break :block_6 zx_type_12{ .base64 = operand_1, .hex = operand_2, .sha256 = operand_3, .sha512 = operand_4, .decoded = operand_5, };
    };
}

