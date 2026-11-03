const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, selection: ir.MatchRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, selection, false);
}

pub fn lowerValue(self: *Lower, selection: ir.MatchRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, selection, true);
}

fn lowerMode(self: *Lower, selection: ir.MatchRow, layout: bool) Lower.Error!node.ExpressionId {
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

    const values = @import("value_call/root.zig");
    var result = if (layout) try values.expression(self, selection.fallback) else try self.expr(selection.fallback);
    var index = selection.arms.len;

    if (try @import("selection.zig").constantLabels(self, selection)) {
        index -= 1;
        const last = selection.arms.at(index);
        const condition = try self.binary(.{ .operator = .equal, .left = selection.subject.?, .right = last.condition });
        const yes = if (layout) try values.expression(self, last.result) else try self.expr(last.result);
        result = try self.builder.expression(.{ .conditional = .{ .condition = condition, .yes = yes, .no = result } });
        const arms = try self.allocator.alloc(node.SelectionArm, index + 1);

        arms[index] = .{ .result = result };

        while (index != 0) {
            index -= 1;
            const arm = selection.arms.at(index);
            const label = try self.expr(arm.condition);
            const value = if (layout) try values.expression(self, arm.result) else try self.expr(arm.result);

            arms[index] = .{ .value = label, .result = value };
        }

        const selected = try self.builder.expression(.{ .selection = .{ .subject = try self.expr(selection.subject.?), .arms = arms } });

        return aggregate.finish(self, &body, selected);
    }

    while (index > 0) {
        index -= 1;
        const arm = selection.arms.at(index);

        const condition = if (selection.subject) |subject|
            try self.binary(.{ .operator = .equal, .left = subject, .right = arm.condition })

        else
            try self.expr(arm.condition);

        const yes = if (layout) try values.expression(self, arm.result) else try self.expr(arm.result);
        result = try self.builder.expression(.{ .conditional = .{ .condition = condition, .yes = yes, .no = result } });
    }

    return if (selection.subject == null) result else aggregate.finish(self, &body, result);
}
