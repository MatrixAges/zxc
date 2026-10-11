const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, id: ir.ExprId, iteration: ir.Iteration) Lower.Error!node.ExpressionId {
    return (try lowerMode(self, id, iteration, .reference, null)).?;
}

pub fn lowerValue(self: *Lower, id: ir.ExprId, iteration: ir.Iteration) Lower.Error!node.ExpressionId {
    return (try lowerMode(self, id, iteration, .value, null)).?;
}

pub fn discard(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const value = self.program.expression(id).value;

    if (value != .iteration) return self.expr(id);

    return (try lowerMode(self, id, value.iteration, .discard, null)).?;
}

pub fn consume(self: *Lower, id: ir.ExprId, consumer: @import("iteration_consumer.zig").Consumer) Lower.Error!?node.ExpressionId {
    return lowerMode(self, id, self.program.expression(id).value.iteration, .consume, consumer);
}

const Mode = enum { reference, value, discard, consume };

fn lowerMode(self: *Lower, id: ir.ExprId, iteration: ir.Iteration, mode: Mode, consumer: ?@import("iteration_consumer.zig").Consumer) Lower.Error!?node.ExpressionId {
    const projected_output = if (consumer) |selected| try @import("iteration_value/result.zig").candidate(self.allocator, self.program, selected) else false;

    var body: std.ArrayList(node.Statement) = .empty;
    var loop: std.ArrayList(node.Statement) = .empty;
    const name = try self.fresh("state");
    const state = try self.builder.identifier(name);
    const layout_analysis = @import("iteration_layout.zig");
    const pure = try layout_analysis.eligible(self.allocator, self.program, iteration, self.pure_functions);
    const local_calls = pure or try layout_analysis.eligible(self.allocator, self.program, iteration, self.local_functions);
    const selected_call = try forwarded(self, iteration);
    const type_id = self.program.expression(id).type_id;
    const deep = !self.state_active and (projected_output or mode == .discard) and pure and !layout_analysis.flat(self.program, type_id) and layout_analysis.represented(self.program, type_id) and try layout_analysis.deep(self.allocator, self.program, iteration, self.pure_functions);
    const selected_state = !deep and self.state_plan.represented(self.program, type_id) and (self.state_active or selected_call != null or local_calls);
    const layout = !deep and (selected_state or selected_call != null or ((local_calls or try layout_analysis.shallow(self.allocator, self.program, iteration)) and layout_analysis.aggregate(self.program, type_id)));
    const by_value = mode != .reference and layout;

    if (mode == .value and !layout) return try self.builder.expression(.{ .dereference = try lower(self, id, iteration) });
    if (mode == .consume and ((!layout and !deep) or selected_call != null)) return null;
    if (consumer) |selected| if (!deep and !@import("iteration_consumer.zig").projection(self.program, selected.result, selected.symbol)) return null;

    const local = layout or deep;
    var context = @import("iteration_value/root.zig"){ .lowering = self, .declarations = &body };
    const direct_initial = deep and try layout_analysis.initialValue(self.allocator, self.program, iteration.initial, self.pure_functions);

    const initial_expression = if (direct_initial) initial: {
        const previous = self.iteration_value;
        self.iteration_value = &context;
        defer self.iteration_value = previous;

        break :initial try self.expr(iteration.initial);
    } else if (by_value) try @import("value_call/root.zig").expression(self, iteration.initial) else try self.expr(iteration.initial);

    const initial = if (local) try aggregate.bind(self, &body, initial_expression) else initial_expression;
    const state_scope = if (selected_state and !self.state_active) try @import("state_value/root.zig").enter(self) else null;

    defer if (state_scope) |scope| scope.restore();

    const changed_name = if (local and !by_value and mode != .discard) try self.fresh("state_changed") else "";

    const condition_index = @backingInt(iteration.condition_parameter);
    const step_index = @backingInt(iteration.parameter);
    const condition_name = self.names[condition_index];
    const step_name = self.names[step_index];

    self.names[condition_index] = name;
    self.names[step_index] = name;
    defer self.names[condition_index] = condition_name;
    defer self.names[step_index] = step_name;

    const condition_stacked = self.stack_symbols.contains(iteration.condition_parameter);
    const step_stacked = self.stack_symbols.contains(iteration.parameter);
    const condition_state = self.state_symbols.contains(iteration.condition_parameter);
    const step_state = self.state_symbols.contains(iteration.parameter);

    if (selected_state) {
        try self.state_symbols.put(self.allocator, iteration.condition_parameter, {});
        try self.state_symbols.put(self.allocator, iteration.parameter, {});
    } else if (layout) {
        try self.stack_symbols.put(self.allocator, iteration.condition_parameter, {});
        try self.stack_symbols.put(self.allocator, iteration.parameter, {});
    }

    defer {
        if (selected_state and !condition_state) _ = self.state_symbols.remove(iteration.condition_parameter);
        if (selected_state and !step_state) _ = self.state_symbols.remove(iteration.parameter);
        if (layout and !condition_stacked) _ = self.stack_symbols.remove(iteration.condition_parameter);
        if (layout and !step_stacked) _ = self.stack_symbols.remove(iteration.parameter);
    }

    const previous_context = self.iteration_value;

    defer self.iteration_value = previous_context;

    if (deep) {
        try context.symbols.put(self.allocator, iteration.condition_parameter, {});
        try context.symbols.put(self.allocator, iteration.parameter, {});

        self.iteration_value = &context;
    }

    const condition = try self.expr(iteration.condition);
    const next = if (selected_call) |call| try @import("value_call/root.zig").expression(self, call) else if (layout) try @import("value_call/root.zig").expression(self, iteration.body) else try self.expr(iteration.body);

    self.iteration_value = previous_context;

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = if (deep) try @import("iteration_value/types.zig").get(&context, type_id) else if (layout) self.layouts[@backingInt(type_id)] else self.types[@backingInt(type_id)],
        .value = if (state_scope != null) try @import("state_value/conversion.zig").convert(self, &body, type_id, initial, if (by_value) .value_layout else .value) else if (selected_state or by_value or direct_initial) initial else if (deep) try @import("iteration_value/conversion.zig").convert(&context, type_id, initial, false) else if (layout) try self.builder.expression(.{ .dereference = initial }) else initial,
    } });

    var renewed = false;

    for (self.plan.renewals) |renewal| if (renewal.owner == id) {
        try @import("growth.zig").renew(self, &body, type_id, state, renewal.path);

        renewed = true;
    };

    try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = next } });

    if (local and !by_value and mode != .discard) {
        try body.append(self.allocator, .{ .variable = .{ .name = changed_name, .value = try self.builder.expression(.{ .boolean = renewed }) } });
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(changed_name), .value = try self.builder.expression(.{ .boolean = true }) } });
    }

    if (iteration.postcondition) {
        try loop.append(self.allocator, .{ .branch = .{
            .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = condition } }),
            .yes = try self.builder.statements(&.{.break_loop}),
            .no = .{},
        } });
    }

    try body.append(self.allocator, .{ .while_loop = .{
        .condition = if (iteration.postcondition) try self.builder.expression(.{ .boolean = true }) else condition,
        .body = try self.builder.statements(loop.items),
    } });

    if (consumer) |selected| {
        if (deep) {
            const result = try @import("iteration_value/result.zig").lower(self, selected, state);

            return try aggregate.finish(self, &body, result);
        }

        const result = try @import("iteration_consumer.zig").read(self, selected, selected.result, state);

        return try aggregate.finish(self, &body, result);
    }

    if (mode == .discard) return try aggregate.finish(self, &body, try self.builder.expression(.unit));

    var converted_body: std.ArrayList(node.Statement) = .empty;
    const converted_state = if (state_scope != null) try @import("state_value/conversion.zig").convert(self, &converted_body, type_id, state, if (by_value) .layout else .pointer) else state;
    const boundary = try aggregate.finish(self, &converted_body, converted_state);

    const result = if (by_value) boundary else if (local) try self.builder.expression(.{ .conditional = .{
        .condition = try self.builder.identifier(changed_name),
        .yes = if (state_scope != null) boundary else if (selected_state) state else if (deep) try @import("iteration_value/conversion.zig").convert(&context, type_id, state, true) else try self.construct(type_id, state),
        .no = initial,
    } }) else state;

    return try aggregate.finish(self, &body, result);
}

/// A loop whose body only forwards its state to a value function of the same type, which then runs on the state layout.
fn forwarded(self: *Lower, iteration: ir.Iteration) Lower.Error!?ir.ExprId {
    const id = forwardedCall(self.program, iteration.body) orelse return null;
    const call = self.program.expression(id).value.call;
    const function = self.program.functions.at(@backingInt(call.function));
    const argument = self.program.expression(call.argument);

    if (!self.value_functions[@backingInt(call.function)]) return null;
    if (self.program.typeOf(function.output_type) != .object) return null;
    if (function.input_type != function.output_type or argument.value != .reference or argument.value.reference != iteration.parameter) return null;
    if (!try @import("iteration_layout.zig").condition(self.allocator, self.program, iteration, self.pure_functions)) return null;

    return id;
}

fn forwardedCall(program: ir.Program, root: ir.ExprId) ?ir.ExprId {
    var id = root;

    while (true) switch (program.expression(id).value) {
        .call => return id,
        .scope => |scope| {
            if (scope.bindings.len == 0) {
                id = scope.result;

                continue;
            }

            if (scope.bindings.len != 1) return null;

            const symbol = scope.bindings.at(0).symbol orelse return null;
            const result = program.expression(scope.result).value;

            if (result != .reference or result.reference != symbol) return null;

            id = scope.bindings.at(0).value;
        },
        else => return null,
    };
}
