const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Target = @import("sequences/target.zig");

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
    if (!@import("rx_options").generated_graph) return seedPropagate(graph, sequence);

    const entry = @import("generated_rx_sequence");
    const root = @backingInt(graph.root(sequence.value));
    const view = Target.borrow(entry, graph);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const plan = entry.executeValue(scratch.allocator(), &.{
        .graph = &view,
        .root = root,
        .count = sequence.elements.len,
    }) catch unreachable;

    switch (plan.route) {
        .Wait => return,
        .Length => return lengthMismatch(graph, sequence.span),
        .Invalid => return invalidSequence(graph, sequence.span),
        .List => try expectList(graph, sequence, plan.argument, plan.declared),
        .Tuple => {
            const children = if (plan.declared)
                view.type_children[plan.argument..][0..sequence.elements.len]

            else
                view.members[root];

            for (sequence.elements, sequence.spans, children) |element, span, child| {
                try graph.expect(element, try Target.child(graph, child, plan.declared, span), span);
            }
        },
    }
}

fn seedPropagate(graph: *Graph, sequence: Sequence) zx.Error!void {
    const target = Target.Seed.read(graph, sequence.value);

    switch (target.sequenceRoute(sequence.elements.len)) {
        .Wait => return,
        .Length => return lengthMismatch(graph, sequence.span),
        .Invalid => return invalidSequence(graph, sequence.span),
        .List => {
            const child = target.member(0);

            try expectList(graph, sequence, child.value, child.declared);
        },
        .Tuple => for (sequence.elements, sequence.spans, 0..) |element, span, index| {
            const child = target.member(index);

            try graph.expect(element, try Target.child(graph, child.value, child.declared, span), span);
        },
    }
}

fn expectList(graph: *Graph, sequence: Sequence, child: u32, declared: bool) zx.Error!void {
    if (sequence.elements.len == 0) return;

    const member = try Target.child(graph, child, declared, sequence.spans[0]);

    for (sequence.elements, sequence.spans) |element, span| try graph.expect(element, member, span);
}

fn lengthMismatch(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, "tuple element count does not match the required type");
}

fn invalidSequence(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, "a sequence requires a list or tuple type");
}
