const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_21;
pub const Output = *const (zx_abi).zx_type_22;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .block_size = zx_shape_4, .cost = zx_shape_4, .length = zx_shape_4, .max_memory = zx_shape_5, .parallelism = zx_shape_4, .password = zx_shape_11, .salt = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .left = zx_shape_11, .right = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .data = zx_shape_11, .key = zx_shape_11, .tag = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .data = zx_shape_11, .key = zx_shape_11, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .info = zx_shape_11, .key = zx_shape_11, .length = zx_shape_4, .salt = zx_shape_11, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .iterations = zx_shape_4, .length = zx_shape_4, .password = zx_shape_11, .salt = zx_shape_11, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .aad = zx_shape_11, .data = zx_shape_11, .key = zx_shape_11, .nonce = zx_shape_11, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .ciphertext = zx_shape_11, .tag = zx_shape_11, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .aad = zx_shape_11, .ciphertext = zx_shape_11, .key = zx_shape_11, .nonce = zx_shape_11, .tag = zx_shape_11, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .bytes = zx_shape_11, .text = zx_shape_10, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .base64 = zx_shape_10, .base64_bytes = zx_shape_11, .hex = zx_shape_10, .hex_bytes = zx_shape_11, .sha256 = zx_shape_11, .sha512 = zx_shape_11, .text = zx_shape_10, .utf8 = zx_shape_11, }, };
pub const input_shape = zx_shape_21;
pub const output_shape = zx_shape_22;

fn function_0(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).crypto).sha256(allocator, in));

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).crypto).sha512(allocator, in));

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).timingSafeEqual(in));

    _ = allocator;

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).verifyHmacSha256(in));

    _ = allocator;

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).verifyHmacSha512(in));

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hmacSha256(allocator, in));

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hmacSha512(allocator, in));

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hkdfSha256(allocator, in));

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hkdfSha512(allocator, in));

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).pbkdf2Sha256(allocator, in));

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).pbkdf2Sha512(allocator, in));

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) anyerror!*const (zx_abi).zx_type_19 {
    const native_result = (try ((zx_native_0).crypto).encryptAes128Gcm(allocator, in));

    return native_result;
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptAes128Gcm(allocator, in));

    return native_result;
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) anyerror!*const (zx_abi).zx_type_19 {
    const native_result = (try ((zx_native_0).crypto).encryptAes256Gcm(allocator, in));

    return native_result;
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptAes256Gcm(allocator, in));

    return native_result;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) anyerror!*const (zx_abi).zx_type_19 {
    const native_result = (try ((zx_native_0).crypto).encryptChaCha20Poly1305(allocator, in));

    return native_result;
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptChaCha20Poly1305(allocator, in));

    return native_result;
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).scrypt(allocator, in));

    return native_result;
}

fn function_18(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeBase64(allocator, in));

    return native_result;
}

fn function_19(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidPadding, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeBase64(allocator, in));

    return native_result;
}

fn function_20(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, Overflow, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeHex(allocator, in));

    return native_result;
}

fn function_21(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidHex, InvalidLength, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeHex(allocator, in));

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeUtf8(in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_21) error{ InvalidCharacter, InvalidHex, InvalidLength, InvalidPadding, InvalidUtf8, NoSpaceLeft, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: []const u8 = (try function_18(allocator, (in).bytes));
    const value_2: []const u8 = (try function_20(allocator, (in).bytes));
    const value_3: []const u8 = (try function_22(allocator, (in).text));

    return block_11: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = (try function_19(allocator, value_1));
        const operand_4 = (try function_21(allocator, value_2));
        const operand_5 = value_3;
        const operand_6 = (try function_23(allocator, value_3));
        const operand_7 = (try function_0(allocator, (in).bytes));
        const operand_8 = (try function_1(allocator, (in).bytes));

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_9).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .base64 = operand_1, .hex = operand_2, .base64_bytes = operand_3, .hex_bytes = operand_4, .utf8 = operand_5, .text = operand_6, .sha256 = operand_7, .sha512 = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_22, operand_9);
        };
    };
}

