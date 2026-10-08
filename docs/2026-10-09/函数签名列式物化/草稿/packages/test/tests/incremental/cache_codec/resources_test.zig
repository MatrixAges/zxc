const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

test "cache encoding cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, encode, .{});
}

test "cache decoding cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, decode, .{});
}

fn encode(allocator: std.mem.Allocator) !void {
    const bytes = try f.bytes(allocator);

    defer allocator.free(bytes);

    try std.testing.expect(std.mem.startsWith(u8, bytes, "zxc.module.v3\n"));
}

fn decode(allocator: std.mem.Allocator) !void {
    const bytes = try f.bytes(std.testing.allocator);

    defer std.testing.allocator.free(bytes);

    var result = try f.codec.decode(allocator, bytes, f.identity);

    defer result.result.deinit();

    try std.testing.expectEqualStrings("/project/shared.zx", result.result.value.path);
}
