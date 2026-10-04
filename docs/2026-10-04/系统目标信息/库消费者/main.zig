const std = @import("std");
const library = @import("library");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const output = try library.execute(&arena, {});
    const json = try std.json.Stringify.valueAlloc(arena.allocator(), output, .{});

    std.debug.print("{s}\n", .{json});
}
