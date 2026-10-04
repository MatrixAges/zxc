const std = @import("std");
const library = @import("library");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();
    std.debug.print("{d}\n", .{try library.execute(&arena, 41)});
}
