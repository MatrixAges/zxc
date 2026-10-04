const std = @import("std");
const Lock = @This();
pub const Archive = struct { archive: []const u8, sha256: []const u8 };
pub const Source = union(enum) { workspace: []const u8, archive: Archive };
pub const Dependency = struct { name: []const u8, requirement: []const u8, development: bool, target: usize };
pub const Package = struct { name: []const u8, version: []const u8, source: Source, dependencies: []const Dependency };
pub const maximum_packages = 65536;
pub const maximum_dependencies = 262144;

format_version: u32,
packages: []const Package,
pub fn parse(allocator: std.mem.Allocator, source: []const u8) !std.json.Parsed(Lock) {
    const parsed = try std.json.parseFromSlice(Lock, allocator, source, .{ .allocate = .alloc_always });

    errdefer parsed.deinit();

    try parsed.value.validate(allocator);

    return parsed;
}

pub fn validate(self: Lock, allocator: std.mem.Allocator) !void {
    try @import("lock/validate.zig").validate(self, allocator);
}

pub fn workspaceTarget(self: Lock, allocator: std.mem.Allocator, owner: usize, name: []const u8, requirement: []const u8) !usize {
    if (owner >= self.packages.len or self.packages[owner].source != .workspace or !std.mem.startsWith(u8, requirement, "workspace:")) return error.InvalidLockWorkspaceTarget;

    for (self.packages, 0..) |package, index| {
        if (package.source != .workspace) continue;

        @import("lock/edges.zig").workspace(allocator, self.packages[owner].source.workspace, .{ .name = name, .requirement = requirement, .development = false, .target = index }, package) catch |err| switch (err) {
            error.InvalidLockWorkspaceTarget => continue,
            else => return err,
        };

        return index;
    }

    return error.InvalidLockWorkspaceTarget;
}
