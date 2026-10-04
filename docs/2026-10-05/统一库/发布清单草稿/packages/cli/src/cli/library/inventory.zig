const std = @import("std");
pub const File = struct { path: []const u8, sha256: []const u8 };
pub const Inventory = struct { format_version: u32, bundled_files: []const File = &.{}, managed_files: ?[]const File = null };

pub fn collect(io: std.Io, allocator: std.mem.Allocator, directory: []const u8) ![]const File {
    var root = try std.Io.Dir.openDirAbsolute(io, directory, .{ .iterate = true });

    defer root.close(io);

    var walker = try root.walk(allocator);

    defer walker.deinit();

    var files: std.ArrayList(File) = .empty;

    while (try walker.next(io)) |entry| {
        if (entry.kind == .directory) continue;
        if (entry.kind != .file) return error.InvalidLibraryInventory;
        if (std.mem.eql(u8, entry.path, "library.json")) continue;

        const path = try allocator.dupe(u8, entry.path);

        if (std.fs.path.sep == '\\') for (path) |*byte| if (byte.* == '\\') {
            byte.* = '/';
        };

        if (!valid(path, false)) return error.InvalidLibraryInventory;

        const bytes = try root.readFileAlloc(io, entry.path, allocator, .unlimited);

        defer allocator.free(bytes);

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(bytes, &digest, .{});

        try files.append(allocator, .{ .path = path, .sha256 = try allocator.dupe(u8, &std.fmt.bytesToHex(digest, .lower)) });
    }

    std.mem.sort(File, files.items, {}, lessThan);

    return files.toOwnedSlice(allocator);
}

pub fn read(io: std.Io, allocator: std.mem.Allocator, directory: []const u8) !?std.json.Parsed(Inventory) {
    const path = try std.fs.path.join(allocator, &.{ directory, "library.json" });

    defer allocator.free(path);

    const bytes = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    defer allocator.free(bytes);

    var parsed = try std.json.parseFromSlice(Inventory, allocator, bytes, .{ .allocate = .alloc_always, .ignore_unknown_fields = true });

    errdefer parsed.deinit();

    if (parsed.value.format_version != 1 and parsed.value.format_version != 2) return error.InvalidLibraryInventory;

    return parsed;
}

pub fn valid(path: []const u8, native_only: bool) bool {
    if (path.len == 0 or std.fs.path.isAbsolute(path) or std.mem.indexOfScalar(u8, path, 0) != null) return false;

    var segments = std.mem.splitScalar(u8, path, '/');

    while (segments.next()) |segment| {
        if (segment.len == 0 or std.mem.eql(u8, segment, ".") or std.mem.eql(u8, segment, "..")) return false;
    }

    if (std.mem.startsWith(u8, path, "native/")) return true;
    if (native_only) return false;
    for ([_][]const u8{ "abi.zig", "root.zig", "build.zig", "pkg.yaml", "library.zxcir" }) |name| if (std.mem.eql(u8, path, name)) return true;
    for ([_][]const u8{ "public/", "modules/", "abi_views/" }) |prefix| if (std.mem.startsWith(u8, path, prefix) and std.mem.endsWith(u8, path, ".zig")) return true;

    return std.mem.startsWith(u8, path, "interfaces/") and std.mem.endsWith(u8, path, ".d.zx");
}

fn lessThan(_: void, left: File, right: File) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}
