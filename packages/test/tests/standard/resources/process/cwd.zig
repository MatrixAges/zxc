const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn check(allocator: std.mem.Allocator) !void {
    var path: f.Path = .{};
    var vtable: std.Io.VTable = undefined;
    const result = try f.api.cwd(allocator, path.io(&vtable));

    defer allocator.free(result);

    try std.testing.expectEqualStrings(path.value, result);
    try std.testing.expectEqual(@as(usize, 1), path.calls);
}

test "process cwd uses caller IO and copies Unicode path" {
    try check(f.allocator);
}

test "process cwd preserves IO failure" {
    var path: f.Path = .{ .failure = true };
    var vtable: std.Io.VTable = undefined;

    try std.testing.expectError(error.Canceled, f.api.cwd(f.allocator, path.io(&vtable)));
}

test "process cwd rejects invalid UTF8 returned by IO" {
    var path: f.Path = .{ .value = "/bad/\xff" };
    var vtable: std.Io.VTable = undefined;

    try std.testing.expectError(error.InvalidUtf8, f.api.cwd(f.allocator, path.io(&vtable)));
}

test "process cwd result outlives overwritten host path" {
    var storage = [_]u8{ '/', 'o', 'l', 'd' };
    var path: f.Path = .{ .value = &storage };
    var vtable: std.Io.VTable = undefined;
    const result = try f.api.cwd(f.allocator, path.io(&vtable));

    defer f.allocator.free(result);
    @memset(&storage, 'X');

    try std.testing.expectEqualStrings("/old", result);
}

test "process cwd matches real host current directory" {
    var buffer: [std.fs.max_path_bytes]u8 = undefined;
    const length = try std.process.currentPath(std.testing.io, &buffer);
    const result = try f.api.cwd(f.allocator, std.testing.io);

    defer f.allocator.free(result);

    try std.testing.expectEqualStrings(buffer[0..length], result);
}

test "process cwd releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, check, .{});
}
