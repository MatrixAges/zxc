const std = @import("std");
const builtin = @import("builtin");
const Self = @This();

const Wait = if (builtin.os.tag == .linux) std.os.linux.W else struct {
    const EXITED = 0x04;
    const NOHANG = 0x01;
    const NOWAIT = 0x20;
};

const process_id = 1;

child: std.process.Child,
pub fn start(io: std.Io, argv: []const []const u8, environment: *const std.process.Environ.Map) !Self {
    if (builtin.os.tag != .linux and builtin.os.tag != .macos) return error.UnsupportedWatchRunPlatform;

    return .{ .child = try std.process.spawn(io, .{ .argv = argv, .environ_map = environment, .pgid = 0, .stdin = .ignore }) };
}

pub fn finished(self: *Self) !bool {
    var info: std.c.siginfo_t = std.mem.zeroes(std.c.siginfo_t);
    const flags: c_int = Wait.EXITED | Wait.NOHANG | Wait.NOWAIT;

    while (true) switch (std.posix.errno(waitid(process_id, @intCast(self.child.id.?), &info, flags))) {
        .SUCCESS => return if (builtin.os.tag == .linux) info.fields.common.first.piduid.pid != 0 else info.pid != 0,
        .INTR => continue,
        else => |err| return std.posix.unexpectedErrno(err),
    };
}

pub fn stop(self: *Self, io: std.Io) !std.process.Child.Term {
    const protection = io.swapCancelProtection(.blocked);
    defer _ = io.swapCancelProtection(protection);

    try self.signal(.TERM);

    for (0..10) |_| {
        if (try self.finished()) break;
        try std.Io.sleep(io, .fromMilliseconds(50), .awake);
    }

    try self.signal(.KILL);

    return self.child.wait(io);
}

fn signal(self: *Self, value: std.posix.SIG) !void {
    std.posix.kill(-self.child.id.?, value) catch |err| switch (err) {
        error.ProcessNotFound => {},
        error.PermissionDenied => if (builtin.os.tag != .macos or !try self.finished()) return err,
        else => return err,
    };
}

extern "c" fn waitid(c_uint, c_uint, *std.c.siginfo_t, c_int) c_int;
