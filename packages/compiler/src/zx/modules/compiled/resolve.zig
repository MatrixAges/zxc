const std = @import("std");
const zx = @import("zx");
const compiled = @import("../compiled.zig");
const registry = @import("../project/target/registry.zig");

pub const Result = union(enum) { found: usize, missing, conflict };

pub fn library(allocator: std.mem.Allocator, libraries: []const compiled.Library, root: []const u8, target: compiled.Target) std.mem.Allocator.Error!Result {
    const match = registry.select(libraries, "instance", target.instance, true);
    const index = match.first orelse return .missing;

    if (match.duplicate) return .conflict;

    const path = try std.fs.path.resolve(allocator, &.{ root, libraries[index].artifact });

    defer allocator.free(path);

    return if (zx.bytes.equal(path, target.artifact)) .{ .found = index } else .conflict;
}
