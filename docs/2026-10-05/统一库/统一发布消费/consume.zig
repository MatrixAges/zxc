const std = @import("std");
const increment = @import("increment");
const multiply = @import("multiply");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const value = try multiply.execute(&arena, try increment.execute(&arena, 3));

    if (value != 40) return error.UnexpectedResult;

    std.debug.print("{d}\n", .{value});
}
