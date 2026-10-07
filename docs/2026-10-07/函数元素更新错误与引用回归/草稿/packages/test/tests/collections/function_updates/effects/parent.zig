const std = @import("std");
const h = @import("check.zig");

test "nested function updates: parent access is required" {
    try h.run(std.testing.allocator, .{ .bad_parent = true });
}

test "nested function updates: parent access skips index failure" {
    try h.run(std.testing.allocator, .{ .bad_parent = true, .failure = .{ .stage = .index } });
}

test "nested function updates: parent access skips RHS failure" {
    try h.run(std.testing.allocator, .{ .bad_parent = true, .failure = .{ .stage = .value } });
}

test "nested function updates: source failure before parent" {
    try h.run(std.testing.allocator, .{ .bad_parent = true, .failure = .{ .stage = .source } });
}

test "nested function updates: container failure before parent read" {
    try h.run(std.testing.allocator, .{ .bad_parent = true, .failure = .{ .stage = .container } });
}

test "nested function updates: later container failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .container, .occurrence = 4 } });
}

test "nested function updates: zero rounds skip invalid parent" {
    try h.run(std.testing.allocator, .{ .inner = 0, .bad_parent = true });
}

test "nested function updates: zero calls skip invalid parent" {
    try h.run(std.testing.allocator, .{ .outer = 0, .bad_parent = true });
}
