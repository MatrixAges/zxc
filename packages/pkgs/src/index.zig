const std = @import("std");
const ranges = @import("version.zig");
const name = @import("name.zig");
const Index = @This();
pub const Release = struct { version: []const u8, archive: []const u8, sha256: []const u8 };
pub const Package = struct { name: []const u8, versions: []const Release };

format_version: u32,
packages: []const Package,
pub fn parse(allocator: std.mem.Allocator, source: []const u8) !std.json.Parsed(Index) {
    const parsed = try std.json.parseFromSlice(Index, allocator, source, .{ .allocate = .alloc_always });

    errdefer parsed.deinit();

    try parsed.value.validate();

    return parsed;
}

pub fn validate(self: Index) !void {
    if (self.format_version != 1) return error.UnsupportedIndexVersion;

    for (self.packages, 0..) |package, index| {
        if (!name.valid(package.name)) return error.InvalidPackageName;
        if (package.versions.len == 0) return error.PackageHasNoVersions;

        for (self.packages[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, package.name)) return error.DuplicatePackage;
        }

        for (package.versions, 0..) |release, release_index| {
            const version = try std.SemanticVersion.parse(release.version);

            if (release.archive.len == 0 or std.mem.indexOfAny(u8, release.archive, "\x00\r\n") != null) return error.InvalidArchiveSource;
            if (release.sha256.len != 64) return error.InvalidArchiveDigest;
            for (release.sha256) |byte| if (!std.ascii.isHex(byte)) return error.InvalidArchiveDigest;

            for (package.versions[0..release_index]) |previous| {
                if (version.order(try std.SemanticVersion.parse(previous.version)) == .eq) return error.DuplicatePackageVersion;
            }
        }
    }
}

pub fn select(self: Index, package_name: []const u8, requirement: []const u8) !?Release {
    _ = try ranges.matches(requirement, .{ .major = 0, .minor = 0, .patch = 0 });

    for (self.packages) |package| {
        if (!std.mem.eql(u8, package.name, package_name)) continue;

        var selected: ?Release = null;

        for (package.versions) |release| {
            const version = try std.SemanticVersion.parse(release.version);

            if (!try ranges.matches(requirement, version)) continue;
            if (selected == null or version.order(try std.SemanticVersion.parse(selected.?.version)) == .gt) selected = release;
        }

        return selected;
    }

    return null;
}
