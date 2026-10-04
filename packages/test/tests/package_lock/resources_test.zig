const std = @import("std");
const Fixture = @import("fixture.zig");

test "lock diamond validation releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{false});
}

test "lock cycle rejection releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{true});
}

fn check(allocator: std.mem.Allocator, cycle: bool) !void {
    var fixture = try Fixture.init(if (cycle) &.{ &.{1}, &.{0} } else &.{ &.{ 1, 2 }, &.{3}, &.{3}, &.{} });
    defer fixture.deinit();
    fixture.validate(allocator) catch |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expect(cycle);
        try std.testing.expectEqual(error.CyclicPackageDependencies, err);
        return;
    };

    try std.testing.expect(!cycle);
}
