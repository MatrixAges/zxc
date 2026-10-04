const std = @import("std");
const Entry = struct { name: []const u8, kind: std.Io.File.Kind };

pub fn digest(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![32]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true });

    defer directory.close(io);

    var entries: std.ArrayList(Entry) = .empty;
    var iterator = directory.iterate();

    while (try iterator.next(io)) |entry| {
        try entries.append(arena.allocator(), .{ .name = try arena.allocator().dupe(u8, entry.name), .kind = entry.kind });
    }

    std.mem.sort(Entry, entries.items, {}, lessThan);

    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    for (entries.items) |entry| {
        hash.update(entry.name);
        hash.update(&.{ 0, @intFromEnum(entry.kind) });
    }

    return hash.finalResult();
}

fn lessThan(_: void, left: Entry, right: Entry) bool {
    return std.mem.lessThan(u8, left.name, right.name);
}
