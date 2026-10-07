const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn analyze(self: *Analyzer, child: anytype, span: zx.Span) zx.Error!ir.ExprId {
    const operand = try self.expression(child, null);
    const members = try zx.error_effects.expression(self.allocator, self.types.items.view(), self.functions, self.nodes.view(), operand) orelse return self.reporter.fail(.type_mismatch, span, "try requires a finite error contract; declare the native function's throws members");
    const errors = try self.types.wrap(.optional, try self.types.errorSet(members));
    const payload = self.node(operand).type_id;
    const result = if (payload == Types.scalarId(.void)) payload else try self.types.wrap(.optional, payload);

    return self.append(.{ .span = span, .type_id = try self.types.tuple(&.{ errors, result }), .value = .{ .capture = operand } });
}

pub fn member(self: *Analyzer, name: zx.ast.Name, span: zx.Span, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const type_id = expected orelse return self.reporter.fail(.type_mismatch, span, "an error member requires a finite error-set context");
    const target = self.types.get(type_id);

    if (target != .error_set) return self.reporter.fail(.type_mismatch, span, "an error member requires a finite error-set context");

    for (target.error_set, 0..) |value, index| {
        if (std.mem.eql(u8, value, name.text)) return self.append(.{ .span = span, .type_id = type_id, .value = .{ .error_value = @intCast(index) } });
    }

    return self.reporter.fail(.name, name.span, "error is not a member of this expression's finite error set");
}
