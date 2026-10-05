const std = @import("std");
const h = @import("check.zig");

test "escaped child borrow preserves independent sibling move" {
    try h.run(.{
        .body = "  const first = borrow(in.first)\n  const second = in.second.reverse()[0]\n\n  return first.length + second.length",
    });
}

test "escaped child borrow freezes same child" {
    try h.run(.{
        .body = "  const first = borrow(in.first)\n  const second = in.first.reverse()[0]\n\n  return first.length + second.length",
        .reject = true,
    });
}

test "whole parent borrow freezes all children" {
    try h.run(.{
        .body = "  const whole = parent(in)\n  const second = in.second.reverse()[0]\n\n  return whole.count + second.length",
        .reject = true,
    });
}

test "parent borrow after child loan freezes siblings" {
    try h.run(.{
        .body = "  const first = borrow(in.first)\n  const whole = parent(in)\n  const second = in.second.reverse()[0]\n\n  return first.length + whole.count + second.length",
        .reject = true,
    });
}

test "temporary child loan ends after scalar call" {
    try h.run(.{
        .body = "  const size = count(in.first)\n  const first = in.first.reverse()[0]\n\n  return size + first.length",
    });
}

test "later temporary loan cannot release permanent borrow" {
    try h.run(.{
        .body = "  const first = borrow(in.first)\n  const size = count(in.first)\n  const second = in.first.reverse()[0]\n\n  return size + first.length + second.length",
        .reject = true,
    });
}

test "nested borrow preserves sibling at same depth" {
    try h.run(.{
        .body = "  const first = borrow(in.lists.first)\n  const second = in.lists.second.reverse()[0]\n\n  return first.length + second.length",
        .input = "{ lists: { first: u64[], second: u64[] } }",
    });
}

test "borrows valid analysis allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = borrow(in.first)\n  const second = in.second.reverse()[0]\n\n  return first.length + second.length",
    }});
}

test "borrows rejected analysis allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = borrow(in.first)\n  const second = in.first.reverse()[0]\n\n  return first.length + second.length",
        .reject = true,
    }});
}
