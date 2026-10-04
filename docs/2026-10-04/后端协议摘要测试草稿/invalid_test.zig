const std = @import("std");
const protocol = @import("backend_protocol");
const fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

test "backend rejects truncated headers and frame bodies" {
    const bytes = try fixture.encode(allocator, &.{fixture.version});
    defer allocator.free(bytes);

    for (1..bytes.len) |length| {
        try std.testing.expectError(error.InvalidBackendProtocol, protocol.decode(allocator, bytes[0..length], "", .{ .exited = 0 }));
    }
}

test "backend requires version before other messages" {
    try expectFailure(error.InvalidBackendProtocol, &.{fixture.finish});
}

test "backend rejects duplicate version and digest" {
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, fixture.version, fixture.finish });
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, fixture.digest, fixture.digest, fixture.finish });
}

test "backend requires terminal diagnostics and forbids subsequent messages" {
    try expectFailure(error.IncompleteBackendResponse, &.{fixture.version});
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, fixture.finish, fixture.digest });
}

test "backend rejects incompatible version" {
    try expectFailure(error.BackendVersionMismatch, &.{.{ .tag = .zig_version, .body = "other" }});
}

test "backend rejects truncated diagnostic header" {
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .error_bundle, .body = &.{ 0, 0, 0 } } });
}

test "backend rejects diagnostic root list outside extra storage" {
    var body = [_]u8{0} ** 20;

    std.mem.writeInt(u32, body[0..4], 3, .little);
    std.mem.writeInt(u32, body[8..12], 1, .little);
    std.mem.writeInt(u32, body[12..16], 100, .little);
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .error_bundle, .body = &body } });
}

fn expectFailure(expected: anyerror, frames: []const fixture.Frame) !void {
    const bytes = try fixture.encode(allocator, frames);
    defer allocator.free(bytes);

    if (protocol.decode(allocator, bytes, "", .{ .exited = 0 })) |decoded| {
        var result = decoded;
        defer result.deinit();

        return error.ExpectedProtocolRejection;
    } else |err| {
        try std.testing.expectEqual(expected, err);
    }
}

test "backend rejects diagnostic message index outside storage" {
    const body = try fixture.errorBody(allocator, &.{ 1, 3, 0, 100 }, "\x00");
    defer allocator.free(body);

    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .error_bundle, .body = body } });
}

test "backend rejects diagnostic string index outside storage" {
    const body = try fixture.errorBody(allocator, &.{ 1, 3, 0, 4, 100, 1, 0, 0 }, "\x00");
    defer allocator.free(body);

    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .error_bundle, .body = body } });
}

test "backend rejects unterminated diagnostic text" {
    const body = try fixture.errorBody(allocator, &.{ 1, 3, 0, 4, 1, 1, 0, 0 }, "\x00bad");
    defer allocator.free(body);

    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .error_bundle, .body = body } });
}

test "backend rejects reserved digest flags" {
    var body = [_]u8{0} ** (1 + std.Build.Cache.bin_digest_len);

    for ([_]u8{ 2, 3, 128, 255 }) |flag| {
        body[0] = flag;
        try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .emit_digest, .body = &body } });
    }
}

test "backend rejects wrong digest lengths" {
    const body = [_]u8{0} ** (2 + std.Build.Cache.bin_digest_len);

    for (0..body.len + 1) |length| {
        if (length == 1 + std.Build.Cache.bin_digest_len) continue;

        try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .emit_digest, .body = body[0..length] } });
    }
}

test "backend rejects unknown message tag" {
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = @enumFromInt(0xffffffff), .body = "" } });
}

test "backend rejects invalid input path prefix" {
    try expectFailure(error.InvalidBackendProtocol, &.{ fixture.version, .{ .tag = .file_system_inputs, .body = &.{ 255, 'a', 0 } } });
}
