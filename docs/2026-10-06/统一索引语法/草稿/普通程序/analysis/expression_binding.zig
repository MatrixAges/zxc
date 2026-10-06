const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Analyzer = @import("analyzer.zig");

pub fn bind(self: *Analyzer, name: zx.ast.Name, type_id: zx.ir.TypeId) zx.Error!void {
    if (type_id == @import("types.zig").scalarId(.void)) return self.reporter.fail(.type_mismatch, name.span, "expression bindings cannot have type void");
    try validateName(self, name);

    const id: zx.ir.SymbolId = @fromBackingInt(@intCast(self.symbols.items.len));

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = type_id, .span = name.span });
    try self.active.append(self.allocator, id);
    try self.expression_bindings.append(self.allocator, id);
}

pub fn lookup(self: *const Analyzer, expression: anytype) ?zx.ir.SymbolId {
    var root = expression;

    while (syntax.value(root) == .field) root = syntax.value(root).field.target;
    if (syntax.value(root) != .identifier) return null;

    for (self.expression_bindings.items) |id| {
        const symbol = self.symbols.items[@backingInt(id)];

        if (self.lookup(syntax.value(root).identifier.text)) |local| {
            if (local != id) continue;
        }

        if (matches(expression, symbol.name)) return id;
    }

    return null;
}

fn matches(expression: anytype, path: []const u8) bool {
    if (syntax.value(expression) == .identifier) return std.mem.eql(u8, syntax.value(expression).identifier.text, path);
    if (syntax.value(expression) != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, path, '.') orelse return false;

    return std.mem.eql(u8, syntax.value(expression).field.name.text, path[separator + 1 ..]) and matches(syntax.value(expression).field.target, path[0..separator]);
}

pub fn bindUnit(self: *Analyzer, name: zx.ast.Name) zx.Error!void {
    try validateName(self, name);
    try self.expression_units.append(self.allocator, try self.allocator.dupe(u8, name.text));
}

pub fn unit(self: *const Analyzer, expression: anytype) bool {
    var root = expression;

    while (syntax.value(root) == .field) root = syntax.value(root).field.target;
    if (syntax.value(root) != .identifier or self.lookup(syntax.value(root).identifier.text) != null) return false;
    for (self.expression_units.items) |name| if (matches(expression, name)) return true;

    return false;
}

fn validateName(self: *Analyzer, name: zx.ast.Name) zx.Error!void {
    if (!@import("binding_path.zig").valid(name.text)) return self.reporter.fail(.name, name.span, "expression bindings require identifier paths");

    for (self.symbols.items) |symbol| {
        if (@import("binding_path.zig").overlaps(symbol.name, name.text)) return self.reporter.fail(.name, name.span, "expression binding paths must not overlap");
    }

    for (self.expression_units.items) |unit_name| {
        if (@import("binding_path.zig").overlaps(unit_name, name.text)) return self.reporter.fail(.name, name.span, "expression binding paths must not overlap");
    }
}
