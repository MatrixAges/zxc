const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const frame = @import("iteration/frame.zig");
const renewal = @import("iteration/renewal.zig");
const state_declaration = @import("iteration/state.zig");

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

const Mode = @import("iteration/result.zig").Mode;

fn lowerMode(self: *Lower, id: ir.ExprId, iteration: ir.Iteration, mode: Mode, consumer: ?@import("iteration_consumer.zig").Consumer) Lower.Error!?node.ExpressionId {
    const projected_output = if (consumer) |selected| try @import("iteration_value/result.zig").candidate(self.allocator, self.program, selected) else false;
    var body: std.ArrayList(node.Statement) = .empty;
    var loop: std.ArrayList(node.Statement) = .empty;
    const name = try self.fresh("state");
    const state = try self.builder.identifier(name);
    const selection = try @import("iteration_layout/select.zig").choose(self, id, iteration, mode, consumer, projected_output);

    switch (selection.representation) {
        .dereference => return try self.builder.expression(.{ .dereference = try lower(self, id, iteration) }),
        .reject => return null,
        else => {},
    }

    const selected_call = selection.forwarded;
    const type_id = self.program.expression(id).type_id;
    const buffered = selection.representation == .buffered;
    const deep = buffered or selection.representation == .deep;
    const selected_state = selection.representation == .state;
    const layout = selected_state or selection.representation == .stack;
    const by_value = mode != .reference and layout;
    const local = layout or deep;
    const direct_initial = selection.direct_initial;
    var context = @import("iteration_value/root.zig"){ .lowering = self, .declarations = &body, .inline_lists = buffered };

    const initial_expression = if (direct_initial) initial: {
        const previous = self.iteration_value;
        self.iteration_value = &context;
        defer self.iteration_value = previous;

        break :initial try self.expr(iteration.initial);
    } else if (by_value) try @import("value_call/root.zig").expression(self, iteration.initial) else try self.expr(iteration.initial);

    const initial = if (local) try aggregate.bind(self, &body, initial_expression) else initial_expression;
    var initial_guard: ?@import("iteration_value/initial.zig") = if (buffered and !iteration.postcondition) try @import("iteration_value/initial.zig").create(self, &body, iteration, consumer, initial) else null;
    const state_scope = if (selected_state and !self.state_active) try @import("state_value/root.zig").enter(self) else null;

    defer if (state_scope) |scope| scope.restore();

    const seed = try self.builder.identifier(try self.fresh("loop_seed"));
    var fields = if (selected_state and selected_call == null and selection.pure) try @import("iteration/fields/prepare.zig").prepare(self, iteration, type_id, &body, seed) else null;
    const previous_fields = self.loop_fields;

    defer self.loop_fields = previous_fields;

    const changed_name = if (local and !by_value and mode != .discard) try self.fresh("state_changed") else "";
    const tracking = if (changed_name.len != 0) changed_name else null;
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

    const finish = @import("iteration/result.zig").Result{
        .consumer = consumer,
        .deep = deep,
        .context = &context,
        .converted = state_scope != null,
        .type_id = type_id,
        .by_value = by_value,
        .local = local,
        .selected_state = selected_state,
        .initial = initial,
        .changed_name = changed_name,
        .mode = mode,
    };

    const converted_initial = if (state_scope != null) try @import("state_value/conversion.zig").convert(self, &body, type_id, initial, if (by_value) .value_layout else .value) else if (selected_state or by_value or direct_initial) initial else if (deep) try @import("iteration_value/conversion.zig").convert(&context, type_id, initial, false) else if (layout) try self.builder.expression(.{ .dereference = initial }) else initial;
    const initial_state = if (selected_state and state_scope == null) try @import("state_value/ownership.zig").clip(self, &body, iteration.initial, converted_initial) else converted_initial;
    var renewal_scope = std.heap.ArenaAllocator.init(self.workspace);
    var renewal_buffer: [256]u8 = undefined;
    var renewal_memory = std.heap.BufferFirstAllocator.init(&renewal_buffer, renewal_scope.allocator());

    defer renewal_scope.deinit();

    const temporary = renewal_memory.allocator();

    if (fields) |*selected| {
        const renewals = try renewal.plan(self, temporary, .{ .owner = id, .type_id = type_id });
        const renewed = renewals.needsEntries(self);
        const seed_name = self.builder.nodes.get(seed).identifier;

        const tracker = try state_declaration.declare(self, &body, .{
            .name = seed_name,
            .layout = try self.layoutExpr(type_id),
            .initial = initial_state,
            .mutable = renewed,
            .tracking = tracking,
        });

        self.names[condition_index] = seed_name;
        self.names[step_index] = seed_name;

        const first_condition = if (iteration.postcondition) null else try self.expr(iteration.condition);

        self.names[condition_index] = name;
        self.names[step_index] = name;
        self.loop_fields = selected;
        const condition = try self.expr(iteration.condition);
        const next = try @import("value_call/root.zig").expression(self, iteration.body);

        self.loop_fields = previous_fields;

        var entered: std.ArrayList(node.Statement) = .empty;

        try renewals.emit(self, &entered, type_id, .{ .reference = seed });
        try selected.maskBorrowed(self, &entered);

        _ = try state_declaration.declare(self, &entered, .{
            .name = name,
            .layout = selected.layout,
            .initial = try selected.initial(self),
        });

        const qualified = try selected.qualify(self, &loop, iteration.body, next);

        try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = qualified } });
        if (tracker) |value| try value.mark(self, &loop);
        try frame.append(self, &entered, null, &loop, .{ .condition = condition, .after_step = true });

        const restored = if (mode == .discard) state else try aggregate.bind(self, &entered, try selected.restore(self, state));
        const result = try finish.lower(self, &entered, restored);

        if (first_condition) |first| {
            var skipped: std.ArrayList(node.Statement) = .empty;

            return try aggregate.finishGuarded(self, &body, first, result, try finish.lower(self, &skipped, seed));
        }

        return try aggregate.finish(self, &body, result);
    }

    const renewals = try renewal.plan(self, temporary, .{
        .owner = id,
        .type_id = type_id,
        .classify = if (!deep and selected_state and selected_call == null) iteration else null,
        .inline_lists = buffered,
    });

    const previous_deferred = self.deferred_lists;

    defer self.deferred_lists = previous_deferred;
    self.deferred_lists = renewals.delayed;
    const condition = try self.expr(iteration.condition);
    const next = if (selected_call) |call| try @import("value_call/root.zig").expression(self, call) else if (layout) try @import("value_call/root.zig").expression(self, iteration.body) else try self.expr(iteration.body);

    self.iteration_value = previous_context;
    self.deferred_lists = previous_deferred;

    const tracker = try state_declaration.declare(self, &body, .{
        .name = name,
        .layout = if (deep) try @import("iteration_value/types.zig").get(&context, type_id) else if (layout) try self.layoutExpr(type_id) else try self.typeExpr(type_id),
        .initial = initial_state,
        .tracking = tracking,
    });

    var entered: std.ArrayList(node.Statement) = .empty;

    try renewals.emit(self, &entered, type_id, .{ .reference = state });

    if (selected_state) {
        const qualified = try @import("state_value/ownership.zig").clip(self, &loop, iteration.body, next);

        try @import("iteration/assignment.zig").append(self, &loop, type_id, state, qualified);
    } else try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = next } });

    if (tracker) |value| try value.mark(self, &loop);

    try frame.append(self, &body, &entered, &loop, .{
        .condition = condition,
        .after_step = iteration.postcondition,
        .guarded_initial = initial_guard != null,
    });

    const result = try finish.lower(self, &body, state);

    if (initial_guard) |*guard| return try guard.finish(self, result);

    return result;
}
