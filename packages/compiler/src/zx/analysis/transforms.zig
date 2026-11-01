const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: anytype, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId) zx.Error!ir.ExprId {
    return analyzeAt(self, expression, target, kind, expected, 0);
}

pub fn analyzeAt(self: *Analyzer, expression: anytype, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId, offset: usize) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;
    const count = arguments.len - offset;

    if (count < 1 or count > 2) return self.reporter.fail(.type_mismatch, expression.span, "collection operations require a callback and at most one optional method argument");

    const source_type = self.node(target).type_id;
    const element_type = self.types.get(source_type).list;
    const reducing = kind == .reduce;
    const second = if (count == 2) try self.expression(syntax.item(arguments, offset + 1), if (reducing) aggregates.payload(self, expected) else null) else null;
    const accumulator_type = if (reducing and second != null) self.node(second.?).type_id else element_type;

    const parameters: []const ir.TypeId = if (reducing)
        &.{ accumulator_type, element_type, Types.scalarId(.u64), source_type }

    else
        &.{ element_type, Types.scalarId(.u64), source_type };

    const hint = aggregates.payload(self, expected);

    const body_hint: ?ir.TypeId = switch (kind) {
        .filter, .every, .some => Types.scalarId(.bool),
        .reduce => accumulator_type,
        .map => if (hint != null and self.types.get(hint.?) == .list) self.types.get(hint.?).list else null,
    };

    const callback = try @import("collections/callback.zig").analyze(self, syntax.item(arguments, offset), parameters, body_hint);

    const type_id = switch (kind) {
        .filter => source_type,
        .every, .some => Types.scalarId(.bool),
        .reduce => accumulator_type,
        .map => try self.types.wrap(.list, self.node(callback.body).type_id),
    };

    return @import("collections/lower.zig").lower(self, .{
        .span = expression.span,
        .kind = kind,
        .target = target,
        .initial = if (reducing) second else null,
        .ignored = if (reducing) null else second,
        .callback = callback,
        .result_type = type_id,
    });
}
