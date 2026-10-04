const std = @import("std");
const zx = @import("zx");
const Analyzer = @import("analyzer.zig");

pub fn bind(self: *Analyzer, name: zx.ast.Name, type_id: zx.ir.TypeId) zx.Error!void {
    if (type_id == @import("types.zig").scalarId(.void)) return self.reporter.fail(.type_mismatch, name.span, "expression bindings cannot have type void");

    var parts = std.mem.splitScalar(u8, name.text, '.');

    while (parts.next()) |part| {
        if (part.len == 0 or zx.syntax.isKeyword(part) or (!std.ascii.isAlphabetic(part[0]) and part[0] != '_' and part[0] != '$')) return self.reporter.fail(.name, name.span, "expression bindings require identifier paths");

        for (part[1..]) |byte| {
            if (!std.ascii.isAlphanumeric(byte) and byte != '_') return self.reporter.fail(.name, name.span, "expression bindings require identifier paths");
        }
    }

    for (self.symbols.items) |symbol| {
        if (contains(symbol.name, name.text) or contains(name.text, symbol.name)) return self.reporter.fail(.name, name.span, "expression binding paths must not overlap");
    }

    const id: zx.ir.SymbolId = @enumFromInt(self.symbols.items.len);

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = type_id, .span = name.span });
    try self.active.append(self.allocator, id);
    try self.expression_bindings.append(self.allocator, id);
}

pub fn lookup(self: *const Analyzer, expression: *const zx.ast.Expression) ?zx.ir.SymbolId {
    var root = expression;

    while (root.value == .field) root = root.value.field.target;

    if (root.value != .identifier) return null;

    for (self.expression_bindings.items) |id| {
        const symbol = self.symbols.items[@intFromEnum(id)];

        if (self.lookup(root.value.identifier.text)) |local| {
            if (local != id) continue;
        }

        if (matches(expression, symbol.name)) return id;
    }

    return null;
}

fn matches(expression: *const zx.ast.Expression, path: []const u8) bool {
    if (expression.value == .identifier) return std.mem.eql(u8, expression.value.identifier.text, path);
    if (expression.value != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, path, '.') orelse return false;

    return std.mem.eql(u8, expression.value.field.name.text, path[separator + 1 ..]) and matches(expression.value.field.target, path[0..separator]);
}

fn contains(parent: []const u8, child: []const u8) bool {
    return std.mem.eql(u8, parent, child) or (child.len > parent.len and std.mem.startsWith(u8, child, parent) and child[parent.len] == '.');
}
