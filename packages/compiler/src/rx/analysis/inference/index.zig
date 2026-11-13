const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Target = @import("sequences/target.zig");
const Projections = @import("projections.zig");

pub const Projection = struct { target: Graph.Id, value: Graph.Id, position: ?u64, span: zx.Span, index_span: zx.Span, resolved: bool = false };

pub fn infer(self: *Expression, source: anytype) zx.Error!Graph.Id {
    const item = syntax.value(source).index;
    const span = self.sourceSpan(source.span);
    const target = try self.infer(item.target, null);

    _ = try self.infer(item.index, try self.graph.scalar(.u64, span));

    const value = try self.graph.add(.unknown, span);
    const projection = Projection{ .target = target, .value = value, .position = try literalIndex(self, item.index), .span = span, .index_span = self.sourceSpan(item.index.span) };

    if (!try propagate(self.graph, projection)) try self.graph.pending.indexes.append(self.graph.pending.allocator, projection);

    return value;
}

pub fn propagate(graph: *Graph, projection: Projection) zx.Error!bool {
    if (!@import("rx_options").generated_graph) return seedPropagate(graph, projection);

    const entry = @import("generated_rx_index");
    const root = graph.root(projection.target);
    const view = Target.borrow(entry, graph);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const plan = entry.executeValue(scratch.allocator(), .{
        .graph = &view,
        .root = @backingInt(root),
        .position = projection.position,
    }) catch unreachable;

    return apply(graph, projection, plan.route, plan.child, plan.declared);
}

fn seedPropagate(graph: *Graph, projection: Projection) zx.Error!bool {
    const target = Target.Seed.read(graph, projection.target);
    const route = target.indexRoute(projection.position);

    const child: Target.Seed.Child = switch (route) {
        .List => target.member(0),
        .Tuple => target.member(@intCast(projection.position.?)),
        else => .{ .value = 0, .declared = false },
    };

    return apply(graph, projection, route, child.value, child.declared);
}

fn apply(graph: *Graph, projection: Projection, route: anytype, child: u32, declared: bool) zx.Error!bool {
    const value = switch (route) {
        .Wait => return false,
        .List, .Tuple => try Target.child(graph, child, declared, projection.span),
        .String => try graph.scalar(.u8, projection.span),
        .MissingLiteral => return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple indexing requires an integer literal"),
        .OutOfBounds => return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple index is out of bounds"),
        .Invalid => return graph.reporter.fail(.type_mismatch, projection.span, "indexing requires a list, tuple or string"),
    };

    try graph.unify(value, projection.value, projection.span);

    return true;
}

pub fn replay(graph: *Graph) zx.Error!void {
    const indexes = graph.pending.indexes.slice();
    const resolved = indexes.items(.resolved);

    if (!@import("rx_options").generated_graph) {
        for (resolved, 0..) |*done, index| {
            if (!done.*) done.* = try seedPropagate(graph, indexes.get(index));
        }

        return;
    }

    const entry = @import("generated_rx_index_replay");
    var scratch = std.heap.FixedBufferAllocator.init(&.{});
    var start: usize = 0;

    while (start < indexes.len) {
        const view = Target.borrow(entry, graph);
        const parents: []u32 = @constCast(graph.forest.state.items);

        const plan = entry.executeValue(scratch.allocator(), &.{
            .graph = &view,
            .parents = @ptrCast(&parents),
            .targets = @ptrCast(indexes.items(.target)),
            .resolved = resolved,
            .positions = indexes.items(.position),
            .start = start,
        }) catch unreachable;

        if (!plan.found) return;

        const row: usize = @intCast(plan.row);
        resolved[row] = try apply(graph, indexes.get(row), plan.route, plan.child, plan.declared);
        start = row + 1;
    }
}

pub fn isResult(graph: *const Graph, id: Graph.Id) bool {
    const indexes = graph.pending.indexes.slice();

    for (indexes.items(.value), indexes.items(.resolved)) |value, resolved| {
        if (!resolved and graph.root(value) == graph.root(id)) return true;
    }

    return false;
}

pub fn defaultLists(graph: *Graph) zx.Error!bool {
    const indexes = graph.pending.indexes.slice();

    const index = if (@import("rx_options").generated_graph)
        if (Projections.next(graph, indexes.items(.target), &.{}, .DefaultIndex, 0)) |result| result.row else null

    else
        seedList(graph, indexes);

    const projection = indexes.get(index orelse return false);
    const value = try graph.payload(projection.target, .list, projection.span);

    try graph.unify(value, projection.value, projection.span);

    return true;
}

const Rows = std.MultiArrayList(Projection).Slice;

fn seedList(graph: *const Graph, indexes: Rows) ?usize {
    for (indexes.items(.target), 0..) |target, index| {
        if (graph.shape(target) == .unknown) return index;
    }

    return null;
}

fn literalIndex(self: *Expression, source: anytype) zx.Error!?u64 {
    if (syntax.value(source) != .number) return null;

    return @import("frontend").parseInteger(self.graph.allocator, syntax.value(source).number);
}
