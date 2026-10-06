const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
pub const analysis = @import("analysis.zig");
pub const functions = analysis.functions;
pub const containsDescendant = analysis.containsDescendant;

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    if (self.state_active and self.state_plan.represented(self.program, self.program.expression(id).type_id)) return self.expr(id);
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
    const result = try lowerInvocation(self, &body, value, buffers, false);

    return aggregate.finish(self, &body, result);
}

pub fn borrowInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.Expression, "value"), "call")) Lower.Error!*const node.Expression {
    return lowerInvocation(self, body, value, null, true);
}

fn lowerInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.Expression, "value"), "call"), buffers: ?*const node.Expression, borrowed: bool) Lower.Error!*const node.Expression {
    const function = self.program.functions[@backingInt(value.function)];
    const can_stack = !containsDescendant(self.program, function.output_type, function.input_type);

    var argument = if (!self.state_active and can_stack and self.program.expression(value.argument).value == .object and !self.cache.contains(value.argument)) temporary: {
        if (borrowed or !analysis.sharesAggregate(self.program, function.input_type, function.output_type)) break :temporary try @import("argument.zig").borrow(self, body, value.argument);

        const layout = try aggregate.bind(self, body, try aggregate.objectValue(self, value.argument));

        break :temporary try self.builder.expression(.{ .address_of = layout });
    } else try self.expr(value.argument);

    const state_callee = self.state_plan.represented(self.program, function.output_type);
    const legacy = !borrowed and buffers == null and state_callee and !self.state_active and !self.allows_allocation and self.state_plan.nested(self.program, function.output_type);

    if (legacy) {
        const result = try self.call(try self.functionReference(value.function), &.{ try self.builder.identifier("allocator"), argument }, true);
        const output_type = self.program.typeOf(function.output_type);
        const output = if (output_type == .object or output_type == .tuple) try self.builder.expression(.{ .dereference = result }) else result;

        return output;
    }

    if (state_callee != self.state_active) {
        argument = try aggregate.bind(self, body, argument);
        argument = try @import("../state_value/conversion.zig").convert(self, body, function.input_type, argument, if (state_callee) .value else .borrow);
    }

    const callee = if (self.function_modules) |modules|
        try self.field(try self.builtin(.import, &.{try self.builder.string(modules[@backingInt(value.function)])}), if (buffers != null) "callBuffered" else "callValue")

    else
        try self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}_{s}", .{ @backingInt(value.function), if (buffers != null) "buffered" else "value" }));

    const arguments = try self.allocator.alloc(*const node.Expression, if (buffers != null) 3 else 2);

    arguments[0] = try self.builder.identifier("allocator");
    arguments[1] = argument;

    if (buffers) |context| arguments[2] = context;

    var result = try self.call(callee, arguments, true);

    if (borrowed) {
        result = try aggregate.bind(self, body, result);

        if (state_callee) return @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, .borrow);

        return self.builder.expression(.{ .address_of = result });
    }

    if (state_callee and !self.state_active) {
        result = try aggregate.bind(self, body, result);
        result = try @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, .layout);
    }

    return result;
}
