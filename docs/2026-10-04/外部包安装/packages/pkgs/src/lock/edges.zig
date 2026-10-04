const std = @import("std");
const Lock = @import("../lock.zig");
const version = @import("../version.zig");

pub fn validate(lock: Lock, allocator: std.mem.Allocator, owner: Lock.Package) !void {
    var names: std.StringHashMapUnmanaged(void) = .empty;

    defer names.deinit(allocator);

    for (owner.dependencies) |edge| {
        if (!@import("../name.zig").valid(edge.name)) return error.InvalidPackageName;
        if ((try names.getOrPut(allocator, edge.name)).found_existing) return error.DuplicateLockDependency;
        if (edge.target >= lock.packages.len) return error.InvalidLockTarget;
        if (owner.source == .archive and edge.development) return error.ArchiveHasDevelopmentDependency;

        const target = lock.packages[edge.target];

        if (std.mem.startsWith(u8, edge.requirement, "workspace:")) {
            if (owner.source != .workspace or target.source != .workspace) return error.InvalidLockWorkspaceTarget;
            try workspace(allocator, owner.source.workspace, edge, target);
        } else {
            if (target.source != .archive or !std.mem.eql(u8, edge.name, target.name)) return error.InvalidLockArchiveTarget;
            if (!try version.matches(edge.requirement, try std.SemanticVersion.parse(target.version))) return error.LockVersionMismatch;
        }
    }
}

pub fn workspace(allocator: std.mem.Allocator, owner: []const u8, edge: Lock.Dependency, target: Lock.Package) !void {
    const text = edge.requirement["workspace:".len..];
    var name = edge.name;
    var range = text;

    if (std.mem.startsWith(u8, text, "./") or std.mem.startsWith(u8, text, "../")) {
        if (std.mem.indexOfAny(u8, text, "\\:\x00") != null) return error.InvalidLockWorkspacePath;

        var depth: usize = if (std.mem.eql(u8, owner, ".")) 0 else std.mem.count(u8, owner, "/") + 1;
        var parts = std.mem.splitScalar(u8, text, '/');

        while (parts.next()) |part| {
            if (std.mem.eql(u8, part, "..")) {
                if (depth == 0) return error.InvalidLockWorkspacePath;

                depth -= 1;
            } else if (part.len != 0 and !std.mem.eql(u8, part, ".")) depth += 1;
        }

        const path = try std.fs.path.resolvePosix(allocator, &.{ "/", owner, text });

        defer allocator.free(path);

        const expected = try std.fs.path.resolvePosix(allocator, &.{ "/", target.source.workspace });

        defer allocator.free(expected);

        if (!std.mem.eql(u8, path, expected)) return error.InvalidLockWorkspaceTarget;

        return;
    }

    if (std.mem.lastIndexOfScalar(u8, text, '@')) |separator| {
        if (separator == 0) return error.InvalidLockWorkspaceTarget;

        name = text[0..separator];
        range = text[separator + 1 ..];
    }

    if (!std.mem.eql(u8, name, target.name)) return error.InvalidLockWorkspaceTarget;
    if (range.len == 0 or std.mem.eql(u8, range, "*") or std.mem.eql(u8, range, "^") or std.mem.eql(u8, range, "~")) return;
    if (!try version.matches(range, try std.SemanticVersion.parse(target.version))) return error.LockVersionMismatch;
}
