const std = @import("std");
const program = @import("program");
const f = @import("fixture");

test "generated RX discarded void IO call evaluates its list argument first" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const source = try fixture.path("source");
    const output = try program.execute(&arena, &.{ .paths = &.{source}, .text = "data", .marker = try fixture.path("marker") }, f.io);

    try std.testing.expect(output);
    try fixture.expectContent("source", "data");
    try fixture.expectContent("marker", "data");
}

test "generated RX IO argument error prevents both native calls" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    try fixture.write("marker", "keep");
    try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &.{ .paths = &.{}, .text = "replace", .marker = try fixture.path("marker") }, f.io));
    try fixture.expectContent("marker", "keep");
    try fixture.expectMissing("source");
}
