const std = @import("std");
const f = @import("fixture.zig");
const Operation = enum { binary, text, directory, stat, lstat, realpath, readlink };

fn check(allocator: std.mem.Allocator, operation: Operation, path: []const u8) !void {
    switch (operation) {
        .binary, .text => {
            const bytes = if (operation == .binary) try f.fs.readFile(allocator, f.io, &.{ .path = path, .max_bytes = 4096 }) else try f.fs.readText(allocator, f.io, &.{ .path = path, .max_bytes = 4096 });

            defer allocator.free(bytes);

            try std.testing.expectEqualStrings("内容 🌿", bytes);
        },
        .directory => {
            const names = try f.fs.readdir(allocator, f.io, path);

            defer f.freeNames(allocator, names);

            try std.testing.expectEqual(@as(usize, 3), names.len);
        },
        .stat, .lstat => {
            const result = if (operation == .stat) try f.fs.stat(allocator, f.io, path) else try f.fs.lstat(allocator, f.io, path);

            defer allocator.destroy(result);

            try std.testing.expectEqual(if (operation == .stat) f.fs.Kind.File else f.fs.Kind.SymbolicLink, result.kind);
        },
        .realpath, .readlink => {
            const result = if (operation == .realpath) try f.fs.realpath(allocator, f.io, path) else try f.fs.readlink(allocator, f.io, path);

            defer allocator.free(result);

            if (operation == .readlink) {
                try std.testing.expectEqualStrings("data", result);
            } else try std.testing.expect(std.mem.endsWith(u8, result, "/data"));
        },
    }
}

fn failures(operation: Operation) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "内容 🌿");
    try fixture.write("second", "b");
    try fixture.temporary.dir.symLink(f.io, "data", "link", .{});

    const path = switch (operation) {
        .binary, .text => try fixture.path("data"),
        .directory => fixture.root,
        else => try fixture.path("link"),
    };

    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ operation, path });
}

test "fs readFile releases every failed allocation" {
    try failures(.binary);
}

test "fs readText releases every failed allocation" {
    try failures(.text);
}

test "fs readdir releases partial name lists after every allocation failure" {
    try failures(.directory);
}

test "fs stat releases every failed allocation" {
    try failures(.stat);
}

test "fs lstat releases every failed allocation" {
    try failures(.lstat);
}

test "fs realpath releases every failed allocation" {
    try failures(.realpath);
}

test "fs readlink releases every failed allocation" {
    try failures(.readlink);
}

fn invalidText(allocator: std.mem.Allocator, path: []const u8) !void {
    const actual = f.fs.readText(allocator, f.io, &.{ .path = path, .max_bytes = 4096 }) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUtf8, err);

        return;
    };

    defer allocator.free(actual);

    return error.TestExpectedError;
}

test "fs invalid readText frees bytes allocated before UTF8 validation fails" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("invalid", "valid-prefix\xff");
    try std.testing.checkAllAllocationFailures(f.allocator, invalidText, .{try fixture.path("invalid")});
}
