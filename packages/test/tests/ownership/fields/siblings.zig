const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "independent owned list fields can both move" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n  const second = in.second.sort()[0]\n\n  return first.length + second.length + in.count",
    });
}

test "scalar sibling remains readable after reference move" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n\n  return in.count + first.length",
    });
}

test "whole parent cannot escape after child move" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n  const whole = parent(in)\n\n  return first.length + whole.count",
        .reject = true,
    });
}

test "same field cannot be consumed twice" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n  const again = in.first.sort()[0]\n\n  return first.length + again.length",
        .reject = true,
    });
}

test "moved field cannot be read" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n\n  return first.length + in.first.length",
        .reject = true,
    });
}

test "borrowed input child cannot move" {
    try h.run(.{
        .body = "  const first = in.first.reverse()[0]\n\n  return first.length",
        .owned = false,
        .reject = true,
    });
}

test "scalar copy before moves remains available" {
    try h.run(.{
        .body = "  const saved = in.count\n  const first = in.first.reverse()[0]\n  const second = in.second.reverse()[0]\n\n  return saved + first.length + second.length",
    });
}

test "siblings valid analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = in.first.reverse()[0]\n  const second = in.second.sort()[0]\n\n  return first.length + second.length + in.count",
    }});
}

test "siblings rejected analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = in.first.reverse()[0]\n  const whole = parent(in)\n\n  return first.length + whole.count",
        .reject = true,
    }});
}

test "spreading owned parent consumes its full subtree before later fields" {
    try h.run(.{
        .body = "  const moved = {...in, count: in.count + 1}\n\n  return moved.count",
        .reject = true,
    });
}
