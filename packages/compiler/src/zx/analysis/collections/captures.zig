const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Self = @This();
pub const Binding = struct { source: ir.SymbolId, target: ir.SymbolId, value: ir.ExprId };

start: usize,
floor: usize,
parent: ?*Self,
bindings: std.ArrayList(Binding) = .empty,
pub fn resolve(self: *Self, analyzer: *Analyzer, name: zx.ast.Name) zx.Error!?ir.SymbolId {
    var index = self.start;

    while (index > self.floor) {
        index -= 1;

        const source = analyzer.active.items[index];

        if (std.mem.eql(u8, analyzer.symbols.at(@backingInt(source)).name, name.text)) return try self.capture(analyzer, source, name.span);
    }

    if (self.parent) |parent| {
        if (try parent.resolve(analyzer, name)) |source| return try self.capture(analyzer, source, name.span);
    }

    return null;
}

fn capture(self: *Self, analyzer: *Analyzer, source: ir.SymbolId, span: zx.Span) zx.Error!ir.SymbolId {
    for (self.bindings.items) |binding| if (binding.source == source) return binding.target;

    const value = try @import("../refinement.zig").reference(analyzer, source, span);
    const type_id = analyzer.node(value).type_id;

    if (analyzer.types.get(type_id) == .task) return analyzer.reporter.fail(.ownership, span, "collection callbacks cannot repeatedly consume a captured task handle");

    const target: ir.SymbolId = @fromBackingInt(@intCast(analyzer.symbols.count()));

    try analyzer.symbols.append(analyzer.allocator, .{ .name = try analyzer.allocator.dupe(u8, analyzer.symbols.at(@backingInt(source)).name), .type_id = type_id, .span = span, .ownership = .borrowed });
    try self.bindings.append(analyzer.allocator, .{ .source = source, .target = target, .value = value });

    return target;
}
