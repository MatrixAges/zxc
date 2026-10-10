const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const lanes = @import("lane_fixture.zig");

fn create(allocator: std.mem.Allocator, program: f.ir.Program, capability: f.Capability) !void {
    var owned = try f.checks.summary.create(allocator, program);

    defer owned.deinit();

    try f.expected(owned.value, program.functions.count(), capability);
}

fn check(capability: f.Capability) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = try f.program(arena.allocator(), 3, capability);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, create, .{ program, capability });
}

test "owned scalar summaries clean every failed allocation" {
    try check(.none);
}

test "owned native capability summaries clean every failed allocation" {
    try check(.io);
    try check(.process);
}

test "owned nested lane arenas clean every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, lanes.copied, .{});
}
