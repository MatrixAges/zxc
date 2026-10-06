const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "reduce fresh initial allows push and consumes resulting accumulator" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n  const result = in.reduce((items, item) => items.push(item)[0], initial)\n\n  return result.reverse()[0]",
    });
}

test "reduce mapped initial allows conditional push and pop" {
    try h.run(.{
        .body = "  const initial = in.map(item => item)\n\n  return in.reduce((items, item) => item > 0 ? items.push(item)[0] : items.pop()[0], initial)",
    });
}

test "reduce owned initial survives identity callback" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, item) => items, initial).reverse()[0]",
    });
}

test "reduce nested borrowed rows can be concatenated into owned accumulator" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, row) => items.concat(row)[0], initial)",
        .input = "u64[][]",
    });
}

test "reduce scalar accumulator stays copy" {
    try h.run(.{
        .body = "  return in.reduce((sum, item) => sum + item, 0)",
        .output = "u64",
        .ownership = "copy",
    });
}

test "reduce borrowed initial can remain borrowed" {
    try h.run(.{
        .body = "  return in.reduce((items, item) => items, in)",
        .ownership = "borrowed",
    });
}

test "reduce borrowed initial can produce an appended value" {
    try h.run(.{
        .body = "  return in.reduce((items, item) => items.push(item)[0], in)",
        .ownership = "borrowed",
    });
}

test "reduce source elements can produce reversed copies" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, row) => row.reverse()[0], initial)",
        .input = "u64[][]",
    });
}

test "reduce borrowed callback result downgrades owned initial" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, row) => row, initial)",
        .input = "u64[][]",
        .ownership = "borrowed",
    });
}

test "reduce borrowed callback result can produce a later reversed copy" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n  const result = in.reduce((items, row) => row, initial)\n\n  return result.reverse()[0]",
        .input = "u64[][]",
    });
}

test "reduce next iteration preserves possibly borrowed accumulator" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, row) => row.length > 0 ? items.push(1)[0] : row, initial)",
        .ownership = "borrowed",
        .input = "u64[][]",
    });
}

test "reduce initial remains usable after identity callback" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n  const result = in.reduce((items, item) => items, initial)\n\n  return initial",
    });
}

test "reduce reduce scalar result releases source temporary loan" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const count = values.reduce((sum, item) => sum + item, 0)\n\n  return values.push(count)[0]",
    });
}

test "reduce source can also be the immutable initial value" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n\n  return values.reduce((items, item) => items.push(item)[0], values)",
        .ownership = "borrowed",
    });
}

test "reduce owned success cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const initial: u64[] = []\n  const result = in.reduce((items, item) => items.push(item)[0], initial)\n\n  return result.reverse()[0]",
    }});
}

test "reduce borrowed recurrence cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, row) => row.length > 0 ? items.push(1)[0] : row, initial)",
        .ownership = "borrowed",
        .input = "u64[][]",
    }});
}
