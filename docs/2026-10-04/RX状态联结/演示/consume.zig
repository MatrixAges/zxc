const std = @import("std");
const state = @import("state");

pub fn main(init: std.process.Init) !void {
    const value = try state.execute(init.arena, {});
    const output = try std.json.Stringify.valueAlloc(init.arena.allocator(), value, .{});

    std.debug.print("{s}\n", .{output});
}
