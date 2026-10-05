const std = @import("std");
const builtin = @import("builtin");
const watch = @import("../watch.zig");
const Options = @import("../options.zig").Options;
const windows = builtin.os.tag == .windows;
const Action = if (windows) void else std.posix.Sigaction;
var interrupted: std.atomic.Value(bool) = .init(false);

pub fn requested() bool {
    return interrupted.load(.monotonic);
}

pub fn run(io: std.Io, allocator: std.mem.Allocator, options: Options, environment: *const std.process.Environ.Map, stdout: *std.Io.Writer, stderr: *std.Io.Writer) !void {
    const signals = try Signals.init();

    defer signals.deinit();

    var done: std.atomic.Value(bool) = .init(false);
    var future = try io.concurrent(execute, .{ io, allocator, options, environment, stdout, stderr, &done });

    defer future.cancel(io) catch {};

    while (!done.load(.acquire) and !interrupted.load(.monotonic)) try std.Io.sleep(io, .fromMilliseconds(50), .awake);

    const result = if (interrupted.load(.monotonic)) future.cancel(io) else future.await(io);

    result catch |err| {
        if (err != error.Canceled) return err;
    };
}

fn execute(io: std.Io, allocator: std.mem.Allocator, options: Options, environment: *const std.process.Environ.Map, stdout: *std.Io.Writer, stderr: *std.Io.Writer, done: *std.atomic.Value(bool)) anyerror!void {
    defer done.store(true, .release);

    try watch.run(io, allocator, options, environment, stdout, stderr);
}

const Signals = struct {
    interrupt: Action,
    terminate: Action,
    fn init() !@This() {
        interrupted.store(false, .monotonic);

        if (windows) {
            if (SetConsoleCtrlHandler(console, 1) == 0) return error.ConsoleHandlerFailed;

            return .{ .interrupt = {}, .terminate = {} };
        }

        var self: @This() = undefined;
        const action: Action = .{ .handler = .{ .handler = signal }, .mask = std.posix.sigemptyset(), .flags = 0 };

        std.posix.sigaction(.INT, &action, &self.interrupt);
        std.posix.sigaction(.TERM, &action, &self.terminate);

        return self;
    }
    fn deinit(self: @This()) void {
        if (windows) {
            _ = SetConsoleCtrlHandler(console, 0);
        } else {
            std.posix.sigaction(.INT, &self.interrupt, null);
            std.posix.sigaction(.TERM, &self.terminate, null);
        }
    }
};

fn signal(_: std.posix.SIG) callconv(.c) void {
    interrupted.store(true, .monotonic);
}

fn console(event: u32) callconv(.winapi) c_int {
    if (event != 0 and event != 1) return 0;

    interrupted.store(true, .monotonic);

    return 1;
}

extern "kernel32" fn SetConsoleCtrlHandler(?*const fn (u32) callconv(.winapi) c_int, c_int) callconv(.winapi) c_int;
