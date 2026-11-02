const std = @import("std");

pub const Root = struct {
    end: usize = 0,
    device_end: usize = 0,
    absolute: bool = false,
    server: []const u8 = "",
    share: []const u8 = "",
};

pub fn separator(windows: bool, byte: u8) bool {
    return byte == '/' or (windows and byte == '\\');
}

pub fn root(windows: bool, path: []const u8) Root {
    if (path.len == 0) return .{};

    if (windows and path.len >= 2 and std.ascii.isAlphabetic(path[0]) and path[1] == ':') {
        const absolute = path.len > 2 and separator(true, path[2]);

        return .{ .end = if (absolute) 3 else 2, .device_end = 2, .absolute = absolute };
    }

    if (!separator(windows, path[0])) return .{};

    if (windows and path.len > 2 and separator(true, path[1]) and !separator(true, path[2])) {
        var index: usize = 2;

        while (index < path.len and !separator(true, path[index])) : (index += 1) {}

        const server = path[2..index];

        while (index < path.len and separator(true, path[index])) : (index += 1) {}

        const share_start = index;

        while (index < path.len and !separator(true, path[index])) : (index += 1) {}
        if (index > share_start) return .{ .end = index + @intFromBool(index < path.len), .device_end = index, .absolute = true, .server = server, .share = path[share_start..index] };
    }

    return .{ .end = 1, .absolute = true };
}

pub fn base(windows: bool, path: []const u8) []const u8 {
    const start = if (windows and path.len >= 2 and std.ascii.isAlphabetic(path[0]) and path[1] == ':') @as(usize, 2) else 0;
    var end = path.len;

    while (end > start and separator(windows, path[end - 1])) : (end -= 1) {}

    var begin = end;

    while (begin > start and !separator(windows, path[begin - 1])) : (begin -= 1) {}

    return path[begin..end];
}

pub fn directory(windows: bool, path: []const u8) []const u8 {
    if (path.len == 0) return ".";

    const prefix = root(windows, path);
    var end = path.len;

    while (end > prefix.end and separator(windows, path[end - 1])) : (end -= 1) {}
    while (end > prefix.end and !separator(windows, path[end - 1])) : (end -= 1) {}
    if (end <= prefix.end) return if (prefix.end > 0) path[0..prefix.end] else ".";
    if (!windows and end == 2 and path[0] == '/') return path[0..2];

    return path[0 .. end - 1];
}

pub fn extension(basename: []const u8) []const u8 {
    if (std.mem.eql(u8, basename, "..")) return "";

    const dot = std.mem.lastIndexOfScalar(u8, basename, '.') orelse return "";

    return if (dot == 0) "" else basename[dot..];
}
