const std = @import("std");
const f = @import("fixture.zig");
const Transport = @import("transport.zig");

test "http get sends origin form and closes its connection" {
    var transport: Transport = .{};
    const options = f.input();
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    try std.testing.expectEqual(@as(u16, 200), result.status);
    try std.testing.expectEqual(@as(usize, 0), result.body.len);
    try std.testing.expect(std.mem.startsWith(u8, transport.request[0..transport.request_len], "GET /path?key=value HTTP/1.1\r\n"));
    try std.testing.expectEqual(@as(usize, 1), transport.connections);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

fn check(args: struct { wire: []const u8, body: []const u8, status: u16 = 200, method: f.api.Method = .Get, limit: u64 = 1024, header_limit: u64 = 8192 }) !void {
    var transport: Transport = .{ .response = args.wire, .chunk = 1 };
    var options = f.input();

    options.method = args.method;
    options.max_body_bytes = args.limit;
    options.max_header_bytes = args.header_limit;
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    try std.testing.expectEqual(args.status, result.status);
    try std.testing.expectEqualSlices(u8, args.body, result.body);
    try std.testing.expectEqual(@as(usize, 1), transport.connections);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

fn reject(args: struct { wire: []const u8, expected: anyerror, limit: u64 = 1024, header_limit: u64 = 8192 }) !void {
    var transport: Transport = .{ .response = args.wire, .chunk = 3 };
    var options = f.input();

    options.max_body_bytes = args.limit;
    options.max_header_bytes = args.header_limit;

    if (f.api.request(f.allocator, transport.io(), &options)) |result| {
        defer f.release(f.allocator, result);

        return error.ExpectedRequestFailure;
    } else |err| try std.testing.expectEqual(args.expected, err);

    try std.testing.expectEqual(@as(usize, 1), transport.connections);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

test "http content length body accepts exact byte limit" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 4\r\n\r\na\x00\xffb", .body = "a\x00\xffb", .limit = 4 });
}

test "http content length body rejects one byte over limit" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 4\r\n\r\nabcd", .limit = 3, .expected = error.StreamTooLong });
}

test "http zero body limit accepts empty body" {
    try check(.{ .wire = f.empty_response, .body = "", .limit = 0 });
}

test "http zero body limit rejects one byte" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 1\r\n\r\nx", .limit = 0, .expected = error.StreamTooLong });
}

test "http close delimited body preserves bytes" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nConnection: close\r\n\r\nabc\xff", .body = "abc\xff", .limit = 4 });
}

test "http close delimited body rejects overflow" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nConnection: close\r\n\r\nabcd", .limit = 3, .expected = error.StreamTooLong });
}

test "http chunked body joins chunks and excludes framing" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n2\r\nab\r\n2\r\nc\xff\r\n0\r\n\r\n", .body = "abc\xff", .limit = 4 });
}

test "http chunked body rejects decoded transfer size above limit" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n4\r\nabcd\r\n0\r\n\r\n", .limit = 3, .expected = error.StreamTooLong });
}

test "http chunked body with trailers excludes trailer bytes" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n1\r\nx\r\n0\r\nX-Trailer: final\r\n\r\n", .body = "x", .limit = 1 });
}

test "http truncated content length fails instead of partial success" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 10\r\n\r\nabc", .expected = error.ReadFailed });
}

test "http malformed chunk fails" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\nNO\r\nx\r\n0\r\n\r\n", .expected = error.ReadFailed });
}

test "http response headers preserve duplicates and nonUTF8 values" {
    var transport: Transport = .{ .response = "HTTP/1.1 200 OK\r\nX-Repeat: first\r\nX-Repeat: second\r\nX-Raw: a\xffb\r\nContent-Length: 0\r\n\r\n" };
    const options = f.input();
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);

    try std.testing.expectEqualStrings("first", result.headers[0].value);
    try std.testing.expectEqualStrings("second", result.headers[1].value);
    try std.testing.expectEqualStrings("a\xffb", f.header(result, "x-raw").?);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

test "http response owns headers and body after transport is overwritten" {
    var wire = "HTTP/1.1 200 OK\r\nX-Value: original\r\nContent-Length: 4\r\n\r\nbody".*;
    var transport: Transport = .{ .response = &wire };
    const options = f.input();
    const result = try f.api.request(f.allocator, transport.io(), &options);

    defer f.release(f.allocator, result);
    @memset(&wire, 'z');

    try std.testing.expectEqualStrings("original", f.header(result, "x-value").?);
    try std.testing.expectEqualStrings("body", result.body);
    try std.testing.expectEqual(transport.connections, transport.closed);
}

test "http head ignores advertised response body length" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 9999\r\n\r\n", .body = "", .method = .Head, .limit = 0 });
}

test "http 204 has no body" {
    try check(.{ .wire = "HTTP/1.1 204 No Content\r\n\r\n", .body = "", .status = 204, .limit = 0 });
}

test "http 304 ignores advertised representation size" {
    try check(.{ .wire = "HTTP/1.1 304 Not Modified\r\nContent-Length: 9999\r\n\r\n", .body = "", .status = 304, .limit = 0 });
}

test "http redirect remains a normal single response" {
    try check(.{ .wire = "HTTP/1.1 302 Found\r\nLocation: http://127.0.0.1:18000/other\r\nContent-Length: 4\r\n\r\nnext", .body = "next", .status = 302 });
}

test "http 404 body remains normal response" {
    try check(.{ .wire = "HTTP/1.1 404 Not Found\r\nContent-Length: 7\r\n\r\nmissing", .body = "missing", .status = 404 });
}

test "http 503 body remains normal response" {
    try check(.{ .wire = "HTTP/1.1 503 Unavailable\r\nContent-Length: 5\r\n\r\nlater", .body = "later", .status = 503 });
}

const informational = "HTTP/1.1 100 Continue\r\n\r\nHTTP/1.1 103 Early Hints\r\nLink: </a>\r\n\r\n";

test "http informational responses continue to final status and headers" {
    try check(.{ .wire = informational ++ f.empty_response, .body = "", .header_limit = informational.len + f.empty_response.len });
}

test "http informational response heads count toward aggregate header limit" {
    try reject(.{ .wire = informational ++ f.empty_response, .expected = error.HttpHeadersTooLarge, .header_limit = informational.len + f.empty_response.len - 1 });
}

test "http rejects switching protocols" {
    try reject(.{ .wire = "HTTP/1.1 101 Switching Protocols\r\nConnection: upgrade\r\nUpgrade: websocket\r\n\r\n", .expected = error.HttpUpgradeUnsupported });
}

test "http header boundary accepts exact raw head length" {
    try check(.{ .wire = f.empty_response, .body = "", .header_limit = f.empty_response.len });
}

test "http header boundary rejects one byte below raw head length" {
    try reject(.{ .wire = f.empty_response, .header_limit = f.empty_response.len - 1, .expected = error.HttpHeadersOversize });
}

test "http minimum header limit rejects response rather than hanging" {
    try reject(.{ .wire = f.empty_response, .header_limit = 1, .expected = error.HttpHeadersOversize });
}

test "http maximum accepted header limit works" {
    try check(.{ .wire = f.empty_response, .body = "", .header_limit = 16 * 1024 * 1024 });
}

test "http maximum body limit does not overflow" {
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 1\r\n\r\nx", .body = "x", .limit = std.math.maxInt(u64) });
}

test "http invalid response header token is rejected" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nBad Name: x\r\nContent-Length: 0\r\n\r\n", .expected = error.InvalidHttpHeader });
}

test "http invalid response header value is rejected" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nX-Bad: x\x00y\r\nContent-Length: 0\r\n\r\n", .expected = error.InvalidHttpHeader });
}

test "http conflicting content lengths are rejected" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\nContent-Length: 1\r\n\r\nx", .expected = error.HttpHeadersInvalid });
}

test "http incomplete response head is rejected" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nX-Partial:", .expected = error.HttpRequestTruncated });
}

test "http chunked missing final chunk fails" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nabc\r\n", .expected = error.ReadFailed });
}

test "http chunked truncated chunk data fails" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\nA\r\nabc", .expected = error.ReadFailed });
}

test "http chunked truncated final terminator fails" {
    try reject(.{ .wire = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nabc\r\n0\r\n", .expected = error.ReadFailed });
}

test "http content encoding remains compressed bytes" {
    const body = "\x1f\x8b\x08\x00\x00\x00\x00\x00\x02\xff\xcb\x2f\xca\x4c\xcf\xcc\x4b\xcc\x51\x28\x49\xad\x28\x01\x00\xef\xbb\x7c\x4a\x0d\x00\x00\x00";
    try check(.{ .wire = "HTTP/1.1 200 OK\r\nContent-Encoding: gzip\r\nContent-Length: 33\r\n\r\n" ++ body, .body = body, .limit = body.len });
}
