const std = @import("std");
const Lock = @import("pkgs").Lock;
const Inputs = @import("../../cli/watch/inputs.zig");
pub const Loaded = struct { lock: Lock, source: []const u8 };
const Installation = struct { format_version: u32, lock_sha256: []const u8, paths: []const []const u8 };
const maximum_bytes = 32 * 1024 * 1024;

pub fn load(io: std.Io, allocator: std.mem.Allocator, root: []const u8, inputs: ?*Inputs) !?Loaded {
    const path = try std.fs.path.join(allocator, &.{ root, "pkg.lock.json" });

    const source = read(io, allocator, path, inputs) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    const parsed = try Lock.parse(allocator, source);

    return .{ .lock = parsed.value, .source = source };
}

pub fn installed(io: std.Io, allocator: std.mem.Allocator, root: []const u8, loaded: Loaded, inputs: ?*Inputs) ![]const []const u8 {
    const digest = hash(loaded.source);
    const path = try mapPath(allocator, root, &digest);

    const source = read(io, allocator, path, inputs) catch |err| switch (err) {
        error.FileNotFound => return error.PackagesNotInstalled,
        else => return err,
    };

    const parsed = try std.json.parseFromSlice(Installation, allocator, source, .{ .allocate = .alloc_always });
    const data = parsed.value;

    if (data.format_version != 1 or !std.mem.eql(u8, data.lock_sha256, &digest) or data.paths.len != loaded.lock.packages.len) return error.InvalidPackageInstallation;
    for (data.paths) |item| if (!std.fs.path.isAbsolute(item)) return error.InvalidPackageInstallation;

    return data.paths;
}

pub fn publish(io: std.Io, allocator: std.mem.Allocator, root: []const u8, prepared: @import("model.zig").Prepared) !void {
    const source = prepared.source orelse try std.json.Stringify.valueAlloc(allocator, prepared.lock, .{ .whitespace = .indent_2 });
    const digest = hash(source);
    const mapping = try std.json.Stringify.valueAlloc(allocator, Installation{ .format_version = 1, .lock_sha256 = &digest, .paths = prepared.paths }, .{ .whitespace = .indent_2 });

    if (source.len > maximum_bytes or mapping.len > maximum_bytes) return error.PackageInstallationTooLarge;

    try write(io, try mapPath(allocator, root, &digest), mapping);

    const path = try std.fs.path.join(allocator, &.{ root, "pkg.lock.json" });

    if (prepared.source != null) {
        const current = try read(io, allocator, path, null);

        if (!std.mem.eql(u8, current, source)) return error.LockChangedDuringInstall;
    } else try write(io, path, source);
}

fn mapPath(allocator: std.mem.Allocator, root: []const u8, digest: []const u8) ![]const u8 {
    return std.fs.path.join(allocator, &.{ root, ".zxc", "packages", try std.fmt.allocPrint(allocator, "{s}.json", .{digest}) });
}

fn hash(source: []const u8) [64]u8 {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    return std.fmt.bytesToHex(digest, .lower);
}

fn read(io: std.Io, allocator: std.mem.Allocator, path: []const u8, inputs: ?*Inputs) ![]const u8 {
    if (inputs) |observed| try observed.add(io, path);

    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(maximum_bytes));

    if (inputs) |observed| try observed.record(io, path, source);

    return source;
}

fn write(io: std.Io, path: []const u8, content: []const u8) !void {
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, content);
    try file.replace(io);
}
