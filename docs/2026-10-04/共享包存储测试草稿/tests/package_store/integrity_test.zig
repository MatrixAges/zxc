const std = @import("std");
const Fixture = @import("fixture.zig");
const allocator = std.testing.allocator;
const io = Fixture.io;
const Mutation = enum { changed, missing, extra, file_link, directory_link, executable, version, digest, duplicate, path, receipt_link };

fn check(mutation: Mutation, expected: anyerror) !void {
    var fixture = try Fixture.init(Fixture.valid);
    defer fixture.deinit();
    allocator.free(try fixture.prepare(allocator, false));
    const relative = try fixture.contentPath();
    defer allocator.free(relative);
    var content = try fixture.temporary.dir.openDir(io, relative, .{});
    defer content.close(io);

    switch (mutation) {
        .changed => try content.writeFile(io, .{ .sub_path = "package/src/main.zx", .data = "tampered" }),
        .missing => try content.deleteFile(io, "package/empty"),
        .extra => try content.writeFile(io, .{ .sub_path = "package/extra", .data = "extra" }),
        .file_link => {
            try content.deleteFile(io, "package/empty");
            try content.symLink(io, "binary", "package/empty", .{});
        },
        .directory_link => {
            try content.deleteTree(io, "package/src");
            try content.symLink(io, "bin", "package/src", .{ .is_directory = true });
        },
        .executable => {
            const file = try content.openFile(io, "package/bin/run", .{});
            defer file.close(io);
            try file.setPermissions(io, .default_file);
        },
        .version => try replaceReceipt(content, "\"format_version\":1", "\"format_version\":2"),
        .digest => try replaceReceipt(content, &fixture.digest, "0" ** 64),
        .path => try replaceReceipt(content, "src/main.zx", "./src/main.zx"),
        .duplicate => {
            const entry = .{ .path = "empty", .sha256 = "0" ** 64, .executable = false };
            const text = try std.json.Stringify.valueAlloc(allocator, .{ .format_version = 1, .archive_sha256 = &fixture.digest, .files = .{ entry, entry } }, .{});
            defer allocator.free(text);
            try content.writeFile(io, .{ .sub_path = "receipt.json", .data = text });
        },
        .receipt_link => {
            try content.rename("receipt.json", content, "original.json", io);
            try content.symLink(io, "original.json", "receipt.json", .{});
        },
    }

    try std.testing.expectError(expected, fixture.prepare(allocator, true));
    try fixture.expectNoStaging();
}

fn replaceReceipt(directory: std.Io.Dir, old: []const u8, new: []const u8) !void {
    const original = try directory.readFileAlloc(io, "receipt.json", allocator, .limited(65536));
    defer allocator.free(original);
    try std.testing.expect(std.mem.indexOf(u8, original, old) != null);
    const replaced = try std.mem.replaceOwned(u8, allocator, original, old, new);
    defer allocator.free(replaced);

    try directory.writeFile(io, .{ .sub_path = "receipt.json", .data = replaced });
}

test "package store rejects changed cached content" {
    try check(.changed, error.CorruptPackageStore);
}

test "package store rejects missing cached content" {
    try check(.missing, error.CorruptPackageStore);
}

test "package store rejects extra cached content" {
    try check(.extra, error.CorruptPackageStore);
}

test "package store rejects file link cached content" {
    try check(.file_link, error.CorruptPackageStore);
}

test "package store rejects directory link cached content" {
    try check(.directory_link, error.CorruptPackageStore);
}

test "package store rejects executable cached content" {
    try check(.executable, error.CorruptPackageStore);
}

test "package store rejects version cached content" {
    try check(.version, error.InvalidPackageReceipt);
}

test "package store rejects digest cached content" {
    try check(.digest, error.InvalidPackageReceipt);
}

test "package store rejects duplicate cached content" {
    try check(.duplicate, error.InvalidPackageReceipt);
}

test "package store rejects path cached content" {
    try check(.path, error.InvalidPackageReceipt);
}

test "package store rejects receipt link cached content" {
    try check(.receipt_link, error.InvalidPackageReceipt);
}
