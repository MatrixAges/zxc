const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Target = @import("sequences/target.zig").Target;
const Projections = @import("projections.zig");

pub const Projection = struct { target: Graph.Id, value: Graph.Id, position: ?u64, span: zx.Span, index_span: zx.Span, resolved: bool = false };

pub fn infer(self: *Expression, source: anytype) zx.Error!Graph.Id {
    const item = syntax.value(source).index;
    const span = self.sourceSpan(source.span);
    const target = try self.infer(item.target, null);

    _ = try self.infer(item.index, try self.graph.scalar(.u64, span));

    const value = try self.graph.add(.unknown, span);
    const projection = Projection{ .target = target, .value = value, .position = try literalIndex(self, item.index), .span = span, .index_span = self.sourceSpan(item.index.span) };

    if (!try propagate(self.graph, projection)) try self.graph.indexes.append(self.graph.allocator, projection);

    return value;
}

pub fn propagate(graph: *Graph, projection: Projection) zx.Error!bool {
    const target = Target.read(graph, projection.target);

    const value = switch (target.indexRoute(projection.position)) {
        .Wait => return false,
        .List => try target.child(graph, 0, projection.span),
        .Tuple => try target.child(graph, @intCast(projection.position.?), projection.span),
        .String => try graph.scalar(.u8, projection.span),
        .MissingLiteral => return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple indexing requires an integer literal"),
        .OutOfBounds => return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple index is out of bounds"),
        .Invalid => return graph.reporter.fail(.type_mismatch, projection.span, "indexing requires a list, tuple or string"),
    };

    try graph.unify(value, projection.value, projection.span);

    return true;
}

pub fn replay(graph: *Graph) zx.Error!void {
    const indexes = graph.indexes.slice();
    const resolved = indexes.items(.resolved);

    if (!@import("rx_options").generated_graph) {
        for (resolved, 0..) |*done, index| {
            if (!done.*) done.* = try propagate(graph, indexes.get(index));
        }

        return;
    }

    const targets = indexes.items(.target);
    var start: usize = 0;

    while (Projections.next(graph, targets, resolved, .Index, start)) |index| {
        resolved[index] = try propagate(graph, indexes.get(index));
        start = index + 1;
    }
}

pub fn isResult(graph: *const Graph, id: Graph.Id) bool {
    const indexes = graph.indexes.slice();

    for (indexes.items(.value), indexes.items(.resolved)) |value, resolved| {
        if (!resolved and graph.root(value) == graph.root(id)) return true;
    }

    return false;
}

pub fn defaultLists(graph: *Graph) zx.Error!bool {
    const indexes = graph.indexes.slice();

    const index = if (@import("rx_options").generated_graph)
        findList(graph, indexes)

    else
        seedList(graph, indexes);

    const projection = indexes.get(index orelse return false);
    const value = try graph.payload(projection.target, .list, projection.span);

    try graph.unify(value, projection.value, projection.span);

    return true;
}

const Rows = std.MultiArrayList(Projection).Slice;

fn findList(graph: *const Graph, indexes: Rows) ?usize {
    if (indexes.len == 0) return null;

    const generated = @import("generated_rx_index_default_list");
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeState(empty.allocator(), .{
        .targets = .{ .items = @ptrCast(indexes.items(.target)), .storage = .plain },
        .kinds = .{ .items = graph.nodes.items(.kind), .storage = .plain },
        .parents = graph.forest.state,
        .index = null,
        .position = 0,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return if (result.index) |index| @intCast(index) else null;
}

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
