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

pub fn defaultLists(graph: *Graph, base: @import("assignment.zig").Base) zx.Error!bool {
    var unresolved: ?Sequence = null;

    for (graph.sequences.items) |sequence| {
        if (graph.shape(sequence.value) != .sequence) continue;

        unresolved = sequence;

        var nested = false;

        for (graph.sequences.items) |parent| {
            if (graph.shape(parent.value) != .sequence) continue;

            for (parent.elements) |element| {
                if (try contains(graph, base, element, sequence.value, sequence.span, 0)) nested = true;
            }
        }

        if (nested) continue;

        _ = try graph.payload(sequence.value, .list, sequence.span);

        return true;
    }

    if (unresolved) |sequence| return graph.reporter.fail(.type_mismatch, sequence.span, "sequence construction would require a recursive type");

    return false;
}

fn contains(graph: *Graph, base: @import("assignment.zig").Base, value: Graph.Id, target: Graph.Id, span: zx.Span, depth: usize) zx.Error!bool {
    if (depth >= 256) return graph.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");

    const source = (try base.representative(graph, value)) orelse value;
    const destination = (try base.representative(graph, target)) orelse target;

    if (graph.root(source) == graph.root(destination)) return true;

    switch (graph.shape(source)) {
        .list, .optional => |child| return contains(graph, base, child, target, span, depth + 1),
        .tuple => |children| for (children) |child| {
            if (try contains(graph, base, child, target, span, depth + 1)) return true;
        },
        .object => |fields| for (0..fields.len) |index| {
            const field = syntax.item(fields, index);

            if (try contains(graph, base, field.value, target, span, depth + 1)) return true;
        },
        else => {},
    }

    return false;
}
