const std = @import("std");
const url = @import("implementation").url;

pub fn check(source: []const u8) !void {
    const allocator = std.testing.allocator;
    const document = try std.json.parseFromSlice(std.json.Value, allocator, source, .{});

    defer document.deinit();

    const fields = document.value.object;
    const input = fields.get("input").?.string;
    const base_value = fields.get("base").?;
    const base = if (base_value == .null) null else base_value.string;
    const failure = if (fields.get("failure")) |value| value.bool else false;

    var parsed = url.parse(allocator, input, base) catch |err| {
        if (err == error.OutOfMemory or !failure) return err;

        return;
    };

    defer parsed.deinit();

    try std.testing.expect(!failure);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const memory = arena.allocator();
    const value = parsed.value;
    const href = try url.serialize(memory, value, false);
    const port = if (value.port) |number| try std.fmt.allocPrint(memory, "{d}", .{number}) else "";
    const hostname = value.host orelse "";
    const host = if (value.port != null) try std.fmt.allocPrint(memory, "{s}:{s}", .{ hostname, port }) else hostname;
    const protocol = try std.fmt.allocPrint(memory, "{s}:", .{value.scheme});
    const pathname = try url.serializePath(memory, value);
    const search = try prefixed(memory, "?", value.query);
    const hash = try prefixed(memory, "#", value.fragment);
    const actual = .{ href, protocol, value.username, value.password, host, hostname, port, pathname, search, hash };
    const names = .{ "href", "protocol", "username", "password", "host", "hostname", "port", "pathname", "search", "hash" };

    inline for (names, actual) |name, text| {
        try std.testing.expectEqualStrings(fields.get(name).?.string, text);
    }

    if (fields.get("origin")) |expected| {
        try std.testing.expectEqualStrings(expected.string, try url.origin(memory, value));
    }

    var reparsed = try url.parse(allocator, href, null);

    defer reparsed.deinit();

    try std.testing.expectEqualStrings(href, try url.serialize(memory, reparsed.value, false));
}

fn prefixed(allocator: std.mem.Allocator, prefix: []const u8, value: ?[]const u8) ![]const u8 {
    const text = value orelse return "";

    if (text.len == 0) return "";

    return std.mem.concat(allocator, u8, &.{ prefix, text });
}
