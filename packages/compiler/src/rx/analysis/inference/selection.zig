const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const selection = @import("frontend").object_selection;
const Graph = @import("types.zig");
const ObjectClosure = @import("object_closure.zig");
const Expression = @import("expression.zig");

pub const Selection = struct { source: Graph.Id, result: Graph.Id, keys: []const []const u8, omit: bool, span: zx.Span };

pub fn infer(self: *Expression, expression: anytype) zx.Error!Graph.Id {
    if (!selection.matches(expression)) return self.graph.reporter.fail(.unsupported, self.sourceSpan(expression.span), @import("../value_rules.zig").message);

    var reporter: zx.Reporter = .{};

    const keys = selection.keys(self.graph.allocator, expression, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = reporter.diagnostic.?;

        return self.graph.reporter.fail(issue.code, self.sourceSpan(issue.span), issue.message);
    };

    const field = syntax.value(syntax.value(expression).call.callee).field;
    const source = try self.infer(field.target, null);
    const span = self.sourceSpan(expression.span);
    const result = try self.graph.add(.{ .object = &.{} }, span);

    try self.graph.selections.append(self.graph.allocator, .{ .source = source, .result = result, .keys = keys, .omit = std.mem.eql(u8, field.name.text, "omit"), .span = span });

    return result;
}

pub fn propagate(graph: *Graph, closure: *ObjectClosure, value: Selection, final: bool) zx.Error!void {
    if (!try closure.prove(graph, value.source, .selection)) {
        if (final) return graph.reporter.fail(.type_mismatch, value.span, "object selection requires a complete source type; declare Args or Input");

        return;
    }

    if (!@import("rx_options").generated_graph) return @import("selection/seed.zig").apply(graph, value, final);

    return @import("selection/project.zig").apply(graph, value, final);
}
