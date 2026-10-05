const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

test "package store first preparation frees every failed allocation and staging directory" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkPrepare, .{false});
}

test "package store cached verification frees every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkPrepare, .{true});
}

fn checkPrepare(gpa: std.mem.Allocator, cached: bool) !void {
    var fixture = try Fixture.init(Fixture.valid);

    defer fixture.deinit();

    if (cached) allocator.free(try fixture.prepare(allocator, false));

    const result = fixture.prepare(gpa, cached) catch |err| {
        try fixture.expectNoStaging();

        return err;
    };

    defer gpa.free(result);

    try Fixture.expectContent(result);
    try fixture.expectNoStaging();
}
