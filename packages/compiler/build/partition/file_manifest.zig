const std = @import("std");

/// The manifest `shared_output` writes into a generated tree: one `<hash:016x> <path>` line per file it wrote.
pub const name = ".zxc-files";

/// The files a manifest lists, in the order they were written.
pub const Listed = struct {
    paths: []const []const u8,
    hashes: []const u64,
};

pub fn list(allocator: std.mem.Allocator, text: []const u8) !Listed {
    const count = std.mem.countScalar(u8, text, '\n') + 1;
    const paths = try allocator.alloc([]const u8, count);
    const hashes = try allocator.alloc(u64, count);
    var lines = std.mem.splitScalar(u8, text, '\n');
    var length: usize = 0;

    while (lines.next()) |line| {
        if (line.len < 18) continue;

        paths[length] = line[17..];
        hashes[length] = try std.fmt.parseInt(u64, line[0..16], 16);
        length += 1;
    }

    return .{ .paths = paths[0..length], .hashes = hashes[0..length] };
}

/// The content hash of every file the manifest `text` lists, by path.
pub fn parse(allocator: std.mem.Allocator, text: []const u8) !std.StringHashMapUnmanaged(u64) {
    var known: std.StringHashMapUnmanaged(u64) = .empty;
    var lines = std.mem.splitScalar(u8, text, '\n');

    while (lines.next()) |line| {
        if (line.len < 18) continue;

        try known.put(allocator, line[17..], try std.fmt.parseInt(u64, line[0..16], 16));
    }

    return known;
}
