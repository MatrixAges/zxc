const std = @import("std");
const f = @import("fixture.zig");

fn check(allocator: std.mem.Allocator) !void {
    const process = try f.context(&.{ "custom-program", "", "two words", "中文 🌿", "'\";$()" }, &.{});
    const result = try f.api.argv(allocator, process);

    defer f.freeArgs(allocator, result);

    try std.testing.expectEqual(@as(usize, 5), result.len);
    for ([_][]const u8{ "custom-program", "", "two words", "中文 🌿", "'\";$()" }, result) |expected, actual| try std.testing.expectEqualStrings(expected, actual);
}

test "process argv preserves program name empty and literal arguments" {
    try check(f.allocator);
}

test "process argv accepts empty host vector without injecting arguments" {
    const result = try f.api.argv(f.allocator, try f.context(&.{}, &.{}));

    defer f.freeArgs(f.allocator, result);

    try std.testing.expectEqual(@as(usize, 0), result.len);
}

test "process argv returns independent argument bytes" {
    var storage: [5:0]u8 = "hello".*;
    const result = try f.api.argv(f.allocator, try f.context(&.{&storage}, &.{}));

    defer f.freeArgs(f.allocator, result);

    storage[0] = 'X';

    try std.testing.expectEqualStrings("hello", result[0]);
}

fn invalid(allocator: std.mem.Allocator) !void {
    const process = try f.context(&.{ "valid", "\xff" }, &.{});

    const result = f.api.argv(allocator, process) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUtf8, err);

        return;
    };

    defer f.freeArgs(allocator, result);

    return error.ExpectedInvalidUtf8;
}

test "process argv rejects invalid bytes after an already copied argument" {
    try invalid(f.allocator);
}

test "process argv releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{});
}

test "process argv invalid UTF8 cleanup survives every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, invalid, .{});
}
