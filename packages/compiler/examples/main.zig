const std = @import("std");
const quote = @import("quote");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const result = try quote.execute(&arena, &.{ .amount = 100, .discount = 20, .enabled = true, .factor = 1.5 });

    std.debug.print("amount={d}, factor={d}\n", .{ result.amount, result.factor });
}
