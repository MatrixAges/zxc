const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");

pub fn reference(self: *Analyzer, symbol: ir.SymbolId, span: zx.Span) zx.Error!ir.ExprId {
    const original = self.symbols.items[@backingInt(symbol)].type_id;
    const value = try self.append(.{ .span = span, .type_id = original, .value = .{ .reference = symbol } });
    const refined = typeOf(self, symbol);

    return if (refined == original) value else self.append(.{ .span = span, .type_id = refined, .value = .{ .optional_value = value } });
}

pub fn typeOf(self: *const Analyzer, symbol: ir.SymbolId) ir.TypeId {
    const id = self.symbols.items[@backingInt(symbol)].type_id;
    const target = self.types.get(id);

    return if (target == .optional and self.refinement.contains(symbol)) target.optional else id;
}
