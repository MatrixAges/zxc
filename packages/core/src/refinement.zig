const std = @import("std");
const ir = @import("ir.zig");
const Self = @This();
const Pair = struct { err: ir.SymbolId, result: ir.SymbolId };

nonnull: std.ArrayList(ir.SymbolId) = .empty,
projections: std.ArrayList(ir.ExprId) = .empty,
captures: std.ArrayList(Pair) = .empty,
pub const Mark = struct { nonnull: usize, projections: usize, captures: usize };

pub fn mark(self: Self) Mark {
    return .{ .nonnull = self.nonnull.items.len, .projections = self.projections.items.len, .captures = self.captures.items.len };
}

pub fn restore(self: *Self, saved: Mark) void {
    self.nonnull.shrinkRetainingCapacity(saved.nonnull);
    self.projections.shrinkRetainingCapacity(saved.projections);
    self.captures.shrinkRetainingCapacity(saved.captures);
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.nonnull.deinit(allocator);
    self.projections.deinit(allocator);
    self.captures.deinit(allocator);
}

pub fn contains(self: Self, symbol: ir.SymbolId) bool {
    return std.mem.indexOfScalar(ir.SymbolId, self.nonnull.items, symbol) != null;
}

pub fn containsValue(self: Self, values: ir.ExpressionTable, id: ir.ExprId) bool {
    const value = values.get(id).value;

    if (value == .reference) return self.contains(value.reference);

    for (self.projections.items) |projection| {
        if (@import("refinement/path.zig").same(values, id, projection)) return true;
    }

    return false;
}

pub fn addValue(self: *Self, allocator: std.mem.Allocator, values: ir.ExpressionTable, id: ir.ExprId) std.mem.Allocator.Error!void {
    const value = values.get(id).value;

    if (value == .reference) return self.add(allocator, value.reference);
    if (!@import("refinement/path.zig").same(values, id, id) or self.containsValue(values, id)) return;
    try self.projections.append(allocator, id);
}

pub fn bind(self: *Self, allocator: std.mem.Allocator, value: ir.ExpressionRow, symbols: []const ?ir.SymbolId) std.mem.Allocator.Error!void {
    if (value.value != .capture or symbols.len != 2) return;

    const err = symbols[0] orelse return;
    const result = symbols[1] orelse return;

    try self.captures.append(allocator, .{ .err = err, .result = result });
}

pub fn scope(self: *Self, allocator: std.mem.Allocator, values: ir.ExpressionTable, bindings: @FieldType(ir.ScopeRow, "bindings")) std.mem.Allocator.Error!void {
    for (0..bindings.len) |index| {
        const binding = bindings.at(index);
        const symbol = binding.symbol orelse continue;
        const value = values.at(@backingInt(binding.value));

        if (value.value != .capture) continue;

        var symbols = [_]?ir.SymbolId{ null, null };

        for (index + 1..bindings.len) |position| {
            const projection = bindings.at(position);
            const field = values.at(@backingInt(projection.value)).value;

            if (field != .tuple_field or field.tuple_field.index >= 2) continue;

            const target = values.at(@backingInt(field.tuple_field.target)).value;

            if (target == .reference and target.reference == symbol) symbols[field.tuple_field.index] = projection.symbol;
        }

        try self.bind(allocator, value, &symbols);
    }
}

pub fn assume(self: *Self, allocator: std.mem.Allocator, values: ir.ExpressionTable, condition: ir.ExprId, truth: bool) std.mem.Allocator.Error!void {
    const value = values.at(@backingInt(condition)).value;

    if (value == .unary and value.unary.operator == .not) return self.assume(allocator, values, value.unary.operand, !truth);
    if (value != .binary) return;

    const binary = value.binary;

    if ((binary.operator == .logical_and and truth) or (binary.operator == .logical_or and !truth)) {
        try self.assume(allocator, values, binary.left, truth);
        try self.assume(allocator, values, binary.right, truth);

        return;
    }

    if (binary.operator != .equal and binary.operator != .not_equal) return;

    const left = values.at(@backingInt(binary.left)).value;
    const right = values.at(@backingInt(binary.right)).value;
    const id = if (right == .none) binary.left else if (left == .none) binary.right else return;
    const selected = values.get(id).value;
    const present = if (binary.operator == .not_equal) truth else !truth;

    if (present) {
        try self.addValue(allocator, values, id);
    } else if (selected == .reference) {
        for (self.captures.items) |pair| {
            if (pair.err == selected.reference) try self.add(allocator, pair.result);
        }
    }
}

fn add(self: *Self, allocator: std.mem.Allocator, symbol: ir.SymbolId) std.mem.Allocator.Error!void {
    if (!self.contains(symbol)) try self.nonnull.append(allocator, symbol);
}
