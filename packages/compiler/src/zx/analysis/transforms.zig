const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: anytype, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId) zx.Error!ir.ExprId {
    return analyzeProjected(self, expression, target, kind, expected, null);
}

pub fn analyzeProjected(self: *Analyzer, expression: anytype, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId, projection: ?u64) zx.Error!ir.ExprId {
    const tuple_result = kind == .map or kind == .filter or kind == .reduce or kind == .sort;
    const result_slot: u64 = if (kind == .reduce) 1 else 0;
    const hint = if (!tuple_result) aggregates.payload(self, expected) else if (projection) |slot| (if (slot == result_slot) aggregates.payload(self, expected) else null) else resultHint(self, expected, result_slot);
    const arguments = syntax.value(expression).call.arguments;
    const count = arguments.len;

    if (count < 1 or count > 2 or (kind == .sort and count != 1)) return self.reporter.fail(.type_mismatch, expression.span, "collection operations require a callback and at most one optional method argument");

    const source_type = self.node(target).type_id;
    const element_type = self.types.get(source_type).list;
    const reducing = kind == .reduce;
    const second = if (count == 2) try self.expression(syntax.item(arguments, 1), if (reducing) hint else null) else null;
    const accumulator_type = if (reducing and second != null) self.node(second.?).type_id else element_type;

    const parameters: []const ir.TypeId = if (kind == .sort) &.{ element_type, element_type } else if (reducing)
        &.{ accumulator_type, element_type, Types.scalarId(.u64), source_type }

    else
        &.{ element_type, Types.scalarId(.u64), source_type };

    const body_hint: ?ir.TypeId = switch (kind) {
        .filter, .every, .some => Types.scalarId(.bool),
        .sort => null,
        .reduce => accumulator_type,
        .map => if (hint != null and self.types.get(hint.?) == .list) self.types.get(hint.?).list else null,
    };

    const callback = try @import("collections/callback.zig").analyze(self, syntax.item(arguments, 0), parameters, body_hint);

    if (kind == .sort and !numbers.isInteger(self.node(callback.body).type_id) and !numbers.isFloat(self.node(callback.body).type_id)) return self.reporter.fail(.type_mismatch, expression.span, "sort comparator must return a number");

    const type_id = switch (kind) {
        .filter, .sort => source_type,
        .every, .some => Types.scalarId(.bool),
        .reduce => accumulator_type,
        .map => try self.types.wrap(.list, self.node(callback.body).type_id),
    };

    return @import("collections/lower.zig").lower(self, .{
        .span = expression.span,
        .tuple_result = tuple_result,
        .projection = projection,
        .kind = kind,
        .target = target,
        .initial = if (reducing) second else null,
        .ignored = if (reducing) null else second,
        .callback = callback,
        .result_type = type_id,
    });
}

fn resultHint(self: *const Analyzer, expected: ?ir.TypeId, slot: u64) ?ir.TypeId {
    const hint = aggregates.payload(self, expected) orelse return null;
    const value = self.types.get(hint);

    return if (value == .tuple and value.tuple.len == 2) value.tuple.at(@intCast(slot)) else null;
}
