const std = @import("std");
const f = @import("fixture.zig");

test "empty and truncated cache bytes are rejected" {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    for ([_]usize{ 0, 1, 12, 13, 77, 78, 142, bytes.len - 1 }) |length| try f.reject(bytes[0..length]);
}

test "different compiler fingerprint is rejected" {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    try std.testing.expectError(error.InvalidCache, f.codec.decode(std.testing.allocator, bytes, [_]u8{18} ** 32));
}

test "unknown format marker is rejected" {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    bytes[11] = '2';

    try f.reject(bytes);
}

test "changed payload without matching digest is rejected" {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    bytes[bytes.len - 2] ^= 1;

    try f.reject(bytes);
}

test "header separator corruption is rejected" {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    bytes[77] = ' ';

    try f.reject(bytes);
}

test "valid checksum does not admit malformed JSON" {
    const bytes = try f.envelope("{broken}");

    defer std.testing.allocator.free(bytes);

    try f.reject(bytes);
}

test "valid checksum does not admit unsupported IR version" {
    const original = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(original);

    var parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, original[143..], .{});

    defer parsed.deinit();

    parsed.value.object.getPtr("ir_version").?.* = .{ .integer = 0 };
    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, parsed.value, .{});

    defer std.testing.allocator.free(payload);

    const bytes = try f.envelope(payload);

    defer std.testing.allocator.free(bytes);

    try f.reject(bytes);
}

test "valid envelope does not admit invalid type table" {
    var analysis = try f.source.analyze(std.testing.allocator);

    defer analysis.deinit();

    var artifact = try f.compiler.project.artifact.extract(std.testing.allocator, &analysis, 0);

    defer artifact.deinit();

    artifact.value.types = &.{};
    const bytes = try f.codec.encode(std.testing.allocator, artifact.value, f.context, f.identity);

    defer std.testing.allocator.free(bytes);

    try f.reject(bytes);
}

test "excessive JSON nesting is rejected with matching digest" {
    const payload = try std.testing.allocator.alloc(u8, 4100);

    defer std.testing.allocator.free(payload);

    @memset(payload[0..2050], '[');
    @memset(payload[2050..], ']');

    const bytes = try f.envelope(payload);

    defer std.testing.allocator.free(bytes);

    try f.reject(bytes);
}
