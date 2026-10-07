const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = void;
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
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .name = zx_shape_10, .value = zx_shape_10, }, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_14 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_12, };
const zx_shape_16 = .{ .kind = .optional, .child = zx_shape_15, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .args = zx_shape_13, .command = zx_shape_10, .cwd = zx_shape_14, .env = zx_shape_16, .max_stderr_bytes = zx_shape_5, .max_stdout_bytes = zx_shape_5, }, };
const zx_shape_18 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .input = zx_shape_18, .options = zx_shape_17, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .code = zx_shape_4, .kind = zx_shape_11, .stderr = zx_shape_18, .stdout = zx_shape_18, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .block_size = zx_shape_4, .cost = zx_shape_4, .length = zx_shape_4, .max_memory = zx_shape_5, .parallelism = zx_shape_4, .password = zx_shape_18, .salt = zx_shape_18, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .left = zx_shape_18, .right = zx_shape_18, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .key = zx_shape_18, .tag = zx_shape_18, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .key = zx_shape_18, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .info = zx_shape_18, .key = zx_shape_18, .length = zx_shape_4, .salt = zx_shape_18, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .iterations = zx_shape_4, .length = zx_shape_4, .password = zx_shape_18, .salt = zx_shape_18, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .aad = zx_shape_18, .data = zx_shape_18, .key = zx_shape_18, .nonce = zx_shape_18, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .ciphertext = zx_shape_18, .tag = zx_shape_18, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .aad = zx_shape_18, .ciphertext = zx_shape_18, .key = zx_shape_18, .nonce = zx_shape_18, .tag = zx_shape_18, }, };
const zx_shape_30 = .{ .kind = .scalar, };
const zx_shape_31 = .{ .kind = .optional, .child = zx_shape_7, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .atime_ms = zx_shape_31, .ctime_ms = zx_shape_7, .kind = zx_shape_30, .mtime_ms = zx_shape_7, .size = zx_shape_5, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .max_bytes = zx_shape_5, .path = zx_shape_10, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .path = zx_shape_10, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .path = zx_shape_10, .text = zx_shape_10, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .length = zx_shape_5, .path = zx_shape_10, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .path = zx_shape_10, .recursive = zx_shape_1, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .from = zx_shape_10, .to = zx_shape_10, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .exclusive = zx_shape_1, .from = zx_shape_10, .to = zx_shape_10, }, };
const zx_shape_40 = .{ .kind = .scalar, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .name = zx_shape_10, .value = zx_shape_18, }, };
const zx_shape_42 = .{ .kind = .list, .child = zx_shape_41, };
const zx_shape_43 = .{ .kind = .optional, .child = zx_shape_18, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .body = zx_shape_43, .headers = zx_shape_42, .max_body_bytes = zx_shape_5, .max_header_bytes = zx_shape_5, .method = zx_shape_40, .url = zx_shape_10, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .body = zx_shape_18, .headers = zx_shape_42, .status = zx_shape_3, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .base = zx_shape_10, .dir = zx_shape_10, .ext = zx_shape_10, .name = zx_shape_10, .root = zx_shape_10, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .cwd = zx_shape_10, .paths = zx_shape_13, }, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .cwd = zx_shape_10, .from = zx_shape_10, .to = zx_shape_10, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .key = zx_shape_10, .value = zx_shape_10, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .assignment = zx_shape_10, .max_keys = zx_shape_4, .query = zx_shape_10, .separator = zx_shape_10, }, };
const zx_shape_51 = .{ .kind = .list, .child = zx_shape_49, };
const zx_shape_52 = .{ .kind = .object, .fields = .{ .assignment = zx_shape_10, .entries = zx_shape_51, .separator = zx_shape_10, }, };
const zx_shape_53 = .{ .kind = .optional, .child = zx_shape_3, };
const zx_shape_54 = .{ .kind = .object, .fields = .{ .fragment = zx_shape_14, .host = zx_shape_14, .opaque_path = zx_shape_14, .password = zx_shape_10, .path = zx_shape_13, .port = zx_shape_53, .query = zx_shape_14, .scheme = zx_shape_10, .username = zx_shape_10, }, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .base = zx_shape_14, .input = zx_shape_10, }, };
const zx_shape_56 = .{ .kind = .scalar, };
const zx_shape_57 = .{ .kind = .object, .fields = .{ .cwd = zx_shape_10, .path = zx_shape_10, .platform = zx_shape_56, }, };
const zx_shape_58 = .{ .kind = .object, .fields = .{ .platform = zx_shape_56, .url = zx_shape_54, }, };
const zx_shape_59 = .{ .kind = .optional, .child = zx_shape_54, };
const zx_shape_60 = .{ .kind = .object, .fields = .{ .entries = zx_shape_51, .key = zx_shape_10, }, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .entries = zx_shape_51, .key = zx_shape_10, .value = zx_shape_14, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .entries = zx_shape_51, .key = zx_shape_10, .value = zx_shape_10, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .max_output_length = zx_shape_4, }, };
const zx_shape_64 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .max_output_length = zx_shape_4, .max_window_length = zx_shape_4, }, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .data = zx_shape_18, .level = zx_shape_6, }, };
pub const input_shape = zx_shape_0;
pub const output_shape = zx_shape_0;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17, io: (std).Io) anyerror!*const (zx_abi).zx_type_20 {
    const native_result = (try ((zx_native_0).child_process).spawnSync(allocator, io, in));

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19, io: (std).Io) anyerror!*const (zx_abi).zx_type_20 {
    const native_result = (try ((zx_native_0).child_process).spawnSyncWithInput(allocator, io, in));

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).crypto).sha256(allocator, in));

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).crypto).sha512(allocator, in));

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_22) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).timingSafeEqual(in));

    _ = allocator;

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).verifyHmacSha256(in));

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) anyerror!bool {
    const native_result = (try ((zx_native_0).crypto).verifyHmacSha512(in));

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_24) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hmacSha256(allocator, in));

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_24) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hmacSha512(allocator, in));

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hkdfSha256(allocator, in));

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_25) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).hkdfSha512(allocator, in));

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).pbkdf2Sha256(allocator, in));

    return native_result;
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).pbkdf2Sha512(allocator, in));

    return native_result;
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) anyerror!*const (zx_abi).zx_type_28 {
    const native_result = (try ((zx_native_0).crypto).encryptAes128Gcm(allocator, in));

    return native_result;
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptAes128Gcm(allocator, in));

    return native_result;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) anyerror!*const (zx_abi).zx_type_28 {
    const native_result = (try ((zx_native_0).crypto).encryptAes256Gcm(allocator, in));

    return native_result;
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptAes256Gcm(allocator, in));

    return native_result;
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) anyerror!*const (zx_abi).zx_type_28 {
    const native_result = (try ((zx_native_0).crypto).encryptChaCha20Poly1305(allocator, in));

    return native_result;
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).decryptChaCha20Poly1305(allocator, in));

    return native_result;
}

fn function_19(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_21) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).crypto).scrypt(allocator, in));

    return native_result;
}

fn function_20(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeBase64(allocator, in));

    return native_result;
}

fn function_21(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidPadding, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeBase64(allocator, in));

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, Overflow, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeHex(allocator, in));

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidHex, InvalidLength, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeHex(allocator, in));

    return native_result;
}

fn function_24(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_25(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_26(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).fs).readFile(allocator, io, in));

    return native_result;
}

fn function_27(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_33, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).fs).readText(allocator, io, in));

    return native_result;
}

fn function_28(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_34, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).writeFile(io, in));

    _ = allocator;

    return native_result;
}

fn function_29(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_35, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).writeText(io, in));

    _ = allocator;

    return native_result;
}

fn function_30(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).truncate(io, in));

    _ = allocator;

    return native_result;
}

fn function_31(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_37, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).mkdir(io, in));

    _ = allocator;

    return native_result;
}

fn function_32(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror![]const []const u8 {
    const native_result = (try ((zx_native_0).fs).readdir(allocator, io, in));

    return native_result;
}

fn function_33(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).rmdir(io, in));

    _ = allocator;

    return native_result;
}

fn function_34(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).unlink(io, in));

    _ = allocator;

    return native_result;
}

fn function_35(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_38, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).rename(io, in));

    _ = allocator;

    return native_result;
}

fn function_36(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_39, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).fs).copyFile(io, in));

    _ = allocator;

    return native_result;
}

fn function_37(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).fs).realpath(allocator, io, in));

    return native_result;
}

fn function_38(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).fs).readlink(allocator, io, in));

    return native_result;
}

fn function_39(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!*const (zx_abi).zx_type_32 {
    const native_result = (try ((zx_native_0).fs).stat(allocator, io, in));

    return native_result;
}

fn function_40(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!*const (zx_abi).zx_type_32 {
    const native_result = (try ((zx_native_0).fs).lstat(allocator, io, in));

    return native_result;
}

fn function_41(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_44, io: (std).Io) anyerror!*const (zx_abi).zx_type_45 {
    const native_result = (try ((zx_native_0).http).request(allocator, io, in));

    return native_result;
}

fn function_42(allocator: ((std).mem).Allocator, in: void) error{ }![]const u8 {
    _ = in;

    const native_result = ((zx_native_0).os).arch();

    _ = allocator;

    return native_result;
}

fn function_43(allocator: ((std).mem).Allocator, in: void) error{ }![]const u8 {
    _ = in;
    const native_result = ((zx_native_0).os).platform();

    _ = allocator;

    return native_result;
}

fn function_44(allocator: ((std).mem).Allocator, in: void) error{ }![]const u8 {
    _ = in;

    const native_result = ((zx_native_0).os).endianness();

    _ = allocator;

    return native_result;
}

fn function_45(allocator: ((std).mem).Allocator, in: []const u8) error{ }!bool {
    const native_result = ((zx_native_0).path).isAbsolute(in);

    _ = allocator;

    return native_result;
}

fn function_46(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path).basename(in);

    _ = allocator;

    return native_result;
}

fn function_47(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path).dirname(in);

    _ = allocator;

    return native_result;
}

fn function_48(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path).extname(in);

    _ = allocator;

    return native_result;
}

fn function_49(allocator: ((std).mem).Allocator, in: []const u8) anyerror!*const (zx_abi).zx_type_46 {
    const native_result = (try ((zx_native_0).path).parse(allocator, in));

    return native_result;
}

fn function_50(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_46) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path).format(allocator, in));

    return native_result;
}

fn function_51(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path).normalize(allocator, in));

    return native_result;
}

fn function_52(allocator: ((std).mem).Allocator, in: []const []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path).join(allocator, in));

    return native_result;
}

fn function_53(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path).resolve(allocator, in));

    return native_result;
}

fn function_54(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_48) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path).relative(allocator, in));

    return native_result;
}

fn function_55(allocator: ((std).mem).Allocator, in: []const u8) error{ }!bool {
    const native_result = ((zx_native_0).path_posix).isAbsolute(in);

    _ = allocator;

    return native_result;
}

fn function_56(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_posix).basename(in);

    _ = allocator;

    return native_result;
}

fn function_57(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_posix).dirname(in);

    _ = allocator;

    return native_result;
}

fn function_58(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_posix).extname(in);

    _ = allocator;

    return native_result;
}

fn function_59(allocator: ((std).mem).Allocator, in: []const u8) anyerror!*const (zx_abi).zx_type_46 {
    const native_result = (try ((zx_native_0).path_posix).parse(allocator, in));

    return native_result;
}

fn function_60(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_46) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_posix).format(allocator, in));

    return native_result;
}

fn function_61(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_posix).normalize(allocator, in));

    return native_result;
}

fn function_62(allocator: ((std).mem).Allocator, in: []const []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_posix).join(allocator, in));

    return native_result;
}

fn function_63(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_posix).resolve(allocator, in));

    return native_result;
}

fn function_64(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_48) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_posix).relative(allocator, in));

    return native_result;
}

fn function_65(allocator: ((std).mem).Allocator, in: []const u8) error{ }!bool {
    const native_result = ((zx_native_0).path_win32).isAbsolute(in);

    _ = allocator;

    return native_result;
}

fn function_66(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_win32).basename(in);

    _ = allocator;

    return native_result;
}

fn function_67(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_win32).dirname(in);

    _ = allocator;

    return native_result;
}

fn function_68(allocator: ((std).mem).Allocator, in: []const u8) error{ }![]const u8 {
    const native_result = ((zx_native_0).path_win32).extname(in);

    _ = allocator;

    return native_result;
}

fn function_69(allocator: ((std).mem).Allocator, in: []const u8) anyerror!*const (zx_abi).zx_type_46 {
    const native_result = (try ((zx_native_0).path_win32).parse(allocator, in));

    return native_result;
}

fn function_70(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_46) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_win32).format(allocator, in));

    return native_result;
}

fn function_71(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_win32).normalize(allocator, in));

    return native_result;
}

fn function_72(allocator: ((std).mem).Allocator, in: []const []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_win32).join(allocator, in));

    return native_result;
}

fn function_73(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_47) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_win32).resolve(allocator, in));

    return native_result;
}

fn function_74(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_48) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).path_win32).relative(allocator, in));

    return native_result;
}

fn function_75(allocator: ((std).mem).Allocator, in: void, process: (((std).process).Init).Minimal) anyerror![]const []const u8 {
    _ = in;

    const native_result = (try ((zx_native_0).process).argv(allocator, process));

    return native_result;
}

fn function_76(allocator: ((std).mem).Allocator, in: []const u8, process: (((std).process).Init).Minimal) anyerror!?[]const u8 {
    const native_result = (try ((zx_native_0).process).getEnv(allocator, process, in));

    return native_result;
}

fn function_77(allocator: ((std).mem).Allocator, in: void, io: (std).Io) anyerror![]const u8 {
    _ = in;

    const native_result = (try ((zx_native_0).process).cwd(allocator, io));

    return native_result;
}

fn function_78(allocator: ((std).mem).Allocator, in: u64, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).process).readStdin(allocator, io, in));

    return native_result;
}

fn function_79(allocator: ((std).mem).Allocator, in: u64, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).process).readStdinText(allocator, io, in));

    return native_result;
}

fn function_80(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStdout(io, in));

    _ = allocator;

    return native_result;
}

fn function_81(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStdoutText(io, in));

    _ = allocator;

    return native_result;
}

fn function_82(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStderr(io, in));

    _ = allocator;

    return native_result;
}

fn function_83(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStderrText(io, in));

    _ = allocator;

    return native_result;
}

fn function_84(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).querystring).escape(allocator, in));

    return native_result;
}

fn function_85(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).querystring).unescape(allocator, in));

    return native_result;
}

fn function_86(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).querystring).parse(allocator, in));

    return native_result;
}

fn function_87(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_50) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).querystring).parseWith(allocator, in));

    return native_result;
}

fn function_88(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).querystring).stringify(allocator, in));

    return native_result;
}

fn function_89(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_52) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).querystring).stringifyWith(allocator, in));

    return native_result;
}

fn function_90(allocator: ((std).mem).Allocator, in: []const u8) anyerror!*const (zx_abi).zx_type_54 {
    const native_result = (try ((zx_native_0).url_api).parse(allocator, in));

    return native_result;
}

fn function_91(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_55) anyerror!*const (zx_abi).zx_type_54 {
    const native_result = (try ((zx_native_0).url_api).resolve(allocator, in));

    return native_result;
}

fn function_92(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_55) anyerror!?*const (zx_abi).zx_type_54 {
    const native_result = (try ((zx_native_0).url_api).tryParse(allocator, in));

    return native_result;
}

fn function_93(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_55) anyerror!bool {
    const native_result = (try ((zx_native_0).url_api).canParse(allocator, in));

    return native_result;
}

fn function_94(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_54) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).stringify(allocator, in));

    return native_result;
}

fn function_95(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_54) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).pathname(allocator, in));

    return native_result;
}

fn function_96(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_54) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).origin(allocator, in));

    return native_result;
}

fn function_97(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).domainToASCII(allocator, in));

    return native_result;
}

fn function_98(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).domainToUnicode(allocator, in));

    return native_result;
}

fn function_99(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_57) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).pathToFileURL(allocator, in));

    return native_result;
}

fn function_100(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_58) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).fileURLToPath(allocator, in));

    return native_result;
}

fn function_101(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_58) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_api).fileURLToBytes(allocator, in));

    return native_result;
}

fn function_102(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).url_search_params).parse(allocator, in));

    return native_result;
}

fn function_103(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).url_search_params).stringify(allocator, in));

    return native_result;
}

fn function_104(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_60) error{ }!?[]const u8 {
    const native_result = ((zx_native_0).url_search_params).get(in);

    _ = allocator;

    return native_result;
}

fn function_105(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_60) anyerror![]const []const u8 {
    const native_result = (try ((zx_native_0).url_search_params).getAll(allocator, in));

    return native_result;
}

fn function_106(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_61) error{ }!bool {
    const native_result = ((zx_native_0).url_search_params).has(in);

    _ = allocator;

    return native_result;
}

fn function_107(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_62) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).url_search_params).append(allocator, in));

    return native_result;
}

fn function_108(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_62) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).url_search_params).set(allocator, in));

    return native_result;
}

fn function_109(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_61) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).url_search_params).remove(allocator, in));

    return native_result;
}

fn function_110(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) anyerror![]const *const (zx_abi).zx_type_49 {
    const native_result = (try ((zx_native_0).url_search_params).sort(allocator, in));

    return native_result;
}

fn function_111(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) anyerror![]const []const u8 {
    const native_result = (try ((zx_native_0).url_search_params).keys(allocator, in));

    return native_result;
}

fn function_112(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) anyerror![]const []const u8 {
    const native_result = (try ((zx_native_0).url_search_params).values(allocator, in));

    return native_result;
}

fn function_113(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_49) error{ }!u64 {
    const native_result = ((zx_native_0).url_search_params).size(in);

    _ = allocator;

    return native_result;
}

fn function_114(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).gzip(allocator, in));

    return native_result;
}

fn function_115(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).deflate(allocator, in));

    return native_result;
}

fn function_116(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).deflateRaw(allocator, in));

    return native_result;
}

fn function_117(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_65) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).gzipWith(allocator, in));

    return native_result;
}

fn function_118(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_65) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).deflateWith(allocator, in));

    return native_result;
}

fn function_119(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_65) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).deflateRawWith(allocator, in));

    return native_result;
}

fn function_120(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_63) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).gunzip(allocator, in));

    return native_result;
}

fn function_121(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_63) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).inflate(allocator, in));

    return native_result;
}

fn function_122(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_63) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).inflateRaw(allocator, in));

    return native_result;
}

fn function_123(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_64) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).zlib).zstdDecompress(allocator, in));

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) error{ }!void {
    @setRuntimeSafety(true);

    _ = arena;
    _ = in;
}

