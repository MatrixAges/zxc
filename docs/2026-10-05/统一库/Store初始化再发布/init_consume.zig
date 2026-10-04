const std = @import("std");
const initial = @import("initial");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const state = try initial.execute(&arena, {});

    std.debug.print("value={d} history={any}\n", .{ state.value, state.history });
}
