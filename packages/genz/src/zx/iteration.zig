const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const frame = @import("iteration/frame.zig");
const renewal = @import("iteration/renewal.zig");
const state_declaration = @import("iteration/state.zig");
const step = @import("iteration/step.zig");

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

    const preparation = @import("iteration/initial.zig").plan(.{
        .layout = layout,
        .selected_state = selected_state,
        .state_active = self.state_active,
        .deep = deep,
        .buffered = buffered,
        .direct_initial = selection.direct_initial,
        .postcondition = iteration.postcondition,
        .reference = mode == .reference,
        .discard = mode == .discard,
        .pure = selection.pure,
        .forwarded = selected_call != null,
    });

    var context = @import("iteration_value/root.zig"){ .lowering = self, .declarations = &body, .inline_lists = buffered };

    const initial_expression = switch (preparation.evaluation) {
        .Reference => try self.expr(iteration.initial),
        .Value => try @import("value_call/root.zig").expression(self, iteration.initial),
        .Deep => initial: {
            const previous = self.iteration_value;
            self.iteration_value = &context;
            defer self.iteration_value = previous;

            break :initial try self.expr(iteration.initial);
        },
    };

    const initial = if (preparation.local) try aggregate.bind(self, &body, initial_expression) else initial_expression;
    var initial_guard: ?@import("iteration_value/initial.zig") = if (preparation.guard) try @import("iteration_value/initial.zig").create(self, &body, iteration, consumer, initial) else null;

    const state_scope = switch (preparation.storage) {
        .State, .StateValue => try @import("state_value/root.zig").enter(self),
        else => null,
    };

    defer if (state_scope) |scope| scope.restore();

    const seed = try self.builder.identifier(try self.fresh("loop_seed"));
    var fields = if (preparation.project_fields) try @import("iteration/fields/prepare.zig").prepare(self, iteration, type_id, &body, seed) else null;
    const previous_fields = self.loop_fields;

    defer self.loop_fields = previous_fields;

    const changed_name = if (preparation.track) try self.fresh("state_changed") else "";
    const tracking = if (changed_name.len != 0) changed_name else null;
    const parameters = try @import("iteration/parameters.zig").enter(self, iteration, selection.representation, name, &context);

    defer parameters.restore();

    const finish = @import("iteration/result.zig").Result{
        .consumer = consumer,
        .deep = deep,
        .context = &context,
        .converted = state_scope != null,
        .type_id = type_id,
        .by_value = preparation.by_value,
        .local = preparation.local,
        .selected_state = selected_state,
        .initial = initial,
        .changed_name = changed_name,
        .mode = mode,
    };

    const initial_state = switch (preparation.storage) {
        .Keep => initial,
        .Dereference => try @import("access/emit.zig").dereference(self, initial),
        .Deep => try @import("iteration_value/conversion.zig").convert(&context, type_id, initial, false),
        .State, .StateValue => try @import("state_value/conversion.zig").convert(self, &body, type_id, initial, if (preparation.storage == .StateValue) .value_layout else .value),
        .Clip => try @import("state_value/ownership.zig").clip(self, &body, iteration.initial, initial),
    };

    var renewal_scope = std.heap.ArenaAllocator.init(self.workspace);
    var renewal_buffer: [256]u8 = undefined;
    var renewal_memory = std.heap.BufferFirstAllocator.init(&renewal_buffer, renewal_scope.allocator());

    defer renewal_scope.deinit();

    const temporary = renewal_memory.allocator();

    const schedule = step.plan(.{
        .body = @backingInt(iteration.body),
        .forwarded = if (selected_call) |call| @backingInt(call) else null,
        .postcondition = iteration.postcondition,
        .projected = fields != null,
        .selected_state = selected_state,
        .layout = layout,
        .buffered = buffered,
    });

    const renewals = try renewal.plan(self, temporary, .{
        .owner = id,
        .type_id = type_id,
        .classify = if (schedule.classify_renewals) iteration else null,
        .inline_lists = schedule.inline_lists,
    });

    if (fields) |*selected| {
        const renewed = renewals.needsEntries(self);
        const seed_name = self.builder.nodes.get(seed).identifier;

        const tracker = try state_declaration.declare(self, &body, .{
            .name = seed_name,
            .layout = try self.layoutExpr(type_id),
            .initial = initial_state,
            .mutable = renewed,
            .tracking = tracking,
        });

        const first_condition = if (schedule.first_test) first: {
            parameters.rename(seed_name);
            defer parameters.rename(name);

            break :first try self.expr(iteration.condition);
        } else null;

        self.loop_fields = selected;

        const next = try step.lower(self, schedule, iteration.condition);

        self.loop_fields = previous_fields;

        var entered: std.ArrayList(node.Statement) = .empty;

        try renewals.emit(self, &entered, type_id, .{ .reference = seed });
        try selected.maskBorrowed(self, &entered);

        _ = try state_declaration.declare(self, &entered, .{
            .name = name,
            .layout = selected.layout,
            .initial = try selected.initial(self),
        });

        try step.append(self, &loop, schedule, .{
            .type_id = type_id,
            .origin = iteration.body,
            .target = state,
            .value = next.value,
            .fields = selected,
        });

        if (tracker) |value| try value.mark(self, &loop);

        try frame.append(self, &entered, null, &loop, .{ .condition = next.condition, .after_step = schedule.after_step });

        const restored = if (mode == .discard) state else try aggregate.bind(self, &entered, try selected.restore(self, state));
        const result = try finish.lower(self, &entered, restored);

        if (first_condition) |first| {
            var skipped: std.ArrayList(node.Statement) = .empty;

            return try aggregate.finishGuarded(self, &body, first, result, try finish.lower(self, &skipped, seed));
        }

        return try aggregate.finish(self, &body, result);
    }

    const previous_deferred = self.deferred_lists;

    defer self.deferred_lists = previous_deferred;
    self.deferred_lists = renewals.delayed;

    const next = try step.lower(self, schedule, iteration.condition);

    parameters.restoreContext();

    self.deferred_lists = previous_deferred;

    const tracker = try state_declaration.declare(self, &body, .{
        .name = name,
        .layout = if (deep) try @import("iteration_value/types.zig").get(&context, type_id) else if (layout) try self.layoutExpr(type_id) else try self.typeExpr(type_id),
        .initial = initial_state,
        .tracking = tracking,
    });

    var entered: std.ArrayList(node.Statement) = .empty;

    try renewals.emit(self, &entered, type_id, .{ .reference = state });

    try step.append(self, &loop, schedule, .{
        .type_id = type_id,
        .origin = iteration.body,
        .target = state,
        .value = next.value,
    });

    if (tracker) |value| try value.mark(self, &loop);

    try frame.append(self, &body, &entered, &loop, .{
        .condition = next.condition,
        .after_step = schedule.after_step,
        .guarded_initial = initial_guard != null,
    });

    const result = try finish.lower(self, &body, state);

    if (initial_guard) |*guard| return try guard.finish(self, result);

    return result;
}
