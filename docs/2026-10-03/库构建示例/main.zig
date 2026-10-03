const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    const arguments = try init.minimal.args.toSlice(init.arena.allocator());

    if (arguments.len != 3) return error.ExpectedTextAndNumber;

    const value = try std.fmt.parseFloat(f64, arguments[2]);
    const result = try library.execute(init.arena, .{ .text = arguments[1], .number = value });

    std.debug.print("sha256={s}\nroot={d}\n", .{ result.encoded, result.root });
}
