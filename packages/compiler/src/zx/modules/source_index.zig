const std = @import("std");
const zx = @import("zx");
pub const Map = zx.bytes.Map(usize);

/// The map and canonical keys belong to the surrounding analysis arena.
pub fn buildIn(allocator: std.mem.Allocator, sources: anytype, root: []const u8) std.mem.Allocator.Error!*const Map {
    const result = try allocator.create(Map);

    result.* = .empty;

    try result.ensureTotalCapacity(allocator, @intCast(sources.len));

    for (sources, 0..) |source, index| {
        const path = try std.fs.path.resolve(allocator, &.{ root, source.path });
        const found = result.getOrPutAssumeCapacity(path);

        if (found.found_existing) allocator.free(path) else found.value_ptr.* = index;
    }

    return result;
}

pub const Known = struct {
    paths: *const Map,
    pub fn has(self: Known, path: []const u8) std.mem.Allocator.Error!bool {
        return self.paths.get(path) != null;
    }
};
