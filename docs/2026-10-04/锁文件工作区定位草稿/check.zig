const std = @import("std");
const Lock = @import("pkgs").Lock;
pub const Case = struct { owner: usize = 0, name: []const u8 = "a", requirement: []const u8, target: usize = 1, failure: ?anyerror = null, archive_owner: bool = false };

pub fn check(allocator: std.mem.Allocator, case: Case) !void {
    var packages = [_]Lock.Package{
        .{ .name = "root", .version = "1.0.0", .source = .{ .workspace = "." }, .dependencies = &.{} },
        .{ .name = "a", .version = "1.2.3", .source = .{ .workspace = "apps/a" }, .dependencies = &.{} },
        .{ .name = "@scope/b", .version = "2.0.0", .source = .{ .workspace = "libs/b" }, .dependencies = &.{} },
    };
    if (case.archive_owner) packages[1].source = .{ .archive = .{ .archive = "a.tgz", .sha256 = "a" ** 64 } };
    const lock: Lock = .{ .format_version = 1, .packages = &packages };
    const target = lock.workspaceTarget(allocator, case.owner, case.name, case.requirement) catch |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expect(case.failure != null);
        try std.testing.expectEqual(case.failure.?, err);
        return;
    };

    try std.testing.expectEqual(@as(?anyerror, null), case.failure);
    try std.testing.expectEqual(case.target, target);
}
