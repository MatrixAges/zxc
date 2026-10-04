const std = @import("std");
const pkgs = @import("pkgs");
const Lock = pkgs.Lock;
const Manifest = @import("../manifest/model.zig").Manifest;
const model = @import("model.zig");
const Self = @This();

pub const Options = struct { root: []const u8, cache: []const u8, source_base: []const u8, offline: bool };

io: std.Io,
allocator: std.mem.Allocator,
options: Options,
index: pkgs.Index,
packages: std.ArrayList(Lock.Package) = .empty,
manifests: std.ArrayList(Manifest) = .empty,
paths: std.ArrayList([]const u8) = .empty,
archives: std.StringHashMapUnmanaged(usize) = .empty,
pub fn resolve(io: std.Io, allocator: std.mem.Allocator, members: []const @import("../workspace.zig").Package, index: pkgs.Index, options: Options) !model.Prepared {
    var self: Self = .{ .io = io, .allocator = allocator, .options = options, .index = index };

    for (members) |member| {
        const path = try std.fs.path.resolve(allocator, &.{ options.root, member.path });

        try self.packages.append(allocator, .{ .name = member.manifest.name, .version = member.manifest.version, .source = .{ .workspace = member.path }, .dependencies = &.{} });
        try self.manifests.append(allocator, member.manifest);
        try self.paths.append(allocator, try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator));
    }

    var owner: usize = 0;
    var edge_count: usize = 0;

    while (owner < self.packages.items.len) : (owner += 1) {
        const data = self.manifests.items[owner];
        const development = if (self.packages.items[owner].source == .workspace) data.dev_dependencies else &.{};
        var dependencies: std.ArrayList(Lock.Dependency) = .empty;

        for ([_][]const @import("../manifest/model.zig").Dependency{ data.dependencies, development }, 0..) |entries, kind| {
            for (entries) |entry| {
                if (edge_count == Lock.maximum_dependencies) return error.TooManyLockDependencies;

                edge_count += 1;

                const target = if (std.mem.startsWith(u8, entry.requirement, "workspace:"))
                    try (Lock{ .format_version = 1, .packages = self.packages.items }).workspaceTarget(allocator, owner, entry.name, entry.requirement)

                else
                    try self.external(entry.name, entry.requirement);
                try dependencies.append(allocator, .{ .name = entry.name, .requirement = entry.requirement, .development = kind == 1, .target = target });
            }
        }

        self.packages.items[owner].dependencies = try dependencies.toOwnedSlice(allocator);
    }

    const lock: Lock = .{ .format_version = 1, .packages = try self.packages.toOwnedSlice(allocator) };

    try lock.validate(allocator);

    return .{ .lock = lock, .paths = try self.paths.toOwnedSlice(allocator) };
}

fn external(self: *Self, name: []const u8, requirement: []const u8) !usize {
    const allocator = self.allocator;
    const release = try self.index.select(name, requirement) orelse return error.PackageVersionNotFound;
    const digest = try std.ascii.allocLowerString(allocator, release.sha256);

    if (self.archives.get(digest)) |target| {
        const previous = self.packages.items[target];

        if (!std.mem.eql(u8, name, previous.name) or !std.mem.eql(u8, release.version, previous.version)) return error.PackageArchiveIdentityMismatch;

        return target;
    }

    if (self.packages.items.len == Lock.maximum_packages) return error.InvalidLockPackageCount;

    const source = if (std.mem.startsWith(u8, release.archive, "https://") or std.mem.startsWith(u8, release.archive, "http://"))
        try allocator.dupe(u8, release.archive)

    else source: {
        const absolute = try std.fs.path.resolve(allocator, &.{ self.options.source_base, release.archive });
        const relative = try std.fs.path.relative(allocator, self.options.root, null, self.options.root, absolute);

        std.mem.replaceScalar(u8, relative, '\\', '/');

        break :source relative;
    };

    const path = try @import("../store.zig").prepare(self.io, allocator, .{ .version = release.version, .archive = source, .sha256 = digest }, self.options.root, self.options.cache, self.options.offline);
    const data = try model.read(self.io, allocator, path, null);

    if (!std.mem.eql(u8, data.name, name) or !std.mem.eql(u8, data.version, release.version)) return error.PackageArchiveIdentityMismatch;
    if (data.workspace != null) return error.ArchiveContainsWorkspace;

    const target = self.packages.items.len;

    try self.packages.append(allocator, .{ .name = data.name, .version = data.version, .source = .{ .archive = .{ .archive = source, .sha256 = digest } }, .dependencies = &.{} });
    try self.paths.append(allocator, try std.Io.Dir.cwd().realPathFileAlloc(self.io, path, allocator));
    try self.manifests.append(allocator, data);
    try self.archives.put(allocator, digest, target);

    return target;
}
