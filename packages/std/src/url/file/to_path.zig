const std = @import("std");
const Url = @import("../model.zig").Url;
const serialize = @import("../serialize.zig");
const percent = @import("../percent.zig");
const idna = @import("../host/idna/root.zig");

pub fn toPath(allocator: std.mem.Allocator, url: Url, windows: bool) ![]const u8 {
    return convert(allocator, url, windows, true);
}

pub fn toBytes(allocator: std.mem.Allocator, url: Url, windows: bool) ![]const u8 {
    return convert(allocator, url, windows, false);
}

fn convert(allocator: std.mem.Allocator, url: Url, windows: bool, text: bool) ![]const u8 {
    if (!std.mem.eql(u8, url.scheme, "file")) return error.InvalidFileUrl;

    const host = url.host orelse return error.InvalidFileUrl;

    if (!windows and host.len != 0) return error.InvalidFileUrlHost;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const path = try temporary.dupe(u8, try serialize.path(temporary, url));
    var index: usize = 0;

    while (index < path.len) : (index += 1) {
        if (windows and path[index] == '/') path[index] = '\\';
        if (!text or path[index] != '%') continue;
        if (path.len - index < 3) return error.InvalidFileUrlPath;

        const high = std.fmt.charToDigit(path[index + 1], 16) catch return error.InvalidFileUrlPath;
        const low = std.fmt.charToDigit(path[index + 2], 16) catch return error.InvalidFileUrlPath;
        const value = high * 16 + low;

        if (value == '/' or (windows and value == '\\')) return error.InvalidFileUrlPath;

        index += 2;
    }

    const decoded = try percent.decode(temporary, path);

    if (text and !std.unicode.utf8ValidateSlice(decoded)) return error.InvalidFileUrlPath;
    if (!windows) return allocator.dupe(u8, decoded);

    if (host.len != 0) {
        const name = idna.toUnicode(temporary, host) catch |err| switch (err) {
            error.OutOfMemory => return err,
            else => host,
        };

        return std.fmt.allocPrint(allocator, "\\\\{s}{s}", .{ name, decoded });
    }

    if (decoded.len < 3 or decoded[0] != '\\' or !std.ascii.isAlphabetic(decoded[1]) or decoded[2] != ':') return error.InvalidFileUrlPath;

    return allocator.dupe(u8, decoded[1..]);
}
