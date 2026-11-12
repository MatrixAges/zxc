const std = @import("std");
pub const Map = if (@import("parser_options").generated_parser) @import("source_index/fixed.zig") else @import("source_index/seed.zig");

/// The map and canonical keys belong to the surrounding analysis arena.
pub fn buildIn(allocator: std.mem.Allocator, sources: anytype, root: []const u8) std.mem.Allocator.Error!*const Map {
    const result = try allocator.create(Map);

    result.* = try Map.init(allocator, sources.len);

    for (sources, 0..) |source, index| {
        const path = try std.fs.path.resolve(allocator, &.{ root, source.path });

        if (!result.claim(index, path)) allocator.free(path);
    }

    return result;
}

pub const Known = struct {
    paths: *const Map,
    pub fn has(self: Known, path: []const u8) std.mem.Allocator.Error!bool {
        return self.paths.get(path) != null;
    }
};
