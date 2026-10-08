const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const batch = @import("batch.zig");

fn rejected(allocator: std.mem.Allocator) !void {
    var result = try f.analyze(allocator, .{ .declaration = batch.case.declaration ++ "export declare function broken(input: u64): Missing\n", .members = &.{} });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.name, result.value.diagnostic.code);
}

test "mixed native descriptors release every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{batch.case});
}

test "late signature failure cleans up before member construction" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{});
}
