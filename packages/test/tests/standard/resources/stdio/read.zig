const std = @import("std");
const f = @import("fixture.zig");

fn read(allocator: std.mem.Allocator, input: []const u8, max_bytes: u64, text: bool) !void {
    var stream: f.Stream = .{ .input = input, .chunk = 3 };
    var vtable: std.Io.VTable = undefined;
    const io = stream.io(&vtable);
    const result = if (text) try f.api.readStdinText(allocator, io, max_bytes) else try f.api.readStdin(allocator, io, max_bytes);

    defer allocator.free(result);

    try std.testing.expectEqualSlices(u8, input, result);
}

fn overflow(input: []const u8, max_bytes: u64, text: bool) !void {
    var stream: f.Stream = .{ .input = input, .chunk = 1 };
    var vtable: std.Io.VTable = undefined;
    const io = stream.io(&vtable);
    const result = if (text) f.api.readStdinText(f.allocator, io, max_bytes) else f.api.readStdin(f.allocator, io, max_bytes);

    if (result) |bytes| {
        defer f.allocator.free(bytes);

        return error.ExpectedStreamTooLong;
    } else |err| try std.testing.expectEqual(error.StreamTooLong, err);
}

test "stdio empty bytes with zero limit" {
    try read(f.allocator, "", 0, false);
}

test "stdio empty text with zero limit" {
    try read(f.allocator, "", 0, true);
}

test "stdio zero byte limit rejects one byte" {
    try overflow("x", 0, false);
}

test "stdio zero text limit rejects one byte" {
    try overflow("x", 0, true);
}

test "stdio binary exact limit keeps NUL and invalid UTF8" {
    try read(f.allocator, "\x00\xff\xc0\x80", 4, false);
}

test "stdio text exact limit counts UTF8 bytes" {
    try read(f.allocator, "中文 🌿", "中文 🌿".len, true);
}

test "stdio bytes one over limit rejects" {
    try overflow("abcd", 3, false);
}

test "stdio text one over limit rejects" {
    try overflow("abcd", 3, true);
}

test "stdio bytes far over limit rejects" {
    try overflow("abcdefghij", 3, false);
}

test "stdio text far over limit rejects" {
    try overflow("abcdefghij", 3, true);
}

test "stdio text preserves NUL and newline" {
    try read(f.allocator, "a\x00b\n", 4, true);
}

test "stdio read supports maximum u64 limit without overflow" {
    try read(f.allocator, "abc", std.math.maxInt(u64), false);
}

test "stdio reads beyond internal buffer" {
    const input = @as([9000]u8, @splat('q'));

    try read(f.allocator, &input, input.len, false);
}

test "stdio overflow at internal buffer boundary" {
    const input = @as([4097]u8, @splat('q'));

    try overflow(&input, 4096, false);
}

test "stdio text rejects each malformed UTF8 category" {
    for ([_][]const u8{ "\xff", "\x80", "\xc0\x80", "\xe2\x82", "\xed\xa0\x80", "\xf4\x90\x80\x80" }) |input| {
        var stream: f.Stream = .{ .input = input, .chunk = 1 };
        var vtable: std.Io.VTable = undefined;

        try std.testing.expectError(error.InvalidUtf8, f.api.readStdinText(f.allocator, stream.io(&vtable), 100));
    }
}

test "stdio read result owns memory independent of host bytes" {
    var input = [_]u8{ 'a', 'b', 'c' };
    var stream: f.Stream = .{ .input = &input };
    var vtable: std.Io.VTable = undefined;
    const result = try f.api.readStdin(f.allocator, stream.io(&vtable), 3);

    defer f.allocator.free(result);
    @memset(&input, 'z');

    try std.testing.expectEqualStrings("abc", result);
}

test "stdio second read sees EOF instead of retained global input" {
    var stream: f.Stream = .{ .input = "abc" };
    var vtable: std.Io.VTable = undefined;
    const io = stream.io(&vtable);
    const first = try f.api.readStdin(f.allocator, io, 3);

    defer f.allocator.free(first);

    const second = try f.api.readStdin(f.allocator, io, 0);

    defer f.allocator.free(second);

    try std.testing.expectEqualStrings("abc", first);
    try std.testing.expectEqual(@as(usize, 0), second.len);
}

test "stdio read errors after partial input release accumulated data" {
    var stream: f.Stream = .{ .input = "abcdef", .chunk = 2, .fail_after = 2 };
    var vtable: std.Io.VTable = undefined;

    try std.testing.expectError(error.ReadFailed, f.api.readStdin(f.allocator, stream.io(&vtable), 100));
}

test "stdio canceled read fails" {
    var stream: f.Stream = .{ .canceled = true };
    var vtable: std.Io.VTable = undefined;

    try std.testing.expectError(error.ReadFailed, f.api.readStdinText(f.allocator, stream.io(&vtable), 100));
}

test "stdio bytes releases every failed allocation" {
    const input = @as([9000]u8, @splat('q'));

    try std.testing.checkAllAllocationFailures(f.allocator, read, .{ &input, 9000, false });
}

test "stdio text releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, read, .{ "中文 🌿", 100, true });
}

fn invalidAllocation(allocator: std.mem.Allocator) !void {
    var stream: f.Stream = .{ .input = "valid-prefix\xff", .chunk = 2 };
    var vtable: std.Io.VTable = undefined;

    const result = f.api.readStdinText(allocator, stream.io(&vtable), 100) catch |err| {
        if (err == error.InvalidUtf8) return;

        return err;
    };

    defer allocator.free(result);

    return error.ExpectedInvalidUtf8;
}

fn overflowAllocation(allocator: std.mem.Allocator) !void {
    const input = @as([9001]u8, @splat('q'));
    var stream: f.Stream = .{ .input = &input, .chunk = 257 };
    var vtable: std.Io.VTable = undefined;

    const result = f.api.readStdin(allocator, stream.io(&vtable), 9000) catch |err| {
        if (err == error.StreamTooLong) return;

        return err;
    };

    defer allocator.free(result);

    return error.ExpectedStreamTooLong;
}

test "stdio invalid text releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, invalidAllocation, .{});
}

test "stdio overflow releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, overflowAllocation, .{});
}

test "stdio text code point spans internal buffer boundary" {
    const input = (@as([4095]u8, @splat('q'))) ++ "🌿".*;

    try read(f.allocator, &input, input.len, true);
}

test "stdio read recovers with a new reader after IO failure" {
    var stream: f.Stream = .{ .input = "abcdef", .chunk = 2, .fail_after = 2 };
    var vtable: std.Io.VTable = undefined;
    const io = stream.io(&vtable);

    try std.testing.expectError(error.ReadFailed, f.api.readStdin(f.allocator, io, 100));

    stream.fail_after = null;
    stream.input = "next";
    stream.position = 0;

    const result = try f.api.readStdin(f.allocator, io, 4);

    defer f.allocator.free(result);

    try std.testing.expectEqualStrings("next", result);
}
