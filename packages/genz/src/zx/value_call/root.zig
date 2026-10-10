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

    if (self.buffer_calls.contains(id)) {
        if (!self.buffer_pointer) return @import("../buffer_call/root.zig").invocation(self, id);

        const result = try @import("../buffer_call/pointer.zig").invocation(self, id);

        return if (self.program.typeOf(self.program.expression(id).type_id) == .list) result else self.builder.expression(.{ .dereference = result });
    }

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

pub fn invocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), buffers: ?*const node.Expression) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, buffers, false, .layout);

    return aggregate.finish(self, &body, result);
}

pub fn borrowInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!*const node.Expression {
    return lowerInvocation(self, body, value, null, true, .layout);
}

pub fn pointerInvocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, null, false, .pointer);

    return aggregate.finish(self, &body, result);
}

fn lowerInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), buffers: ?*const node.Expression, borrowed: bool, result_mode: @import("../state_value/conversion.zig").Mode) Lower.Error!*const node.Expression {
    const function = self.program.functions.at(@backingInt(value.function));
    const can_stack = !containsDescendant(self.program, function.output_type, function.input_type);

    var argument = if (result_mode != .pointer and !self.state_active and can_stack and self.program.expression(value.argument).value == .object and !self.cache.contains(value.argument)) temporary: {
        if (borrowed or !analysis.sharesAggregate(self.program, function.input_type, function.output_type)) break :temporary try @import("argument.zig").borrow(self, body, value.argument);

        const layout = try aggregate.bind(self, body, try aggregate.objectValue(self, value.argument));

        break :temporary try self.builder.expression(.{ .address_of = layout });
    } else try self.expr(value.argument);

    const transfer = @import("../buffer_call/transfer/root.zig");
    const selected = if (buffers == null) try transfer.select(self, value) else null;
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

    const selected_buffers = if (buffers) |ready| ready else if (selected) |slots| try transfer.prepare(self, body, value, &argument, slots) else null;
    const callee = try self.requestFunction(value.function, if (selected_buffers != null) .buffered else .value);
    const arguments = try self.allocator.alloc(*const node.Expression, if (selected_buffers != null) 3 else 2);
    arguments[0] = try self.builder.identifier("allocator");
    arguments[1] = argument;

    if (selected_buffers) |context| arguments[2] = context;

    var result = try self.call(callee, arguments, true);

    if (borrowed) {
        result = try aggregate.bind(self, body, result);

        if (state_callee) return @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, .borrow);

        return self.builder.expression(.{ .address_of = result });
    }

    if (state_callee and !self.state_active) {
        result = try aggregate.bind(self, body, result);
        result = try @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, result_mode);
    } else if (!state_callee and result_mode == .pointer) {
        result = try aggregate.bind(self, body, result);
        result = try self.construct(function.output_type, result);
    }

    return result;
}
