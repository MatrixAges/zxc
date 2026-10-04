const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
pub const File = struct { path: []const u8, sha256: []const u8, executable: bool };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    files: []const File,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const maximum_archive = 128 * 1024 * 1024;
pub const maximum_unpacked = 512 * 1024 * 1024;
pub const maximum_entries = 65536;

pub fn extract(io: std.Io, allocator: std.mem.Allocator, source: []const u8, expected: [32]u8, directory: std.Io.Dir) !Result {
    if (source.len > maximum_archive) return error.PackageArchiveTooLarge;

    var digest: [32]u8 = undefined;

    Sha256.hash(source, &digest, .{});

    if (!std.mem.eql(u8, &digest, &expected)) return error.PackageArchiveChecksumMismatch;

    const unpacked = try @import("archive/gzip.zig").decode(allocator, source, maximum_unpacked);

    defer allocator.free(unpacked);

    try @import("archive/header.zig").validate(unpacked, maximum_entries);

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var paths: std.StringHashMapUnmanaged(void) = .empty;
    var files: std.ArrayList(File) = .empty;
    var input: std.Io.Reader = .fixed(unpacked);
    var names: [std.fs.max_path_bytes]u8 = undefined;
    var links: [std.fs.max_path_bytes]u8 = undefined;
    var iterator = std.tar.Iterator.init(&input, .{ .file_name_buffer = &names, .link_name_buffer = &links });

    while (try iterator.next()) |entry| {
        const name = try @import("archive/path.zig").normalize(entry.name, entry.kind == .directory);

        if (name.len == 0) continue;

        const path = try owned.dupe(u8, name);
        const previous = try paths.getOrPut(owned, path);

        if (previous.found_existing) return error.DuplicatePackageArchivePath;

        switch (entry.kind) {
            .directory => try directory.createDirPath(io, path),
            .sym_link => return error.UnsupportedPackageTarEntry,
            .file => {
                if (std.fs.path.dirname(path)) |parent| try directory.createDirPath(io, parent);

                const executable = entry.mode & 0o100 != 0;
                const file = try directory.createFile(io, path, .{ .exclusive = true, .permissions = if (executable) .executable_file else .default_file });

                defer file.close(io);

                var output_buffer: [65536]u8 = undefined;
                var hash_buffer: [65536]u8 = undefined;
                var output = file.writer(io, &output_buffer);
                var hashed = std.Io.Writer.Hashed(Sha256).initHasher(&output.interface, .init(.{}), &hash_buffer);

                try iterator.streamRemaining(entry, &hashed.writer);
                try hashed.writer.flush();
                try output.interface.flush();

                const hex = std.fmt.bytesToHex(hashed.hasher.finalResult(), .lower);

                try files.append(owned, .{ .path = path, .sha256 = try owned.dupe(u8, &hex), .executable = executable });
            },
        }
    }

    return .{ .arena = arena, .files = try files.toOwnedSlice(owned) };
}
