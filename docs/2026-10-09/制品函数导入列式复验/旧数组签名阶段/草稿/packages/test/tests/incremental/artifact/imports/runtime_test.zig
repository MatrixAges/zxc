const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Input = @typeInfo(program.Input).pointer.child;

fn execute(allocator: std.mem.Allocator, value: u64) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var input = struct { before: u64 = 87654321, value: Input, after: u64 = 12345678 }{ .value = .{ .value = value } };
    const output = try program.execute(&arena, &input.value);

    try std.testing.expectEqual(value + 2, output.value);
    try std.testing.expectEqual(value, input.value.value);
    try std.testing.expectEqual(@as(u64, 87654321), input.before);
    try std.testing.expectEqual(@as(u64, 12345678), input.after);
}

test "relinked alias calls execute twice through the actual generated program" {
    for ([_]u64{ 0, 1, 17, 65537, std.math.maxInt(u64) - 2 }) |value| try execute(std.testing.allocator, value);
}

test "relinked alias calls preserve earlier outputs during repeated executions" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &.{ .value = 0 });
    const second = try program.execute(&arena, &.{ .value = 999 });

    try std.testing.expectEqual(@as(u64, 2), first.value);
    try std.testing.expectEqual(@as(u64, 1001), second.value);
}

test "relinked alias calls clean every runtime allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execute, .{@as(u64, 17)});
}
