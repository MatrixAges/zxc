const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");
const numbers = @import("../numbers.zig");
const selection = @import("../switch.zig");
const Self = @This();

analyzer: *Analyzer,
state: ir.SymbolId,
scope_start: usize,
bindings: std.ArrayList(ir.ScopeBinding) = .empty,
pub fn analyze(analyzer: *Analyzer, source: anytype, parameter: ir.SymbolId) zx.Error!ir.ExprId {
    const start = analyzer.active.items.len;
    const facts = analyzer.refinement.mark();

    defer analyzer.active.shrinkRetainingCapacity(start);
    defer analyzer.refinement.restore(facts);

    var self = Self{ .analyzer = analyzer, .state = parameter, .scope_start = start };

    for (0..source.statements.len) |index| try self.statement(syntax.item(source.statements, index));

    const result = try self.reference(self.state, source.span);

    return analyzer.append(.{ .span = source.span, .type_id = analyzer.node(result).type_id, .value = .{ .scope = .{
        .bindings = try self.bindings.toOwnedSlice(analyzer.allocator),
        .result = result,
    } } });
}

fn statement(self: *Self, source: anytype) zx.Error!void {
    const analyzer = self.analyzer;

    switch (source.value) {
        .evaluate => |value| try self.bindings.append(analyzer.allocator, .{ .symbol = null, .value = try analyzer.expression(value, Types.scalarId(.void)) }),
        .constant => |binding| {
            try self.bindingName(binding.name);

            const annotation = if (binding.annotation) |value| try analyzer.resolveType(value) else null;
            const value = try analyzer.expression(binding.value, annotation);
            _ = try self.bind(binding.name, value, self.scope_start);
        },
        .destructure => |binding| {
            const value = try analyzer.expression(binding.value, null);
            const target = analyzer.types.get(analyzer.node(value).type_id);

            if (target != .tuple or target.tuple.len != binding.names.len) return analyzer.reporter.fail(.type_mismatch, source.span, "tuple destructuring must match every result slot");

            const saved = try self.temporary(value);
            const symbols = try analyzer.allocator.alloc(?ir.SymbolId, binding.names.len);

            @memset(symbols, null);

            for (target.tuple, 0..) |type_id, index| {
                const name = syntax.item(binding.names, index);

                if (std.mem.eql(u8, name.text, "_")) continue;
                try self.bindingName(name);

                const item = try analyzer.append(.{ .span = name.span, .type_id = type_id, .value = .{ .tuple_field = .{ .target = saved, .index = @intCast(index) } } });
                symbols[index] = try self.bind(name, item, self.scope_start);
            }

            try analyzer.refinement.bind(analyzer.allocator, analyzer.node(value), symbols);
        },
        .state_update => |update| {
            const location = try analyzer.expression(update.target, null);

            if (update.operator == null and analyzer.node(location).value == .reference and analyzer.node(location).value.reference == self.state) {
                const value = try analyzer.expression(update.value, analyzer.node(location).type_id);

                try self.advance(value, source.span);

                return;
            }

            const place = try @import("update.zig").prepare(self, location);
            const target = place.value;
            const type_id = analyzer.node(target).type_id;
            const right = try analyzer.expression(update.value, type_id);
            var value = try self.temporary(right);

            if (update.operator) |operator| {
                if (!numbers.isInteger(type_id) and !numbers.isFloat(type_id)) return analyzer.reporter.fail(.type_mismatch, source.span, "compound updates require numeric state values");

                value = try analyzer.append(.{ .span = source.span, .type_id = type_id, .value = .{ .binary = .{ .operator = operator, .left = target, .right = value } } });
            }

            try self.advance(try @import("update.zig").replace(analyzer, place, value), source.span);
        },
        .branch => |branch| {
            const condition = try analyzer.expression(branch.condition, Types.scalarId(.bool));
            const facts = analyzer.refinement.mark();

            try analyzer.refinement.assume(analyzer.allocator, analyzer.nodes.items, condition, true);

            const yes = try analyze(analyzer, branch.yes, self.state);

            analyzer.refinement.restore(facts);

            try analyzer.refinement.assume(analyzer.allocator, analyzer.nodes.items, condition, false);

            const no = if (branch.no) |body| try analyze(analyzer, body, self.state) else try self.reference(self.state, source.span);

            analyzer.refinement.restore(facts);

            const value = try analyzer.append(.{ .span = source.span, .type_id = analyzer.node(yes).type_id, .value = .{ .conditional = .{ .condition = condition, .yes = yes, .no = no } } });

            try self.advance(value, source.span);
        },
        .switch_stmt => |switch_value| try self.switchStatement(switch_value, source.span),
        .result => return analyzer.reporter.fail(.return_path, source.span, "loop steps yield state at the block end; return is not allowed"),
        .store_set => return analyzer.reporter.fail(.capability, source.span, "Store writes are not allowed in loop callbacks"),
    }
}

fn switchStatement(self: *Self, source: anytype, span: zx.Span) zx.Error!void {
    const analyzer = self.analyzer;
    const subject = try analyzer.expression(source.subject, null);
    const type_id = analyzer.node(subject).type_id;
    const target = analyzer.types.get(type_id);

    if (target != .enumeration and target != .error_set and !numbers.isInteger(type_id) and type_id != Types.scalarId(.bool) and type_id != Types.scalarId(.string)) return analyzer.reporter.fail(.type_mismatch, source.subject.span, "switch requires an enum, finite error, integer, bool or string");

    var arms: std.ArrayList(ir.MatchArm) = .empty;
    var fallback: ?ir.ExprId = null;

    for (0..source.cases.len) |index| {
        const case = syntax.item(source.cases, index);

        if (case.value) |label_source| {
            const label = try analyzer.expression(label_source, type_id);

            if (!selection.isConstant(analyzer.node(label).value)) return analyzer.reporter.fail(.type_mismatch, label_source.span, "case labels must be literals, enum members or finite errors");
            for (arms.items) |arm| if (selection.equal(analyzer.node(arm.condition).value, analyzer.node(label).value)) return analyzer.reporter.fail(.name, label_source.span, "duplicate switch case");
            try arms.append(analyzer.allocator, .{ .condition = label, .result = try analyze(analyzer, case.body, self.state) });
        } else {
            if (fallback != null) return analyzer.reporter.fail(.name, case.span, "duplicate switch default");

            fallback = try analyze(analyzer, case.body, self.state);
        }
    }

    const result = try analyzer.append(.{ .span = span, .type_id = analyzer.symbols.items[@backingInt(self.state)].type_id, .value = .{ .match_expr = .{
        .subject = subject,
        .arms = try arms.toOwnedSlice(analyzer.allocator),
        .fallback = fallback orelse try self.reference(self.state, span),
    } } });

    try self.advance(result, span);
}

fn bindingName(self: *Self, name: zx.ast.Name) zx.Error!void {
    try @import("../statements.zig").bindingName(self.analyzer, name);
    if (std.mem.eql(u8, name.text, self.analyzer.symbols.items[@backingInt(self.state)].name)) return self.analyzer.reporter.fail(.name, name.span, "the loop state parameter cannot be redeclared");
}

fn bind(self: *Self, name: zx.ast.Name, value: ir.ExprId, scope_start: usize) zx.Error!ir.SymbolId {
    const analyzer = self.analyzer;
    const type_id = analyzer.node(value).type_id;

    if (type_id == Types.scalarId(.void)) return analyzer.reporter.fail(.type_mismatch, name.span, "void results cannot be bound to a value");

    const symbol = try analyzer.bind(name, type_id, scope_start);

    const borrow = switch (analyzer.node(value).value) {
        .reference, .field, .tuple_field, .index, .optional_value => true,
        else => false,
    };

    try self.bindings.append(analyzer.allocator, .{ .symbol = symbol, .value = value, .borrow = borrow });

    return symbol;
}

fn reference(self: *Self, symbol: ir.SymbolId, span: zx.Span) zx.Error!ir.ExprId {
    return self.analyzer.append(.{ .span = span, .type_id = self.analyzer.symbols.items[@backingInt(symbol)].type_id, .value = .{ .reference = symbol } });
}

pub fn temporary(self: *Self, value: ir.ExprId) zx.Error!ir.ExprId {
    const span = self.analyzer.node(value).span;
    const symbol = try self.bind(.{ .text = "iteration_value", .span = span }, value, self.analyzer.active.items.len);

    _ = self.analyzer.active.pop();

    return self.reference(symbol, span);
}

fn advance(self: *Self, value: ir.ExprId, span: zx.Span) zx.Error!void {
    const name = self.analyzer.symbols.items[@backingInt(self.state)].name;

    self.state = try self.bind(.{ .text = name, .span = span }, value, self.analyzer.active.items.len);
}
