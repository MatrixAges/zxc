const std = @import("std");
const protocol = @import("backend_protocol");
const fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

test "backend result owns inputs and stderr" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.inputs, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var stderr = [_]u8{ 'l', 'o', 'g' };
    var result = try protocol.decode(allocator, bytes, &stderr, .{ .exited = 0 });
    defer result.deinit();

    @memset(bytes, 0);
    @memset(&stderr, 0);
    try std.testing.expect(result.succeeded and result.inputs_complete);
    try std.testing.expectEqualStrings("a.zig", result.inputs[0].path);
    try std.testing.expectEqualStrings("log", result.stderr);
}

test "backend success without input frame is incomplete for dependency tracking" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "", .{ .exited = 0 });
    defer result.deinit();

    try std.testing.expect(result.succeeded and !result.inputs_complete);
}

test "backend nonzero termination prevents success" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.inputs, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "failed", .{ .exited = 1 });
    defer result.deinit();

    try std.testing.expect(!result.succeeded and !result.inputs_complete);
}

test "backend missing digest prevents success" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "", .{ .exited = 0 });
    defer result.deinit();

    try std.testing.expect(!result.succeeded);
}

test "backend later input snapshot replaces earlier paths" {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.inputs, .{ .tag = .file_system_inputs, .body = "" }, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "", .{ .exited = 0 });
    defer result.deinit();

    try std.testing.expect(result.inputs_complete);
    try std.testing.expectEqual(@as(usize, 0), result.inputs.len);
}

test "backend decoder cleans up every allocation failure" {
    try std.testing.checkAllAllocationFailures(allocator, checkAllocations, .{});
}

fn checkAllocations(gpa: std.mem.Allocator) !void {
    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.inputs, fixture.digest, fixture.finish });
    defer allocator.free(bytes);

    var result = try protocol.decode(gpa, bytes, "stderr", .{ .exited = 0 });
    defer result.deinit();

    try std.testing.expect(result.succeeded);
}

test "backend valid diagnostic remains readable and prevents success" {
    const body = try fixture.errorBody(allocator, &.{ 1, 3, 0, 4, 1, 1, 0, 0 }, "\x00bad\x00");
    defer allocator.free(body);

    const bytes = try fixture.encode(allocator, &.{ fixture.version, fixture.digest, .{ .tag = .error_bundle, .body = body } });
    defer allocator.free(bytes);

    var result = try protocol.decode(allocator, bytes, "", .{ .exited = 0 });
    defer result.deinit();

    @memset(bytes, 0);
    try std.testing.expect(!result.succeeded);
    const messages = result.diagnostics.getMessages();
    try std.testing.expectEqual(@as(usize, 1), messages.len);
    const message = result.diagnostics.getErrorMessage(messages[0]);
    try std.testing.expectEqualStrings("bad", result.diagnostics.nullTerminatedString(message.msg));
}
