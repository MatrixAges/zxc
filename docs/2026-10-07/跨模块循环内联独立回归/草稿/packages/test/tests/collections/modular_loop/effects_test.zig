const std = @import("std");
const run = @import("execution.zig").run;
const Case = @import("model.zig").Case;
const allocation_testing = @import("allocation_testing");
const bounds = @import("bounds_test.zig");

comptime {
    _ = bounds;
}

test "native argument evaluation runs once through initial condition and each step" {
    for ([_]u64{ 0, 1, 2, 3, 6 }) |token| try run(std.testing.allocator, .{ .count = 3, .frames = 17, .fail_token = token });
}

test "native argument errors precede callee bounds with exact trace cutoff" {
    for ([_]u64{ 0, 1, 2, std.math.maxInt(u64) }) |token| try run(std.testing.allocator, .{ .count = 3, .frames = 0, .selected = std.math.maxInt(u64), .fail_token = token });
}

test "native later call failure keeps the first selected result alive" {
    try run(std.testing.allocator, .{ .count = 3, .frames = 17, .columns = 17, .fail_token = 7 });
}

test "native failure prefixes and retained results release every allocation failure" {
    for ([_]Case{
        .{ .count = 3, .frames = 17, .columns = 17, .fail_token = 3 },
        .{ .count = 3, .frames = 17, .columns = 17, .fail_token = 7 },
        .{ .count = 3, .frames = 0, .fail_token = 1 },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{args});
}
