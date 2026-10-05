const std = @import("std");
const f = @import("fixture.zig");
const Transport = @import("transport.zig");

fn value(wire: []const u8, name: []const u8) ?[]const u8 {
    var lines = std.mem.splitSequence(u8, wire, "\r\n");

    while (lines.next()) |line| {
        const colon = std.mem.indexOfScalar(u8, line, ':') orelse continue;

        if (std.ascii.eqlIgnoreCase(line[0..colon], name)) return std.mem.trim(u8, line[colon + 1 ..], " \t");
    }

    return null;
}

fn method(method_value: f.api.Method, name: []const u8, body: ?[]const u8) !void {
    var transport: Transport = .{ .chunk = 2 };
    var options = f.input();

    options.method = method_value;
    options.body = body;
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    const wire = transport.request[0..transport.request_len];
    const first_space = std.mem.indexOfScalar(u8, wire, ' ').?;
    const boundary = std.mem.indexOf(u8, wire, "\r\n\r\n").? + 4;

    try std.testing.expectEqualStrings(name, wire[0..first_space]);
    try std.testing.expectEqualSlices(u8, body orelse "", wire[boundary..]);
    try std.testing.expectEqualStrings("127.0.0.1:18000", value(wire, "host").?);
    try std.testing.expect(value(wire, "authorization") == null);
    try std.testing.expect(value(wire, "accept-encoding") == null);
    try std.testing.expect(value(wire, "user-agent") == null);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

test "http Get method and request body cross short writes" {
    try method(.Get, "GET", null);
}

test "http Head method and request body cross short writes" {
    try method(.Head, "HEAD", null);
}

test "http Post method and request body cross short writes" {
    try method(.Post, "POST", "a\x00\xffb");
}

test "http Put method and request body cross short writes" {
    try method(.Put, "PUT", "a\x00\xffb");
}

test "http Patch method and request body cross short writes" {
    try method(.Patch, "PATCH", "a\x00\xffb");
}

test "http Delete method and request body cross short writes" {
    try method(.Delete, "DELETE", null);
}

test "http Options method and request body cross short writes" {
    try method(.Options, "OPTIONS", null);
}

test "http Post accepts null and empty body" {
    try method(.Post, "POST", null);
    try method(.Post, "POST", "");
}

test "http Put accepts null and empty body" {
    try method(.Put, "PUT", null);
    try method(.Put, "PUT", "");
}

test "http Patch accepts null and empty body" {
    try method(.Patch, "PATCH", null);
    try method(.Patch, "PATCH", "");
}

test "http preserves explicit authorization duplicates and nonUTF8 header values" {
    var transport: Transport = .{};
    var options = f.input();
    options.headers = &.{ &.{ .name = "Authorization", .value = "Bearer explicit-test-token" }, &.{ .name = "X-Repeat", .value = "one" }, &.{ .name = "X-Repeat", .value = "two" }, &.{ .name = "X-Raw", .value = "a\xffb" }, &.{ .name = "!#$%&'*+-.^_`|~", .value = "a\tb" } };

    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    const wire = transport.request[0..transport.request_len];

    try std.testing.expectEqualStrings("Bearer explicit-test-token", value(wire, "authorization").?);
    try std.testing.expectEqualStrings("a\xffb", value(wire, "x-raw").?);
    try std.testing.expect(std.mem.indexOf(u8, wire, "X-Repeat: one\r\nX-Repeat: two\r\n") != null);
    try std.testing.expectEqualStrings("a\tb", value(wire, "!#$%&'*+-.^_`|~").?);
}

test "http request excludes URL fragment and preserves escaped query" {
    var transport: Transport = .{};
    var options = f.input();
    options.url = "http://127.0.0.1:18000/a%20b?q=%2F&x=1#client-only";

    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    const wire = transport.request[0..transport.request_len];

    try std.testing.expect(std.mem.startsWith(u8, wire, "GET /a%20b?q=%2F&x=1 HTTP/1.1\r\n"));
    try std.testing.expect(std.mem.indexOf(u8, wire, "client-only") == null);
}

test "http normalizes mixed case scheme" {
    var transport: Transport = .{};
    var options = f.input();
    options.url = "HtTp://127.0.0.1:18000/";
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    try std.testing.expectEqual(@as(u16, 200), result.status);
}

test "http repeated calls do not reuse hidden connection or response state" {
    var first: Transport = .{ .response = "HTTP/1.1 201 Created\r\nContent-Length: 3\r\n\r\none" };
    var second: Transport = .{ .response = "HTTP/1.1 202 Accepted\r\nContent-Length: 3\r\n\r\ntwo" };
    const options = f.input();
    const a = try f.api.request(f.allocator, first.io(), &options);

    defer f.release(f.allocator, a);

    const b = try f.api.request(f.allocator, second.io(), &options);

    defer f.release(f.allocator, b);

    try std.testing.expectEqualStrings("one", a.body);
    try std.testing.expectEqualStrings("two", b.body);
    try std.testing.expectEqual(@as(u16, 201), a.status);
    try std.testing.expectEqual(@as(u16, 202), b.status);
    try std.testing.expectEqual(@as(usize, 1), first.connections);
    try std.testing.expectEqual(@as(usize, 1), second.connections);
    try std.testing.expectEqual(first.connections, first.closed);
    try std.testing.expectEqual(second.connections, second.closed);
}

test "http large request body crosses client write buffer" {
    const body = &@as([16385:0]u8, @splat('q'));

    try method(.Post, "POST", body);
}
