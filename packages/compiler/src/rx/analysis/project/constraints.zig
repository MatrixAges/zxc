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
const State = struct { input: Graph.Id, output: Graph.Id, input_fixed: bool, bindings: []const Expression.Binding = &.{}, tasks: []const Task = &.{} };
pub const States = std.MultiArrayList(State).Slice;
pub const Task = struct { id: usize, output: Graph.Id };

pub fn collect(graph: *Graph, modules: []const Prepared.Module, source_map: SourceMap) zx.Error!States {
    var storage: std.MultiArrayList(State) = .empty;

    try storage.ensureTotalCapacity(graph.allocator, modules.len);

    const declared = try @import("contracts.zig").resolve(graph, modules, source_map);
    var port: usize = 0;

    for (modules, 0..) |module, index| {
        const offset = source_map.base(index) + module.source.node.location.offset;
        const span = zx.Span{ .start = offset, .end = offset };
        var input: ?zx.ir.TypeId = null;
        var output: ?zx.ir.TypeId = null;

        while (port < declared.len and declared[port].module == index) : (port += 1) {
            switch (declared[port].kind) {
                .input => input = declared[port].type_id,
                .output => output = declared[port].type_id,
            }
        }

        storage.appendAssumeCapacity(.{
            .input = if (input) |id| try graph.known(id, span) else try graph.add(.unknown, span),
            .output = if (output) |id| try graph.known(id, span) else try graph.add(.unknown, span),
            .input_fixed = input != null,
        });
    }

    const states = storage.slice();
    const inputs = states.items(.input);
    const outputs = states.items(.output);
    const fixed = states.items(.input_fixed);
    const bindings = states.items(.bindings);
    const tasks = states.items(.tasks);
    var unused: usize = 0;

    for (modules, 0..) |module, index| {
        const location = module.source.node.location;
        const input = inputs[index];
        const output = outputs[index];

        var expression = Expression{
            .graph = graph,
            .aliases = module.value_imports,
            .input = input,
            .attribute = .{ .name = "", .value = "", .location = location, .value_location = location },
            .span_offset = source_map.base(index),
        };

        var walker = Walker{ .expression = &expression, .module = module, .states = states, .output = output };

        if (module.shortcut) |call_index| {
            const call = module.calls[call_index];
            const callee = call.callee.module;
            const span = graph.nodes.items(.span)[@backingInt(input)];

            try graph.unify(input, inputs[callee], span);
            try graph.unify(output, outputs[callee], span);
            try walker.bindResult(call.node, output, .call);

            fixed[index] = true;
            bindings[index] = walker.bindings.items;

            continue;
        }

        try walker.steps(module.steps);

        if (!walker.returned) {
            const span = graph.nodes.items(.span)[@backingInt(output)];

            try graph.unify(output, try graph.scalar(.void, span), span);
        }

        fixed[index] = fixed[index] or expression.input_used;
        unused += @intFromBool(!fixed[index]);
        bindings[index] = walker.bindings.items;
        tasks[index] = walker.tasks.items;
    }

    try @import("input_defaults.zig").apply(graph, inputs, fixed, unused);

    return states;
}

const Walker = struct {
    expression: *Expression,
    module: Prepared.Module,
    states: States,
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
                        if (paths.overlaps(previous.name, binding.name)) try @import("../inference/bindings.zig").distinct(expression.graph, previous.value, binding.value, binding.span, "Parallel result binding paths must not overlap");
                    }

                    try expression.bindings.append(expression.graph.allocator, binding);
                }
            },
            .result => |attribute| {
                _ = try inferAttribute(expression, self.module.source.path, attribute, self.output);
                self.returned = true;
            },
            .task => |task| {
                const count = expression.bindings.items.len;

                try self.steps(task.body);

                const output = if (target.optionalAttribute(task.node, "out")) |attribute|
                    try inferAttribute(expression, self.module.source.path, attribute, null)
                else
                    null;

                expression.bindings.shrinkRetainingCapacity(count);
                if (output) |value| try self.bindResult(task.node, value, .task);
            },
            .selection => |selection| {
                const condition = @import("../condition.zig");
                const owner = self.module.source.path;
                const allocator = expression.graph.allocator;
                var parsed = try @import("../attribute.zig").parse(allocator, selection.subject, owner);

                defer parsed.deinit();

                const subject = try inferParsedAttribute(expression, &parsed, selection.subject, null);
                const count = expression.bindings.items.len;

                for (selection.cases) |case| {
                    const truth = if (case.value) |attribute| label: {
                        var label = try @import("../attribute.zig").parse(allocator, attribute, owner);

                        defer label.deinit();

                        _ = try inferParsedAttribute(expression, &label, attribute, subject);

                        break :label condition.boolean(&label);
                    } else try condition.defaultTruth(allocator, owner, selection.cases);

                    const facts = expression.nonnull.items.len;

                    if (truth) |present| {
                        try condition.assumeParsed(expression.graph.scratch, &parsed, present, expression);
                    }

                    try self.steps(case.body);

                    expression.nonnull.shrinkRetainingCapacity(facts);
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
            .module => |module_index| self.states.items(.input)[module_index],
            .signature => |signature| try graph.known(signature.input_type, span),
        };

        if (attribute) |value| {
            expression.attribute = value;
            const count = expression.bindings.items.len;

            for (invocation.getters) |getter| try expression.bindings.append(graph.allocator, .{ .name = getter.name, .value = try graph.known(getter.slot.type_id, span) });

            _ = try inferAttribute(expression, self.module.source.path, value, input);

            expression.bindings.shrinkRetainingCapacity(count);
        } else try graph.unify(input, try graph.scalar(.void, span), span);

        const output = switch (invocation.callee) {
            .function => |function| try graph.known(function.program.output_type, span),
            .module => |module_index| self.states.items(.output)[module_index],
            .signature => |signature| try graph.known(signature.output_type, span),
        };

        try self.bindResult(invocation.node, output, .call);
    }

    fn bindResult(self: *Walker, node: rx.ast.Node, output: Graph.Id, kind: enum { call, task }) zx.Error!void {
        const expression = self.expression;
        const graph = expression.graph;
        const result = @import("../result_name.zig").resolve(node);
        expression.attribute = result.attribute;
        const span = expression.sourceSpan(.{ .start = 0, .end = result.attribute.value.len });

        if (!paths.valid(result.name) or std.mem.indexOfScalar(u8, result.name, '.') != null) return graph.reporter.fail(.name, span, "result name must be one identifier; Call targets must have a valid filename");
        if (kind == .call and std.mem.eql(u8, result.name, "task")) return graph.reporter.fail(.name, span, "Call target name task is reserved for Task results");

        const prefix: []const u8 = if (kind == .task) "$ctx.task" else "$ctx";
        const name = try std.fmt.allocPrint(graph.allocator, "{s}.{s}", .{ prefix, result.name });
        const binding = Expression.Binding{ .name = name, .value = output, .span = span };

        try self.bindings.append(graph.allocator, binding);
        if (@import("../inference/bindings.zig").isVoid(graph, output)) return;

        for (expression.bindings.items) |previous| {
            if (paths.overlaps(previous.name, name)) try @import("../inference/bindings.zig").distinct(graph, previous.value, output, span, "flow result paths must not overlap; each visible Call target name must be unique");
        }

        try expression.bindings.append(graph.allocator, binding);
    }
};

fn inferAttribute(expression: *Expression, owner: []const u8, attribute: rx.ast.Attribute, expected: ?Graph.Id) zx.Error!Graph.Id {
    var parsed = try @import("../attribute.zig").parse(expression.graph.allocator, attribute, owner);

    defer parsed.deinit();

    return inferParsedAttribute(expression, &parsed, attribute, expected);
}

fn inferParsedAttribute(expression: *Expression, parsed: *const frontend.ExpressionInput.Result, attribute: rx.ast.Attribute, expected: ?Graph.Id) zx.Error!Graph.Id {
    expression.attribute = attribute;
    const allocator = expression.graph.allocator;

    if (parsed.diagnostic()) |issue| {
        const message = try allocator.dupe(u8, issue.message);

        return expression.graph.reporter.fail(issue.code, expression.sourceSpan(issue.span), message);
    }

    return switch (parsed.*) {
        .native => |result| expression.infer(result.value.parsed.expression, expected),
        .indexed => |result| if (@import("frontend").ExpressionInput.indexed_enabled) block: {
            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const view = try result.view(scratch.allocator());

            break :block try expression.infer(view.expression(result.output.result), expected);
        } else unreachable,
    };
}
