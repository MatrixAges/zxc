const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const lower = @import("../../statements.zig").lower;

pub fn lowerSwitch(self: *Lower, selection: @FieldType(ir.StatementRow, "switch_stmt")) Lower.Error![]const node.Statement {
    const name = try self.fresh("switch");
    const subject = try self.expr(selection.subject);
    const old = self.cache.get(selection.subject);

    try self.cache.put(self.allocator, selection.subject, try self.builder.identifier(name));

    defer {
        if (old) |previous| self.cache.put(self.allocator, selection.subject, previous) catch unreachable else _ = self.cache.remove(selection.subject);
    }

    var tail: []const node.Statement = if (selection.exhaustive) try self.allocator.dupe(node.Statement, &.{.unreachable_stmt}) else &.{};

    for (0..selection.cases.len) |case_index| {
        const case = selection.cases.at(case_index);

        if (case.value == null) {
            tail = try lower(self, case.body);
        }
    }

    var conditions: std.ArrayList(u32) = .empty;

    defer conditions.deinit(self.allocator);

    for (0..selection.cases.len) |case_index| {
        if (selection.cases.at(case_index).value) |value| try conditions.append(self.allocator, @backingInt(value));
    }

    if (try @import("../../selection.zig").labels(self, selection.subject, conditions.items)) {
        const arms = try self.allocator.alloc(node.SelectionArm, conditions.items.len);
        var remaining = conditions.items.len;
        var position = selection.cases.len;

        while (position != 0) {
            position -= 1;
            const case = selection.cases.at(position);
            const label = case.value orelse continue;
            remaining -= 1;

            const body = try self.builder.statements(try lower(self, case.body));

            if (remaining + 1 == arms.len) {
                const condition = try self.binary(.{ .operator = .equal, .left = selection.subject, .right = label });
                const branch = try self.builder.statements(&.{.{ .branch = .{ .condition = condition, .yes = body, .no = try self.builder.statements(tail) } }});
                arms[remaining] = .{ .result = try self.builder.expression(.{ .block = .{ .label = "", .statements = branch } }) };
            } else {
                arms[remaining] = .{ .value = try @import("../../selection.zig").literal(self, label), .result = try self.builder.expression(.{ .block = .{ .label = "", .statements = body } }) };
            }
        }

        const value = try self.builder.expression(.{ .selection = .{ .subject = try self.builder.identifier(name), .arms = arms } });

        return self.allocator.dupe(node.Statement, &.{ .{ .constant = .{ .name = name, .value = subject } }, .{ .discard = value } });
    }

    var index = selection.cases.len;

    while (index > 0) {
        index -= 1;
        const case = selection.cases.at(index);

        if (case.value) |label| {
            tail = try self.allocator.dupe(node.Statement, &.{.{ .branch = .{ .condition = try self.binary(.{ .operator = .equal, .left = selection.subject, .right = label }), .yes = try self.builder.statements(try lower(self, case.body)), .no = try self.builder.statements(tail) } }});
        }
    }

    var result: std.ArrayList(node.Statement) = .empty;

    try result.append(self.allocator, .{ .constant = .{ .name = name, .value = subject } });
    if (selection.cases.len == 0 or (selection.cases.len == 1 and selection.cases.at(0).value == null)) try result.append(self.allocator, .{ .discard = try self.builder.identifier(name) });
    try result.appendSlice(self.allocator, tail);

    return result.toOwnedSlice(self.allocator);
}
