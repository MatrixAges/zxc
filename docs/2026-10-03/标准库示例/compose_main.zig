const std = @import("std");
const compose = @import("compose");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 3) return error.ExpectedTextAndNumber;

    const result = try compose.execute(init.arena, .{ .text = args[1], .number = try std.fmt.parseFloat(f64, args[2]) });

    std.debug.print("sha256={s}\nroot={d}\n", .{ result.encoded, result.root });
}
