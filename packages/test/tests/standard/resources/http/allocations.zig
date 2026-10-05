const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const Transport = @import("transport.zig");

fn execute(gpa: std.mem.Allocator, wire: []const u8, expected_body: []const u8) !void {
    var transport: Transport = .{ .response = wire, .chunk = 257 };
    var options = f.input();

    defer std.debug.assert(transport.connections == transport.closed);

    options.method = .Post;
    options.body = "request\x00\xff";
    options.headers = &.{ &.{ .name = "X-First", .value = "a" }, &.{ .name = "X-Second", .value = "b\xff" } };
    options.max_body_bytes = 20000;

    const result = try f.api.request(gpa, transport.io(), &options);

    defer f.release(gpa, result);

    try std.testing.expectEqualSlices(u8, expected_body, result.body);
}

fn failure(gpa: std.mem.Allocator, wire: []const u8, expected: anyerror) !void {
    var transport: Transport = .{ .response = wire };
    var options = f.input();

    defer std.debug.assert(transport.connections == transport.closed);

    options.max_body_bytes = 3;

    const result = f.api.request(gpa, transport.io(), &options) catch |err| {
        if (err == expected) return;

        return err;
    };

    defer f.release(gpa, result);

    return error.ExpectedRequestFailure;
}

fn invalidHeaders(gpa: std.mem.Allocator) !void {
    var transport: Transport = .{};
    var options = f.input();

    defer std.debug.assert(transport.connections == 0);

    options.headers = &.{ &.{ .name = "X-Valid", .value = "a" }, &.{ .name = "Invalid Name", .value = "b" } };

    const result = f.api.request(gpa, transport.io(), &options) catch |err| {
        if (err == error.InvalidHttpHeader) return;

        return err;
    };

    defer f.release(gpa, result);

    return error.ExpectedHeaderFailure;
}

test "http successful response releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, execute, .{ "HTTP/1.1 200 OK\r\nX-First: a\r\nX-First: b\xff\r\nContent-Length: 4\r\n\r\nbody", "body" });
}

test "http large response releases every failed allocation" {
    const body = &@as([9000:0]u8, @splat('q'));

    try allocation_testing.checkAllAllocationFailures(f.allocator, execute, .{ "HTTP/1.1 200 OK\r\nX-Value: v\r\nContent-Length: 9000\r\n\r\n" ++ body, body });
}

test "http chunked response releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, execute, .{ "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\nX-Value: v\r\n\r\n4\r\nbody\r\n0\r\n\r\n", "body" });
}

test "http body overflow releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ "HTTP/1.1 200 OK\r\nX-Value: v\r\nContent-Length: 4\r\n\r\nbody", error.StreamTooLong });
}

test "http invalid response header releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ "HTTP/1.1 200 OK\r\nX-First: v\r\nBad Name: v\r\nContent-Length: 0\r\n\r\n", error.InvalidHttpHeader });
}

test "http malformed chunk releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\nX-Value: v\r\n\r\nNO\r\n", error.ReadFailed });
}

test "http invalid request header releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, invalidHeaders, .{});
}

test "http connection refusal does not create a connection to close" {
    var transport: Transport = .{ .refuse = true };
    const options = f.input();

    try std.testing.expectError(error.ConnectionRefused, f.api.request(f.allocator, transport.io(), &options));
    try std.testing.expectEqual(@as(usize, 0), transport.connections + transport.closed);
}

test "http send failure closes the connection" {
    var transport: Transport = .{ .write_failure = true };
    const options = f.input();

    try std.testing.expectError(error.WriteFailed, f.api.request(f.allocator, transport.io(), &options));
    try std.testing.expectEqual(@as(usize, 1), transport.closed);
}

test "http head read failure closes the connection" {
    var transport: Transport = .{ .read_failure = true };
    const options = f.input();

    try std.testing.expectError(error.ReadFailed, f.api.request(f.allocator, transport.io(), &options));
    try std.testing.expectEqual(@as(usize, 1), transport.closed);
}

test "http body read failure releases copied headers and closes connection" {
    const head = "HTTP/1.1 200 OK\r\nX-Value: v\r\nContent-Length: 4\r\n\r\n";
    var transport: Transport = .{ .response = head ++ "body", .chunk = 1, .read_fail_after = head.len + 1 };
    const options = f.input();

    try std.testing.expectError(error.ReadFailed, f.api.request(f.allocator, transport.io(), &options));
    try std.testing.expectEqual(@as(usize, 1), transport.closed);
}

test "http truncated content length releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ "HTTP/1.1 200 OK\r\nX-Value: v\r\nContent-Length: 10\r\n\r\nabc", error.ReadFailed });
}

test "http missing terminal chunk releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\nX-Value: v\r\n\r\n3\r\nabc\r\n", error.ReadFailed });
}

test "http oversized response head releases every failed allocation" {
    const wire = "HTTP/1.1 200 OK\r\nX-Large: " ++ (&@as([8192:0]u8, @splat('q'))) ++ "\r\nContent-Length: 0\r\n\r\n";

    try allocation_testing.checkAllAllocationFailures(f.allocator, failure, .{ wire, error.HttpHeadersOversize });
}
