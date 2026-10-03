const std = @import("std");
const grade = @import("grade");
const quote = @import("quote");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const result = try grade.execute(&arena, .{ .score = 85.5, .enabled = true, .status = "paid", .weights = &.{} });
    const price = try quote.execute(&arena, .{ .subtotal = 12000, .discount = 1000, .shipping_fee = 600, .free_shipping_minimum = 10000 });

    std.debug.print("grade={s}, ready={}, score={d}; shipping={d}, payable={d}\n", .{ result.grade, result.ready, result.score, price.shipping, price.payable });
}
