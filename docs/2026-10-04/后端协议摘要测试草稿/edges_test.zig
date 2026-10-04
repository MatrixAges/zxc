const std = @import("std");
const protocol = @import("backend_protocol");
const fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

test "backend cache flag preserves every digest byte" {
    for ([_]u8{ 0, 1 }) |flag| {
        var body: [1 + std.Build.Cache.bin_digest_len]u8 = undefined;
        body[0] = flag;

        for (body[1..], 0..) |*byte, index| byte.* = @intCast(index + 17);

        const bytes = try fixture.encode(allocator, &.{ fixture.version, .{ .tag = .emit_digest, .body = &body }, fixture.finish });
        defer allocator.free(bytes);

        var result = try protocol.decode(allocator, bytes, "", .{ .exited = 0 });
        defer result.deinit();

        @memset(bytes, 0);
        try std.testing.expect(result.succeeded);
        try std.testing.expectEqual(flag == 1, result.cached);
        try std.testing.expectEqualSlices(u8, body[1..], &result.digest.?);
    }
}

test "backend signal termination prevents success" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "", .{ .signal = .KILL });
    defer result.deinit();

    try std.testing.expect(!result.succeeded and !result.inputs_complete);
    try std.testing.expectEqual(std.posix.SIG.KILL, result.termination.signal);
}
