const std = @import("std");
const builtin = @import("builtin");
const Backend = if (builtin.os.tag == .windows) @import("process/windows.zig") else @import("process/posix.zig");
const Options = @import("../options.zig").Options;
const Self = @This();

allocator: std.mem.Allocator,
process: ?Backend = null,
path: ?[]const u8 = null,
pub fn deinit(self: *Self, io: std.Io) void {
    _ = self.stop(io) catch null;
}

pub fn restart(self: *Self, io: std.Io, options: Options, environment: *const std.process.Environ.Map) !void {
    var random: [16]u8 = undefined;

    std.Io.random(io, &random);

    const name = try std.fmt.allocPrint(self.allocator, ".{s}.zxc-run-{s}{s}", .{ std.fs.path.basename(options.output.?), std.fmt.bytesToHex(random, .lower), if (builtin.os.tag == .windows) ".exe" else "" });

    defer self.allocator.free(name);

    const path = try std.fs.path.resolve(self.allocator, &.{ std.fs.path.dirname(options.output.?) orelse ".", name });

    errdefer self.allocator.free(path);

    try std.Io.Dir.cwd().copyFile(options.output.?, .cwd(), path, io, .{ .replace = false });

    errdefer {
        const protection = io.swapCancelProtection(.blocked);
        defer _ = io.swapCancelProtection(protection);

        std.Io.Dir.cwd().deleteFile(io, path) catch {};
    }

    const argv = try self.allocator.alloc([]const u8, options.run_args.len + 1);

    defer self.allocator.free(argv);

    argv[0] = path;

    @memcpy(argv[1..], options.run_args);

    _ = try self.stop(io);
    self.process = try Backend.start(io, argv, environment);
    self.path = path;
}

pub fn poll(self: *Self, io: std.Io, stderr: *std.Io.Writer) !void {
    const process = if (self.process) |*value| value else return;

    if (!try process.finished()) return;

    const termination = (try self.stop(io)).?;

    try stderr.print("zxc watch: application {f}; waiting for changes\n", .{termination});
    try stderr.flush();
}

fn stop(self: *Self, io: std.Io) !?std.process.Child.Term {
    const protection = io.swapCancelProtection(.blocked);
    defer _ = io.swapCancelProtection(protection);
    var termination: ?std.process.Child.Term = null;

    if (self.process) |*process| {
        termination = try process.stop(io);
        self.process = null;
    }

    try self.remove(io);

    return termination;
}

fn remove(self: *Self, io: std.Io) !void {
    const path = self.path orelse return;

    self.path = null;

    defer self.allocator.free(path);

    std.Io.Dir.cwd().deleteFile(io, path) catch |err| switch (err) {
        error.FileNotFound => {},
        else => return err,
    };
}
