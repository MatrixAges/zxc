const std = @import("std");
const program = @import("program");
const f = @import("fixture");

fn check(allocator: std.mem.Allocator) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = try program.execute(&arena, &.{
        .source = try fixture.path("source"),
        .marker = try fixture.path("marker"),
        .text = "payload",
        .max_bytes = 7,
    }, f.io);

    try std.testing.expect(output);
    try fixture.expectContent("source", "payload");
    try fixture.expectContent("marker", "payload");
}

test "generated RX discarded nonvoid IO result executes before subsequent write" {
    try check(f.allocator);
}

test "generated RX discarded nonvoid IO result releases all failed allocations" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{});
}

test "generated RX discarded nonvoid IO failure prevents the marker write" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    try fixture.write("marker", "keep");

    try std.testing.expectError(error.StreamTooLong, program.execute(&arena, &.{
        .source = try fixture.path("source"),
        .marker = try fixture.path("marker"),
        .text = "payload",
        .max_bytes = 6,
    }, f.io));

    try fixture.expectContent("source", "payload");
    try fixture.expectContent("marker", "keep");
}
