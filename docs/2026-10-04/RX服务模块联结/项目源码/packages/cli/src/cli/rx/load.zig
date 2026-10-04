const std = @import("std");
const rx = @import("rx");

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, writer: *std.Io.Writer) !?[]const rx.TextSource {
    var loaded = try @import("collection.zig").load(allocator, .{ .io = io, .root = ".", .entry = entry, .writer = writer }) orelse return null;

    defer loaded.deinit();

    for (loaded.data.functions) |function| {
        if (!try @import("function.zig").validate(io, allocator, function.path, function.source, config_path, writer)) return null;
    }

    const sources = try allocator.alloc(rx.TextSource, loaded.data.sources.len);

    for (loaded.data.sources, sources) |source, *item| {
        item.* = .{ .path = try allocator.dupe(u8, source.path), .source = try allocator.dupe(u8, source.source) };
    }

    return sources;
}
