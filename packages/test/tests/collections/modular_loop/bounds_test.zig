const std = @import("std");
const run = @import("execution.zig").run;
const root = @import("root.zig");

comptime {
    _ = root;
}

test "modular dynamic bounds preserve exact errors and zero step laziness" {
    for ([_]u64{ 0, 1, 17, std.math.maxInt(u64) }) |selected| {
        try run(std.testing.allocator, .{ .count = 0, .frames = 0, .selected = selected });
        try run(std.testing.allocator, .{ .count = 3, .frames = 17, .selected = selected });
    }
}
