const std = @import("std");

pub fn digest(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![32]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true });

    defer directory.close(io);

    var names: std.ArrayList([]const u8) = .empty;
    var iterator = directory.iterate();

    while (try iterator.next(io)) |entry| {
        if (entry.kind != .directory or ignored(entry.name)) continue;
        try names.append(arena.allocator(), try arena.allocator().dupe(u8, entry.name));
    }

    std.mem.sort([]const u8, names.items, {}, lessThan);

    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    for (names.items) |name| {
        hash.update(name);
        hash.update(&.{0});
    }

    return hash.finalResult();
}

pub fn ignored(name: []const u8) bool {
    for ([_][]const u8{ ".git", ".zxc", ".zig-cache", "zig-out", "zig-pkg", "node_modules" }) |value| {
        if (std.mem.eql(u8, name, value)) return true;
    }

    return false;
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
