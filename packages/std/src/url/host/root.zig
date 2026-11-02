const std = @import("std");
const ipv4 = @import("ipv4.zig");
const ipv6 = @import("ipv6.zig");
const idna = @import("idna/root.zig");
const percent = @import("../percent.zig");

pub fn parse(allocator: std.mem.Allocator, input: []const u8, is_opaque: bool) ![]const u8 {
    if (std.mem.startsWith(u8, input, "[")) {
        if (!std.mem.endsWith(u8, input, "]")) return error.InvalidHost;

        const address = try ipv6.parse(input[1 .. input.len - 1]);
        const text = try ipv6.serialize(allocator, address);

        defer allocator.free(text);

        return std.fmt.allocPrint(allocator, "[{s}]", .{text});
    }

    if (is_opaque) {
        if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidHost;

        for (input) |byte| {
            if (forbidden(byte)) return error.InvalidHost;
        }

        return percent.encode(allocator, input, .control);
    }

    const decoded = try percent.decode(allocator, input);

    defer allocator.free(decoded);

    const domain = try parseDomain(allocator, decoded);

    errdefer allocator.free(domain);

    if (ipv4.endsInNumber(domain)) {
        const address = try ipv4.parse(domain);
        const text = try ipv4.serialize(allocator, address);

        allocator.free(domain);

        return text;
    }

    return domain;
}

pub fn parseDomain(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var ascii = true;

    for (input) |byte| {
        if (byte >= 128) {
            ascii = false;

            break;
        }
    }

    const domain = if (ascii) try std.ascii.allocLowerString(allocator, input) else try idna.toAscii(allocator, input);

    errdefer allocator.free(domain);

    if (domain.len == 0) return error.InvalidHost;

    for (domain) |byte| {
        if (forbidden(byte) or byte <= 0x1f or byte == '%' or byte == 0x7f) return error.InvalidHost;
    }

    return domain;
}

fn forbidden(byte: u8) bool {
    return std.mem.indexOfScalar(u8, "\x00\t\n\r #/:<>?@[\\]^|", byte) != null;
}
