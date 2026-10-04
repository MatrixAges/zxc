const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const input: application.Input = if (application.Input == void) blk: {
        if (args.len != 1) return error.ExpectedNoArguments;

        break :blk {};
    } else blk: {
        if (args.len != 2) return error.ExpectedJsonInput;

        break :blk try std.json.parseFromSliceLeaky(application.Input, allocator, args[1], .{ .allocate = .alloc_always });
    };

    var state = State{ .arena = init.arena };

    try state.initialize();

    const output = try application.execute(init.arena, input, &state);
    var buffer: [4096]u8 = undefined;
    var file = std.Io.File.Writer.init(.stdout(), init.io, &buffer);

    if (application.Output == void) {
        try file.interface.writeAll("null");
    } else {
        try std.json.Stringify.value(output, .{}, &file.interface);
    }

    try file.interface.writeByte('\n');
    try file.interface.flush();
}
