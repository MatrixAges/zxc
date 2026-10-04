const std = @import("std");
const protocol = @import("backend_protocol");
const fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

test "backend nonempty diagnostics release every failed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, checkDiagnostics, .{false});
}

test "backend malformed diagnostics release every failed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, checkDiagnostics, .{true});
}

fn checkDiagnostics(gpa: std.mem.Allocator, malformed: bool) !void {
    const body = try fixture.errorBody(allocator, &.{ 1, 3, 0, 4, 1, 1, 0, 0 }, if (malformed) "\x00bad" else "\x00bad\x00");
    defer allocator.free(body);

    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.inputs, .{ .tag = .error_bundle, .body = body } });
    defer allocator.free(bytes);

    if (protocol.decode(gpa, bytes, "stderr", .{ .exited = 1 })) |decoded| {
        var result = decoded;
        defer result.deinit();

        try std.testing.expect(!malformed);
        try std.testing.expectEqual(@as(u32, 1), result.diagnostics.errorMessageCount());
    } else |err| {
        if (malformed and err == error.InvalidBackendProtocol) return;

        return err;
    }
}
