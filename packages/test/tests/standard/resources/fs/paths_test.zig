const std = @import("std");
const f = @import("fixture.zig");

test "fs exclusive copy creates a new independent destination" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("source", "copy\x00\xff");
    try f.fs.copyFile(f.io, &.{ .from = try fixture.path("source"), .to = try fixture.path("target"), .exclusive = true });
    try fixture.expectContent("target", "copy\x00\xff");
    try fixture.write("source", "changed");
    try fixture.expectContent("target", "copy\x00\xff");
}

test "fs exclusive copy refuses existing destination without changing either file" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("source", "source");
    try fixture.write("target", "target");
    try std.testing.expectError(error.PathAlreadyExists, f.fs.copyFile(f.io, &.{ .from = try fixture.path("source"), .to = try fixture.path("target"), .exclusive = true }));
    try fixture.expectContent("source", "source");
    try fixture.expectContent("target", "target");
}

test "fs replacing copy removes old destination suffix" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("source", "new");
    try fixture.write("target", "previous-long");
    try f.fs.copyFile(f.io, &.{ .from = try fixture.path("source"), .to = try fixture.path("target"), .exclusive = false });
    try fixture.expectContent("source", "new");
    try fixture.expectContent("target", "new");
}

test "fs rename moves contents and removes the old directory entry" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("source", "payload");
    try f.fs.rename(f.io, &.{ .from = try fixture.path("source"), .to = try fixture.path("target") });
    try fixture.expectMissing("source");
    try fixture.expectContent("target", "payload");
}

test "fs missing copy and rename sources leave an existing target untouched" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("target", "keep");

    const from = try fixture.path("missing");
    const to = try fixture.path("target");

    try std.testing.expectError(error.FileNotFound, f.fs.copyFile(f.io, &.{ .from = from, .to = to, .exclusive = false }));
    try fixture.expectContent("target", "keep");
    try std.testing.expectError(error.FileNotFound, f.fs.rename(f.io, &.{ .from = from, .to = to }));
    try fixture.expectContent("target", "keep");
}

test "fs unlink removes a symlink without removing its target" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("target", "keep");
    try fixture.temporary.dir.symLink(f.io, "target", "link", .{});
    try f.fs.unlink(f.io, try fixture.path("link"));
    try fixture.expectMissing("link");
    try fixture.expectContent("target", "keep");
    try f.fs.unlink(f.io, try fixture.path("target"));
    try fixture.expectMissing("target");
}

test "fs readlink preserves a relative target and permits dangling links" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.temporary.dir.symLink(f.io, "./missing", "link", .{});

    const actual = try f.fs.readlink(f.allocator, f.io, try fixture.path("link"));

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings("./missing", actual);
    try fixture.expectMissing("missing");
}

test "fs realpath follows links and normalizes parent components" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("target", "data");
    try fixture.temporary.dir.createDir(f.io, "directory", .default_dir);
    try fixture.temporary.dir.symLink(f.io, "target", "link", .{});

    const actual = try f.fs.realpath(f.allocator, f.io, try fixture.path("directory/../link"));

    defer f.allocator.free(actual);

    try std.testing.expectEqualStrings(try fixture.path("target"), actual);
}

test "fs missing unlink realpath and readlink report file not found" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("missing");

    try std.testing.expectError(error.FileNotFound, f.fs.unlink(f.io, path));
    try std.testing.expectError(error.FileNotFound, f.fs.realpath(f.allocator, f.io, path));
    try std.testing.expectError(error.FileNotFound, f.fs.readlink(f.allocator, f.io, path));
}
