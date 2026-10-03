const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, selection: ir.Match) Lower.Error!*const node.Expression {
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

    var result = try self.expr(selection.fallback);
    var index = selection.arms.len;

    while (index > 0) {
        index -= 1;
        const arm = selection.arms[index];

        const condition = if (selection.subject) |subject|
            try self.binary(.{ .operator = .equal, .left = subject, .right = arm.condition })

        else
            try self.expr(arm.condition);

        result = try self.builder.expression(.{ .conditional = .{ .condition = condition, .yes = try self.expr(arm.result), .no = result } });
    }

    return if (selection.subject == null) result else aggregate.finish(self, &body, result);
}
