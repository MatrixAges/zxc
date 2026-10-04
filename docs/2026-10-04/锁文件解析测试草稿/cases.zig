const std = @import("std");
const Lock = @import("pkgs").Lock;
const data = @import("data.zig");
pub const Case = enum { missing_version, unknown_root, duplicate_field, missing_name, unknown_package, empty, version, root_path, root_archive, uppercase_digest, short_digest, archive_newline, duplicate_archive, duplicate_identity, range, target_name, archive_development, archive_workspace, cycle, truncated };

pub fn input(case: Case) ![]u8 {
    const change: struct { []const u8, []const u8 } = switch (case) {
        .missing_version => .{ "\"format_version\":1,", "" },
        .unknown_root => .{ "\"format_version\":1", "\"format_version\":1,\"unknown\":true" },
        .duplicate_field => .{ "\"format_version\":1", "\"format_version\":1,\"format_version\":1" },
        .missing_name => .{ "\"name\":\"dep\",\"version\"", "\"version\"" },
        .unknown_package => .{ "\"name\":\"dep\",\"version\"", "\"unknown\":true,\"name\":\"dep\",\"version\"" },
        .empty => .{ data.root ++ "," ++ data.archive, "" },
        .version => .{ "\"format_version\":1", "\"format_version\":2" },
        .root_path => .{ "\"workspace\":\".\"", "\"workspace\":\"nested\"" },
        .root_archive => .{ "\"workspace\":\".\"", "\"archive\":{\"archive\":\"root.tgz\",\"sha256\":\"" ++ "b" ** 64 ++ "\"}" },
        .uppercase_digest => .{ data.digest, "A" ** 64 },
        .short_digest => .{ data.digest, "abc" },
        .archive_newline => .{ "dep.tgz", "dep\\n.tgz" },
        .duplicate_archive => .{ data.archive, data.archive ++ "," ++ "{\"name\":\"other\",\"version\":\"1.0.0\",\"source\":{\"archive\":{\"archive\":\"other.tgz\",\"sha256\":\"" ++ data.digest ++ "\"}},\"dependencies\":[]}" },
        .duplicate_identity => .{ data.archive, data.archive ++ "," ++ "{\"name\":\"dep\",\"version\":\"1.2.3\",\"source\":{\"archive\":{\"archive\":\"other.tgz\",\"sha256\":\"" ++ "b" ** 64 ++ "\"}},\"dependencies\":[]}" },
        .range => .{ "^1.0.0", "^2.0.0" },
        .target_name => .{ "\"name\":\"dep\",\"requirement\"", "\"name\":\"other\",\"requirement\"" },
        .archive_development => .{ "\"dependencies\":[]", "\"dependencies\":[{\"name\":\"dep\",\"requirement\":\"*\",\"development\":true,\"target\":1}]" },
        .archive_workspace => .{ "\"dependencies\":[]", "\"dependencies\":[{\"name\":\"root\",\"requirement\":\"workspace:*\",\"development\":false,\"target\":0}]" },
        .cycle => .{ "\"dependencies\":[]", "\"dependencies\":[" ++ data.dependency ++ "]" },
        .truncated => return std.testing.allocator.dupe(u8, data.source[0 .. data.source.len - 1]),
    };
    try std.testing.expect(std.mem.indexOf(u8, data.source, change[0]) != null);

    return std.mem.replaceOwned(u8, std.testing.allocator, data.source, change[0], change[1]);
}

pub fn check(allocator: std.mem.Allocator, case: Case) !void {
    const source = try input(case);
    defer std.testing.allocator.free(source);
    const expected: anyerror = switch (case) {
        .missing_version, .missing_name => error.MissingField,
        .unknown_root, .unknown_package => error.UnknownField,
        .duplicate_field => error.DuplicateField,
        .empty => error.InvalidLockPackageCount,
        .version => error.UnsupportedLockVersion,
        .root_path, .root_archive => error.MissingLockWorkspaceRoot,
        .uppercase_digest, .short_digest => error.InvalidArchiveDigest,
        .archive_newline => error.InvalidArchiveSource,
        .duplicate_archive => error.DuplicateLockArchive,
        .duplicate_identity => error.DuplicateLockPackage,
        .range => error.LockVersionMismatch,
        .target_name => error.InvalidLockArchiveTarget,
        .archive_development => error.ArchiveHasDevelopmentDependency,
        .archive_workspace => error.InvalidLockWorkspaceTarget,
        .cycle => error.CyclicPackageDependencies,
        .truncated => error.UnexpectedEndOfInput,
    };
    const parsed = Lock.parse(allocator, source) catch |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(expected, err);
        return;
    };
    defer parsed.deinit();

    return error.TestExpectedError;
}
