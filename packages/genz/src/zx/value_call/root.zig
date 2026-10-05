const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
pub const functions = @import("analysis.zig").functions;
pub const containsDescendant = @import("analysis.zig").containsDescendant;

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    if (self.cache.contains(id)) return dereference(self, id);

    return switch (self.program.expression(id).value) {
        .object => aggregate.objectValue(self, id),
        .conditional => |value| self.builder.expression(.{ .conditional = .{
            .condition = try self.expr(value.condition),
            .yes = try expression(self, value.yes),
            .no = try expression(self, value.no),
        } }),
        .call => |value| if (self.value_functions[@intFromEnum(value.function)]) invocation(self, value) else dereference(self, id),
        else => dereference(self, id),
    };
}

fn dereference(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    return self.builder.expression(.{ .dereference = try self.expr(id) });
}

fn invocation(self: *Lower, value: @FieldType(@FieldType(ir.Expression, "value"), "call")) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const function = self.program.functions[@intFromEnum(value.function)];
    const can_stack = !containsDescendant(self.program, function.output_type, function.input_type);

    const argument = if (can_stack and self.program.expression(value.argument).value == .object and !self.cache.contains(value.argument)) temporary: {
        const layout = try aggregate.bind(self, &body, try aggregate.objectValue(self, value.argument));

        break :temporary try self.builder.expression(.{ .address_of = layout });
    } else try self.expr(value.argument);

    const callee = if (self.function_modules) |modules|
        try self.field(try self.builtin(.import, &.{try self.builder.string(modules[@intFromEnum(value.function)])}), "callValue")

    else
        try self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}_value", .{@intFromEnum(value.function)}));

    const result = try self.call(callee, &.{ try self.builder.identifier("allocator"), argument }, true);

    return aggregate.finish(self, &body, result);
}
