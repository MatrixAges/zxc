const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, environment: bool) !void {
    var input = f.options(&.{"bytes"});

    if (environment) input.env = &.{ &.{ .name = "A", .value = "one" }, &.{ .name = "A", .value = "two" }, &.{ .name = "B", .value = "three" } };

    const result = try f.child.spawnSync(allocator, f.io, &input);

    defer f.free(allocator, result);

    try std.testing.expectEqualSlices(u8, &.{ 0, 255, 128, 13, 10 }, result.stdout);
    try std.testing.expectEqualSlices(u8, &.{ 254, 0, 127 }, result.stderr);
}

test "child process releases every failed allocation without environment" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, run, .{false});
}

test "child process releases every failed allocation with duplicate environment keys" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, run, .{true});
}

fn invalid(allocator: std.mem.Allocator) !void {
    var input = f.options(&.{"bytes"});
    input.env = &.{ &.{ .name = "VALID", .value = "allocated" }, &.{ .name = "INVALID=KEY", .value = "rejected" } };

    const result = f.child.spawnSync(allocator, f.io, &input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidEnvironmentName, err);

        return;
    };

    defer f.free(allocator, result);

    return error.ExpectedValidationFailure;
}

test "child process frees partial environment map on validation and allocation failures" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, invalid, .{});
}

fn overflow(allocator: std.mem.Allocator) !void {
    var input = f.options(&.{"bytes"});

    input.max_stderr_bytes = 2;

    const result = f.child.spawnSync(allocator, f.io, &input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.StreamTooLong, err);

        return;
    };

    defer f.free(allocator, result);

    return error.ExpectedLimitFailure;
}

test "child process output overflow releases every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, overflow, .{});
}
