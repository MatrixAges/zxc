const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const expressions = @import("expressions.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const selection = syntax.value(expression).match_expr;
    const subject = if (selection.subject) |value| try self.expression(value, null) else null;
    const condition_type = if (subject) |id| self.node(id).type_id else Types.scalarId(.bool);

    if (subject != null) {
        const target = self.types.get(condition_type);

        if ((target != .scalar and target != .enumeration and target != .error_set) or condition_type == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, expression.span, "match subject must be a scalar, enum or finite error");
    }

    var result_type = expected orelse hint(self, selection);
    const arms = try self.allocator.alloc(ir.MatchArm, selection.arms.len);

    for (0..selection.arms.len) |index| {
        const arm = syntax.item(selection.arms, index);
        const condition = try self.expression(arm.condition, condition_type);
        const result = try self.expression(arm.result, result_type);

        result_type = self.node(result).type_id;
        arms[index] = .{ .condition = condition, .result = result };
    }

    const fallback = try self.expression(selection.fallback, result_type);

    return self.append(.{ .span = expression.span, .type_id = self.node(fallback).type_id, .value = .{ .match_expr = .{ .subject = subject, .arms = arms, .fallback = fallback } } });
}

pub fn hint(self: *const Analyzer, selection: anytype) ?ir.TypeId {
    for (0..selection.arms.len) |index| {
        const arm = syntax.item(selection.arms, index);

        if (expressions.knownType(self, arm.result)) |type_id| return type_id;
    }

    if (expressions.knownType(self, selection.fallback)) |type_id| return type_id;

    var result: ?ir.TypeId = null;

    for (0..selection.arms.len) |index| {
        const arm = syntax.item(selection.arms, index);

        if (expressions.literalHint(arm.result, selection.fallback)) |type_id| {
            if (type_id == Types.scalarId(.f64)) return type_id;

            result = type_id;
        }
    }

    return result;
}
