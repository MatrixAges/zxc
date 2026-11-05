const std = @import("std");
const generated = @import("generated");

pub fn check(terms: u64, list: bool, branch: bool) bool {
    const input: std.meta.Child(generated.Input) = .{ .terms = terms, .list = list, .branch = branch };
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return generated.executeValue(memory.allocator(), &input) catch unreachable;
}
