const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();

state: zx.Refinement = .{},
pub const Mark = zx.Refinement.Mark;

pub fn mark(self: Self) Mark {
    return self.state.mark();
}

pub fn restore(self: *Self, saved: Mark) void {
    self.state.restore(saved);
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.state.deinit(allocator);
}

pub fn add(self: *Self, allocator: std.mem.Allocator, symbol: ir.SymbolId) std.mem.Allocator.Error!void {
    try self.state.nonnull.append(allocator, symbol);
}

pub fn bind(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, value: ir.ExprId, symbols: []const ?ir.SymbolId) std.mem.Allocator.Error!void {
    try self.state.bind(allocator, expressions.get(value), symbols);
}

pub fn assume(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, condition: ir.ExprId, truth: bool) std.mem.Allocator.Error!void {
    try self.state.assume(allocator, expressions, condition, truth);
}

pub fn typeOf(self: *const Self, types: ir.TypeTable, id: ir.TypeId, symbol: ir.SymbolId) ir.TypeId {
    const target = types.at(@backingInt(id));

    return if (target == .optional and self.state.contains(symbol)) target.optional else id;
}
