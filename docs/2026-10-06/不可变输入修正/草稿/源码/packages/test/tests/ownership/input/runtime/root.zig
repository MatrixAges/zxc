const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");
const h = @import("check.zig");

test "generated entry has no input consumption metadata" {
    try std.testing.expect(!@hasDecl(program, "consumes_input"));
}

test "immutable helper chain executes empty" {
    try h.run(std.testing.allocator, 0);
}

test "immutable helper chain executes single maximum integer" {
    try h.run(std.testing.allocator, 1);
}

test "immutable helper chain executes two elements" {
    try h.run(std.testing.allocator, 2);
}

test "immutable helper chain executes seven elements" {
    try h.run(std.testing.allocator, 7);
}

test "immutable helper chain executes duplicates and zero" {
    try h.run(std.testing.allocator, 31);
}

test "immutable helper chain executes long sequence" {
    try h.run(std.testing.allocator, 127);
}

test "immutable helper chain executes larger sequence" {
    try h.run(std.testing.allocator, 256);
}

test "immutable helper chain releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{@as(usize, 128)});
}

test "empty immutable helper chain releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{@as(usize, 0)});
}
