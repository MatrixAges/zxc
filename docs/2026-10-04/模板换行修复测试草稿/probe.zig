const std = @import("std");
const program = @import("program");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const actual = try program.execute(&arena, 0);

    for (actual) |byte| std.debug.print("{x:0>2}", .{byte});

    std.debug.print("\n", .{});
}
