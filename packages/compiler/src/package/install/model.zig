const std = @import("std");
const Lock = @import("pkgs").Lock;
const manifest = @import("../manifest.zig");
const Manifest = @import("../manifest/model.zig").Manifest;
const Inputs = @import("../../cli/watch/inputs.zig");

pub const Prepared = struct { lock: Lock, paths: []const []const u8, source: ?[]const u8 = null };

pub fn read(io: std.Io, allocator: std.mem.Allocator, root: []const u8, inputs: ?*Inputs) !Manifest {
    const path = try std.fs.path.join(allocator, &.{ root, "pkg.yaml" });

    if (inputs) |observed| try observed.add(io, path);

    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024));

    if (inputs) |observed| try observed.record(io, path, source);

    const parsed = try manifest.parse(allocator, source);

    return switch (parsed.value) {
        .data => |data| data,
        .diagnostic => error.InvalidInstalledManifest,
    };
}

pub fn matches(data: Manifest, package: Lock.Package) bool {
    if (!std.mem.eql(u8, data.name, package.name) or !std.mem.eql(u8, data.version, package.version)) return false;
    if (package.source == .archive and data.workspace != null) return false;

    const development = if (package.source == .workspace) data.dev_dependencies else &.{};

    if (data.dependencies.len + development.len != package.dependencies.len) return false;

    for ([_][]const @import("../manifest/model.zig").Dependency{ data.dependencies, development }, 0..) |entries, kind| {
        for (entries) |entry| {
            var found = false;

            for (package.dependencies) |edge| {
                if (!std.mem.eql(u8, entry.name, edge.name)) continue;
                if (!std.mem.eql(u8, entry.requirement, edge.requirement) or edge.development != (kind == 1)) return false;

                found = true;

                break;
            }

            if (!found) return false;
        }
    }

    return true;
}

pub fn matchesWorkspace(lock: Lock, members: []const @import("../workspace.zig").Package) bool {
    var count: usize = 0;

    for (lock.packages) |package| {
        if (package.source != .workspace) continue;

        count += 1;

        var found = false;

        for (members) |member| {
            if (!std.mem.eql(u8, member.path, package.source.workspace)) continue;
            if (!matches(member.manifest, package)) return false;

            found = true;

            break;
        }

        if (!found) return false;
    }

    return count == members.len;
}
