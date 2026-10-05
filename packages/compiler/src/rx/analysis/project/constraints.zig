const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Graph = @import("../inference/types.zig");
const Expression = @import("../inference/expression.zig");
const SourceMap = @import("../source_map.zig");
const Prepared = @import("prepare.zig");
const target = @import("../call/target.zig");
const paths = frontend.binding_path;
pub const State = struct { input: Graph.Id, output: Graph.Id, input_used: bool = false, bindings: []const Expression.Binding = &.{}, tasks: []const Task = &.{} };
pub const Task = struct { id: usize, output: Graph.Id };

pub fn collect(graph: *Graph, modules: []const Prepared.Module, source_map: SourceMap) zx.Error![]const State {
    const states = try graph.allocator.alloc(State, modules.len);

    for (modules, states, 0..) |module, *state, index| {
        const offset = source_map.base(index) + module.source.node.location.offset;
        const span = zx.Span{ .start = offset, .end = offset };

        state.* = .{ .input = try graph.add(.unknown, span), .output = try graph.add(.unknown, span) };
    }

    for (modules, states, 0..) |module, *state, index| {
        const location = module.source.node.location;

        var expression = Expression{
            .graph = graph,
            .input = state.input,
            .attribute = .{ .name = "", .value = "", .location = location, .value_location = location },
            .span_offset = source_map.base(index),
        };

        var walker = Walker{ .expression = &expression, .module = module, .states = states, .output = state.output };

        try walker.steps(module.steps);

        if (!walker.returned) {
            const span = graph.nodes.items[@backingInt(state.output)].span;

            try graph.unify(state.output, try graph.scalar(.void, span), span);
        }

        state.input_used = expression.input_used;
        state.bindings = walker.bindings.items;
        state.tasks = walker.tasks.items;
    }

    for (states) |state| {
        if (state.input_used) continue;

        var referenced = false;

        for (graph.assignments.items) |edge| {
            if (graph.root(edge.value) == graph.root(state.input) or graph.root(edge.expected) == graph.root(state.input)) referenced = true;
        }

        if (referenced) continue;

        const span = graph.nodes.items[@backingInt(state.input)].span;

        try graph.unify(state.input, try graph.scalar(.void, span), span);
    }

    return states;
}

const Walker = struct {
    expression: *Expression,
    module: Prepared.Module,
    states: []const State,
    output: Graph.Id,
    bindings: std.ArrayList(Expression.Binding) = .empty,
    returned: bool = false,
    tasks: std.ArrayList(Task) = .empty,
    fn steps(self: *Walker, sequence: []const @import("flow.zig").Step) zx.Error!void {
        const expression = self.expression;

        for (sequence) |step| switch (step.value) {
            .call => |index| try self.call(self.module.calls[index]),
            .parallel => |branches| {
                const count = expression.bindings.items.len;
                var outputs: std.ArrayList(Expression.Binding) = .empty;

                for (branches) |branch| {
                    switch (branch) {
                        .call => |index| try self.call(self.module.calls[index]),
                        .task => |task| {
                            const parent_output = self.output;
                            const parent_returned = self.returned;
                            const offset = expression.span_offset + task.node.location.offset;
                            const span = zx.Span{ .start = offset, .end = offset };
                            const output = try expression.graph.add(.unknown, span);
                            self.output = output;
                            self.returned = false;

                            try self.steps(task.body);
                            if (!self.returned) try expression.graph.unify(output, try expression.graph.scalar(.void, span), span);
                            try self.tasks.append(expression.graph.allocator, .{ .id = task.id, .output = output });

                            self.output = parent_output;
                            self.returned = parent_returned;

                            expression.bindings.shrinkRetainingCapacity(count);
                            try self.bindResult(task.node, output, .task);
                        },
                    }

                    try outputs.appendSlice(expression.graph.allocator, expression.bindings.items[count..]);

                    expression.bindings.shrinkRetainingCapacity(count);
                }

                for (outputs.items, 0..) |binding, index| {
                    for (outputs.items[0..index]) |previous| {
                        if (paths.overlaps(previous.name, binding.name)) return expression.graph.reporter.fail(.name, binding.span, "Parallel result binding paths must not overlap");
                    }

                    try expression.bindings.append(expression.graph.allocator, binding);
                }
            },
            .result => |attribute| {
                const parsed = try parse(expression, self.module.source.path, attribute);
                _ = try expression.infer(parsed, self.output);
                self.returned = true;
            },
            .task => |task| {
                const count = expression.bindings.items.len;

                try self.steps(task.body);

                const output = if (target.optionalAttribute(task.node, "out")) |attribute|
                    try expression.infer(try parse(expression, self.module.source.path, attribute), null)
                else
                    null;

                expression.bindings.shrinkRetainingCapacity(count);
                if (output) |value| try self.bindResult(task.node, value, .task);
            },
            .selection => |selection| {
                const subject = try expression.infer(try parse(expression, self.module.source.path, selection.subject), null);
                const count = expression.bindings.items.len;

                for (selection.cases) |case| {
                    if (case.value) |attribute| {
                        const parsed = try parse(expression, self.module.source.path, attribute);
                        _ = try expression.infer(parsed, subject);
                    }

                    try self.steps(case.body);

                    expression.bindings.shrinkRetainingCapacity(count);
                }
            },
        };
    }
    fn call(self: *Walker, invocation: Prepared.Call) zx.Error!void {
        const expression = self.expression;
        const graph = expression.graph;
        const attribute = target.optionalAttribute(invocation.node, "in");
        const offset = if (attribute) |value| value.value_location.offset else invocation.node.location.offset;
        const span = zx.Span{ .start = expression.span_offset + offset, .end = expression.span_offset + offset };

        const input = switch (invocation.callee) {
            .function => |function| try graph.known(function.program.input_type, span),
            .service => |service| self.states[service].input,
        };

        if (attribute) |value| {
            const parsed = try parse(expression, self.module.source.path, value);
            const count = expression.bindings.items.len;

            for (invocation.getters) |getter| try expression.bindings.append(graph.allocator, .{ .name = getter.name, .value = try graph.known(getter.slot.type_id, span) });

            _ = try expression.infer(parsed, input);

            expression.bindings.shrinkRetainingCapacity(count);
        } else try graph.unify(input, try graph.scalar(.void, span), span);

        const output = switch (invocation.callee) {
            .function => |function| try graph.known(function.program.output_type, span),
            .service => |service| self.states[service].output,
        };

        try self.bindResult(invocation.node, output, .call);
    }

    fn bindResult(self: *Walker, node: rx.ast.Node, output: Graph.Id, kind: enum { call, task }) zx.Error!void {
        const expression = self.expression;
        const graph = expression.graph;
        const result = @import("../result_name.zig").resolve(node);
        expression.attribute = result.attribute;
        const span = expression.sourceSpan(.{ .start = 0, .end = result.attribute.value.len });

        if (!paths.valid(result.name) or std.mem.indexOfScalar(u8, result.name, '.') != null) return graph.reporter.fail(.name, span, "result name must be one identifier; specify Call.name explicitly when the target has no valid name");
        if (kind == .call and std.mem.eql(u8, result.name, "task")) return graph.reporter.fail(.name, span, "Call name task is reserved for Task results; specify a different Call.name");

        const prefix: []const u8 = if (kind == .task) "ctx.task" else "ctx";
        const name = try std.fmt.allocPrint(graph.allocator, "{s}.{s}", .{ prefix, result.name });

        for (expression.bindings.items) |binding| {
            if (paths.overlaps(binding.name, name)) return graph.reporter.fail(.name, span, "named flow results must not overlap; use a distinct name");
        }

        const binding = Expression.Binding{ .name = name, .value = output, .span = span };

        try expression.bindings.append(graph.allocator, binding);
        try self.bindings.append(graph.allocator, binding);
    }
};

fn parse(expression: *Expression, owner: []const u8, attribute: rx.ast.Attribute) zx.Error!*const zx.ast.Expression {
    expression.attribute = attribute;
    const parsed = try @import("../attribute.zig").parse(expression.graph.allocator, attribute, owner);

    if (parsed.value == .diagnostic) {
        const issue = parsed.value.diagnostic;

        return expression.graph.reporter.fail(issue.code, expression.sourceSpan(issue.span), issue.message);
    }

    return parsed.value.parsed.expression;
}
