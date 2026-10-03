const std = @import("std");
const zlib = @import("standard").zlib;
const Operation = enum { gzip, deflate, raw, gzip_with, deflate_with, raw_with };

test "zlib gzip releases all compression allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.gzip, -1 });
}

test "zlib deflate releases all compression allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.deflate, -1 });
}

test "zlib deflateRaw releases all compression allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.raw, -1 });
}

test "zlib gzipWith releases level nine allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.gzip_with, 9 });
}

test "zlib deflateWith releases level nine allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.deflate_with, 9 });
}

test "zlib deflateRawWith releases level nine allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.raw_with, 9 });
}

test "zlib gzipWith releases stored block allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.gzip_with, 0 });
}

test "zlib deflateWith releases stored block allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.deflate_with, 0 });
}

test "zlib deflateRawWith releases stored block allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{ Operation.raw_with, 0 });
}

test "zlib gzipWith rejects invalid levels before allocations" {
    try checkInvalid(.gzip_with);
}

test "zlib deflateWith rejects invalid levels before allocations" {
    try checkInvalid(.deflate_with);
}

test "zlib deflateRawWith rejects invalid levels before allocations" {
    try checkInvalid(.raw_with);
}

fn execute(allocator: std.mem.Allocator, operation: Operation, level: i32) ![]const u8 {
    const input = "abc" ** 2000;

    return switch (operation) {
        .gzip => zlib.gzip(allocator, input),
        .deflate => zlib.deflate(allocator, input),
        .raw => zlib.deflateRaw(allocator, input),
        .gzip_with => zlib.gzipWith(allocator, &.{ .data = input, .level = level }),
        .deflate_with => zlib.deflateWith(allocator, &.{ .data = input, .level = level }),
        .raw_with => zlib.deflateRawWith(allocator, &.{ .data = input, .level = level }),
    };
}

fn checkSuccess(allocator: std.mem.Allocator, operation: Operation, level: i32) !void {
    const output = try execute(allocator, operation, level);

    defer allocator.free(output);

    try std.testing.expect(output.len != 0);
}

fn checkInvalid(operation: Operation) !void {
    var allocator = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });

    for ([_]i32{ std.math.minInt(i32), -2, 10, std.math.maxInt(i32) }) |level| {
        try std.testing.expectError(error.InvalidCompressionLevel, execute(allocator.allocator(), operation, level));
    }

    try std.testing.expectEqual(@as(usize, 0), allocator.alloc_index);
}
