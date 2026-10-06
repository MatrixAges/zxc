const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "exclusive branches may consume same field" {
    try h.run(.{
        .body = "  const first = in.count == 0 ? in.first.reverse()[0] : in.first.sort()[0]\n  const second = in.second.reverse()[0]\n\n  return first.length + second.length",
    });
}

test "conditional move blocks subsequent field use" {
    try h.run(.{
        .body = "  const size = in.count == 0 ? in.first.reverse()[0].length : 0\n\n  return size + in.first.length",
    });
}

test "returning branch does not poison continuing branch" {
    try h.run(.{
        .body = "  if (in.count == 0) {\n    return in.first.reverse()[0].length\n  }\n\n  return in.first.sort()[0].length",
    });
}

test "conditional moves of different siblings merge conservatively" {
    try h.run(.{
        .body = "  const size = in.count == 0 ? in.first.reverse()[0].length : in.second.reverse()[0].length\n\n  return size + in.second.length",
    });
}

test "conditional borrow freezes selected child" {
    try h.run(.{
        .body = "  const first = in.count == 0 ? borrow(in.first) : borrow(in.first)\n  const second = in.first.reverse()[0]\n\n  return first.length + second.length",
    });
}

test "conditional borrow preserves independent sibling" {
    try h.run(.{
        .body = "  const first = in.count == 0 ? borrow(in.first) : borrow(in.first)\n  const second = in.second.reverse()[0]\n\n  return first.length + second.length",
    });
}

test "branches valid analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = in.count == 0 ? in.first.reverse()[0] : in.first.sort()[0]\n  const second = in.second.reverse()[0]\n\n  return first.length + second.length",
    }});
}

test "branches rejected analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const size = in.count == 0 ? in.first.reverse()[0].length : 0\n\n  return size + in.first.length",
    }});
}
