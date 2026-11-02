const std = @import("std");
const model = @import("../model.zig");
const percent = @import("../percent.zig");
const authority = @import("authority.zig");
const path = @import("path.zig");
const file = @import("file.zig");

pub fn parse(allocator: std.mem.Allocator, original: []const u8, base: ?model.Url) !model.Url {
    const input = try clean(allocator, original);
    const hash = std.mem.indexOfScalar(u8, input, '#') orelse input.len;
    const question = std.mem.indexOfScalar(u8, input[0..hash], '?') orelse hash;
    const main = input[0..question];
    var url: model.Url = .{};

    if (schemeEnd(main)) |colon| {
        url.scheme = try std.ascii.allocLowerString(allocator, main[0..colon]);
        const rest = main[colon + 1 ..];

        if (std.mem.eql(u8, url.scheme, "file")) {
            try file.parse(allocator, &url, rest, base);
        } else if (model.special(url.scheme)) {
            if (base != null and std.mem.eql(u8, base.?.scheme, url.scheme) and !std.mem.startsWith(u8, rest, "//")) {
                try relative(allocator, &url, rest, base.?);
            } else try withAuthority(allocator, &url, std.mem.trimStart(u8, rest, "/\\"));
        } else if (std.mem.startsWith(u8, rest, "//")) {
            try withAuthority(allocator, &url, rest[2..]);
        } else if (std.mem.startsWith(u8, rest, "/")) {
            try path.append(allocator, &url, rest[1..]);
        } else {
            const encoded = try percent.encode(allocator, rest, .control);

            url.opaque_path = if (question < input.len and std.mem.endsWith(u8, encoded, " "))
                try std.fmt.allocPrint(allocator, "{s}%20", .{encoded[0 .. encoded.len - 1]})

            else
                encoded;
        }
    } else {
        const parent = base orelse return error.InvalidUrl;

        if (parent.opaque_path != null) {
            if (!std.mem.startsWith(u8, input, "#")) return error.InvalidUrl;

            url = parent;
        } else if (std.mem.eql(u8, parent.scheme, "file")) {
            url.scheme = "file";

            try file.parse(allocator, &url, main, parent);
        } else try relative(allocator, &url, main, parent);
    }

    if (question < hash) url.query = try percent.encode(allocator, input[question + 1 .. hash], if (model.special(url.scheme)) .special_query else .query);

    url.fragment = if (hash < input.len) try percent.encode(allocator, input[hash + 1 ..], .fragment) else null;

    return url;
}

fn relative(allocator: std.mem.Allocator, url: *model.Url, input: []const u8, base: model.Url) !void {
    const is_special = model.special(base.scheme);

    url.* = base;
    url.fragment = null;

    if (input.len == 0) return;

    url.query = null;

    if (slash(input[0], is_special)) {
        if (input.len > 1 and slash(input[1], is_special)) {
            url.* = .{ .scheme = base.scheme };
            const rest = if (is_special) std.mem.trimStart(u8, input[2..], "/\\") else input[2..];

            return withAuthority(allocator, url, rest);
        }

        url.path = &.{};

        return path.append(allocator, url, input[1..]);
    }

    if (url.path.len != 0) url.path = url.path[0 .. url.path.len - 1];
    try path.append(allocator, url, input);
}

fn withAuthority(allocator: std.mem.Allocator, url: *model.Url, input: []const u8) !void {
    const is_special = model.special(url.scheme);
    const boundary = std.mem.indexOfAny(u8, input, if (is_special) "/\\" else "/") orelse input.len;

    try authority.parse(allocator, url, input[0..boundary]);

    if (boundary < input.len) {
        try path.append(allocator, url, input[boundary + 1 ..]);
    } else if (is_special) try path.append(allocator, url, "");
}

fn schemeEnd(input: []const u8) ?usize {
    if (input.len == 0 or !std.ascii.isAlphabetic(input[0])) return null;

    for (input[1..], 1..) |byte, index| {
        if (byte == ':') return index;
        if (!std.ascii.isAlphanumeric(byte) and byte != '+' and byte != '-' and byte != '.') return null;
    }

    return null;
}

fn clean(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidUrl;

    var start: usize = 0;
    var end = input.len;

    while (start < end and input[start] <= 0x20) : (start += 1) {}
    while (end > start and input[end - 1] <= 0x20) : (end -= 1) {}

    var result: std.ArrayList(u8) = .empty;

    for (input[start..end]) |byte| {
        if (byte != '\t' and byte != '\r' and byte != '\n') try result.append(allocator, byte);
    }

    return result.toOwnedSlice(allocator);
}

fn slash(byte: u8, is_special: bool) bool {
    return byte == '/' or (is_special and byte == '\\');
}
