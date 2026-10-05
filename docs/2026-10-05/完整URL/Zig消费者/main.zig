const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const input: library.Input = if (library.Input == void) blk: {
        if (args.len != 1) return error.ExpectedNoArguments;

        break :blk {};
    } else blk: {
        if (args.len != 2) return error.ExpectedJsonInput;

        break :blk try std.json.parseFromSliceLeaky(library.Input, allocator, args[1], .{ .allocate = .alloc_always });
    };

    const output = try library.execute(init.arena, input);
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
