const std = @import("std");
const f = @import("fixture.zig");
const Transport = @import("transport.zig");

fn reject(options: f.Input, expected: anyerror) !void {
    var transport: Transport = .{};

    try std.testing.expectError(expected, f.api.request(f.allocator, transport.io(), &options));
    try std.testing.expectEqual(@as(usize, 0), transport.lookups + transport.connections + transport.request_len);
}

test "http rejects invalid URL UTF8 before network" {
    var options = f.input();
    options.url = "http://127.0.0.1/\xff";

    try reject(options, error.InvalidUtf8);
}

test "http rejects whitespace and control bytes in URL" {
    for ([_][]const u8{ "http://127.0.0.1/a b", "http://127.0.0.1/\t", "http://127.0.0.1/\r\n", "http://127.0.0.1/\x00", "http://127.0.0.1/\x7f" }) |url| {
        var options = f.input();

        options.url = url;

        try reject(options, error.InvalidUrl);
    }
}

test "http rejects unsupported schemes before network" {
    for ([_][]const u8{ "ftp://127.0.0.1/file", "file:///tmp/value", "ws://127.0.0.1/path" }) |url| {
        var options = f.input();

        options.url = url;

        try reject(options, error.UnsupportedUriScheme);
    }
}

test "http rejects embedded URL credentials" {
    for ([_][]const u8{ "http://user@127.0.0.1/", "http://user:secret@127.0.0.1/", "http://:secret@127.0.0.1/" }) |url| {
        var options = f.input();

        options.url = url;

        try reject(options, error.UrlCredentialsUnsupported);
    }
}

test "http rejects missing URL host" {
    var options = f.input();

    options.url = "http:/path";

    try reject(options, error.UriMissingHost);
}

test "http rejects zero header limit" {
    var options = f.input();
    options.max_header_bytes = 0;

    try reject(options, error.InvalidHeaderLimit);
}

test "http rejects header limit beyond maximum" {
    var options = f.input();

    options.max_header_bytes = 16 * 1024 * 1024 + 1;

    try reject(options, error.InvalidHeaderLimit);
}

test "http rejects maximum integer header limit without narrowing" {
    var options = f.input();
    options.max_header_bytes = std.math.maxInt(u64);

    try reject(options, error.InvalidHeaderLimit);
}

test "http Get rejects nonnull body including empty body" {
    for ([_][]const u8{ "", "body" }) |body| {
        var options = f.input();

        options.method = .Get;
        options.body = body;

        try reject(options, error.UnsupportedRequestBody);
    }
}

test "http Head rejects nonnull body including empty body" {
    for ([_][]const u8{ "", "body" }) |body| {
        var options = f.input();

        options.method = .Head;
        options.body = body;

        try reject(options, error.UnsupportedRequestBody);
    }
}

test "http Delete rejects nonnull body including empty body" {
    for ([_][]const u8{ "", "body" }) |body| {
        var options = f.input();

        options.method = .Delete;
        options.body = body;

        try reject(options, error.UnsupportedRequestBody);
    }
}

test "http Options rejects nonnull body including empty body" {
    for ([_][]const u8{ "", "body" }) |body| {
        var options = f.input();

        options.method = .Options;
        options.body = body;

        try reject(options, error.UnsupportedRequestBody);
    }
}

test "http reserves managed Host header case insensitively" {
    for ([_][]const u8{ "Host", "host", "HOST" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http reserves managed Content-Length header case insensitively" {
    for ([_][]const u8{ "Content-Length", "content-length", "CONTENT-LENGTH" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http reserves managed Transfer-Encoding header case insensitively" {
    for ([_][]const u8{ "Transfer-Encoding", "transfer-encoding", "TRANSFER-ENCODING" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http reserves managed Connection header case insensitively" {
    for ([_][]const u8{ "Connection", "connection", "CONNECTION" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http reserves managed Expect header case insensitively" {
    for ([_][]const u8{ "Expect", "expect", "EXPECT" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http reserves managed Upgrade header case insensitively" {
    for ([_][]const u8{ "Upgrade", "upgrade", "UPGRADE" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.ManagedHttpHeader);
    }
}

test "http rejects empty request header name" {
    var options = f.input();

    options.headers = &.{&.{ .name = "", .value = "value" }};

    try reject(options, error.InvalidHttpHeader);
}

test "http rejects separators controls and nonASCII header names" {
    for ([_][]const u8{ "x name", "x:name", "x\tname", "x\r\nInjected", "x\x00", "x\xff" }) |name| {
        var options = f.input();

        options.headers = &.{&.{ .name = name, .value = "value" }};

        try reject(options, error.InvalidHttpHeader);
    }
}

test "http rejects every forbidden request header control byte" {
    for (0..33) |index| {
        const byte: u8 = if (index == 32) 127 else @intCast(index);

        if (byte == 9) continue;

        var value = [_]u8{ 'a', byte, 'b' };
        var options = f.input();

        options.headers = &.{&.{ .name = "X-Value", .value = &value }};

        try reject(options, error.InvalidHttpHeader);
    }
}

test "http validates later headers before network" {
    var options = f.input();

    options.headers = &.{ &.{ .name = "X-First", .value = "ok" }, &.{ .name = "X-Second", .value = "bad\r\nInjected: yes" } };

    try reject(options, error.InvalidHttpHeader);
}
