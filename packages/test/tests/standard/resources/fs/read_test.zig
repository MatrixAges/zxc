const std = @import("std");
const f = @import("fixture.zig");

test "fs readFile retains every byte including NUL and invalid UTF8" {
    var fixture = try f.init();

    defer fixture.deinit();

    var bytes: [256]u8 = undefined;

    for (&bytes, 0..) |*byte, index| byte.* = @intCast(index);

    try fixture.write("binary", &bytes);

    const actual = try f.fs.readFile(f.allocator, f.io, &.{ .path = try fixture.path("binary"), .max_bytes = bytes.len });

    defer f.allocator.free(actual);

    try std.testing.expectEqualSlices(u8, &bytes, actual);
}

test "fs zero read limit accepts an empty file" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("empty", "");

    const actual = try f.fs.readFile(f.allocator, f.io, &.{ .path = try fixture.path("empty"), .max_bytes = 0 });

    defer f.allocator.free(actual);

    try std.testing.expectEqual(@as(usize, 0), actual.len);
}

test "fs zero read limit rejects a nonempty file" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("one", "x");
    try std.testing.expectError(error.StreamTooLong, f.fs.readFile(f.allocator, f.io, &.{ .path = try fixture.path("one"), .max_bytes = 0 }));
}

test "fs read limit is inclusive and never returns a partial prefix" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "abcd");

    const path = try fixture.path("data");

    try std.testing.expectError(error.StreamTooLong, f.fs.readFile(f.allocator, f.io, &.{ .path = path, .max_bytes = 3 }));

    const actual = try f.fs.readFile(f.allocator, f.io, &.{ .path = path, .max_bytes = 4 });

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings("abcd", actual);
}

test "fs maximal u64 read limit does not overflow on a small file" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "abcd");

    const actual = try f.fs.readFile(f.allocator, f.io, &.{ .path = try fixture.path("data"), .max_bytes = std.math.maxInt(u64) });

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings("abcd", actual);
}

test "fs readText preserves UTF8 BOM embedded NUL and newlines" {
    var fixture = try f.init();

    defer fixture.deinit();

    const text = "\xef\xbb\xbf你好 🌿\x00\r\n";

    try fixture.write("text", text);

    const path = try fixture.path("text");
    const actual = try f.fs.readText(f.allocator, f.io, &.{ .path = path, .max_bytes = text.len });

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings(text, actual);
    try std.testing.expectError(error.StreamTooLong, f.fs.readText(f.allocator, f.io, &.{ .path = path, .max_bytes = text.len - 1 }));
}

test "fs readText rejects malformed UTF8 without replacement characters" {
    var fixture = try f.init();

    defer fixture.deinit();

    for ([_][]const u8{ "\x80", "\xc0\xaf", "\xc2", "\xed\xa0\x80", "\xf4\x90\x80\x80" }) |bytes| {
        try fixture.write("invalid", bytes);
        try std.testing.expectError(error.InvalidUtf8, f.fs.readText(f.allocator, f.io, &.{ .path = try fixture.path("invalid"), .max_bytes = bytes.len }));
    }
}

test "fs missing file read errors do not create a file" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("missing");

    try std.testing.expectError(error.FileNotFound, f.fs.readFile(f.allocator, f.io, &.{ .path = path, .max_bytes = 10 }));
    try std.testing.expectError(error.FileNotFound, f.fs.readText(f.allocator, f.io, &.{ .path = path, .max_bytes = 10 }));
    try fixture.expectMissing("missing");
}

test "fs readText accepts empty UTF8 at a zero byte limit" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("empty", "");

    const actual = try f.fs.readText(f.allocator, f.io, &.{ .path = try fixture.path("empty"), .max_bytes = 0 });

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings("", actual);
}
