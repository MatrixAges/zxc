const std = @import("std");
const fixture = @import("fixture.zig");

test "package archive rejects parent" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/parent.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects absolute" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/absolute.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects nested parent" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/nested_parent.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects backslash" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/backslash.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects drive" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/drive.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects double separator" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/double_separator.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects interior dot" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/interior_dot.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects newline" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/newline.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects empty path" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/empty_path.tgz"), error.InvalidPackageArchivePath);
}

test "package archive rejects symlink" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/symlink.tgz"), error.UnsupportedPackageTarEntry);
}

test "package archive rejects hardlink" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/hardlink.tgz"), error.UnsupportedPackageTarEntry);
}

test "package archive rejects fifo" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/fifo.tgz"), error.UnsupportedPackageTarEntry);
}

test "package archive rejects pax" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/pax.tgz"), error.UnsupportedPackageTarEntry);
}
