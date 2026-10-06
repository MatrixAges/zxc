const std = @import("std");
const fixture = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

test "borrowed nested list analysis and codec release every failed allocation" {
    const case: fixture.Case = .{ .input = "string?[][]", .pure = false };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.check, .{case});
}

test "expanded borrowed arguments release every failed allocation" {
    const case: fixture.Case = .{ .input = "[u64, string]", .parameters = "left: u64, right: string", .arguments = "in[0], in[1]", .expanded = true, .pure = false };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.check, .{case});
}

test "IO fallback analysis and codec release every failed allocation" {
    const case: fixture.Case = .{ .input = "string", .prefix = "io, ", .io = true, .pure = false, .local = false };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.check, .{case});
}
