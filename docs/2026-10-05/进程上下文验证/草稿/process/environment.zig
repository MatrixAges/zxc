const std = @import("std");
const f = @import("fixture.zig");

fn check(allocator: std.mem.Allocator) !void {
    const process = try f.context(&.{}, &.{ "KEY=值 🌿=suffix", "EMPTY=" });
    const value = (try f.api.getEnv(allocator, process, "KEY")).?;

    defer allocator.free(value);

    try std.testing.expectEqualStrings("值 🌿=suffix", value);
}

test "process getEnv preserves Unicode and equals in values" {
    try check(f.allocator);
}

test "process getEnv distinguishes empty value and missing variable" {
    const process = try f.context(&.{}, &.{"EMPTY="});
    const empty = (try f.api.getEnv(f.allocator, process, "EMPTY")).?;

    defer f.allocator.free(empty);

    try std.testing.expectEqual(@as(usize, 0), empty.len);
    try std.testing.expect(try f.api.getEnv(f.allocator, process, "MISSING") == null);
}

test "process getEnv empty context does not consult global environment" {
    try std.testing.expect(try f.api.getEnv(f.allocator, try f.context(&.{}, &.{}), "PATH") == null);
}

test "process getEnv copies bytes independently of host environment storage" {
    var storage: [9:0]u8 = "KEY=value".*;
    const value = (try f.api.getEnv(f.allocator, try f.context(&.{}, &.{&storage}), "KEY")).?;

    defer f.allocator.free(value);

    storage[4] = 'X';

    try std.testing.expectEqualStrings("value", value);
}

test "process getEnv switches explicit environments between calls" {
    const first = (try f.api.getEnv(f.allocator, try f.context(&.{}, &.{"KEY=first"}), "KEY")).?;

    defer f.allocator.free(first);

    const second = (try f.api.getEnv(f.allocator, try f.context(&.{}, &.{"KEY=second"}), "KEY")).?;

    defer f.allocator.free(second);

    try std.testing.expectEqualStrings("first", first);
    try std.testing.expectEqualStrings("second", second);
}

test "process getEnv rejects empty NUL and equals keys" {
    const process = try f.context(&.{}, &.{});

    for ([_][]const u8{ "", "A\x00B", "A=B" }) |key| try std.testing.expectError(error.InvalidEnvironmentKey, f.api.getEnv(f.allocator, process, key));
}

test "process getEnv rejects invalid UTF8 key" {
    try std.testing.expectError(error.InvalidUtf8, f.api.getEnv(f.allocator, try f.context(&.{}, &.{}), "\xff"));
}

fn invalid(allocator: std.mem.Allocator) !void {
    const result = f.api.getEnv(allocator, try f.context(&.{}, &.{"KEY=\xed\xa0\x80"}), "KEY") catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUtf8, err);

        return;
    };

    if (result) |value| allocator.free(value);

    return error.ExpectedInvalidUtf8;
}

test "process getEnv rejects invalid UTF8 environment value" {
    try invalid(f.allocator);
}

test "process getEnv releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{});
}

test "process getEnv invalid value releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, invalid, .{});
}
