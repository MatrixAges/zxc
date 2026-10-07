const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "function update effects: source index value after in order" {
    try h.run(std.testing.allocator, .{  });
}

test "function update effects: single round" {
    try h.run(std.testing.allocator, .{ .outer = 1, .inner = 1 });
}

test "function update effects: repeated calls" {
    try h.run(std.testing.allocator, .{ .outer = 3, .inner = 17 });
}

test "function update effects: zero outer skips all native calls" {
    try h.run(std.testing.allocator, .{ .outer = 0, .failure = .{ .stage = .source } });
}

test "function update effects: zero inner skips all native calls" {
    try h.run(std.testing.allocator, .{ .inner = 0, .failure = .{ .stage = .source } });
}

test "function update effects: empty list zero rounds" {
    try h.run(std.testing.allocator, .{ .empty = true, .inner = 0 });
}

test "function update effects: last element" {
    try h.run(std.testing.allocator, .{ .selected = 2 });
}

test "function update effects: negative delta" {
    try h.run(std.testing.allocator, .{ .delta = -13 });
}

test "function update effects: source fails first" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .source } });
}

test "function update effects: index fails before value" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .index } });
}

test "function update effects: value fails before later statements" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .value } });
}

test "function update effects: after failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .after } });
}

test "function update effects: later source failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .source, .occurrence = 4 } });
}

test "function update effects: later index failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .index, .occurrence = 4 } });
}

test "function update effects: later value failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .value, .occurrence = 4 } });
}

test "function update effects: later after failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .after, .occurrence = 4 } });
}

test "function update effects: unreached failure" {
    try h.run(std.testing.allocator, .{ .failure = .{ .stage = .value, .occurrence = 7 } });
}

test "function update effects: empty write bounds" {
    try h.run(std.testing.allocator, .{ .empty = true });
}

test "function update effects: invalid index bounds" {
    try h.run(std.testing.allocator, .{ .selected = 3 });
}

test "function update effects: invalid index and source failure" {
    try h.run(std.testing.allocator, .{ .selected = 3, .failure = .{ .stage = .source } });
}

test "function update effects: invalid index and index failure" {
    try h.run(std.testing.allocator, .{ .selected = 3, .failure = .{ .stage = .index } });
}

test "function update effects: invalid index and value failure" {
    try h.run(std.testing.allocator, .{ .selected = 3, .failure = .{ .stage = .value } });
}

test "function update effects: invalid index skips after" {
    try h.run(std.testing.allocator, .{ .selected = 3, .failure = .{ .stage = .after } });
}

test "function update effects clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{}});
}
 test "function update effects clean allocation failures before native value failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .failure = .{ .stage = .value, .occurrence = 4 } }});
}

test "function update effects: signed right value" {
    try h.run(std.testing.allocator, .{ .outer = 1, .inner = 1, .delta = -2 });
}

test "function update effects: zero right value skipped by zero rounds" {
    try h.run(std.testing.allocator, .{ .inner = 0, .delta = 0 });
}

test "function update effects: right value failure precedes zero arithmetic" {
    try h.run(std.testing.allocator, .{ .delta = 0, .failure = .{ .stage = .value } });
}

test "function update effects: index failure precedes zero right value" {
    try h.run(std.testing.allocator, .{ .delta = 0, .failure = .{ .stage = .index } });
}

test "function update effects: source failure precedes zero right value" {
    try h.run(std.testing.allocator, .{ .delta = 0, .failure = .{ .stage = .source } });
}

test "function update effects: bounds precede zero arithmetic" {
    try h.run(std.testing.allocator, .{ .selected = 3, .delta = 0 });
}

test "function update effects: empty bounds precede zero arithmetic" {
    try h.run(std.testing.allocator, .{ .empty = true, .delta = 0 });
}

comptime {
    if (h.nested) _ = @import("parent.zig");
}
