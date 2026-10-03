const std = @import("std");
const standard = @import("standard");
const encoding = standard.encoding;
const Operation = enum { base64_encode, base64_decode, hex_encode, hex_decode, utf8_encode, utf8_decode, sha256, sha512 };

test "standard operations release every successful direct allocation" {
    inline for (std.meta.tags(Operation)) |operation| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{operation});
    }
}

test "base64 errors release allocated output and propagate allocation failure" {
    for ([_][]const u8{ "A", "AA", "AAA", "AA=A", "AA/=", "A/==", "A===", "====" }) |input| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Operation.base64_decode, input, error.InvalidPadding });
    }

    for ([_][]const u8{ "A..A", "Zm9vYmFyZm9vYmFyA..A", "!!!!" }) |input| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Operation.base64_decode, input, error.InvalidCharacter });
    }
}

test "hex errors release allocated output and propagate allocation failure" {
    for ([_][]const u8{ "0", "abc", "abcde" }) |input| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Operation.hex_decode, input, error.InvalidHex });
    }

    for ([_][]const u8{ "gg", "00zz", " 0", "0x" }) |input| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Operation.hex_decode, input, error.InvalidCharacter });
    }
}

test "UTF8 rejects invalid byte sequences without accepting replacement characters" {
    for ([_][]const u8{ "\x80", "\xc0\xaf", "\xc2", "\xe0\x80\x80", "\xed\xa0\x80", "\xf4\x90\x80\x80", "\xf5\x80\x80\x80", "\xff" }) |input| {
        inline for (.{ Operation.utf8_encode, Operation.utf8_decode }) |operation| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ operation, input, error.InvalidUtf8 });
        }
    }
}

fn execute(allocator: std.mem.Allocator, operation: Operation, input: []const u8) ![]const u8 {
    return switch (operation) {
        .base64_encode => encoding.encodeBase64(allocator, input),
        .base64_decode => encoding.decodeBase64(allocator, input),
        .hex_encode => encoding.encodeHex(allocator, input),
        .hex_decode => encoding.decodeHex(allocator, input),
        .utf8_encode => encoding.encodeUtf8(input),
        .utf8_decode => encoding.decodeUtf8(input),
        .sha256 => standard.crypto.sha256(allocator, input),
        .sha512 => standard.crypto.sha512(allocator, input),
    };
}

fn checkSuccess(allocator: std.mem.Allocator, operation: Operation) !void {
    const input = switch (operation) {
        .base64_decode => "YWJj",
        .hex_decode => "616263",
        else => "abc",
    };

    const output = try execute(allocator, operation, input);

    defer if (operation != .utf8_encode and operation != .utf8_decode) allocator.free(output);

    if (operation == .utf8_encode or operation == .utf8_decode) try std.testing.expectEqual(input.ptr, output.ptr);

    switch (operation) {
        .base64_encode => try std.testing.expectEqualStrings("YWJj", output),
        .hex_encode => try std.testing.expectEqualStrings("616263", output),
        .sha256 => try std.testing.expectEqual(@as(usize, 32), output.len),
        .sha512 => try std.testing.expectEqual(@as(usize, 64), output.len),
        else => try std.testing.expectEqualStrings("abc", output),
    }
}

fn checkFailure(allocator: std.mem.Allocator, operation: Operation, input: []const u8, expected: anyerror) !void {
    const output = execute(allocator, operation, input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(expected, err);

        return;
    };

    defer if (operation != .utf8_encode and operation != .utf8_decode) allocator.free(output);

    return error.TestExpectedError;
}
