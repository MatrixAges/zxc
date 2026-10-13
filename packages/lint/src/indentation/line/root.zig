const std = @import("std");
const generated = @import("generated");

pub const Planned = struct { start: usize, end: usize, count: usize };

pub fn plan(source: []const u8, offset: usize, level: usize) ?Planned {
    var storage: [256]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    const output = generated.executeIn(fixed.allocator(), &.{
        .source = source,
        .offset = offset,
        .level = level,
    }) catch unreachable;

    if (!output.needs_edit) return null;

    return .{
        .start = @intCast(output.start),
        .end = @intCast(output.end),
        .count = @intCast(output.count),
    };
}
