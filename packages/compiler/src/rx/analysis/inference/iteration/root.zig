const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Expression = @import("../expression.zig");

pub fn infer(self: *Expression, source: *const zx.ast.Expression, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(source.span);
    const arguments = source.value.call.arguments;

    for (self.bindings.items, 0..) |binding, index| {
        if (!std.mem.eql(u8, binding.name, "loop")) continue;

        return self.graph.reporter.fail(if (index < self.floor) .ownership else .type_mismatch, span, if (index < self.floor) "callbacks cannot capture outer bindings" else "a local value is not a callable function");
    }

    if (arguments.len != 2 or arguments[1].value != .object) return self.graph.reporter.fail(.type_mismatch, span, "loop requires an initial state and an inline rule literal");

    var condition: ?*const zx.ast.Expression = null;
    var step: ?*const zx.ast.Expression = null;

    for (arguments[1].value.object) |field| {
        const location = self.sourceSpan(field.name.span);

        if (field.spread) return self.graph.reporter.fail(.type_mismatch, self.sourceSpan(field.value.span), "loop rules cannot use spread");

        if (std.mem.eql(u8, field.name.text, "while")) {
            if (condition != null) return self.graph.reporter.fail(.name, location, "duplicate loop condition");

            condition = field.value;
        } else if (std.mem.eql(u8, field.name.text, "next") or std.mem.eql(u8, field.name.text, "do")) {
            if (step != null) return self.graph.reporter.fail(.name, location, "loop requires exactly one next or do step");

            step = field.value;
        } else return self.graph.reporter.fail(.name, location, "unknown loop rule; expected while and next or do");
    }

    if (condition == null or step == null) return self.graph.reporter.fail(.type_mismatch, span, "loop requires while and exactly one next or do step");

    const state = try self.infer(arguments[0], expected);

    try callback(self, condition.?, state, false);
    try callback(self, step.?, state, true);

    return state;
}

fn callback(self: *Expression, source: *const zx.ast.Expression, state: Graph.Id, updating: bool) zx.Error!void {
    const span = self.sourceSpan(source.span);

    if (source.value != .lambda or source.value.lambda.parameters.len != 1) return self.graph.reporter.fail(.type_mismatch, span, "loop callbacks require one inline state parameter");

    const lambda = source.value.lambda;
    const start = self.bindings.items.len;
    const floor = self.floor;

    self.floor = start;
    self.callback_depth += 1;

    defer {
        self.bindings.shrinkRetainingCapacity(start);

        self.floor = floor;
        self.callback_depth -= 1;
    }

    try self.bindings.append(self.graph.allocator, .{ .name = lambda.parameters[0].text, .value = state, .span = self.sourceSpan(lambda.parameters[0].span) });

    if (updating) {
        if (lambda.body.value != .state_block) return self.graph.reporter.fail(.type_mismatch, self.sourceSpan(lambda.body.span), "loop next and do require a state update block");
        try @import("block.zig").infer(self, lambda.body.value.state_block, lambda.parameters[0].text);
    } else _ = try self.infer(lambda.body, try self.graph.scalar(.bool, span));
}
