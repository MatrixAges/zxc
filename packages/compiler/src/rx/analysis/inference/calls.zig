const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub fn infer(self: *Expression, expression: *const zx.ast.Expression, expected: ?Graph.Id) zx.Error!Graph.Id {
    const call = expression.value.call;
    const span = self.sourceSpan(expression.span);

    if (call.type_argument != null) return self.graph.reporter.fail(.unsupported, span, "generic calls are not available in RX expressions");
    if (call.callee.value != .field) return self.graph.reporter.fail(.name, span, "RX expressions do not import functions; use Call.fn");

    const field = call.callee.value.field;
    const target = try self.infer(field.target, null);
    const element = try self.graph.payload(target, .list, span);

    if (std.meta.stringToEnum(@FieldType(zx.ir.Transform, "kind"), field.name.text)) |kind| return transform(self, expression, target, element, kind, expected);

    const kind = std.meta.stringToEnum(zx.ir.ListOperation, field.name.text) orelse return self.graph.reporter.fail(.name, span, "unknown list operation");

    const count: usize = switch (kind) {
        .push, .concat => 1,
        .pop, .sort, .reverse => 0,
        .splice => 3,
    };

    if (call.arguments.len != count) return self.graph.reporter.fail(.type_mismatch, span, "list operation argument count mismatch");

    if (kind == .sort) {
        var sortable = Graph.numeric();

        sortable.insert(.string);

        try self.graph.restrict(element, sortable, span);
    }

    for (call.arguments, 0..) |argument, index| {
        const hint = switch (kind) {
            .push => element,
            .concat => target,
            .splice => if (index < 2) try self.graph.scalar(.u64, span) else target,
            else => unreachable,
        };

        _ = try self.infer(argument, hint);
    }

    const result = switch (kind) {
        .pop => try self.graph.add(.{ .optional = element }, span),
        .splice => target,
        else => try self.graph.scalar(.void, span),
    };

    const tuple = try self.graph.allocator.dupe(Graph.Id, &.{ target, result });

    return self.graph.add(.{ .tuple = tuple }, span);
}

fn transform(self: *Expression, expression: *const zx.ast.Expression, target: Graph.Id, element: Graph.Id, kind: @FieldType(zx.ir.Transform, "kind"), expected: ?Graph.Id) zx.Error!Graph.Id {
    const arguments = expression.value.call.arguments;
    const span = self.sourceSpan(expression.span);
    const reducing = kind == .reduce;

    if (arguments.len != @as(usize, if (reducing) 2 else 1)) return self.graph.reporter.fail(.type_mismatch, span, "map/filter/forEach require a callback; reduce requires a callback and initial value");
    if (arguments[0].value != .lambda) return self.graph.reporter.fail(.type_mismatch, self.sourceSpan(arguments[0].span), "collection callback must be an inline lambda");

    const lambda = arguments[0].value.lambda;

    if (lambda.parameters.len != @as(usize, if (reducing) 2 else 1)) return self.graph.reporter.fail(.type_mismatch, span, "callback parameter count does not match the collection operation");

    const accumulator = if (reducing) try self.infer(arguments[1], expected) else null;

    const result = switch (kind) {
        .filter => target,
        .reduce => accumulator.?,
        .forEach => try self.graph.scalar(.void, span),
        .map => expected orelse try self.graph.add(.{ .list = try self.graph.add(.unknown, span) }, span),
    };

    const body_hint: ?Graph.Id = switch (kind) {
        .filter => try self.graph.scalar(.bool, span),
        .reduce => accumulator.?,
        .forEach => null,
        .map => try self.graph.payload(result, .list, span),
    };

    const previous_floor = self.floor;
    const start = self.bindings.items.len;

    self.floor = start;
    self.callback_depth += 1;

    defer {
        self.bindings.shrinkRetainingCapacity(start);

        self.floor = previous_floor;
        self.callback_depth -= 1;
    }

    for (lambda.parameters, 0..) |parameter, index| try self.bindings.append(self.graph.allocator, .{ .name = parameter.text, .value = if (reducing and index == 0) accumulator.? else element });

    _ = try self.infer(lambda.body, body_hint);

    return result;
}
