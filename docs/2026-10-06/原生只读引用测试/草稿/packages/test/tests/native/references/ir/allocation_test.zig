const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const mutation = @import("mutation.zig");

fn rejected(allocator: std.mem.Allocator) !void {
    var result = try f.analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    try f.rejected(allocator, try mutation.apply(arena.allocator(), result.value.ir, .nested_concurrent));
}

fn accepted(allocator: std.mem.Allocator) !void {
    var result = try f.analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const program = try mutation.apply(arena.allocator(), result.value.ir, .same_owner);

    try std.testing.expect(try f.compiler.validateIr(allocator, program) == null);

    const bundle = try f.compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}

test "independent native reference rejection cleans up every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{});
}

test "independent native reference alias generation cleans up every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, accepted, .{});
}
