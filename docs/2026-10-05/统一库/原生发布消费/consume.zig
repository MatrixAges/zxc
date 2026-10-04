const std = @import("std");
const once = @import("once");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const first = try once.execute(&arena, .First);
    const second = try once.execute(&arena, .Second);

    std.debug.print("{t} {t}\n", .{ first, second });
}
