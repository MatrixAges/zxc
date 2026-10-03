const std = @import("std");
const zlib = @import("standard").zlib;
const fixtures = @import("fixtures.zig");
const Format = enum { gzip, zlib, raw };
const Failure = enum { limit, checksum, length, truncated };

test "zlib gunzip releases all output allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Format.gzip});
}

test "zlib inflate releases all output allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Format.zlib});
}

test "zlib inflateRaw releases all output allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Format.raw});
}

test "zlib gunzip releases output when limit is exceeded" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.gzip, Failure.limit });
}

test "zlib inflate releases output when limit is exceeded" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.zlib, Failure.limit });
}

test "zlib inflateRaw releases output when limit is exceeded" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.raw, Failure.limit });
}

test "zlib gunzip releases decoded output on checksum failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.gzip, Failure.checksum });
}

test "zlib inflate releases decoded output on checksum failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.zlib, Failure.checksum });
}

test "zlib gunzip releases decoded output on length failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.gzip, Failure.length });
}

test "zlib gunzip releases decoded output on truncated footer" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{ Format.gzip, Failure.truncated });
}

fn input(format: Format) []const u8 {
    return switch (format) {
        .gzip => &fixtures.gzip,
        .zlib => &fixtures.zlib,
        .raw => &fixtures.raw,
    };
}

fn execute(allocator: std.mem.Allocator, format: Format, data: []const u8, limit: u32) ![]const u8 {
    return switch (format) {
        .gzip => zlib.gunzip(allocator, &.{ .data = data, .max_output_length = limit }),
        .zlib => zlib.inflate(allocator, &.{ .data = data, .max_output_length = limit }),
        .raw => zlib.inflateRaw(allocator, &.{ .data = data, .max_output_length = limit }),
    };
}

fn checkSuccess(allocator: std.mem.Allocator, format: Format) !void {
    const output = try execute(allocator, format, input(format), 3);

    defer allocator.free(output);

    try std.testing.expectEqualStrings("abc", output);
}

fn checkFailure(allocator: std.mem.Allocator, format: Format, failure: Failure) !void {
    var storage: [64]u8 = undefined;
    const source = input(format);

    @memcpy(storage[0..source.len], source);

    var data = storage[0..source.len];

    switch (failure) {
        .checksum => data[data.len - (if (format == .gzip) @as(usize, 8) else 4)] ^= 1,
        .length => data[data.len - 4] ^= 1,
        .truncated => data = data[0 .. data.len - 1],
        .limit => {},
    }

    const output = execute(allocator, format, data, if (failure == .limit) 2 else 3) catch |err| {
        if (err == error.OutOfMemory) return err;

        const expected = switch (failure) {
            .limit => error.OutputTooLarge,
            .checksum => error.InvalidChecksum,
            .length => error.InvalidLength,
            .truncated => error.EndOfStream,
        };

        try std.testing.expectEqual(expected, err);

        return;
    };

    defer allocator.free(output);

    return error.TestExpectedError;
}
