const std = @import("std");
const f = @import("fixture.zig");

fn reject(path: []const u8, expected: anyerror) !void {
    try std.testing.expectError(expected, f.fs.readFile(f.allocator, f.io, &.{ .path = path, .max_bytes = 16 }));
    try std.testing.expectError(expected, f.fs.readText(f.allocator, f.io, &.{ .path = path, .max_bytes = 16 }));
    try std.testing.expectError(expected, f.fs.writeFile(f.io, &.{ .path = path, .data = "replace" }));
    try std.testing.expectError(expected, f.fs.writeText(f.io, &.{ .path = path, .text = "replace" }));
    try std.testing.expectError(expected, f.fs.truncate(f.io, &.{ .path = path, .length = 0 }));
    try std.testing.expectError(expected, f.fs.mkdir(f.io, &.{ .path = path, .recursive = false }));
    try std.testing.expectError(expected, f.fs.readdir(f.allocator, f.io, path));
    try std.testing.expectError(expected, f.fs.rmdir(f.io, path));
    try std.testing.expectError(expected, f.fs.unlink(f.io, path));
    try std.testing.expectError(expected, f.fs.rename(f.io, &.{ .from = path, .to = path }));
    try std.testing.expectError(expected, f.fs.copyFile(f.io, &.{ .from = path, .to = path, .exclusive = false }));
    try std.testing.expectError(expected, f.fs.realpath(f.allocator, f.io, path));
    try std.testing.expectError(expected, f.fs.readlink(f.allocator, f.io, path));
    try std.testing.expectError(expected, f.fs.stat(f.allocator, f.io, path));
    try std.testing.expectError(expected, f.fs.lstat(f.allocator, f.io, path));
}

test "fs all operations reject NUL paths without modifying the valid prefix" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("target", "keep");
    try reject(try fixture.path("target\x00suffix"), error.InvalidPath);
    try fixture.expectContent("target", "keep");
}

test "fs all operations reject invalid UTF8 paths before IO" {
    var fixture = try f.init();

    defer fixture.deinit();

    try reject(try fixture.path("\xff"), error.InvalidUtf8);
}

fn rejectDestination(suffix: []const u8, expected: anyerror) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("source", "source");
    try fixture.write("target", "target");

    const from = try fixture.path("source");
    const to = try fixture.path(suffix);

    try std.testing.expectError(expected, f.fs.copyFile(f.io, &.{ .from = from, .to = to, .exclusive = false }));
    try std.testing.expectError(expected, f.fs.rename(f.io, &.{ .from = from, .to = to }));
    try fixture.expectContent("source", "source");
    try fixture.expectContent("target", "target");
}

test "fs copy and rename validate NUL destination before changing source" {
    try rejectDestination("target\x00suffix", error.InvalidPath);
}

test "fs copy and rename validate UTF8 destination before changing source" {
    try rejectDestination("target\xff", error.InvalidUtf8);
}
