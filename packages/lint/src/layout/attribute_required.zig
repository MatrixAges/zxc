const std = @import("std");
const generated = @import("generated");

pub fn check(source: []const u8, level: usize, prefix: usize) bool {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    return generated.executeIn(fixed.allocator(), &.{ .source = source, .level = level, .prefix = prefix }) catch unreachable;
}
