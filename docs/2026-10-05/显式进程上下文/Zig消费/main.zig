const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    const output = try library.execute(init.arena, {}, init.io, init.minimal);
    var buffer: [4096]u8 = undefined;
    var file = std.Io.File.Writer.init(.stdout(), init.io, &buffer);

    if (library.Output == void) {
        try file.interface.writeAll("null");
    } else {
        try std.json.Stringify.value(output, .{}, &file.interface);
    }

    try file.interface.writeByte('\n');
    try file.interface.flush();
}
