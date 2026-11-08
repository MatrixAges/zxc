const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const bridge = @import("match/bridge.zig");

pub fn lower(self: *Lower, selection: ir.MatchRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, selection, false);
}

pub fn lowerValue(self: *Lower, selection: ir.MatchRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, selection, true);
}

fn lowerMode(self: *Lower, selection: ir.MatchRow, layout: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return if (layout) @import("match/seed.zig").lowerValue(self, selection) else @import("match/seed.zig").lower(self, selection);

    var body: std.ArrayList(node.Statement) = .empty;
    const previous = if (selection.subject) |subject| self.cache.get(subject) else null;

    if (selection.subject) |subject| {
        const saved = try aggregate.bind(self, &body, try self.expr(subject));

        try self.cache.put(self.allocator, subject, saved);
        if (selection.arms.len == 0) try body.append(self.allocator, .{ .discard = saved });
    }

    defer {
        if (selection.subject) |subject| {
            if (previous) |value| self.cache.put(self.allocator, subject, value) catch unreachable else _ = self.cache.remove(subject);
        }
    }

    const fallback = if (layout) try @import("value_call/root.zig").expression(self, selection.fallback) else try self.expr(selection.fallback);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = buffered.allocator();
    const plan = try bridge.plan(self, allocator, selection, layout);

    if (!plan.valid) return error.OutOfMemory;

    const values = try allocator.alloc(node.ExpressionId, plan.operations.len);

    for (plan.operations, plan.first, plan.second, values) |operation, first, second, *value| {
        value.* = switch (operation) {
            .Expression => try self.expr(@fromBackingInt(first)),
            .Value => try @import("value_call/root.zig").expression(self, @fromBackingInt(first)),
            .Equality => try self.binary(.{ .operator = .equal, .left = @fromBackingInt(first), .right = @fromBackingInt(second) }),
            .Literal => try @import("selection.zig").literal(self, @fromBackingInt(first)),
        };
    }

    const result = try bridge.emit(self, allocator, plan.selected, plan.count, values, fallback);

    return if (selection.subject == null) result else aggregate.finish(self, &body, result);
}
