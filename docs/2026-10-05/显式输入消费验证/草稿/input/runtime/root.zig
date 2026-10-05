const std = @import("std");
const program = @import("program");
const h = @import("check.zig");

test "generated entry exposes precise input consumption metadata" {
    try std.testing.expectEqual(@import("options").owned, program.consumes_input);
}

test "owned helper chain executes empty" {
    try h.run(std.testing.allocator, 0);
}

test "owned helper chain executes single maximum integer" {
    try h.run(std.testing.allocator, 1);
}

test "owned helper chain executes two elements" {
    try h.run(std.testing.allocator, 2);
}

test "owned helper chain executes seven elements" {
    try h.run(std.testing.allocator, 7);
}

test "owned helper chain executes duplicates and zero" {
    try h.run(std.testing.allocator, 31);
}

test "owned helper chain executes long sequence" {
    try h.run(std.testing.allocator, 127);
}

test "owned helper chain executes larger sequence" {
    try h.run(std.testing.allocator, 256);
}

test "owned helper chain releases every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{@as(usize, 128)});
}

test "empty owned helper chain releases every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{@as(usize, 0)});
}
