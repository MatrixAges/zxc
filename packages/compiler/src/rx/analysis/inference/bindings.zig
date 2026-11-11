const zx = @import("zx");
const Graph = @import("types.zig");
const rules = @import("bindings/rules.zig");
const missing_message = "flow value is not defined in this scope";
pub const Use = struct { value: Graph.Id, span: zx.Span };
pub const Collision = struct { left: Graph.Id, right: Graph.Id, span: zx.Span, message: []const u8 };
pub const Lookup = struct { candidates: []const Graph.Id, value: Graph.Id, span: zx.Span };

pub fn isVoid(graph: *const Graph, id: Graph.Id) bool {
    return rules.status(graph, id) == .Void;
}

pub fn requireValue(graph: *Graph, value: Graph.Id, span: zx.Span) zx.Error!void {
    switch (rules.status(graph, value)) {
        .Void => return graph.reporter.fail(.name, span, missing_message),
        .Value => {},
        .Pending => try graph.value_uses.append(graph.allocator, .{ .value = value, .span = span }),
    }
}

pub fn validateUses(graph: *const Graph) zx.Error!void {
    const uses = graph.value_uses.slice();
    const index = rules.missing(graph, uses.items(.value)) orelse return;

    return graph.reporter.fail(.name, uses.items(.span)[index], missing_message);
}

pub fn distinct(graph: *Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, message: []const u8) zx.Error!void {
    switch (rules.pair(graph, left, right, false)) {
        .Ignore => {},
        .Conflict => return graph.reporter.fail(.name, span, message),
        .Defer => try graph.binding_collisions.append(graph.allocator, .{ .left = left, .right = right, .span = span, .message = message }),
    }
}

/// The caller transfers the candidate buffer on success.
pub fn lookup(graph: *Graph, candidates: []const Graph.Id, span: zx.Span) zx.Error!Graph.Id {
    const value = try graph.add(.unknown, span);

    try graph.binding_lookups.append(graph.allocator, .{ .candidates = candidates, .value = value, .span = span });

    return value;
}

pub fn propagate(graph: *Graph, final: bool) zx.Error!void {
    const collisions = graph.binding_collisions.slice();

    if (rules.conflict(graph, collisions.items(.left), collisions.items(.right), final)) |index| {
        return graph.reporter.fail(.name, collisions.items(.span)[index], collisions.items(.message)[index]);
    }

    for (graph.binding_lookups.items) |query| {
        const choice = rules.select(graph, query.candidates);

        if (choice.multiple) continue;

        const candidate = choice.value orelse return graph.reporter.fail(.name, query.span, missing_message);

        try graph.unify(query.value, candidate, query.span);
    }
}
