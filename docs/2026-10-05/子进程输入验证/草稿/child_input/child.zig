const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const mode = args[1];
    var deadline_task = try std.Io.concurrent(init.io, deadline, .{init.io});

    defer deadline_task.cancel(init.io);

    if (std.mem.eql(u8, mode, "close")) {
        std.Io.File.stdin().close(init.io);

        try std.Io.sleep(init.io, .fromSeconds(10), .awake);

        return;
    }

    if (std.mem.eql(u8, mode, "duplex")) {
        const out = [_]u8{'o'} ** 4096;
        const err = [_]u8{'e'} ** 4096;

        for (0..64) |_| {
            try std.Io.File.stdout().writeStreamingAll(init.io, &out);
            try std.Io.File.stderr().writeStreamingAll(init.io, &err);
        }
    }

    var buffer: [8192]u8 = undefined;

    while (true) {
        const count = std.Io.File.stdin().readStreaming(init.io, &.{&buffer}) catch |err| {
            if (err == error.EndOfStream) break;

            return err;
        };

        if (std.mem.eql(u8, mode, "echo") or std.mem.eql(u8, mode, "duplex") or std.mem.eql(u8, mode, "mirror")) try std.Io.File.stdout().writeStreamingAll(init.io, buffer[0..count]);
        if (std.mem.eql(u8, mode, "mirror")) try std.Io.File.stderr().writeStreamingAll(init.io, buffer[0..count]);
    }

    if (std.mem.eql(u8, mode, "eof")) try std.Io.File.stdout().writeStreamingAll(init.io, "eof");
    if (std.mem.eql(u8, mode, "exit")) std.process.exit(73);

    if (std.mem.eql(u8, mode, "signal") and @import("builtin").os.tag != .windows) {
        try std.posix.raise(.TERM);

        return error.SignalDidNotTerminate;
    }

    if (std.mem.eql(u8, mode, "args")) for (args[2..]) |argument| {
        try std.Io.File.stdout().writeStreamingAll(init.io, argument);
        try std.Io.File.stdout().writeStreamingAll(init.io, &.{0});
    };

    if (std.mem.eql(u8, mode, "env")) try std.Io.File.stdout().writeStreamingAll(init.io, init.environ_map.get("ZXC_CHILD_INPUT_VALUE") orelse "missing");

    if (std.mem.eql(u8, mode, "cwd")) {
        const cwd = try std.Io.Dir.cwd().realPathFileAlloc(init.io, ".", init.arena.allocator());

        try std.Io.File.stdout().writeStreamingAll(init.io, cwd);
    }
}

fn deadline(io: std.Io) void {
    std.Io.sleep(io, .fromSeconds(15), .awake) catch return;
    std.process.exit(124);
}
