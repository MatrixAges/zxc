const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");
const f = @import("fixture");

fn check(allocator: std.mem.Allocator, enabled: bool) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = try program.execute(&arena, &.{
        .enabled = enabled,
        .fallback = "unchanged",
        .request = &.{
            .source = try fixture.path(if (enabled) "source" else "source\x00invalid"),
            .copy = try fixture.path("copy"),
            .destination = try fixture.path("destination"),
            .text = "payload",
            .max_bytes = 7,
            .length = 3,
            .exclusive = true,
        },
    }, f.io);

    if (enabled) {
        try std.testing.expectEqualStrings("payload", output.before);
        try std.testing.expectEqualStrings("pay", output.after);
        try fixture.expectContent("source", "payload");
        try fixture.expectContent("destination", "pay");
    } else {
        try std.testing.expectEqualStrings("unchanged", output.before);
        try std.testing.expectEqualStrings("unchanged", output.after);
        try fixture.expectMissing("source");
        try fixture.expectMissing("destination");
    }

    try fixture.expectMissing("copy");
}

test "generated RX Switch selected service receives host IO" {
    try check(f.allocator, true);
}

test "generated RX Switch unselected service performs no IO or path validation" {
    try check(f.allocator, false);
}

test "generated RX selected IO branch frees every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, check, .{true});
}

test "generated RX unselected IO branch frees every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, check, .{false});
}
