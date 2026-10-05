const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!*const node.Expression {
    if (try @import("append_reduce/root.zig").lower(self, value)) |result| return result;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(value.target));
    const result_type = self.types[@intFromEnum(self.program.expression(id).type_id)];
    const callback = try self.expr(value.body);
    const element = value.parameters[value.parameters.len - 1];
    const capture = self.names[@intFromEnum(element)];
    var loop: std.ArrayList(node.Statement) = .empty;
    var result: *const node.Expression = undefined;

    if (value.kind == .reduce) {
        const accumulator = self.names[@intFromEnum(value.parameters[0])];

        try body.append(self.allocator, .{ .variable = .{ .name = accumulator, .type_expr = result_type, .value = try self.expr(value.initial.?) } });
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(accumulator), .value = callback } });

        result = try self.builder.identifier(accumulator);
    } else {
        const name = try self.fresh("items");
        const list_type = self.program.typeOf(self.program.expression(id).type_id);
        const buffer_type = try self.call(try self.field(try self.builder.identifier("std"), "ArrayList"), &.{self.types[@intFromEnum(list_type.list)]}, false);

        try body.append(self.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try self.builder.expression(.{ .enum_literal = "empty" }) } });

        const append_value = if (value.kind == .filter) try self.builder.identifier(capture) else callback;
        const append = node.Statement{ .expression = try self.call(try self.field(try self.builder.identifier(name), "append"), &.{ try self.builder.identifier("allocator"), append_value }, true) };

        if (value.kind == .filter) {
            self.used[@intFromEnum(element)] = true;

            try loop.append(self.allocator, .{ .branch = .{ .condition = callback, .yes = try self.allocator.dupe(node.Statement, &.{append}), .no = &.{} } });
        } else try loop.append(self.allocator, append);

        result = try self.call(try self.field(try self.builder.identifier(name), "toOwnedSlice"), &.{try self.builder.identifier("allocator")}, true);
    }

    try body.append(self.allocator, .{ .for_loop = .{ .iterable = source, .capture = if (self.used[@intFromEnum(element)]) capture else "_", .body = try loop.toOwnedSlice(self.allocator) } });

    return aggregate.finish(self, &body, result);
}
