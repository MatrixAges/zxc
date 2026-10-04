const std = @import("std");
const protocol = @import("backend_protocol");
const fixture = @import("fixture.zig");

pub fn chain(allocator: std.mem.Allocator, depth: usize, branches: u32) ![]u32 {
    const extra = try allocator.alloc(u32, 4 + depth * 6);
    @memset(extra, 0);
    @memcpy(extra[0..4], &[_]u32{ 1, 3, 0, 4 });

    for (0..depth) |index| {
        const start = 4 + index * 6;
        extra[start] = 1;
        extra[start + 1] = 1;

        if (index + 1 < depth) {
            extra[start + 3] = branches;
            extra[start + 4] = @intCast(start + 6);
            extra[start + 5] = @intCast(start + 6);
        }
    }

    return extra;
}

pub fn check(allocator: std.mem.Allocator, extra: []const u32, expected: ?anyerror) !void {
    const backing = std.testing.allocator;
    const body = try fixture.errorBody(backing, extra, "\x00message\x00");
    defer backing.free(body);

    const bytes = try fixture.encode(backing, &.{ fixture.version, .{ .tag = .error_bundle, .body = body } });
    defer backing.free(bytes);

    if (protocol.decode(allocator, bytes, "", .{ .exited = 1 })) |decoded| {
        var result = decoded;
        defer result.deinit();

        try std.testing.expect(expected == null);
        try std.testing.expectEqual(extra[0], result.diagnostics.errorMessageCount());
    } else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(expected orelse return err, err);
    }
}
