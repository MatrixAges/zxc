const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!node.ExpressionId {
    const state_symbols = try @import("state_value/locals.zig").parameters(self, value.parameters);

    defer for (state_symbols) |symbol| {
        _ = self.state_symbols.remove(symbol);
    };

    if (value.kind == .every or value.kind == .some) return @import("predicates.zig").lower(self, value);
    if (try @import("simd/root.zig").lower(self, id, value)) |result| return result;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(value.target));
    const result_type = try self.typeExpr(self.program.expression(id).type_id);
    const callback = try self.expr(value.body);
    const element = value.parameters[if (value.kind == .reduce) @as(usize, 1) else 0];
    const capture = self.names[@backingInt(element)];
    var loop: std.ArrayList(node.Statement) = .empty;
    var result: node.ExpressionId = undefined;
    var index_capture: ?[]const u8 = null;

    try @import("transform/context.zig").bind(self, &body, value);

    if (value.kind == .reduce) {
        const accumulator = self.names[@backingInt(value.parameters[0])];

        try body.append(self.allocator, .{ .variable = .{ .name = accumulator, .type_expr = result_type, .value = try self.expr(value.initial.?) } });
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(accumulator), .value = callback } });

        result = try self.builder.identifier(accumulator);
    } else if (value.kind == .map) {
        const list_type = self.program.typeOf(self.program.expression(id).type_id);
        const allocation = try self.call(try self.field(try self.builder.identifier("allocator"), "alloc"), &.{ try self.typeExpr(list_type.list), try self.field(source, "len") }, true);
        result = try aggregate.bind(self, &body, allocation);
        index_capture = try self.fresh("index");

        try loop.append(self.allocator, .{ .assignment = .{
            .target = try self.builder.expression(.{ .index = .{ .target = result, .index = try self.builder.identifier(index_capture.?) } }),
            .value = callback,
        } });
    } else {
        const name = try self.fresh("items");
        const list_type = self.program.typeOf(self.program.expression(id).type_id);
        const buffer_type = try self.call(try self.field(try self.builder.identifier("std"), "ArrayList"), &.{try self.typeExpr(list_type.list)}, false);

        try body.append(self.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try self.builder.expression(.{ .enum_literal = "empty" }) } });

        const append_value = try self.builder.identifier(capture);
        const append = node.Statement{ .expression = try self.call(try self.field(try self.builder.identifier(name), "append"), &.{ try self.builder.identifier("allocator"), append_value }, true) };

        self.used[@backingInt(element)] = true;

        try loop.append(self.allocator, .{ .branch = .{ .condition = callback, .yes = try self.builder.statements(&.{append}), .no = .{} } });

        result = try self.call(try self.field(try self.builder.identifier(name), "toOwnedSlice"), &.{try self.builder.identifier("allocator")}, true);
    }

    try body.append(self.allocator, .{ .for_loop = .{ .iterable = source, .capture = if (self.used[@backingInt(element)]) capture else "_", .body = try self.builder.statements(loop.items), .index_capture = index_capture } });

    return aggregate.finish(self, &body, result);
}
