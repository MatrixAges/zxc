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

pub const State = struct { input: Graph.Id, output: Graph.Id, input_used: bool = false, bindings: []const Expression.Binding = &.{} };

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

        for (module.calls) |call| {
            const attribute = target.attribute(call.node, "in");
            const parsed = try parse(&expression, module.source.path, attribute);
            const span = expression.sourceSpan(parsed.span);

            const input = switch (call.callee) {
                .function => |function| try graph.known(function.program.input_type, span),
                .service => |service| states[service].input,
            };

            _ = try expression.infer(parsed, input);

            for (call.node.attributes) |out| {
                if (!std.mem.eql(u8, out.name, "out")) continue;

                expression.attribute = out;
                const out_span = expression.sourceSpan(.{ .start = 0, .end = out.value.len });

                if (!paths.valid(out.value) or paths.overlaps(out.value, "$in")) return graph.reporter.fail(.name, out_span, "Call.out requires a result binding path distinct from the module input");

                for (expression.bindings.items) |binding| {
                    if (paths.overlaps(binding.name, out.value)) return graph.reporter.fail(.name, out_span, "flow result binding paths must not overlap");
                }

                const output = switch (call.callee) {
                    .function => |function| try graph.known(function.program.output_type, out_span),
                    .service => |service| states[service].output,
                };

                try expression.bindings.append(graph.allocator, .{ .name = try graph.allocator.dupe(u8, out.value), .value = output });
            }
        }

        if (module.returned) |attribute| {
            const parsed = try parse(&expression, module.source.path, attribute);
            _ = try expression.infer(parsed, state.output);
        } else {
            try graph.unify(state.output, try graph.scalar(.void, graph.nodes.items[@intFromEnum(state.output)].span), graph.nodes.items[@intFromEnum(state.output)].span);
        }

        state.input_used = expression.input_used;
        state.bindings = expression.bindings.items;
    }

    for (states) |state| {
        if (state.input_used) continue;

        var referenced = false;

        for (graph.assignments.items) |edge| {
            if (graph.root(edge.value) == graph.root(state.input) or graph.root(edge.expected) == graph.root(state.input)) referenced = true;
        }

        if (referenced) continue;

        const span = graph.nodes.items[@intFromEnum(state.input)].span;

        try graph.unify(state.input, try graph.scalar(.void, span), span);
    }

    return states;
}

fn parse(expression: *Expression, owner: []const u8, attribute: rx.ast.Attribute) zx.Error!*const zx.ast.Expression {
    expression.attribute = attribute;
    const parsed = try frontend.parseExpression(expression.graph.allocator, attribute.value, owner);

    if (parsed.value == .diagnostic) {
        const issue = parsed.value.diagnostic;

        return expression.graph.reporter.fail(issue.code, expression.sourceSpan(issue.span), issue.message);
    }

    return parsed.value.parsed.expression;
}
