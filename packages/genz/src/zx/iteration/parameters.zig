const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Context = @import("../iteration_value/root.zig");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_parameters") else struct {};
const Input = if (generated) std.meta.Child(entry.Input) else void;
pub const Layout = if (generated) @FieldType(Input, "layout") else enum { Plain, Stack, State, Deep };

const Plan = if (generated) std.meta.Child(entry.Output) else struct {
    add_condition: bool,
    add_step: bool,
    remove_state_condition: bool,
    remove_state_step: bool,
    remove_stack_condition: bool,
    remove_stack_step: bool,
};

const Self = @This();

lowering: *Lower,
condition: ir.SymbolId,
step: ir.SymbolId,
condition_name: []const u8,
step_name: []const u8,
previous_context: ?*Context,
plan: Plan,
pub fn enter(lowering: *Lower, iteration: ir.Iteration, layout: Layout, name: []const u8, context: *Context) Lower.Error!Self {
    const condition = iteration.condition_parameter;
    const step = iteration.parameter;
    const plan = decide(lowering, layout, condition, step);

    const scope: Self = .{
        .lowering = lowering,
        .condition = condition,
        .step = step,
        .condition_name = lowering.names[@backingInt(condition)],
        .step_name = lowering.names[@backingInt(step)],
        .previous_context = lowering.iteration_value,
        .plan = plan,
    };

    scope.rename(name);
    errdefer scope.restore();

    const symbols = switch (layout) {
        .Plain => return scope,
        .State => &lowering.state_symbols,
        .Stack => &lowering.stack_symbols,
        .Deep => &context.symbols,
    };

    if (plan.add_condition) try symbols.put(lowering.allocator, condition, {});
    if (plan.add_step) try symbols.put(lowering.allocator, step, {});
    if (layout == .Deep) lowering.iteration_value = context;

    return scope;
}

pub fn rename(self: Self, name: []const u8) void {
    self.lowering.names[@backingInt(self.condition)] = name;
    self.lowering.names[@backingInt(self.step)] = name;
}

pub fn restoreContext(self: Self) void {
    self.lowering.iteration_value = self.previous_context;
}

pub fn restore(self: Self) void {
    self.restoreContext();

    if (self.plan.remove_state_condition) _ = self.lowering.state_symbols.remove(self.condition);
    if (self.plan.remove_state_step) _ = self.lowering.state_symbols.remove(self.step);
    if (self.plan.remove_stack_condition) _ = self.lowering.stack_symbols.remove(self.condition);
    if (self.plan.remove_stack_step) _ = self.lowering.stack_symbols.remove(self.step);

    self.lowering.names[@backingInt(self.step)] = self.step_name;
    self.lowering.names[@backingInt(self.condition)] = self.condition_name;
}

fn decide(lowering: *const Lower, layout: Layout, condition: ir.SymbolId, step: ir.SymbolId) Plan {
    if (comptime !generated) return seed(lowering, layout, condition, step);

    const Index = std.meta.Child(@FieldType(Input, "state"));
    const state = lowering.state_symbols.view(Index);
    const stack = lowering.stack_symbols.view(Index);

    const input: Input = .{
        .layout = layout,
        .condition = @backingInt(condition),
        .step = @backingInt(step),
        .state = &state,
        .stack = &stack,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    return .{
        .add_condition = output.add_condition,
        .add_step = output.add_step,
        .remove_state_condition = output.remove_state_condition,
        .remove_state_step = output.remove_state_step,
        .remove_stack_condition = output.remove_stack_condition,
        .remove_stack_step = output.remove_stack_step,
    };
}

fn seed(lowering: *const Lower, layout: Layout, condition: ir.SymbolId, step: ir.SymbolId) Plan {
    const state = layout == .State;
    const stack = state or layout == .Stack;
    const distinct = condition != step;
    const remove_state_condition = state and !lowering.state_symbols.contains(condition);
    const remove_state_step = state and distinct and !lowering.state_symbols.contains(step);
    const remove_stack_condition = stack and !lowering.stack_symbols.contains(condition);
    const remove_stack_step = stack and distinct and !lowering.stack_symbols.contains(step);

    return .{
        .add_condition = switch (layout) {
            .Plain => false,
            .State => remove_state_condition,
            .Stack => remove_stack_condition,
            .Deep => true,
        },
        .add_step = switch (layout) {
            .Plain => false,
            .State => remove_state_step,
            .Stack => remove_stack_step,
            .Deep => distinct,
        },
        .remove_state_condition = remove_state_condition,
        .remove_state_step = remove_state_step,
        .remove_stack_condition = remove_stack_condition,
        .remove_stack_step = remove_stack_step,
    };
}
