const std = @import("std");
const fixture = @import("fixture.zig");

test "package archive rejects duplicate" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/duplicate.tgz"), error.DuplicatePackageArchivePath);
}

test "package archive rejects directory duplicate" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/directory_duplicate.tgz"), error.DuplicatePackageArchivePath);
}

test "package archive rejects directory data" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/directory_data.tgz"), error.InvalidPackageDirectory);
}

test "package archive rejects missing end" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/missing_end.tgz"), error.InvalidPackageTarEnd);
}

test "package archive rejects one end block" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/one_end_block.tgz"), error.InvalidPackageTarEnd);
}

test "package archive rejects short header" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/short_header.tgz"), error.TruncatedPackageTar);
}

test "package archive rejects short content" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/short_content.tgz"), error.TruncatedPackageTar);
}

test "package archive rejects trailing tar" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/trailing_tar.tgz"), error.TrailingPackageTarData);
}

test "package archive rejects long unterminated" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/long_unterminated.tgz"), error.InvalidPackageLongName);
}

test "package archive rejects long embedded null" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/long_embedded_null.tgz"), error.InvalidPackageLongName);
}

test "package archive rejects long orphan" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/long_orphan.tgz"), error.InvalidPackageTarEnd);
}

test "package archive rejects long repeated" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/long_repeated.tgz"), error.InvalidPackageLongName);
}

test "package archive rejects invalid size" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/invalid_size.tgz"), error.InvalidPackageTarSize);
}

test "package archive rejects invalid header" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/invalid_header.tgz"), error.TarHeaderChksum);
}

test "package archive rejects gzip crc" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/gzip_crc.tgz"), error.InvalidPackageGzipChecksum);
}

test "package archive rejects gzip length" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/gzip_length.tgz"), error.InvalidPackageGzipChecksum);
}

test "package archive rejects gzip trailing" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/gzip_trailing.tgz"), error.TrailingPackageGzipData);
}

test "package archive rejects gzip concatenated" {
    try fixture.expectFailure(std.testing.allocator, @embedFile("fixtures/gzip_concatenated.tgz"), error.TrailingPackageGzipData);
}
