const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub const Sequence = struct { value: Graph.Id, elements: []const Graph.Id, spans: []const zx.Span, span: zx.Span };

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);
    const value = try self.graph.add(.sequence, span);

    if (expected) |target| try self.graph.expect(value, target, span);

    const items = syntax.value(expression).list;
    const elements = try self.graph.allocator.alloc(Graph.Id, items.len);
    const spans = try self.graph.allocator.alloc(zx.Span, items.len);
    const sequence = Sequence{ .value = value, .elements = elements, .spans = spans, .span = span };

    try checkLength(self.graph, sequence);

    for (elements, 0..) |*element, index| {
        const item = syntax.item(items, index);

        spans[index] = self.sourceSpan(item.span);
        element.* = try self.infer(item, try hint(self.graph, sequence, index));
    }

    try self.graph.sequences.append(self.graph.allocator, sequence);

    return value;
}

pub fn propagate(graph: *Graph, sequence: Sequence) zx.Error!void {
    try checkLength(graph, sequence);

    for (sequence.elements, 0..) |element, index| {
        if (try hint(graph, sequence, index)) |target| try graph.expect(element, target, sequence.spans[index]);
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

fn checkLength(graph: *Graph, sequence: Sequence) zx.Error!void {
    const shape = graph.shape(sequence.value);

    const count: ?usize = switch (shape) {
        .tuple => |items| items.len,
        .known => |id| if (graph.types.get(id) == .tuple) graph.types.get(id).tuple.len else null,
        else => null,
    };

    if (count) |length| {
        if (length != sequence.elements.len) return graph.reporter.fail(.type_mismatch, sequence.span, "tuple element count does not match the required type");
    }
}

fn hint(graph: *Graph, sequence: Sequence, index: usize) zx.Error!?Graph.Id {
    return switch (graph.shape(sequence.value)) {
        .sequence => null,
        .list => |child| child,
        .tuple => |items| items[index],
        .known => |id| switch (graph.types.get(id)) {
            .list => |child| try graph.known(child, sequence.spans[index]),
            .tuple => |items| try graph.known(items.at(index), sequence.spans[index]),
            else => graph.reporter.fail(.type_mismatch, sequence.span, "a sequence requires a list or tuple type"),
        },
        else => graph.reporter.fail(.type_mismatch, sequence.span, "a sequence requires a list or tuple type"),
    };
}
