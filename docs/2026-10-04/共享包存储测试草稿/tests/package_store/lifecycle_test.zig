const std = @import("std");
const store = @import("package_store");
const Fixture = @import("fixture.zig");
const allocator = std.testing.allocator;
const io = Fixture.io;

test "package store publishes content and reuses it offline after source removal" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    const first = try fixture.prepare(allocator, false);
    defer allocator.free(first);
    try Fixture.expectContent(first);
    const content = try fixture.contentPath();
    defer allocator.free(content);
    const expected = try std.fs.path.join(allocator, &.{ fixture.root, content, "package" });
    defer allocator.free(expected);
    try std.testing.expectEqualStrings(expected, first);
    const blob = try fixture.blobPath();
    defer allocator.free(blob);
    const bytes = try fixture.temporary.dir.readFileAlloc(io, blob, allocator, .limited(65536));
    defer allocator.free(bytes);
    try std.testing.expectEqualSlices(u8, Fixture.valid, bytes);
    try fixture.temporary.dir.deleteFile(io, "source.tgz");
    const second = try fixture.prepare(allocator, true);
    defer allocator.free(second);

    try std.testing.expectEqualStrings(first, second);
    try Fixture.expectContent(second);
    try fixture.expectNoStaging();
}

test "package store reconstructs removed content from offline archive cache" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    allocator.free(try fixture.prepare(allocator, false));
    const content = try fixture.contentPath();
    defer allocator.free(content);
    try fixture.temporary.dir.deleteTree(io, content);
    try fixture.temporary.dir.deleteFile(io, "source.tgz");
    const result = try fixture.prepare(allocator, true);
    defer allocator.free(result);

    try Fixture.expectContent(result);
    try fixture.expectNoStaging();
}

test "package store normalizes uppercase archive digest to one cache identity" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    const first = try fixture.prepare(allocator, false);
    defer allocator.free(first);
    for (&fixture.digest) |*byte| byte.* = std.ascii.toUpper(byte.*);
    const second = try fixture.prepare(allocator, true);
    defer allocator.free(second);

    try std.testing.expectEqualStrings(first, second);
}

test "package store offline miss does not read available source" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();

    try std.testing.expectError(error.PackageNotCached, fixture.prepare(allocator, true));
    try std.testing.expectError(error.FileNotFound, fixture.temporary.dir.statFile(io, "cache", .{}));
}

test "package store rejects relative cache root" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();

    try std.testing.expectError(error.InvalidPackageCacheDirectory, store.prepare(io, allocator, fixture.release(), fixture.root, "relative", false));
}

test "package store corrupted source fails before cache publication" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    try fixture.temporary.dir.writeFile(io, .{ .sub_path = "source.tgz", .data = "bad archive" });

    try std.testing.expectError(error.PackageArchiveChecksumMismatch, fixture.prepare(allocator, false));
    try std.testing.expectError(error.FileNotFound, fixture.temporary.dir.statFile(io, "cache", .{}));
}

test "package store failed extraction removes its partial staging directory" {
    var fixture = try Fixture.init(Fixture.duplicate);
    defer fixture.deinit();

    try std.testing.expectError(error.DuplicatePackageArchivePath, fixture.prepare(allocator, false));
    try fixture.expectNoStaging();
    const content = try fixture.contentPath();
    defer allocator.free(content);
    const blob = try fixture.blobPath();
    defer allocator.free(blob);
    try std.testing.expectError(error.FileNotFound, fixture.temporary.dir.statFile(io, content, .{}));
    try std.testing.expectError(error.FileNotFound, fixture.temporary.dir.statFile(io, blob, .{}));
}

test "package store corrupt cached archive refuses offline reconstruction" {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    allocator.free(try fixture.prepare(allocator, false));
    const content = try fixture.contentPath();
    defer allocator.free(content);
    const blob = try fixture.blobPath();
    defer allocator.free(blob);
    try fixture.temporary.dir.deleteTree(io, content);
    try fixture.temporary.dir.writeFile(io, .{ .sub_path = blob, .data = "corrupt cached blob" });

    try std.testing.expectError(error.PackageArchiveChecksumMismatch, fixture.prepare(allocator, true));
    try fixture.expectNoStaging();
}
