const std = @import("std");
const fixture = @import("fixture.zig");

test "unsigned scalar preserves both native boundaries" {
    try fixture.check(std.testing.allocator, .{});
}

test "signed scalar preserves both native boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "i64" });
}

test "floating scalar preserves both native boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "f64" });
}

test "boolean scalar preserves both native boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "bool" });
}

test "string input permits local values without buffer purity" {
    try fixture.check(std.testing.allocator, .{ .input = "string", .pure = false });
}

test "optional string input remains a borrowed boundary" {
    try fixture.check(std.testing.allocator, .{ .input = "string?", .pure = false });
}

test "scalar list input permits local values without buffer purity" {
    try fixture.check(std.testing.allocator, .{ .input = "u64[]", .pure = false });
}

test "string list input permits local values without buffer purity" {
    try fixture.check(std.testing.allocator, .{ .input = "string[]", .pure = false });
}

test "optional scalar list input remains a borrowed boundary" {
    try fixture.check(std.testing.allocator, .{ .input = "u64[]?", .pure = false });
}

test "list of optional strings remains a borrowed boundary" {
    try fixture.check(std.testing.allocator, .{ .input = "string?[]", .pure = false });
}

test "nested scalar list recursively preserves borrowing" {
    try fixture.check(std.testing.allocator, .{ .input = "u64[][]", .pure = false });
}

test "native reference input preserves both boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "Node" });
}

test "optional native reference input preserves both boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "Node?" });
}

test "native reference list input permits local values" {
    try fixture.check(std.testing.allocator, .{ .input = "Node[]", .pure = false });
}

test "expanded scalar arguments preserve both boundaries" {
    try fixture.check(std.testing.allocator, .{ .input = "[u64, i64]", .parameters = "left: u64, right: i64", .arguments = "in[0], in[1]", .expanded = true });
}

test "expanded string argument separates borrowing from purity" {
    try fixture.check(std.testing.allocator, .{ .input = "[u64, string]", .parameters = "left: u64, right: string", .arguments = "in[0], in[1]", .pure = false, .expanded = true });
}

test "string result keeps ordinary product callers eligible" {
    try fixture.check(std.testing.allocator, .{ .output = "string" });
}

test "optional string result keeps ordinary product callers eligible" {
    try fixture.check(std.testing.allocator, .{ .output = "string?" });
}

test "nested scalar list result keeps ordinary product callers eligible" {
    try fixture.check(std.testing.allocator, .{ .output = "u64[][]" });
}

test "allocator injection preserves string borrowing" {
    try fixture.check(std.testing.allocator, .{ .input = "string", .prefix = "allocator, ", .suffix = " throws { OutOfMemory }", .pure = false, .allocating = true });
}
