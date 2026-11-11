const zx = @import("zx");
const Graph = @import("../../types.zig");
const Base = @import("../../assignment/base.zig");
const Sequence = @import("../../sequences.zig").Sequence;

pub fn apply(graph: *Graph, base: Base) zx.Error!bool {
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

fn contains(graph: *Graph, base: Base, value: Graph.Id, target: Graph.Id, span: zx.Span, depth: usize) zx.Error!bool {
    if (depth >= 256) return graph.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");

    const source = (try base.representative(graph, value)) orelse value;
    const destination = (try base.representative(graph, target)) orelse target;

    if (graph.root(source) == graph.root(destination)) return true;

    switch (graph.shape(source)) {
        .list, .optional => |child| return contains(graph, base, child, target, span, depth + 1),
        .tuple => |children| for (children) |child| {
            if (try contains(graph, base, child, target, span, depth + 1)) return true;
        },
        .object => |fields| for (fields) |field| {
            if (try contains(graph, base, field.value, target, span, depth + 1)) return true;
        },
        else => {},
    }

    return false;
}
