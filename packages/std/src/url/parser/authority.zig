const std = @import("std");
const model = @import("../model.zig");
const host = @import("../host/root.zig");
const percent = @import("../percent.zig");

pub fn parse(allocator: std.mem.Allocator, url: *model.Url, input: []const u8) !void {
    var address = input;

    if (std.mem.lastIndexOfScalar(u8, input, '@')) |at| {
        const credentials = input[0..at];
        const colon = std.mem.indexOfScalar(u8, credentials, ':') orelse credentials.len;
        url.username = try percent.encode(allocator, credentials[0..colon], .userinfo);

        if (colon < credentials.len) url.password = try percent.encode(allocator, credentials[colon + 1 ..], .userinfo);

        address = input[at + 1 ..];

        if (address.len == 0) return error.InvalidUrl;
    }

    var bracketed = false;
    var boundary = address.len;

    for (address, 0..) |byte, index| {
        if (byte == '[') bracketed = true;
        if (byte == ']') bracketed = false;

        if (byte == ':' and !bracketed) {
            boundary = index;

            break;
        }
    }

    if (boundary == 0 and (model.special(url.scheme) or boundary < address.len)) return error.InvalidUrl;

    url.host = try host.parse(allocator, address[0..boundary], !model.special(url.scheme));

    if (boundary < address.len) {
        const text = address[boundary + 1 ..];

        if (text.len == 0) return;

        var value: u32 = 0;

        for (text) |byte| {
            if (!std.ascii.isDigit(byte)) return error.InvalidUrl;

            value = value * 10 + byte - '0';

            if (value > 65535) return error.InvalidUrl;
        }

        const port: u16 = @intCast(value);

        url.port = if (model.defaultPort(url.scheme) == port) null else port;
    }
}
