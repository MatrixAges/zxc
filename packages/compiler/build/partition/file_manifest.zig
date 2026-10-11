const std = @import("std");

/// The manifest `shared_output` writes into a generated tree: one `<hash:016x> <path>` line per file it wrote.
pub const name = ".zxc-files";

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
