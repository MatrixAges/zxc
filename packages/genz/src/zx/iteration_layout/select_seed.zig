const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const layout = @import("../iteration_layout.zig");
const consumers = @import("../iteration_consumer.zig");
const Mode = @import("../iteration/result.zig").Mode;
const Selection = @import("select.zig").Selection;

pub fn choose(self: *Lower, id: ir.ExprId, iteration: ir.Iteration, mode: Mode, consumer: ?consumers.Consumer, projected_output: bool) Lower.Error!Selection {
    const pure = try layout.eligible(self.allocator, self.program, iteration, self.pure_functions);
    const local_calls = pure or try layout.eligible(self.allocator, self.program, iteration, self.local_functions);
    const forwarded = try layout.forwarded(self, iteration);
    const type_id = self.program.expression(id).type_id;
    const deep_candidate = !self.state_active and (projected_output or mode == .discard) and pure and !layout.flat(self, type_id) and layout.represented(self, type_id);
    const buffered = deep_candidate and self.plan.get(id).buffered and try layout.buffers(self.allocator, self.program, iteration, self.identity_free_functions, self.plan.flags);
    const deep = buffered or (deep_candidate and try layout.deep(self.allocator, self.program, iteration, self.identity_free_functions));
    const scalar_result = if (consumer) |selected| @import("../types/scalar.zig").check(self.program.types, self.program.expression(selected.result).type_id) else false;
    const abi_state = !self.state_active and scalar_result and try layout.abi(self, iteration, type_id);
    const selected_state = !deep and !abi_state and self.state_plan.represented(self.program, type_id) and (self.state_active or forwarded != null or local_calls);
    const stack = !deep and (selected_state or forwarded != null or ((local_calls or try layout.shallow(self.allocator, self.program, iteration)) and layout.aggregate(self, type_id)));

    if (mode == .value and !stack) return .{ .representation = .dereference };
    if (mode == .consume and ((!stack and !deep) or forwarded != null)) return .{ .representation = .reject };
    if (consumer) |selected| if (!deep and !consumers.projection(self.program, selected.result, selected.symbol)) return .{ .representation = .reject };

    return .{
        .representation = if (buffered) .buffered else if (deep) .deep else if (selected_state) .state else if (stack) .stack else .plain,
        .forwarded = forwarded,
        .pure = pure,
        .direct_initial = deep and !buffered and try layout.initialValue(self.allocator, self.program, iteration.initial, self.identity_free_functions),
    };
}
