const std = @import("std");
const f = @import("fixture.zig");
const Stream = enum { stdout, stderr };

fn write(io: std.Io, data: []const u8, stream: Stream, text: bool) !void {
    switch (stream) {
        .stdout => if (text) try f.api.writeStdoutText(io, data) else try f.api.writeStdout(io, data),
        .stderr => if (text) try f.api.writeStderrText(io, data) else try f.api.writeStderr(io, data),
    }
}

fn check(data: []const u8, stream: Stream, text: bool) !void {
    var host: f.Stream = .{ .chunk = 3 };
    var vtable: std.Io.VTable = undefined;

    try write(host.io(&vtable), data, stream, text);
    try std.testing.expectEqualSlices(u8, if (stream == .stdout) data else "", host.stdout[0..host.stdout_len]);
    try std.testing.expectEqualSlices(u8, if (stream == .stderr) data else "", host.stderr[0..host.stderr_len]);
}

fn invalid(stream: Stream) !void {
    for ([_][]const u8{ "\xff", "\x80", "\xc0\x80", "\xe2\x82", "\xed\xa0\x80", "\xf4\x90\x80\x80" }) |bytes| {
        var host: f.Stream = .{};
        var vtable: std.Io.VTable = undefined;

        try std.testing.expectError(error.InvalidUtf8, write(host.io(&vtable), bytes, stream, true));
        try std.testing.expectEqual(@as(usize, 0), host.calls);
        try std.testing.expectEqual(@as(usize, 0), host.stdout_len + host.stderr_len);
    }
}

fn failure(stream: Stream, text: bool, after: usize) !void {
    var host: f.Stream = .{ .chunk = 3, .fail_after = after };
    var vtable: std.Io.VTable = undefined;
    const io = host.io(&vtable);

    try std.testing.expectError(error.WriteFailed, write(io, "abcdefghi", stream, text));
    try std.testing.expectEqual(after, host.stdout_len + host.stderr_len);

    host.fail_after = null;

    try write(io, "next", stream, text);

    const expected = if (after == 0) "next" else "abcnext";
    const actual = if (stream == .stdout) host.stdout[0..host.stdout_len] else host.stderr[0..host.stderr_len];

    try std.testing.expectEqualStrings(expected, actual);
}

test "stdio empty stdout bytes writes no bytes" {
    try check("", .stdout, false);
}

test "stdio stdout bytes completes partial writes and flushes" {
    try check("中文 🌿\x00tail", .stdout, false);
}

test "stdio stdout bytes fails after 0 bytes and recovers" {
    try failure(.stdout, false, 0);
}

test "stdio stdout bytes fails after 3 bytes and recovers" {
    try failure(.stdout, false, 3);
}

test "stdio empty stdout text writes no bytes" {
    try check("", .stdout, true);
}

test "stdio stdout text completes partial writes and flushes" {
    try check("中文 🌿\x00tail", .stdout, true);
}

test "stdio stdout text fails after 0 bytes and recovers" {
    try failure(.stdout, true, 0);
}

test "stdio stdout text fails after 3 bytes and recovers" {
    try failure(.stdout, true, 3);
}

test "stdio stdout bytes preserves invalid UTF8" {
    try check("\x00\xff\xc0\x80", .stdout, false);
}

test "stdio stdout text rejects malformed UTF8 before any IO" {
    try invalid(.stdout);
}

test "stdio stdout writes beyond buffer with short writes" {
    const bytes = @as([9000]u8, @splat('q'));

    try check(&bytes, .stdout, false);
}

test "stdio empty stderr bytes writes no bytes" {
    try check("", .stderr, false);
}

test "stdio stderr bytes completes partial writes and flushes" {
    try check("中文 🌿\x00tail", .stderr, false);
}

test "stdio stderr bytes fails after 0 bytes and recovers" {
    try failure(.stderr, false, 0);
}

test "stdio stderr bytes fails after 3 bytes and recovers" {
    try failure(.stderr, false, 3);
}

test "stdio empty stderr text writes no bytes" {
    try check("", .stderr, true);
}

test "stdio stderr text completes partial writes and flushes" {
    try check("中文 🌿\x00tail", .stderr, true);
}

test "stdio stderr text fails after 0 bytes and recovers" {
    try failure(.stderr, true, 0);
}

test "stdio stderr text fails after 3 bytes and recovers" {
    try failure(.stderr, true, 3);
}

test "stdio stderr bytes preserves invalid UTF8" {
    try check("\x00\xff\xc0\x80", .stderr, false);
}

test "stdio stderr text rejects malformed UTF8 before any IO" {
    try invalid(.stderr);
}

test "stdio stderr writes beyond buffer with short writes" {
    const bytes = @as([9000]u8, @splat('q'));

    try check(&bytes, .stderr, false);
}

test "stdio sequential writes append without newline and keep streams separate" {
    var host: f.Stream = .{ .chunk = 1 };
    var vtable: std.Io.VTable = undefined;
    const io = host.io(&vtable);

    try f.api.writeStdoutText(io, "first");
    try f.api.writeStderrText(io, "error");
    try f.api.writeStdout(io, "second");
    try f.api.writeStderr(io, "tail");
    try std.testing.expectEqualStrings("firstsecond", host.stdout[0..host.stdout_len]);
    try std.testing.expectEqualStrings("errortail", host.stderr[0..host.stderr_len]);
}

test "stdio canceled writes fail without bytes" {
    var host: f.Stream = .{ .canceled = true };
    var vtable: std.Io.VTable = undefined;
    const io = host.io(&vtable);

    try std.testing.expectError(error.WriteFailed, f.api.writeStdout(io, "a"));
    try std.testing.expectError(error.WriteFailed, f.api.writeStderrText(io, "b"));
    try std.testing.expectEqual(@as(usize, 0), host.stdout_len + host.stderr_len);
}
