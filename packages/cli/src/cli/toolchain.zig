const std = @import("std");
const builtin = @import("builtin");
const bundle = @import("bundle");
pub const Paths = struct { root: []const u8, executable: []const u8, library: []const u8, standard: []const u8 };

const zig_executable = if (builtin.os.tag == .windows) "zig.exe" else "zig";

/// What one cache directory holds: its marker digest, the files that prove it complete and how to fill it.
const Contents = struct { digest: []const u8, required: []const []const u8, extract: *const fn (std.Io, std.mem.Allocator, std.Io.Dir) anyerror!void };

const bundled: Contents = .{ .digest = bundle.digest, .required = &.{ "zig/" ++ zig_executable, "zig/lib/std/std.zig", "standard/src/root.zig" }, .extract = @import("toolchain/extract.zig").run };
const resources: Contents = .{ .digest = bundle.resources_digest, .required = &.{"standard/src/root.zig"}, .extract = @import("toolchain/extract.zig").resources };

/// The Zig toolchain and zxc standard sources a build uses. `ZXC_ZIG` names a Zig executable to use instead of the
/// bundled one; zxc then unpacks only its own standard sources.
pub fn resolve(io: std.Io, allocator: std.mem.Allocator, environment: *const std.process.Environ.Map) !Paths {
    if (environment.get("ZXC_ZIG")) |zig| return external(io, allocator, environment, zig);

    const root = try prepare(io, allocator, environment, bundle.digest, bundled);

    return .{
        .root = root,
        .executable = try std.fs.path.join(allocator, &.{ root, "zig", zig_executable }),
        .library = try std.fs.path.join(allocator, &.{ root, "zig", "lib" }),
        .standard = try std.fs.path.join(allocator, &.{ root, "standard" }),
    };
}

fn external(io: std.Io, allocator: std.mem.Allocator, environment: *const std.process.Environ.Map, zig: []const u8) !Paths {
    const executable = std.Io.Dir.cwd().realPathFileAlloc(io, zig, allocator) catch return error.ZxcZigNotFound;
    const root = try prepare(io, allocator, environment, try std.fmt.allocPrint(allocator, "resources-{s}", .{bundle.resources_digest}), resources);

    return .{ .root = root, .executable = executable, .library = try library(io, allocator, executable), .standard = try std.fs.path.join(allocator, &.{ root, "standard" }) };
}

/// The library directory of a Zig installation: beside the executable in official archives, or under `lib/zig` in
/// system packages.
fn library(io: std.Io, allocator: std.mem.Allocator, executable: []const u8) ![]const u8 {
    const directory = std.fs.path.dirname(executable) orelse return error.ZxcZigLibraryNotFound;

    for ([_][]const []const u8{ &.{"lib"}, &.{ "..", "lib", "zig" }, &.{ "..", "lib" } }) |parts| {
        var segments: [4][]const u8 = undefined;

        segments[0] = directory;
        @memcpy(segments[1..][0..parts.len], parts);

        const candidate = try std.fs.path.resolve(allocator, segments[0 .. parts.len + 1]);
        const marker = try std.fs.path.join(allocator, &.{ candidate, "std", "std.zig" });

        if (std.Io.Dir.cwd().access(io, marker, .{})) |_| return candidate else |_| {}
    }

    return error.ZxcZigLibraryNotFound;
}

/// The cache directory `name` with `contents`, unpacked under a lock when missing.
fn prepare(io: std.Io, allocator: std.mem.Allocator, environment: *const std.process.Environ.Map, name: []const u8, contents: Contents) ![]const u8 {
    const cache = try @import("toolchain/cache.zig").root(allocator, environment);
    const parent = try std.fs.path.join(allocator, &.{ cache, "toolchains" });
    const root = try std.fs.path.join(allocator, &.{ parent, name });

    try std.Io.Dir.cwd().createDirPath(io, parent);

    const lock = try std.Io.Dir.cwd().createFile(io, try std.fmt.allocPrint(allocator, "{s}.lock", .{root}), .{ .truncate = false });

    defer lock.close(io);

    try lock.lock(io, .exclusive);
    if (!try ready(io, allocator, root, contents)) try unpack(io, allocator, root, contents);

    return root;
}

fn ready(io: std.Io, allocator: std.mem.Allocator, root: []const u8, contents: Contents) !bool {
    var directory = std.Io.Dir.cwd().openDir(io, root, .{}) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };

    defer directory.close(io);

    const marker = directory.readFileAlloc(io, "ready", allocator, .limited(128)) catch return error.IncompleteToolchainCache;

    defer allocator.free(marker);

    if (!std.mem.eql(u8, marker, contents.digest)) return error.IncompleteToolchainCache;

    for (contents.required) |path| {
        const file = directory.openFile(io, path, .{}) catch return error.IncompleteToolchainCache;

        defer file.close(io);

        const stat = try file.stat(io);

        if (stat.kind != .file or stat.size == 0) return error.IncompleteToolchainCache;
    }

    return true;
}

fn unpack(io: std.Io, allocator: std.mem.Allocator, root: []const u8, contents: Contents) !void {
    const staging = try std.fmt.allocPrint(allocator, "{s}.partial", .{root});

    try std.Io.Dir.cwd().deleteTree(io, staging);
    try std.Io.Dir.cwd().createDirPath(io, staging);

    errdefer std.Io.Dir.cwd().deleteTree(io, staging) catch {};

    {
        var directory = try std.Io.Dir.cwd().openDir(io, staging, .{});

        defer directory.close(io);

        try contents.extract(io, allocator, directory);
    }

    try @import("artifacts.zig").write(io, try std.fs.path.join(allocator, &.{ staging, "ready" }), contents.digest);
    if (!try ready(io, allocator, staging, contents)) return error.IncompleteToolchainCache;
    try std.Io.Dir.cwd().rename(staging, std.Io.Dir.cwd(), root, io);
}
