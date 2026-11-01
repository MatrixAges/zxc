const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Builder = @import("collections/builder.zig");
const selection = @import("../frontend/object_selection.zig");

pub fn analyze(self: *Analyzer, expression: anytype, source: ir.ExprId) zx.Error!ir.ExprId {
    const keys = try selection.keys(self.allocator, expression, self.reporter);
    const fields = self.types.get(self.node(source).type_id).object;
    const omit = std.mem.eql(u8, syntax.value(syntax.value(expression).call.callee).field.name.text, "omit");
    var indices: std.ArrayList(u32) = .empty;

    for (keys) |key| {
        const found = for (0..fields.len) |index| {
            if (std.mem.eql(u8, fields.at(index).name, key)) break true;
        } else false;

        if (!found) return self.reporter.fail(.name, expression.span, "unknown object selection field");
    }

    for (0..fields.len) |index| {
        const requested = for (keys) |key| {
            if (std.mem.eql(u8, fields.at(index).name, key)) break true;
        } else false;

        if (requested != omit) try indices.append(self.allocator, @intCast(index));
    }

    if (indices.items.len == fields.len) return source;

    const builder = Builder{ .analyzer = self, .span = expression.span };
    const reusable = reusableSource(self, source);
    const symbol = if (reusable) null else try builder.symbol("$object_selection", self.node(source).type_id);
    const reference = if (symbol) |id| try builder.reference(id) else source;
    const values = try self.allocator.alloc(Builder.Field, indices.items.len);

    for (indices.items, values) |index, *field| {
        const original = fields.at(index);

        field.* = .{ .name = original.name, .value = try builder.expression(original.type_id, .{ .field = .{ .target = reference, .index = index } }) };
    }

    const result = try builder.object(values);
    const type_id = self.node(result).type_id;

    if (reusable) return result;

    const bindings = try self.allocator.alloc(ir.ScopeBinding, 1);

    const borrow = switch (self.node(source).value) {
        .reference, .field, .tuple_field, .index, .optional_value => true,
        else => false,
    };

    bindings[0] = .{ .symbol = symbol, .value = source, .borrow = borrow };

    return builder.expression(type_id, .{ .scope = .{ .bindings = bindings, .result = result } });
}

fn reusableSource(self: *const Analyzer, source: ir.ExprId) bool {
    return switch (self.node(source).value) {
        .reference => true,
        .field, .tuple_field => |field| reusableSource(self, field.target),
        .optional_value => |value| reusableSource(self, value),
        else => false,
    };
}
