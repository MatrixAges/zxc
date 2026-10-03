const std = @import("std");
const builtin = @import("builtin");
const bundle = @import("bundle");
pub const Paths = struct { root: []const u8, executable: []const u8, library: []const u8, standard: []const u8 };

pub fn resolve(io: std.Io, allocator: std.mem.Allocator, environment: *const std.process.Environ.Map) !Paths {
    const cache = try @import("toolchain/cache.zig").root(allocator, environment);
    const parent = try std.fs.path.join(allocator, &.{ cache, "toolchains" });
    const root = try std.fs.path.join(allocator, &.{ parent, bundle.digest });

    try std.Io.Dir.cwd().createDirPath(io, parent);

    const lock = try std.Io.Dir.cwd().createFile(io, try std.fmt.allocPrint(allocator, "{s}.lock", .{root}), .{ .truncate = false });

    defer lock.close(io);

    try lock.lock(io, .exclusive);
    if (!try ready(io, allocator, root)) try unpack(io, allocator, root);

    return .{
        .root = root,
        .executable = try std.fs.path.join(allocator, &.{ root, "zig", if (builtin.os.tag == .windows) "zig.exe" else "zig" }),
        .library = try std.fs.path.join(allocator, &.{ root, "zig", "lib" }),
        .standard = try std.fs.path.join(allocator, &.{ root, "standard" }),
    };
}

fn ready(io: std.Io, allocator: std.mem.Allocator, root: []const u8) !bool {
    var directory = std.Io.Dir.cwd().openDir(io, root, .{}) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };

    defer directory.close(io);

    const marker = directory.readFileAlloc(io, "ready", allocator, .limited(128)) catch return error.IncompleteToolchainCache;

    defer allocator.free(marker);

    if (!std.mem.eql(u8, marker, bundle.digest)) return error.IncompleteToolchainCache;

    for ([_][]const u8{ if (builtin.os.tag == .windows) "zig/zig.exe" else "zig/zig", "zig/lib/std/std.zig", "standard/src/root.zig" }) |path| {
        const file = directory.openFile(io, path, .{}) catch return error.IncompleteToolchainCache;

        defer file.close(io);

        const stat = try file.stat(io);

        if (stat.kind != .file or stat.size == 0) return error.IncompleteToolchainCache;
    }

    return true;
}

fn unpack(io: std.Io, allocator: std.mem.Allocator, root: []const u8) !void {
    const staging = try std.fmt.allocPrint(allocator, "{s}.partial", .{root});

    try std.Io.Dir.cwd().deleteTree(io, staging);
    try std.Io.Dir.cwd().createDirPath(io, staging);

    errdefer std.Io.Dir.cwd().deleteTree(io, staging) catch {};

    {
        var directory = try std.Io.Dir.cwd().openDir(io, staging, .{});

        defer directory.close(io);

        try @import("toolchain/extract.zig").run(io, allocator, directory);
    }

    try @import("artifacts.zig").write(io, try std.fs.path.join(allocator, &.{ staging, "ready" }), bundle.digest);
    if (!try ready(io, allocator, staging)) return error.IncompleteToolchainCache;
    try std.Io.Dir.cwd().rename(staging, std.Io.Dir.cwd(), root, io);
}
