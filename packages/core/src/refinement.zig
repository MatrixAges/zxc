const std = @import("std");
const ir = @import("ir.zig");
const Self = @This();
const Pair = struct { err: ir.SymbolId, result: ir.SymbolId };

nonnull: std.ArrayList(ir.SymbolId) = .empty,
predicates: std.ArrayList(?ir.ExprId) = .empty,
visits: std.ArrayList(u64) = .empty,
epoch: u64 = 0,
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
    self.predicates.deinit(allocator);
    self.visits.deinit(allocator);
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

pub fn alias(self: *Self, allocator: std.mem.Allocator, symbol: ir.SymbolId, value: ir.ExprId) std.mem.Allocator.Error!void {
    const index = @backingInt(symbol);

    if (index >= self.predicates.items.len) {
        const previous = self.predicates.items.len;

        try self.predicates.resize(allocator, index + 1);

        @memset(self.predicates.items[previous..], null);
    }

    self.predicates.items[index] = value;
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
    self.epoch +%= 1;

    if (self.epoch == 0) {
        @memset(self.visits.items, 0);

        self.epoch = 1;
    }

    return self.assumeInner(allocator, values, condition, truth);
}

fn assumeInner(self: *Self, allocator: std.mem.Allocator, values: ir.ExpressionTable, condition: ir.ExprId, truth: bool) std.mem.Allocator.Error!void {
    var selected_condition = condition;

    while (true) {
        const node = values.at(@backingInt(selected_condition)).value;

        if (node != .reference or @backingInt(node.reference) >= self.predicates.items.len) break;

        const predicate = self.predicates.items[@backingInt(node.reference)] orelse break;
        const slot = @as(usize, @backingInt(node.reference)) * 2 + @intFromBool(truth);

        if (slot >= self.visits.items.len) {
            const previous = self.visits.items.len;

            try self.visits.resize(allocator, slot + 1);

            @memset(self.visits.items[previous..], 0);
        }

        if (self.visits.items[slot] == self.epoch) return;

        self.visits.items[slot] = self.epoch;
        selected_condition = predicate;
    }

    const value = values.at(@backingInt(selected_condition)).value;

    if (value == .scope) return self.assumeInner(allocator, values, value.scope.result, truth);
    if (value == .unary and value.unary.operator == .not) return self.assumeInner(allocator, values, value.unary.operand, !truth);
    if (value != .binary) return;

    const binary = value.binary;

    if ((binary.operator == .logical_and and truth) or (binary.operator == .logical_or and !truth)) {
        try self.assumeInner(allocator, values, binary.left, truth);
        try self.assumeInner(allocator, values, binary.right, truth);

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
