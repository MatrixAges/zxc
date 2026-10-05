const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    try library.execute(init.arena, "host", init.io);
}
