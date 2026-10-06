const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
pub const analysis = @import("analysis.zig");
pub const functions = analysis.functions;
pub const containsDescendant = analysis.containsDescendant;

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    if (self.cache.contains(id)) return dereference(self, id);
    if (self.buffer_calls.contains(id)) return @import("../buffer_call/root.zig").invocation(self, id);

    return switch (self.program.expression(id).value) {
        .capture => |child| @import("../capture.zig").lowerValue(self, self.program.expression(id).type_id, child),
        .object => aggregate.objectValue(self, id),
        .tuple => |items| aggregate.tupleValue(self, self.program.expression(id), items),
        .list_operation => |operation| @import("../collections.zig").lowerValue(self, self.program.expression(id).type_id, operation, self.layouts[@backingInt(self.program.expression(id).type_id)], self.collection_buffers.get(id)),
        .scope => |scope| @import("../scope.zig").lowerValue(self, scope),
        .iteration => |iteration| @import("../iteration.zig").lowerValue(self, id, iteration),
        .match_expr => |selection| @import("../match.zig").lowerValue(self, selection),
        .conditional => |value| self.builder.expression(.{ .conditional = .{
            .condition = try self.expr(value.condition),
            .yes = try expression(self, value.yes),
            .no = try expression(self, value.no),
        } }),
        .call => |value| if (self.value_functions[@backingInt(value.function)]) invocation(self, value, null) else dereference(self, id),
        else => dereference(self, id),
    };
}

fn dereference(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    return self.builder.expression(.{ .dereference = try self.expr(id) });
}

pub fn invocation(self: *Lower, value: @FieldType(@FieldType(ir.Expression, "value"), "call"), buffers: ?*const node.Expression) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const function = self.program.functions[@backingInt(value.function)];
    const can_stack = !containsDescendant(self.program, function.output_type, function.input_type);

    const argument = if (can_stack and self.program.expression(value.argument).value == .object and !self.cache.contains(value.argument)) temporary: {
        const layout = try aggregate.bind(self, &body, try aggregate.objectValue(self, value.argument));

        break :temporary try self.builder.expression(.{ .address_of = layout });
    } else try self.expr(value.argument);

    const callee = if (self.function_modules) |modules|
        try self.field(try self.builtin(.import, &.{try self.builder.string(modules[@backingInt(value.function)])}), if (buffers != null) "callBuffered" else "callValue")

    else
        try self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}_{s}", .{ @backingInt(value.function), if (buffers != null) "buffered" else "value" }));

    const arguments = try self.allocator.alloc(*const node.Expression, if (buffers != null) 3 else 2);

    arguments[0] = try self.builder.identifier("allocator");
    arguments[1] = argument;

    if (buffers) |context| arguments[2] = context;

    const result = try self.call(callee, arguments, true);

    return aggregate.finish(self, &body, result);
}
