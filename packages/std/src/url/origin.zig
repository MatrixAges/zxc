const std = @import("std");
const model = @import("model.zig");
const parser = @import("parser/root.zig");
const serialize = @import("serialize.zig");

pub fn origin(allocator: std.mem.Allocator, url: model.Url) ![]const u8 {
    if (std.mem.eql(u8, url.scheme, "blob")) {
        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        const temporary = arena.allocator();
        const path = try serialize.path(temporary, url);

        const inner = parser.parse(temporary, path, null) catch |err| switch (err) {
            error.OutOfMemory => return err,
            else => return allocator.dupe(u8, "null"),
        };

        if (std.mem.eql(u8, inner.scheme, "http") or std.mem.eql(u8, inner.scheme, "https")) return tuple(allocator, inner);

        return allocator.dupe(u8, "null");
    }

    if (model.defaultPort(url.scheme) != null) return tuple(allocator, url);

    return allocator.dupe(u8, "null");
}

fn tuple(allocator: std.mem.Allocator, url: model.Url) ![]const u8 {
    const host = url.host orelse return error.InvalidUrl;

    if (url.port) |port| return std.fmt.allocPrint(allocator, "{s}://{s}:{d}", .{ url.scheme, host, port });

    return std.fmt.allocPrint(allocator, "{s}://{s}", .{ url.scheme, host });
}
