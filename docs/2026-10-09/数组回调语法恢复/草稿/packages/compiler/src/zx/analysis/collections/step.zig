const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Types = @import("../types.zig");
const Builder = @import("builder.zig");
const Callback = @import("callback.zig").Result;

pub fn build(builder: Builder, kind: @FieldType(ir.Transform, "kind"), parameter: ir.SymbolId, callback: Callback) zx.Error!ir.ExprId {
    const analyzer = builder.analyzer;
    const current = try builder.reference(parameter);
    const source = try builder.field(current, "source");
    const index = try builder.field(current, "index");
    const previous = try builder.field(current, "result");
    const element_type = analyzer.types.get(analyzer.node(source).type_id).list;
    const element = try builder.expression(element_type, .{ .index = .{ .target = source, .index = index } });
    const item_symbol = try builder.symbol("$collection_item", element_type);
    const item = try builder.reference(item_symbol);
    var bindings: std.ArrayList(ir.ScopeBinding) = .empty;

    try bindings.append(analyzer.allocator, .{ .symbol = item_symbol, .value = element, .borrow = true });

    if (callback.captures.len != 0) {
        const context = try builder.field(current, "captures");

        for (callback.captures, 0..) |capture, position| {
            const type_id = analyzer.symbols.at(@backingInt(capture.target)).type_id;
            const value = try builder.expression(type_id, .{ .tuple_field = .{ .target = context, .index = @intCast(position) } });

            try bindings.append(analyzer.allocator, .{ .symbol = capture.target, .value = value, .borrow = true });
        }
    }

    const parameters: []const ir.ExprId = if (kind == .reduce) &.{ previous, item, index, source } else &.{ item, index, source };

    for (callback.parameters, 0..) |symbol, position| try bindings.append(analyzer.allocator, .{ .symbol = symbol, .value = parameters[position], .borrow = true });

    const computed = try builder.symbol("$collection_value", analyzer.node(callback.body).type_id);

    try bindings.append(analyzer.allocator, .{ .symbol = computed, .value = callback.body });

    const value = try builder.reference(computed);

    const result = switch (kind) {
        .map => try builder.push(previous, value),
        .filter => try builder.expression(analyzer.node(previous).type_id, .{ .conditional = .{ .condition = value, .yes = try builder.push(previous, item), .no = previous } }),
        .reduce, .every, .some => value,
    };

    const next_index = try builder.expression(Types.scalarId(.u64), .{ .binary = .{ .operator = .add, .left = index, .right = try builder.integer(1) } });
    var fields: std.ArrayList(Builder.Field) = .empty;

    try fields.appendSlice(analyzer.allocator, &.{ .{ .name = "source", .value = source }, .{ .name = "index", .value = next_index }, .{ .name = "result", .value = result } });
    if (callback.captures.len != 0) try fields.append(analyzer.allocator, .{ .name = "captures", .value = try builder.field(current, "captures") });

    const next = try builder.object(fields.items);

    return builder.expression(analyzer.node(current).type_id, .{ .scope = .{ .bindings = try bindings.toOwnedSlice(analyzer.allocator), .result = next } });
}
