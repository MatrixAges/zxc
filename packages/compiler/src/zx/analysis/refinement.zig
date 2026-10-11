const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");

pub fn reference(self: *Analyzer, symbol: ir.SymbolId, span: zx.Span) zx.Error!ir.ExprId {
    const original = self.symbols.at(@backingInt(symbol)).type_id;
    const value = try self.append(.{ .span = span, .type_id = original, .value = .{ .reference = symbol } });
    const refined = typeOf(self, symbol);

    return if (refined == original) value else self.append(.{ .span = span, .type_id = refined, .value = .{ .optional_value = value } });
}

pub fn typeOf(self: *const Analyzer, symbol: ir.SymbolId) ir.TypeId {
    const id = self.symbols.at(@backingInt(symbol)).type_id;

    return self.refinement.typeOf(self.types.items.view(), id, symbol);
}

pub fn project(self: *Analyzer, id: ir.ExprId) zx.Error!ir.ExprId {
    const expression = self.node(id);
    const target = self.types.get(expression.type_id);

    if (target != .optional or !self.refinement.containsValue(self.nodes.view(), id)) return id;

    return self.append(.{ .span = expression.span, .type_id = target.optional, .value = .{ .optional_value = id } });
}
