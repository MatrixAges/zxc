const std = @import("std");
const Lock = @import("pkgs").Lock;
const Fixture = @This();

arena: std.heap.ArenaAllocator,
packages: []Lock.Package,

pub fn init(edges: []const []const usize) !Fixture {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    errdefer arena.deinit();
    const allocator = arena.allocator();
    const packages = try allocator.alloc(Lock.Package, edges.len);

    for (packages, edges, 0..) |*package, targets, index| {
        const name = try std.fmt.allocPrint(allocator, "pkg{d}", .{index});
        const dependencies = try allocator.alloc(Lock.Dependency, targets.len);
        for (dependencies, targets) |*edge, target| edge.* = .{
            .name = try std.fmt.allocPrint(allocator, "pkg{d}", .{target}),
            .requirement = "workspace:*",
            .development = false,
            .target = target,
        };

        package.* = .{ .name = name, .version = "1.0.0", .source = .{ .workspace = if (index == 0) "." else name }, .dependencies = dependencies };
    }

    return .{ .arena = arena, .packages = packages };
}

pub fn chain(count: usize, reversed: bool, shortcut_first: ?bool) !Fixture {
    const allocator = std.testing.allocator;
    const edges = try allocator.alloc([]const usize, count);
    defer allocator.free(edges);
    const targets = try allocator.alloc(usize, count);
    defer allocator.free(targets);

    for (edges, targets, 0..) |*edge, *target, index| {
        target.* = if (reversed) index -| 1 else index + 1;
        edge.* = if ((reversed and index == 0) or (!reversed and index + 1 == count)) &.{} else target[0..1];
    }

    const early = [_]usize{ 128, 1 };
    const late = [_]usize{ 1, 128 };
    if (shortcut_first) |first| edges[0] = if (first) &early else &late;

    return init(edges);
}

pub fn validate(self: *Fixture, allocator: std.mem.Allocator) !void {
    try (Lock{ .format_version = 1, .packages = self.packages }).validate(allocator);
}

pub fn deinit(self: *Fixture) void {
    self.arena.deinit();
}
