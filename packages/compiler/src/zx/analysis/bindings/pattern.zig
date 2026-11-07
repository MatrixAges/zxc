const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const syntax = zx.syntax.borrow;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");
const Scope = @import("../iteration/block.zig");

pub fn statements(analyzer: *Analyzer, target: *std.ArrayList(ir.Statement), pattern: anytype, value: ir.ExprId, scope_start: usize) zx.Error!void {
    var sink = Statements{ .analyzer = analyzer, .target = target, .scope_start = scope_start };

    try lower(&sink, pattern, value);
}

pub fn scope(owner: *Scope, pattern: anytype, value: ir.ExprId) zx.Error!void {
    var sink = Scoped{ .analyzer = owner.analyzer, .owner = owner };

    try lower(&sink, pattern, value);
}

pub fn flat(pattern: anytype) bool {
    if (syntax.bindingKind(pattern) != .sequence) return false;

    for (0..syntax.bindingCount(pattern)) |index| {
        if (syntax.bindingChild(pattern, index)) |child| {
            if (syntax.bindingKind(child) != .name) return false;
        }
    }

    return true;
}

fn lower(sink: anytype, pattern: anytype, value: ir.ExprId) zx.Error!void {
    const analyzer = sink.analyzer;
    const kind = syntax.bindingKind(pattern);

    if (kind == .name) {
        const name = syntax.bindingName(pattern);

        if (!std.mem.eql(u8, name.text, "_")) _ = try sink.bind(name, value, false);

        return;
    }

    const type_id = analyzer.node(value).type_id;
    const target = analyzer.types.get(type_id);
    const count = syntax.bindingCount(pattern);

    if (kind == .sequence) {
        if (target != .list and target != .tuple and type_id != Types.scalarId(.string)) return analyzer.reporter.fail(.type_mismatch, pattern.span, "sequence binding requires a list, tuple or string");
        if (target == .tuple and count > target.tuple.len) return analyzer.reporter.fail(.type_mismatch, pattern.span, "tuple binding contains more positions than the tuple");
    } else if (target != .object and target != .list and type_id != Types.scalarId(.string)) {
        return analyzer.reporter.fail(.type_mismatch, pattern.span, "object binding requires an object or existing named members");
    }

    var saved = value;

    if (!reusable(analyzer, value)) {
        const symbol = try sink.bind(.{ .text = "destructure_value", .span = pattern.span }, value, true);

        saved = try analyzer.append(.{ .span = pattern.span, .type_id = type_id, .value = .{ .reference = symbol } });
    }

    for (0..count) |index| {
        const child = syntax.bindingChild(pattern, index) orelse continue;

        const selected = if (kind == .object)
            try field(analyzer, saved, syntax.bindingKey(pattern, index), child.span)

        else if (target == .tuple)
            try analyzer.append(.{ .span = child.span, .type_id = target.tuple.at(index), .value = .{ .tuple_field = .{ .target = saved, .index = @intCast(index) } } })
        else selected: {
            const position = try analyzer.append(.{ .span = child.span, .type_id = Types.scalarId(.u64), .value = .{ .integer = index } });

            break :selected try analyzer.append(.{ .span = child.span, .type_id = if (target == .list) target.list else Types.scalarId(.u8), .value = .{ .index = .{ .target = saved, .index = position } } });
        };

        try lower(sink, child, selected);
    }
}

fn field(analyzer: *Analyzer, value: ir.ExprId, name: zx.ast.Name, span: zx.Span) zx.Error!ir.ExprId {
    const type_id = analyzer.node(value).type_id;
    const target = analyzer.types.get(type_id);

    if ((target == .list or type_id == Types.scalarId(.string)) and std.mem.eql(u8, name.text, "length")) return analyzer.append(.{ .span = span, .type_id = Types.scalarId(.u64), .value = .{ .length = value } });
    if (target != .object) return analyzer.reporter.fail(.type_mismatch, name.span, "field access requires an object");

    for (0..target.object.len) |index| {
        const item = target.object.at(index);

        if (!std.mem.eql(u8, item.name, name.text)) continue;

        const selected = try analyzer.append(.{ .span = span, .type_id = item.type_id, .value = .{ .field = .{ .target = value, .index = @intCast(index) } } });

        return @import("../refinement.zig").project(analyzer, selected);
    }

    return analyzer.reporter.fail(.name, name.span, "unknown object field");
}

fn reusable(analyzer: *Analyzer, source: ir.ExprId) bool {
    var value = source;

    while (true) switch (analyzer.node(value).value) {
        .reference => return true,
        .field, .tuple_field => |item| value = item.target,
        .optional_value => |child| value = child,
        else => return false,
    };
}

const Statements = struct {
    analyzer: *Analyzer,
    target: *std.ArrayList(ir.Statement),
    scope_start: usize,
    fn bind(self: *@This(), name: zx.ast.Name, value: ir.ExprId, temporary: bool) zx.Error!ir.SymbolId {
        const analyzer = self.analyzer;
        const type_id = analyzer.node(value).type_id;

        if (!temporary) try @import("../statements.zig").bindingName(analyzer, name);
        if (type_id == Types.scalarId(.void)) return analyzer.reporter.fail(.type_mismatch, name.span, "void results cannot be bound to a value");

        const symbol = try analyzer.bind(name, type_id, if (temporary) analyzer.active.items.len else self.scope_start);

        if (temporary) _ = analyzer.active.pop();
        if (type_id == Types.scalarId(.bool)) try analyzer.refinement.alias(analyzer.allocator, analyzer.nodes.view(), symbol, value);
        try self.target.append(analyzer.allocator, .{ .constant = .{ .symbol = symbol, .value = value } });

        return symbol;
    }
};

const Scoped = struct {
    analyzer: *Analyzer,
    owner: *Scope,
    fn bind(self: *@This(), name: zx.ast.Name, value: ir.ExprId, temporary: bool) zx.Error!ir.SymbolId {
        if (!temporary) try self.owner.bindingName(name);

        const symbol = try self.owner.bind(name, value, if (temporary) self.analyzer.active.items.len else self.owner.scope_start);

        if (temporary) _ = self.analyzer.active.pop();

        return symbol;
    }
};
