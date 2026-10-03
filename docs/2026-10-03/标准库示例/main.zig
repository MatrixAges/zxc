const std = @import("std");
const digest = @import("digest");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedTextArgument;

    const result = try digest.execute(init.arena, args[1]);

    std.debug.print("base64={s}\nhex={s}\nsha256={s}\nsha512={s}\ndecoded={s}\n", .{ result.base64, result.hex, result.sha256, result.sha512, result.decoded });
}
