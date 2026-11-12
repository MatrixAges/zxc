const std = @import("std");
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
    if (!@import("rx_options").generated_graph) return seed(graph, infer_source);

    const projections = graph.nonnull.slice();

    if (projections.len == 0) return;

    const generated = @import("generated_rx_non_null_scan");
    const Request = @typeInfo(@TypeOf(generated.executeState)).@"fn".param_types[1].?;
    const View = std.meta.Child(@FieldType(Request, "graph"));
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var start: usize = 0;

    while (start < projections.len) {
        const rows = graph.nodes.slice();

        const view: View = .{
            .kinds = rows.items(.kind),
            .arguments = rows.items(.argument),
            .types = &.{ .kinds = graph.types.items.kinds.items, .children = graph.types.items.first.items },
        };

        const action = generated.executeState(empty.allocator(), .{
            .graph = &view,
            .parents = graph.forest.state,
            .sources = .{ .items = @ptrCast(projections.items(.source)), .storage = .plain },
            .values = .{ .items = @ptrCast(projections.items(.value)), .storage = .plain },
            .infer_source = infer_source,
            .next = start,
            .value = 0,
            .action = .Wait,
        }) catch unreachable;

        std.debug.assert(action.parents.items.ptr == graph.forest.state.items.ptr);

        if (action.action == .Wait) break;

        start = @intCast(action.next);

        const projection = projections.get(start - 1);

        switch (action.action) {
            .Unify => try graph.unify(projection.value, @fromBackingInt(action.value), projection.span),
            .Register => try graph.unify(projection.value, try graph.known(@fromBackingInt(action.value), projection.span), projection.span),
            .Infer => try infer(graph, projection),
            .Wait => unreachable,
        }
    }
}

fn seed(graph: *Graph, infer_source: bool) zx.Error!void {
    const projections = graph.nonnull.slice();

    for (0..projections.len) |index| {
        const projection = projections.get(index);

        if (try Optional.guarded(graph, projection.source, projection.span)) |value| {
            try graph.unify(projection.value, value, projection.span);
        } else if (infer_source and graph.shape(projection.value) != .unknown) {
            try infer(graph, projection);
        }
    }
}

fn infer(graph: *Graph, projection: Projection) zx.Error!void {
    const optional = try graph.add(.{ .optional = projection.value }, projection.span);

    try graph.unify(projection.source, optional, projection.span);
}
