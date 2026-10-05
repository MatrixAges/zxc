const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const mutation = @import("mutation.zig");
const compiler = f.compiler;

fn publish(allocator: std.mem.Allocator) !void {
    var value = try f.library(allocator, .{});

    defer value.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &value);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();
}

fn consume(allocator: std.mem.Allocator, bytes: []const u8) !void {
    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    var analyzed = try f.consume(allocator, &decoded, "u64");

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, analyzed.value.ir) == null);
}

fn reject(allocator: std.mem.Allocator, bytes: []const u8) !void {
    var unexpected = compiler.library.codec.decode(allocator, bytes) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidLibrary, err);

        return;
    };

    unexpected.deinit();

    return error.ExpectedInvalidLibrary;
}

test "typed capture publication and roundtrip clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, publish, .{});
}

test "typed capture compiled consumer cleans every allocation failure" {
    var value = try f.library(std.testing.allocator, .{});

    defer value.deinit();

    const bytes = try compiler.library.codec.encode(std.testing.allocator, &value);

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, consume, .{bytes});
}

test "typed capture semantic decode rejection cleans every allocation failure" {
    var value = try f.library(std.testing.allocator, .{});

    defer value.deinit();

    try mutation.apply(&value, .guard);

    const bytes = try mutation.envelope(std.testing.allocator, &value);

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{bytes});
}
