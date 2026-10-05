const std = @import("std");
const impl = @import("implementation");

fn check(allocator: std.mem.Allocator, input: []const u21, expected: []const u21) !void {
    const result = try impl.normalize(allocator, input);

    defer allocator.free(result);

    try std.testing.expectEqualSlices(u21, expected, result);
}

fn checkInvalid(allocator: std.mem.Allocator, point: u21) !void {
    const input = [_]u21{ 0x1e0a, 0x323, point };

    const result = impl.normalize(allocator, &input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUnicodeScalar, err);

        return;
    };

    defer allocator.free(result);

    return error.TestExpectedError;
}

test "NFC empty input has empty output" {
    try check(std.testing.allocator, &.{}, &.{});
}

test "NFC decomposition and ordering release partial allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as([]const u21, &.{ 0x1e0a, 0x323, 0x1100, 0xac00, 0x11a8 }), @as([]const u21, &.{ 0x1e0c, 0x307, 0x1100, 0xac01 }) });
}

test "NFC initial combining marks preserve equal class order" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as([]const u21, &.{ 0x301, 0x300, 0x323 }), @as([]const u21, &.{ 0x323, 0x301, 0x300 }) });
}

test "NFC rejects high surrogate after allocating prefix" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{@as(u21, 0xd800)});
}

test "NFC rejects low surrogate after allocating prefix" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{@as(u21, 0xdfff)});
}

test "NFC rejects value above Unicode maximum" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{@as(u21, 0x110000)});
}

test "NFC rejects maximum u21 value" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{@as(u21, 0x1fffff)});
}
