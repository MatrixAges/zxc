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

const Mode = @import("iteration/result.zig").Mode;

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
    const deep_candidate = !self.state_active and (projected_output or mode == .discard) and pure and !layout_analysis.flat(self, type_id) and layout_analysis.represented(self, type_id);
    const buffered = deep_candidate and self.plan.get(id).buffered and try layout_analysis.buffers(self.allocator, self.program, iteration, self.identity_free_functions, self.plan.flags);
    const deep = buffered or (deep_candidate and try layout_analysis.deep(self.allocator, self.program, iteration, self.identity_free_functions));
    const scalar_result = if (consumer) |selected| @import("types/scalar.zig").check(self.program.types, self.program.expression(selected.result).type_id) else false;

    const abi_state = !self.state_active and scalar_result and
        @import("iteration_layout/types_seed.zig").scalarProduct(self.program, type_id) and
        try layout_analysis.deep(self.allocator, self.program, iteration, self.identity_free_functions);

    const selected_state = !deep and !abi_state and self.state_plan.represented(self.program, type_id) and (self.state_active or selected_call != null or local_calls);
    const layout = !deep and (selected_state or selected_call != null or ((local_calls or try layout_analysis.shallow(self.allocator, self.program, iteration)) and layout_analysis.aggregate(self, type_id)));
    const by_value = mode != .reference and layout;

    if (mode == .value and !layout) return try self.builder.expression(.{ .dereference = try lower(self, id, iteration) });
    if (mode == .consume and ((!layout and !deep) or selected_call != null)) return null;
    if (consumer) |selected| if (!deep and !@import("iteration_consumer.zig").projection(self.program, selected.result, selected.symbol)) return null;

    const local = layout or deep;
    var context = @import("iteration_value/root.zig"){ .lowering = self, .declarations = &body, .inline_lists = buffered };
    const direct_initial = deep and !buffered and try layout_analysis.initialValue(self.allocator, self.program, iteration.initial, self.identity_free_functions);

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
    var fields = if (selected_state and selected_call == null and pure and !deep) try @import("iteration/fields/prepare.zig").prepare(self, iteration, type_id, &body, seed) else null;
    const previous_fields = self.loop_fields;

    defer self.loop_fields = previous_fields;

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

    if (fields) |*selected| {
        var renewed = false;

        for (self.plan.renewals) |renewal| if (renewal.owner == @backingInt(id) and !renewal.value) {
            renewed = true;
        };

        const seed_name = self.builder.nodes.get(seed).identifier;
        const declaration = node.Constant{ .name = seed_name, .type_expr = try self.layoutExpr(type_id), .value = initial_state };

        try body.append(self.allocator, if (renewed) .{ .variable = declaration } else .{ .constant = declaration });

        if (local and !by_value and mode != .discard) try body.append(self.allocator, .{ .variable = .{ .name = changed_name, .value = try self.builder.expression(.{ .boolean = false }) } });

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

        for (self.plan.renewals) |renewal| if (renewal.owner == @backingInt(id) and !renewal.value) {
            try @import("growth.zig").renew(self, &entered, type_id, seed, renewal.path);
        };

        try selected.maskBorrowed(self, &entered);
        try entered.append(self.allocator, .{ .variable = .{ .name = name, .type_expr = selected.layout, .value = try selected.initial(self) } });

        const qualified = try selected.qualify(self, &loop, iteration.body, next);

        try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = qualified } });
        if (local and !by_value and mode != .discard) try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(changed_name), .value = try self.builder.expression(.{ .boolean = true }) } });

        try loop.append(self.allocator, .{ .branch = .{
            .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = condition } }),
            .yes = try self.builder.statements(&.{.break_loop}),
            .no = .{},
        } });

        try entered.append(self.allocator, .{ .while_loop = .{ .condition = try self.builder.expression(.{ .boolean = true }), .body = try self.builder.statements(loop.items) } });

        const restored = if (mode == .discard) state else try aggregate.bind(self, &entered, try selected.restore(self, state));
        const result = try finish.lower(self, &entered, restored);

        if (first_condition) |first| {
            var skipped: std.ArrayList(node.Statement) = .empty;

            return try aggregate.finish(self, &body, try self.builder.expression(.{ .conditional = .{
                .condition = first,
                .yes = result,
                .no = try finish.lower(self, &skipped, seed),
            } }));
        }

        return try aggregate.finish(self, &body, result);
    }

    const deferred = if (!deep and selected_state and selected_call == null) try @import("iteration/deferred.zig").paths(self, id, iteration) else &.{};
    const previous_deferred = self.deferred_lists;

    defer self.deferred_lists = previous_deferred;
    self.deferred_lists = std.mem.indexOfScalar(bool, deferred, true) != null;

    const condition = try self.expr(iteration.condition);
    const next = if (selected_call) |call| try @import("value_call/root.zig").expression(self, call) else if (layout) try @import("value_call/root.zig").expression(self, iteration.body) else try self.expr(iteration.body);

    self.iteration_value = previous_context;
    self.deferred_lists = previous_deferred;

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = if (deep) try @import("iteration_value/types.zig").get(&context, type_id) else if (layout) try self.layoutExpr(type_id) else try self.typeExpr(type_id),
        .value = initial_state,
    } });

    var entered: std.ArrayList(node.Statement) = .empty;
    var renewal_index: usize = 0;

    for (self.plan.renewals) |renewal| if (renewal.owner == @backingInt(id) and !renewal.value) {
        const delayed = renewal_index < deferred.len and deferred[renewal_index];

        renewal_index += 1;

        if (delayed) continue;
        if (context.bufferedPath(type_id, renewal.path)) continue;
        try @import("growth.zig").renew(self, &entered, type_id, state, renewal.path);
    };

    const prepared = entered.items.len != 0;

    if (selected_state) {
        const qualified = try @import("state_value/ownership.zig").clip(self, &loop, iteration.body, next);

        try @import("iteration/assignment.zig").append(self, &loop, type_id, state, qualified);
    } else try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = next } });

    if (local and !by_value and mode != .discard) {
        try body.append(self.allocator, .{ .variable = .{ .name = changed_name, .value = try self.builder.expression(.{ .boolean = false }) } });
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(changed_name), .value = try self.builder.expression(.{ .boolean = true }) } });
    }

    if (iteration.postcondition or prepared or initial_guard != null) {
        try loop.append(self.allocator, .{ .branch = .{
            .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = condition } }),
            .yes = try self.builder.statements(&.{.break_loop}),
            .no = .{},
        } });
    }

    try entered.append(self.allocator, .{ .while_loop = .{
        .condition = if (iteration.postcondition or prepared or initial_guard != null) try self.builder.expression(.{ .boolean = true }) else condition,
        .body = try self.builder.statements(loop.items),
    } });

    if (!iteration.postcondition and prepared) {
        try body.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = try self.builder.statements(entered.items), .no = .{} } });
    } else try body.appendSlice(self.allocator, entered.items);

    const result = try finish.lower(self, &body, state);

    if (initial_guard) |*guard| return try guard.finish(self, result);

    return result;
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
