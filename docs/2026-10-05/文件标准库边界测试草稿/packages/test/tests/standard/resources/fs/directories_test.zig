const std = @import("std");
const f = @import("fixture.zig");

test "fs recursive mkdir creates parents and accepts existing directories" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("one/two/three");

    try f.fs.mkdir(f.io, &.{ .path = path, .recursive = true });
    try f.fs.mkdir(f.io, &.{ .path = path, .recursive = true });

    const actual = try fixture.temporary.dir.statFile(f.io, "one/two/three", .{});

    try std.testing.expectEqual(.directory, actual.kind);
}

test "fs nonrecursive mkdir reports duplicate and missing parent errors" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("one");

    try f.fs.mkdir(f.io, &.{ .path = path, .recursive = false });
    try std.testing.expectError(error.PathAlreadyExists, f.fs.mkdir(f.io, &.{ .path = path, .recursive = false }));
    try std.testing.expectError(error.FileNotFound, f.fs.mkdir(f.io, &.{ .path = try fixture.path("missing/child"), .recursive = false }));
    try fixture.expectMissing("missing");
}

test "fs readdir returns empty without dot entries" {
    var fixture = try f.init();

    defer fixture.deinit();

    const names = try f.fs.readdir(f.allocator, f.io, fixture.root);

    defer f.freeNames(f.allocator, names);

    try std.testing.expectEqual(@as(usize, 0), names.len);
}

test "fs readdir returns owned file directory and hidden names without ordering assumptions" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("alpha", "a");
    try fixture.write("文件 🌿", "b");
    try fixture.write(".hidden", "c");
    try fixture.temporary.dir.createDir(f.io, "directory", .default_dir);

    const names = try f.fs.readdir(f.allocator, f.io, fixture.root);

    defer f.freeNames(f.allocator, names);

    try fixture.temporary.dir.deleteFile(f.io, "alpha");
    try fixture.temporary.dir.deleteFile(f.io, "文件 🌿");
    try fixture.temporary.dir.deleteFile(f.io, ".hidden");
    try fixture.temporary.dir.deleteDir(f.io, "directory");
    try std.testing.expectEqual(@as(usize, 4), names.len);

    for ([_][]const u8{ "alpha", "文件 🌿", ".hidden", "directory" }) |expected| {
        var count: usize = 0;

        for (names) |name| {
            if (std.mem.eql(u8, name, expected)) count += 1;
        }

        try std.testing.expectEqual(@as(usize, 1), count);
    }
}

test "fs rmdir refuses nonempty directories and removes empty directories" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.temporary.dir.createDir(f.io, "directory", .default_dir);
    try fixture.write("directory/data", "keep");

    const path = try fixture.path("directory");

    try std.testing.expectError(error.DirNotEmpty, f.fs.rmdir(f.io, path));
    try fixture.expectContent("directory/data", "keep");
    try fixture.temporary.dir.deleteFile(f.io, "directory/data");
    try f.fs.rmdir(f.io, path);
    try fixture.expectMissing("directory");
}

test "fs missing directory enumeration and removal preserve missing state" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("missing");

    try std.testing.expectError(error.FileNotFound, f.fs.readdir(f.allocator, f.io, path));
    try std.testing.expectError(error.FileNotFound, f.fs.rmdir(f.io, path));
    try fixture.expectMissing("missing");
}
