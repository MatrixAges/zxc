const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var state = State{ .arena = init.arena };

    defer state.deinit();

    try state.initialize();

    var request = state.request();

    defer request.deinit();

    const allocator = request.arena.allocator();

    const input: application.Input = if (application.Input == void) blk: {
        if (!application.requires_process and args.len != 1) return error.ExpectedNoArguments;

        break :blk {};
    } else blk: {
        if (args.len != 2) return error.ExpectedJsonInput;

        break :blk try std.json.parseFromSliceLeaky(application.Input, allocator, args[1], .{ .allocate = .alloc_always });
    };

    const output = if (application.requires_process)
        if (application.requires_io) try request.execute(input, init.io, init.minimal) else try request.execute(input, init.minimal)

    else if (application.requires_io)
        try request.execute(input, init.io)
    else
        try request.execute(input);

    if (@import("result.zig").emit) {
        var buffer: [4096]u8 = undefined;
        var file = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

        if (application.Output == void) {
            try file.interface.writeAll("null");
        } else {
            try std.json.Stringify.value(output, .{}, &file.interface);
        }

        try file.interface.writeByte('\n');
        try file.interface.flush();
    }
}
