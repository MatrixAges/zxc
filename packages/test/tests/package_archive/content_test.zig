const std = @import("std");
const allocation_testing = @import("allocation_testing");
const archive = @import("package_archive");
const fixture = @import("fixture.zig");
const io = std.testing.io;
const allocator = std.testing.allocator;
const long_name = "nested/" ++ "segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_segment_" ++ ".zx";

test "package archive extracts normalized ustar GNU binary empty and executable files" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkContent, .{});
}

test "package archive accepts empty tar with two end blocks" {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    var result = try fixture.extract(allocator, @embedFile("fixtures/empty.tgz"), temporary.dir);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 0), result.files.len);
}

test "package archive rejects SHA mismatch before gzip decoding" {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    try std.testing.expectError(error.PackageArchiveChecksumMismatch, archive.extract(io, allocator, "invalid gzip", @splat(0), temporary.dir));
}

test "package archive never overwrites existing files" {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    try temporary.dir.writeFile(io, .{ .sub_path = "file", .data = "keep" });
    try std.testing.expectError(error.PathAlreadyExists, fixture.extract(allocator, @embedFile("fixtures/duplicate.tgz"), temporary.dir));

    const contents = try temporary.dir.readFileAlloc(io, "file", allocator, .limited(1024));

    defer allocator.free(contents);

    try std.testing.expectEqualStrings("keep", contents);
}

test "package archive duplicate rejection cleans every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(allocator, fixture.expectFailure, .{ @embedFile("fixtures/duplicate.tgz"), error.DuplicatePackageArchivePath });
}

test "package archive gzip rejection cleans every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(allocator, fixture.expectFailure, .{ @embedFile("fixtures/gzip_crc.tgz"), error.InvalidPackageGzipChecksum });
}

test "package archive path rejection cleans every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(allocator, fixture.expectFailure, .{ @embedFile("fixtures/nested_parent.tgz"), error.InvalidPackageArchivePath });
}

fn checkContent(gpa: std.mem.Allocator) !void {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    const source = try gpa.dupe(u8, @embedFile("fixtures/valid.tgz"));

    defer gpa.free(source);

    var result = try fixture.extract(gpa, source, temporary.dir);

    defer result.deinit();
    @memset(source, 0);

    var binary: [513]u8 = undefined;

    for (&binary, 0..) |*byte, index| byte.* = @truncate(index);

    const paths = [_][]const u8{ "src/main.zx", "bin/run", "empty", "binary", long_name };
    const expected = [_][]const u8{ "export const value = 7\n", "#!/bin/sh\nexit 0\n", "", &binary, "long-name-content" };

    try std.testing.expectEqual(paths.len, result.files.len);

    for (paths, expected, result.files, 0..) |path, content, file, index| {
        try std.testing.expectEqualStrings(path, file.path);
        try std.testing.expectEqual(index == 1, file.executable);

        const stat = try temporary.dir.statFile(io, path, .{});

        try std.testing.expectEqual(index == 1, stat.permissions.toMode() & 0o100 != 0);

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(content, &digest, .{});

        try std.testing.expectEqualStrings(&std.fmt.bytesToHex(digest, .lower), file.sha256);

        const actual = try temporary.dir.readFileAlloc(io, path, allocator, .limited(1024));

        defer allocator.free(actual);

        try std.testing.expectEqualSlices(u8, content, actual);
    }
}
