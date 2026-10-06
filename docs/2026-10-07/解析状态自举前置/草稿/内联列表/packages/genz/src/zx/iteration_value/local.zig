const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Context = @import("root.zig");
const aggregate = @import("../aggregate.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub fn lower(self: *Lower, iteration: ir.Iteration, consumer: ?Consumer) Lower.Error!?*const node.Expression {
    if (self.state_active or self.iteration_value != null or self.transaction()) return null;
    if (!try @import("list_plan.zig").eligible(self, iteration)) return null;

    var body: std.ArrayList(node.Statement) = .empty;
    var context = Context{ .lowering = self, .declarations = &body, .inline_lists = true };
    const initial = try aggregate.bind(self, &body, try self.expr(iteration.initial));
    const name = try self.fresh("local_state");
    const state = try self.builder.identifier(name);
    const type_id = self.program.expression(iteration.initial).type_id;
    const previous = self.iteration_value;
    self.iteration_value = &context;
    defer self.iteration_value = previous;

    var buffers = try @import("../iteration_buffer/root.zig").init(self, iteration, &body, true, true);

    defer buffers.restore();

    var path: std.ArrayList(usize) = .empty;
    const value = try @import("initial.zig").convert(&context, &buffers, type_id, initial, &path);

    try body.append(self.allocator, .{ .variable = .{ .name = name, .type_expr = try @import("types.zig").get(&context, type_id), .value = value } });

    const condition_index = @backingInt(iteration.condition_parameter);
    const step_index = @backingInt(iteration.parameter);
    const condition_name = self.names[condition_index];
    const step_name = self.names[step_index];

    self.names[condition_index] = name;
    self.names[step_index] = name;
    defer self.names[condition_index] = condition_name;
    defer self.names[step_index] = step_name;

    try context.symbols.put(self.allocator, iteration.condition_parameter, {});
    try context.symbols.put(self.allocator, iteration.parameter, {});

    const condition = try self.expr(iteration.condition);
    const next = try self.expr(iteration.body);
    var loop: std.ArrayList(node.Statement) = .empty;

    try loop.append(self.allocator, .{ .assignment = .{ .target = state, .value = next } });

    if (iteration.postcondition) try loop.append(self.allocator, .{ .branch = .{
        .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = condition } }),
        .yes = try self.allocator.dupe(node.Statement, &.{.break_loop}),
        .no = &.{},
    } });

    try body.append(self.allocator, .{ .while_loop = .{
        .condition = if (iteration.postcondition) try self.builder.expression(.{ .boolean = true }) else condition,
        .body = try loop.toOwnedSlice(self.allocator),
    } });

    self.iteration_value = previous;

    const result = if (consumer) |selected| try @import("../iteration_consumer.zig").read(self, selected, selected.result, state) else try self.builder.expression(.unit);

    return try aggregate.finish(self, &body, result);
}
