const std = @import("std");
const allocation_testing = @import("allocation_testing");
const impl = @import("implementation");

fn checkEncode(allocator: std.mem.Allocator, point: u21) !void {
    const input = [_]u21{ 0x41, 0x42, point };

    const output = impl.encode(allocator, &input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidPunycode, err);

        return;
    };

    defer allocator.free(output);

    return error.TestExpectedError;
}

fn checkDecode(allocator: std.mem.Allocator, input: []const u8) !void {
    const output = impl.decode(allocator, input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidPunycode, err);

        return;
    };

    defer allocator.free(output);

    return error.TestExpectedError;
}

test "Punycode encode rejects high surrogate with allocation cleanup" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkEncode, .{@as(u21, 0xd800)});
}

test "Punycode encode rejects low surrogate with allocation cleanup" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkEncode, .{@as(u21, 0xdfff)});
}

test "Punycode encode rejects value above Unicode maximum" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkEncode, .{@as(u21, 0x110000)});
}

test "Punycode encode rejects maximum u21 value" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkEncode, .{@as(u21, 0x1fffff)});
}

test "Punycode decode rejects nonASCII basic prefix after partial copy" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "ABC\xff-")});
}

test "Punycode decode rejects invalid digit after basic prefix" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "ABC-!")});
}

test "Punycode decode rejects truncated variable integer" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "ABC-9")});
}

test "Punycode decode rejects integer overflow after allocating basic prefix" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "ABC-" ++ &@as([64:0]u8, @splat('9')))});
}

test "Punycode decode rejects encoded surrogate" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "ib9b")});
}

test "Punycode decode rejects encoded point above Unicode maximum" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDecode, .{@as([]const u8, "en32g")});
}
