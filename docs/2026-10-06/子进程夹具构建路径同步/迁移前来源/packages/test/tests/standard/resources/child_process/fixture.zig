const std = @import("std");
pub const child = @import("standard").child_process;
const build_options = @import("options");
pub const executable = if (std.fs.path.isAbsolute(build_options.child)) build_options.child else std.fmt.comptimePrint("{s}/{s}", .{ build_options.root, build_options.child });
pub const Options = std.meta.Child(child.Options);
pub const allocator = std.testing.allocator;
pub const io = std.testing.io;

pub fn options(args: []const []const u8) Options {
    return .{ .command = executable, .args = args, .cwd = null, .env = null, .max_stdout_bytes = 1024 * 1024, .max_stderr_bytes = 1024 * 1024 };
}

pub fn free(gpa: std.mem.Allocator, result: child.Result) void {
    gpa.free(result.stdout);
    gpa.free(result.stderr);
    gpa.destroy(result);
}

pub fn expect(input: Options, stdout: []const u8, stderr: []const u8, code: u32) !void {
    const result = try child.spawnSync(allocator, io, &input);

    defer free(allocator, result);

    try std.testing.expectEqual(child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(code, result.code);
    try std.testing.expectEqualSlices(u8, stdout, result.stdout);
    try std.testing.expectEqualSlices(u8, stderr, result.stderr);
}
