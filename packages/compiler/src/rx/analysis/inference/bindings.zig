const zx = @import("zx");
const Graph = @import("types.zig");

pub const Collision = struct { left: Graph.Id, right: Graph.Id, span: zx.Span, message: []const u8 };
pub const Lookup = struct { candidates: []const Graph.Id, value: Graph.Id, span: zx.Span };

pub fn isVoid(graph: *const Graph, id: Graph.Id) bool {
    const shape = graph.shape(id);

    return shape == .known and shape.known == @import("frontend").types.scalarId(.void);
}

pub fn distinct(graph: *Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, message: []const u8) zx.Error!void {
    if (isVoid(graph, left) or isVoid(graph, right)) return;
    if (graph.shape(left) != .unknown and graph.shape(right) != .unknown) return graph.reporter.fail(.name, span, message);
    try graph.binding_collisions.append(graph.allocator, .{ .left = left, .right = right, .span = span, .message = message });
}

pub fn lookup(graph: *Graph, candidates: []const Graph.Id, span: zx.Span) zx.Error!Graph.Id {
    const value = try graph.add(.unknown, span);

    try graph.binding_lookups.append(graph.allocator, .{ .candidates = try graph.allocator.dupe(Graph.Id, candidates), .value = value, .span = span });

    return value;
}

pub fn propagate(graph: *Graph, final: bool) zx.Error!void {
    for (graph.binding_collisions.items) |collision| {
        if (isVoid(graph, collision.left) or isVoid(graph, collision.right)) continue;
        if (!final and (graph.shape(collision.left) == .unknown or graph.shape(collision.right) == .unknown)) continue;

        return graph.reporter.fail(.name, collision.span, collision.message);
    }

    for (graph.binding_lookups.items) |query| {
        var selected: ?Graph.Id = null;
        var multiple = false;

        for (query.candidates) |candidate| {
            if (isVoid(graph, candidate)) continue;
            if (selected != null) multiple = true;

            selected = candidate;
        }

        if (multiple) continue;

        const candidate = selected orelse return graph.reporter.fail(.name, query.span, "flow value is not defined in this scope");

        try graph.unify(query.value, candidate, query.span);
    }
}
