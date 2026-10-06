const std = @import("std");
const fixture = @import("fixture.zig");

test "object input rejects local value substitution" {
    try fixture.check(std.testing.allocator, .{ .input = "{ value: u64 }", .pure = false, .local = false });
}

test "object list input rejects local value substitution" {
    try fixture.check(std.testing.allocator, .{ .input = "Cell[]", .pure = false, .local = false });
}

test "single tuple input cannot impersonate expanded arguments" {
    try fixture.check(std.testing.allocator, .{ .input = "[u64, u64]", .pure = false, .local = false });
}

test "expanded object argument remains conservative" {
    try fixture.check(std.testing.allocator, .{ .input = "[{ value: u64 }, u64]", .parameters = "left: { value: u64 }, right: u64", .arguments = "in[0], in[1]", .expanded = true, .pure = false, .local = false });
}

test "object result rejects leaf value substitution" {
    try fixture.check(std.testing.allocator, .{ .output = "{ value: u64 }", .pure = false, .local = false });
}

test "tuple result rejects leaf value substitution" {
    try fixture.check(std.testing.allocator, .{ .output = "[u64, u64]", .pure = false, .local = false });
}

test "optional object result remains conservative" {
    try fixture.check(std.testing.allocator, .{ .output = "{ value: u64 }?", .pure = false, .local = false });
}

test "object list result remains conservative" {
    try fixture.check(std.testing.allocator, .{ .output = "Cell[]", .pure = false, .local = false });
}

test "IO numeric call cannot enter local value specialization" {
    try fixture.check(std.testing.allocator, .{ .prefix = "io, ", .io = true, .local = false });
}

test "process numeric call cannot enter local value specialization" {
    try fixture.check(std.testing.allocator, .{ .prefix = "process, ", .process = true, .local = false });
}

test "IO string call preserves both conservative guards" {
    try fixture.check(std.testing.allocator, .{ .input = "string", .prefix = "io, ", .io = true, .pure = false, .local = false });
}

test "process list call preserves both conservative guards" {
    try fixture.check(std.testing.allocator, .{ .input = "u64[]", .prefix = "process, ", .process = true, .pure = false, .local = false });
}
