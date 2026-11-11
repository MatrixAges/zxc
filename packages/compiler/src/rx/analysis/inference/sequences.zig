const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Target = @import("sequences/target.zig").Target;

pub const Sequence = struct { value: Graph.Id, elements: []const Graph.Id, spans: []const zx.Span, span: zx.Span };

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);
    const value = try self.graph.add(.sequence, span);

    if (expected) |target| try self.graph.expect(value, target, span);

    const items = syntax.value(expression).list;
    const elements = try self.graph.allocator.alloc(Graph.Id, items.len);
    const spans = try self.graph.allocator.alloc(zx.Span, items.len);

    for (elements, 0..) |*element, index| {
        const item = syntax.item(items, index);

        spans[index] = self.sourceSpan(item.span);
        element.* = try self.infer(item, null);
    }

    try self.graph.sequences.append(self.graph.allocator, .{ .value = value, .elements = elements, .spans = spans, .span = span });

    return value;
}

pub fn propagate(graph: *Graph, sequence: Sequence) zx.Error!void {
    const target = Target.read(graph, sequence.value);

    switch (target.sequenceRoute(sequence.elements.len)) {
        .Wait => return,
        .Length => return graph.reporter.fail(.type_mismatch, sequence.span, "tuple element count does not match the required type"),
        .Invalid => return graph.reporter.fail(.type_mismatch, sequence.span, "a sequence requires a list or tuple type"),
        .List => {
            if (sequence.elements.len == 0) return;

            const child = try target.child(graph, 0, sequence.spans[0]);

            for (sequence.elements, sequence.spans) |element, span| try graph.expect(element, child, span);
        },
        .Tuple => for (sequence.elements, sequence.spans, 0..) |element, span, index| {
            try graph.expect(element, try target.child(graph, index, span), span);
        },
    }
}
