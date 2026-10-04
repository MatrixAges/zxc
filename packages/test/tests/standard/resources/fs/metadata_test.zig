const std = @import("std");
const f = @import("fixture.zig");

test "fs stat reports file kind and byte size with independent allocated snapshots" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "你好");

    const path = try fixture.path("data");
    const first = try f.fs.stat(f.allocator, f.io, path);

    defer f.allocator.destroy(first);

    try fixture.write("data", "a");

    const second = try f.fs.stat(f.allocator, f.io, path);

    defer f.allocator.destroy(second);

    try std.testing.expectEqual(.File, first.kind);
    try std.testing.expectEqual(@as(u64, 6), first.size);
    try std.testing.expectEqual(@as(u64, 1), second.size);
    try std.testing.expect(first != second);
}

test "fs stat and lstat identify directories" {
    var fixture = try f.init();

    defer fixture.deinit();

    inline for (.{ f.fs.stat, f.fs.lstat }) |operation| {
        const result = try operation(f.allocator, f.io, fixture.root);

        defer f.allocator.destroy(result);

        try std.testing.expectEqual(.Directory, result.kind);
    }
}

test "fs stat follows symlinks while lstat describes the link itself" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("target", "payload");
    try fixture.temporary.dir.symLink(f.io, "target", "link", .{});

    const path = try fixture.path("link");
    const followed = try f.fs.stat(f.allocator, f.io, path);

    defer f.allocator.destroy(followed);

    const link = try f.fs.lstat(f.allocator, f.io, path);

    defer f.allocator.destroy(link);

    try std.testing.expectEqual(.File, followed.kind);
    try std.testing.expectEqual(@as(u64, 7), followed.size);
    try std.testing.expectEqual(.SymbolicLink, link.kind);
}

test "fs dangling link has lstat metadata but no followed stat" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.temporary.dir.symLink(f.io, "missing", "link", .{});

    const path = try fixture.path("link");
    const link = try f.fs.lstat(f.allocator, f.io, path);

    defer f.allocator.destroy(link);

    try std.testing.expectEqual(.SymbolicLink, link.kind);
    try std.testing.expectError(error.FileNotFound, f.fs.stat(f.allocator, f.io, path));
}

test "fs stat and lstat reject missing paths" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("missing");

    try std.testing.expectError(error.FileNotFound, f.fs.stat(f.allocator, f.io, path));
    try std.testing.expectError(error.FileNotFound, f.fs.lstat(f.allocator, f.io, path));
}

test "fs metadata converts controlled filesystem timestamps to milliseconds" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "payload");

    const file = try fixture.temporary.dir.openFile(f.io, "data", .{ .mode = .read_write });

    defer file.close(f.io);

    try file.setTimestamps(f.io, .{
        .access_timestamp = .{ .new = .{ .nanoseconds = 1_700_000_000_000_000_000 } },
        .modify_timestamp = .{ .new = .{ .nanoseconds = 1_710_000_000_000_000_000 } },
    });

    const raw = try fixture.temporary.dir.statFile(f.io, "data", .{});
    const result = try f.fs.stat(f.allocator, f.io, try fixture.path("data"));

    defer f.allocator.destroy(result);

    try std.testing.expectEqual(@as(i64, 1_710_000_000_000), result.mtime_ms);
    try std.testing.expectEqual(if (raw.atime == null) @as(?i64, null) else @as(?i64, 1_700_000_000_000), result.atime_ms);
    try std.testing.expectEqual(@as(i64, @intCast(@divTrunc(raw.ctime.nanoseconds, 1_000_000))), result.ctime_ms);
}
