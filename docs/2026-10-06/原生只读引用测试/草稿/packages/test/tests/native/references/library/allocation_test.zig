const std = @import("std");
const allocation_testing = @import("allocation_testing");
const types = @import("types.zig");
const mutation = @import("mutation.zig");
const roundtrip = @import("roundtrip.zig");

fn accepted(allocator: std.mem.Allocator) !void {
    try roundtrip.run(allocator, true);
}

fn rejected(allocator: std.mem.Allocator) !void {
    var value = try types.library(allocator);

    defer value.deinit();

    try types.inspect(&value);
    try mutation.apply(&value, .other_origin);
    try mutation.rejected(allocator, &value);
}

test "native reference consumer and republisher clean up every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, accepted, .{});
}

test "native reference late codec semantic rejection cleans up every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{});
}
