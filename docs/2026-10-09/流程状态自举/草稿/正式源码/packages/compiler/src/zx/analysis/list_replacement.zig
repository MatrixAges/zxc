const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn analyze(self: *Analyzer, expression: anytype, target: ir.ExprId) zx.Error!ir.ExprId {
    const call = syntax.value(expression).call;
    const list_type = self.node(target).type_id;

    if (call.arguments.len != 2) return self.reporter.fail(.type_mismatch, expression.span, "with requires an index and replacement value");

    const index = try self.expression(syntax.item(call.arguments, 0), Types.scalarId(.u64));
    const value = try self.expression(syntax.item(call.arguments, 1), self.types.get(list_type).list);

    return self.append(.{ .span = expression.span, .type_id = list_type, .value = .{ .list_update = .{ .target = target, .index = index, .value = value } } });
}
