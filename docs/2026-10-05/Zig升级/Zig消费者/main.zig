const std = @import("std");
const example = @import("example");

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);

    defer arena.deinit();
    std.debug.print("{d}\n", .{try example.execute(&arena, 5)});
}
