const zx = @import("zx");
const Graph = @import("types.zig");
const Optional = @import("optional.zig");

pub const Projection = struct { source: Graph.Id, value: Graph.Id, span: zx.Span };

pub fn read(graph: *Graph, source: Graph.Id, span: zx.Span) zx.Error!Graph.Id {
    if (try Optional.guarded(graph, source, span)) |value| return value;

    const value = try graph.add(.unknown, span);

    try graph.nonnull.append(graph.allocator, .{ .source = source, .value = value, .span = span });

    return value;
}

pub fn propagate(graph: *Graph, infer_source: bool) zx.Error!void {
    for (graph.nonnull.items) |projection| {
        if (try Optional.guarded(graph, projection.source, projection.span)) |value| {
            try graph.unify(projection.value, value, projection.span);
        } else if (infer_source and graph.shape(projection.value) != .unknown) {
            const optional = try graph.add(.{ .optional = projection.value }, projection.span);

            try graph.unify(projection.source, optional, projection.span);
        }
    }
}
