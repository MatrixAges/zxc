const std = @import("std");
const program = @import("program");
const f = @import("fixture");
const options = @import("options");

fn check(allocator: std.mem.Allocator) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = try program.execute(&arena, &.{
        .source = try fixture.path("source"),
        .copy = try fixture.path("copy"),
        .destination = try fixture.path("destination"),
        .text = "payload",
        .length = 3,
        .exclusive = true,
    }, f.io);

    if (options.service) try std.testing.expect(output);

    try fixture.expectContent("source", "payload");
    try fixture.expectMissing("copy");
    try fixture.expectContent("destination", "pay");
}

test "generated RX void flow executes all discarded side effects" {
    try check(f.allocator);
}

test "generated RX void flow cleans every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{});
}

test "generated RX void flow error stops caller completion and later operations" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    try fixture.write("copy", "keep");

    try std.testing.expectError(error.PathAlreadyExists, program.execute(&arena, &.{
        .source = try fixture.path("source"),
        .copy = try fixture.path("copy"),
        .destination = try fixture.path("destination"),
        .text = "payload",
        .length = 1,
        .exclusive = true,
    }, f.io));

    try fixture.expectContent("source", "payload");
    try fixture.expectContent("copy", "keep");
    try fixture.expectMissing("destination");
}
