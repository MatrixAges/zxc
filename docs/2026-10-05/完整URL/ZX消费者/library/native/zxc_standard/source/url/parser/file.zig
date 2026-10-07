const std = @import("std");
const Url = @import("../model.zig").Url;
const host = @import("../host/root.zig");
const path = @import("path.zig");

pub fn parse(allocator: std.mem.Allocator, url: *Url, input: []const u8, original_base: ?Url) !void {
    const base = if (original_base != null and std.mem.eql(u8, original_base.?.scheme, "file")) original_base else null;

    url.host = "";

    if (input.len > 0 and slash(input[0])) {
        const rest = input[1..];

        if (rest.len > 0 and slash(rest[0])) {
            const authority = rest[1..];
            const boundary = std.mem.indexOfAny(u8, authority, "/\\") orelse authority.len;
            const name = authority[0..boundary];

            if (path.drive(name)) return path.append(allocator, url, authority);

            if (name.len != 0) {
                const parsed = try host.parse(allocator, name, false);
                url.host = if (std.mem.eql(u8, parsed, "localhost")) "" else parsed;
            }

            const remaining = if (boundary < authority.len) authority[boundary + 1 ..] else "";

            return path.append(allocator, url, remaining);
        }

        if (base) |parent| {
            url.host = parent.host;

            if (!path.startsDrive(rest) and parent.path.len != 0 and path.drive(parent.path[0]) and parent.path[0][1] == ':') {
                url.path = parent.path[0..1];
            }
        }

        return path.append(allocator, url, rest);
    }

    if (base) |parent| {
        url.host = parent.host;
        url.path = parent.path;
        url.query = parent.query;

        if (input.len == 0) return;

        url.query = null;

        if (path.startsDrive(input)) {
            url.path = &.{};
        } else if (url.path.len != 0 and !(url.path.len == 1 and path.drive(url.path[0]) and url.path[0][1] == ':')) {
            url.path = url.path[0 .. url.path.len - 1];
        }
    }

    try path.append(allocator, url, input);
}

fn slash(byte: u8) bool {
    return byte == '/' or byte == '\\';
}
