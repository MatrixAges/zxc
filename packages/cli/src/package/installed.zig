const std = @import("std");
const graph = @import("graph.zig");
const model = @import("install/model.zig");
const files = @import("install/files.zig");
const Inputs = @import("../cli/watch/inputs.zig");

pub fn load(io: std.Io, allocator: std.mem.Allocator, root: []const u8, members: []const @import("workspace.zig").Package, inputs: ?*Inputs) ![]graph.Package {
    const loaded = try files.load(io, allocator, root, inputs) orelse return error.PackagesNotInstalled;

    if (!model.matchesWorkspace(loaded.lock, members)) return error.LockFileOutdated;

    const paths = try files.installed(io, allocator, root, loaded, inputs);
    const packages = try allocator.alloc(graph.Package, loaded.lock.packages.len);

    for (loaded.lock.packages, packages, 0..) |locked, *package, index| {
        const path = switch (locked.source) {
            .workspace => |relative| try std.Io.Dir.cwd().realPathFileAlloc(io, try std.fs.path.resolve(allocator, &.{ root, relative }), allocator),
            .archive => |source| archive: {
                const location = paths[index];
                const parent = std.fs.path.dirname(location) orelse return error.InvalidPackageInstallation;

                if (!std.mem.eql(u8, std.fs.path.basename(location), "package") or !std.mem.eql(u8, std.fs.path.basename(parent), source.sha256)) return error.InvalidPackageInstallation;

                const real = try std.Io.Dir.cwd().realPathFileAlloc(io, location, allocator);

                if (!std.mem.eql(u8, real, location)) return error.InvalidPackageInstallation;

                const receipt = try std.fs.path.join(allocator, &.{ parent, "receipt.json" });

                if (inputs) |observed| try observed.add(io, receipt);

                var directory = try std.Io.Dir.cwd().openDir(io, parent, .{ .follow_symlinks = false });

                defer directory.close(io);

                try @import("store/receipt.zig").verify(io, allocator, directory, source.sha256);

                break :archive real;
            },
        };

        const data = if (locked.source == .workspace) local: {
            for (members) |member| {
                if (std.mem.eql(u8, member.path, locked.source.workspace)) break :local member.manifest;
            }

            return error.LockFileOutdated;
        } else try model.read(io, allocator, path, inputs);

        if (!model.matches(data, locked)) return error.InstalledManifestDoesNotMatchLock;

        const dependencies = try allocator.alloc(graph.Dependency, locked.dependencies.len);

        for (locked.dependencies, dependencies) |edge, *dependency| dependency.* = .{ .name = edge.name, .target = edge.target, .development = edge.development };

        package.* = .{ .path = path, .manifest = data, .dependencies = dependencies };
    }

    return packages;
}
