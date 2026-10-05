const std = @import("std");
const f = @import("fixture.zig");

fn check(allocator: std.mem.Allocator, source: []const u8, valid: bool) !void {
    var result = try f.analyze(allocator, source, "nested/main.gateway.rx");

    defer result.deinit();

    try std.testing.expectEqual(valid, result.value == .definition);
}

test "Gateway nested route analysis releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ "<Gateway name='api'><Group prefix='/a'><Group prefix='/b/'><Route method='POST' path='/item' service='../handler'/><Route method='GET' path='/item' service='../reader'/></Group></Group></Gateway>", true });
}

test "Gateway overlap diagnostic releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ "<Gateway name='api'><Route path='/a' service='a'/><Route method='GET' path='/a' service='b'/></Gateway>", false });
}

test "Gateway path diagnostic releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ "<Gateway name='api'><Group prefix='/a'><Route path='/:id' service='a'/></Group></Gateway>", false });
}

test "Gateway limit diagnostic releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ "<Gateway name='api' max_header_bytes='0'><Route path='/a' service='a'/></Gateway>", false });
}
