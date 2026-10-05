const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const mode = args[1];
    const stdout = std.Io.File.stdout();
    const stderr = std.Io.File.stderr();

    if (std.mem.eql(u8, mode, "args")) {
        for (args[2..]) |argument| {
            try stdout.writeStreamingAll(init.io, argument);
            try stdout.writeStreamingAll(init.io, &.{0});
        }
    } else if (std.mem.eql(u8, mode, "bytes")) {
        try stdout.writeStreamingAll(init.io, &.{ 0, 255, 128, 13, 10 });
        try stderr.writeStreamingAll(init.io, &.{ 254, 0, 127 });
    } else if (std.mem.eql(u8, mode, "exit")) {
        std.process.exit(try std.fmt.parseInt(u8, args[2], 10));
    } else if (std.mem.eql(u8, mode, "signal") and @import("builtin").os.tag != .windows) {
        try std.posix.raise(.TERM);

        return error.SignalDidNotTerminate;
    } else if (std.mem.eql(u8, mode, "streams")) {
        const count = try std.fmt.parseInt(usize, args[2], 10);
        const out = @as([4096]u8, @splat('o'));
        const err = @as([4096]u8, @splat('e'));
        var written: usize = 0;

        while (written < count) {
            const size = @min(count - written, out.len);

            try stdout.writeStreamingAll(init.io, out[0..size]);
            try stderr.writeStreamingAll(init.io, err[0..size]);

            written += size;
        }
    } else if (std.mem.eql(u8, mode, "env")) {
        if (init.environ_map.get("ZXC_CHILD_TEST_VALUE")) |value| {
            try stdout.writeStreamingAll(init.io, value);
        } else try stdout.writeStreamingAll(init.io, "<missing>");
    } else if (std.mem.eql(u8, mode, "cwd")) {
        const path = try std.Io.Dir.cwd().realPathFileAlloc(init.io, ".", init.arena.allocator());

        try stdout.writeStreamingAll(init.io, path);
    } else if (std.mem.eql(u8, mode, "stdin")) {
        var buffer: [8]u8 = undefined;

        _ = std.Io.File.stdin().readStreaming(init.io, &.{&buffer}) catch |err| {
            if (err != error.EndOfStream) return err;
            try stdout.writeStreamingAll(init.io, "eof");

            return;
        };

        return error.UnexpectedInput;
    } else return error.UnknownMode;
}
