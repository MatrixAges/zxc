const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, id: ir.ExprId, iteration: ir.Iteration) Lower.Error!*const node.Expression {
    return (try lowerMode(self, id, iteration, .reference, null)).?;
}

pub fn lowerValue(self: *Lower, id: ir.ExprId, iteration: ir.Iteration) Lower.Error!*const node.Expression {
    return (try lowerMode(self, id, iteration, .value, null)).?;
}

pub fn discard(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    const value = self.program.expression(id).value;

    if (value != .iteration) return self.expr(id);

    return (try lowerMode(self, id, value.iteration, .discard, null)).?;
}

pub fn consume(self: *Lower, id: ir.ExprId, consumer: @import("iteration_consumer.zig").Consumer) Lower.Error!?*const node.Expression {
    return lowerMode(self, id, self.program.expression(id).value.iteration, .consume, consumer);
}

const Mode = enum { reference, value, discard, consume };

fn lowerMode(self: *Lower, id: ir.ExprId, iteration: ir.Iteration, mode: Mode, consumer: ?@import("iteration_consumer.zig").Consumer) Lower.Error!?*const node.Expression {
    if (mode == .consume or mode == .discard) {
        if (try @import("iteration_value/local.zig").lower(self, iteration, consumer)) |value| return value;
    }

    var body: std.ArrayList(node.Statement) = .empty;
    var loop: std.ArrayList(node.Statement) = .empty;
    const name = try self.fresh("state");
    const state = try self.builder.identifier(name);
    const layout_analysis = @import("iteration_layout.zig");
    const pure = try layout_analysis.eligible(self.allocator, self.program, iteration, self.pure_functions);
    const local_calls = pure or try layout_analysis.eligible(self.allocator, self.program, iteration, self.local_functions);
    const selected_call = try @import("buffer_call/iteration.zig").candidate(self, iteration);
    const type_id = self.program.expression(id).type_id;
    const selected_state = self.state_plan.represented(self.program, type_id) and (self.state_active or selected_call != null or (mode != .reference and pure));
    const layout = selected_state or selected_call != null or (local_calls and layout_analysis.flat(self.program, type_id));
    const by_value = mode != .reference and layout;

    if (mode == .consume and (!layout or selected_call != null)) return null;
    if (mode == .value and !layout) return self.builder.expression(.{ .dereference = try lower(self, id, iteration) });

    const deep = !self.state_active and pure and !layout and layout_analysis.represented(self.program, type_id) and try layout_analysis.deep(self.allocator, self.program, iteration, self.pure_functions);
    const local = layout or deep;
    var context = @import("iteration_value/root.zig"){ .lowering = self, .declarations = &body };
    const initial_expression = if (by_value) try @import("value_call/root.zig").expression(self, iteration.initial) else try self.expr(iteration.initial);
    const initial = if (local) try aggregate.bind(self, &body, initial_expression) else initial_expression;
    const state_scope = if (selected_state and !self.state_active) try @import("state_value/root.zig").enter(self) else null;

    defer if (state_scope) |scope| scope.restore();

    const changed_name = if (local and !by_value and mode != .discard) try self.fresh("state_changed") else "";
    var buffers = try @import("iteration_buffer/root.zig").init(self, iteration, &body, pure, local or self.program.typeOf(type_id) == .list);

    defer buffers.restore();

    var calls = try @import("buffer_call/iteration.zig").init(self, selected_call, &body);

    defer calls.restore();

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
        .value = if (state_scope != null) try @import("state_value/conversion.zig").convert(self, &body, type_id, initial, if (by_value) .value_layout else .value) else if (selected_state or by_value) initial else if (deep) try @import("iteration_value/conversion.zig").convert(&context, type_id, initial, false) else if (layout) try self.builder.expression(.{ .dereference = initial }) else initial,
    } });

    try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = next } });

    if (local and !by_value and mode != .discard) {
        try body.append(self.allocator, .{ .variable = .{ .name = changed_name, .value = try self.builder.expression(.{ .boolean = false }) } });
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(changed_name), .value = try self.builder.expression(.{ .boolean = true }) } });
    }

    if (iteration.postcondition) {
        try loop.append(self.allocator, .{ .branch = .{
            .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = condition } }),
            .yes = try self.allocator.dupe(node.Statement, &.{.break_loop}),
            .no = &.{},
        } });
    }

    try body.append(self.allocator, .{ .while_loop = .{
        .condition = if (iteration.postcondition) try self.builder.expression(.{ .boolean = true }) else condition,
        .body = try loop.toOwnedSlice(self.allocator),
    } });

    if (consumer) |selected| {
        const result = try @import("iteration_consumer.zig").read(self, selected, selected.result, state);

        return aggregate.finish(self, &body, result);
    }

    try buffers.finish(&body, state, type_id);
    try calls.finish(&body, state, type_id);
    if (mode == .discard) return aggregate.finish(self, &body, try self.builder.expression(.unit));

    var converted_body: std.ArrayList(node.Statement) = .empty;
    const converted_state = if (state_scope != null) try @import("state_value/conversion.zig").convert(self, &converted_body, type_id, state, if (by_value) .layout else .pointer) else state;
    const boundary = try aggregate.finish(self, &converted_body, converted_state);

    const result = if (by_value) boundary else if (local) try self.builder.expression(.{ .conditional = .{
        .condition = try self.builder.identifier(changed_name),
        .yes = if (state_scope != null) boundary else if (selected_state) state else if (deep) try @import("iteration_value/conversion.zig").convert(&context, type_id, state, true) else try self.construct(type_id, state),
        .no = initial,
    } }) else state;

    return aggregate.finish(self, &body, result);
}
