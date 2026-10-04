const std = @import("std");
const builtin = @import("builtin");
const pkgs = @import("pkgs");
const archive = @import("archive.zig");
const receipt = @import("store/receipt.zig");

pub fn prepare(io: std.Io, allocator: std.mem.Allocator, release: pkgs.Index.Release, source_base: []const u8, cache_root: []const u8, offline: bool) ![]u8 {
    if (!std.fs.path.isAbsolute(cache_root)) return error.InvalidPackageCacheDirectory;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var digest: [32]u8 = undefined;

    if (release.sha256.len != 64) return error.InvalidArchiveDigest;

    _ = try std.fmt.hexToBytes(&digest, release.sha256);

    const hex = std.fmt.bytesToHex(digest, .lower);
    const root = try std.fs.path.join(temporary, &.{ cache_root, "packages", "v1" });
    const destination = try std.fs.path.join(temporary, &.{ root, "contents", &hex });
    const package_path = try std.fs.path.join(temporary, &.{ destination, "package" });

    if (try cached(io, temporary, destination, &hex)) return allocator.dupe(u8, package_path);

    const blob_path = try std.fmt.allocPrint(temporary, "{s}/archives/{s}.tar.gz", .{ root, hex });

    const cached_blob = std.Io.Dir.cwd().readFileAlloc(io, blob_path, allocator, .limited(archive.maximum_archive + 1)) catch |err| switch (err) {
        error.FileNotFound => null,
        else => return err,
    };

    const bytes = cached_blob orelse if (offline) return error.PackageNotCached else try @import("store/download.zig").read(io, allocator, release.archive, source_base);

    defer allocator.free(bytes);

    if (bytes.len > archive.maximum_archive) return error.PackageArchiveTooLarge;

    var actual: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(bytes, &actual, .{});

    if (!std.mem.eql(u8, &actual, &digest)) return error.PackageArchiveChecksumMismatch;

    var random: [16]u8 = undefined;

    std.Io.random(io, &random);

    const staging = try std.fmt.allocPrint(temporary, "{s}/contents/.prepare-{s}", .{ root, std.fmt.bytesToHex(random, .lower) });

    try std.Io.Dir.cwd().createDirPath(io, try std.fs.path.join(temporary, &.{ root, "contents" }));
    try std.Io.Dir.cwd().createDir(io, staging, .default_dir);

    defer std.Io.Dir.cwd().deleteTree(io, staging) catch {};

    {
        var directory = try std.Io.Dir.cwd().openDir(io, staging, .{});

        defer directory.close(io);

        try directory.createDir(io, "package", .default_dir);

        var package = try directory.openDir(io, "package", .{});

        defer package.close(io);

        var result = try archive.extract(io, allocator, bytes, digest, package);

        defer result.deinit();

        const text = try std.json.Stringify.valueAlloc(temporary, receipt.Receipt{ .archive_sha256 = &hex, .files = result.files }, .{});

        try write(io, try std.fs.path.join(temporary, &.{ staging, "receipt.json" }), text);
        try receipt.verify(io, allocator, directory, &hex);
    }

    if (cached_blob == null) try write(io, blob_path, bytes);

    const moved: std.Io.Dir.RenamePreserveError!void = if (builtin.os.tag == .windows or builtin.os.tag == .linux)
        std.Io.Dir.cwd().renamePreserve(staging, .cwd(), destination, io)

    else
        std.Io.Dir.cwd().rename(staging, .cwd(), destination, io);

    moved catch |err| switch (err) {
        error.PathAlreadyExists, error.DirNotEmpty => if (!try cached(io, temporary, destination, &hex)) return error.CorruptPackageStore,
        else => return err,
    };

    return allocator.dupe(u8, package_path);
}

fn cached(io: std.Io, allocator: std.mem.Allocator, path: []const u8, expected: []const u8) !bool {
    var directory = std.Io.Dir.cwd().openDir(io, path, .{ .follow_symlinks = false }) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };

    defer directory.close(io);

    try receipt.verify(io, allocator, directory, expected);

    return true;
}

fn write(io: std.Io, path: []const u8, content: []const u8) !void {
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, content);
    try file.replace(io);
}
