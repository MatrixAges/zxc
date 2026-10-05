const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "nested siblings independently move" {
    try h.run(.{
        .body = "  const first = in.lists.first.reverse()[0]\n  const second = in.lists.second.sort()[0]\n\n  return first.length + second.length + in.count",
        .input = "{ lists: { first: u64[], second: u64[] }, count: u64 }",
    });
}

test "nested child move blocks parent alias" {
    try h.run(.{
        .body = "  const first = in.lists.first.reverse()[0]\n  const whole = parent(in)\n\n  return first.length + whole.count",
        .input = "{ lists: { first: u64[], second: u64[] }, count: u64 }",
        .reject = true,
    });
}

test "static tuple fields independently move" {
    try h.run(.{
        .body = "  const first = in[0].reverse()[0]\n  const second = in[1].sort()[0]\n\n  return first.length + second.length + in[2]",
        .input = "[u64[], u64[], u64]",
    });
}

test "static tuple field repeated move is rejected" {
    try h.run(.{
        .body = "  const first = in[0].reverse()[0]\n  const second = in[0].sort()[0]\n\n  return first.length + second.length",
        .input = "[u64[], u64[]]",
        .reject = true,
    });
}

test "dynamic index cannot establish sibling independence" {
    try h.run(.{
        .body = "  const first = in[0].reverse()[0]\n  const second = in[1].reverse()[0]\n\n  return first.length + second.length",
        .input = "u64[][]",
        .reject = true,
    });
}

test "deep child move preserves other branch" {
    try h.run(.{
        .body = "  const first = in.left.values.reverse()[0]\n  const second = in.right.values.reverse()[0]\n\n  return first.length + second.length",
        .input = "{ left: { values: u64[] }, right: { values: u64[] } }",
    });
}

test "nested valid analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = in.lists.first.reverse()[0]\n  const second = in.lists.second.sort()[0]\n\n  return first.length + second.length + in.count",
        .input = "{ lists: { first: u64[], second: u64[] }, count: u64 }",
    }});
}

test "nested rejected analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const first = in.lists.first.reverse()[0]\n  const whole = parent(in)\n\n  return first.length + whole.count",
        .input = "{ lists: { first: u64[], second: u64[] }, count: u64 }",
        .reject = true,
    }});
}
