const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const syntax = zx.syntax.borrow;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const Builder = @import("collections/builder.zig");
pub const Operation = @import("../modules/intrinsic.zig").Operation;

pub fn arity(operation: Operation) usize {
    return switch (operation) {
        .pick, .omit, .take, .takeRight, .drop, .dropRight => 2,
        .clamp, .inRange => 3,
        else => 1,
    };
}

pub fn analyze(self: *Analyzer, expression: anytype, operation: Operation, _: ?ir.TypeId) zx.Error!ir.ExprId {
    const call = syntax.value(expression).call;

    if (call.arguments.len != arity(operation)) return self.reporter.fail(.type_mismatch, expression.span, "utility argument count mismatch");
    if ((operation == .isNil or operation == .isNotNil) and syntax.value(syntax.item(call.arguments, 0)) == .null_value) return self.append(.{ .type_id = Types.scalarId(.bool), .span = expression.span, .value = .{ .boolean = operation == .isNil } });

    const first = try self.expression(syntax.item(call.arguments, 0), null);
    const first_type = self.node(first).type_id;

    if (operation == .identity) return first;

    if (operation == .pick or operation == .omit) {
        if (self.types.get(first_type) != .object) return self.reporter.fail(.type_mismatch, expression.span, "object selection requires an object");

        return @import("object_selection.zig").analyzeAt(self, expression, first, operation == .omit, 1);
    }

    const builder = Builder{ .analyzer = self, .span = expression.span };
    var values: std.ArrayList(ir.ExprId) = .empty;
    var bindings: std.ArrayList(ir.ScopeBinding) = .empty;

    for (0..call.arguments.len) |index| {
        const hint = if (operation == .clamp or operation == .inRange) first_type else Types.scalarId(.u64);
        const value = if (index == 0) first else try self.expression(syntax.item(call.arguments, index), hint);
        const symbol = if (self.node(value).type_id == Types.scalarId(.void)) null else try builder.symbol("$utils_argument", self.node(value).type_id);

        try bindings.append(self.allocator, .{ .symbol = symbol, .value = value, .borrow = true });
        try values.append(self.allocator, if (symbol) |id| try builder.reference(id) else value);
    }

    const result = try @import("utilities/value.zig").lower(builder, operation, values.items);

    return builder.expression(self.node(result).type_id, .{ .scope = .{ .bindings = try bindings.toOwnedSlice(self.allocator), .result = result } });
}
