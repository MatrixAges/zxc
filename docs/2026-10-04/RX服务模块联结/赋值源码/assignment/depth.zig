const zx = @import("zx");
const Graph = @import("../types.zig");
const Bound = struct { lower: usize = 0, upper: ?usize = null, prefer_lower: bool = false };

pub fn solve(graph: *Graph) zx.Error![]usize {
    const bounds = try graph.allocator.alloc(Bound, graph.nodes.items.len);

    defer graph.allocator.free(bounds);
    @memset(bounds, .{});

    for (graph.nodes.items, bounds) |node, *bound| {
        switch (node.shape) {
            .known => |id| {
                var current = id;
                var depth: usize = 0;

                while (graph.types.get(current) == .optional) : (depth += 1) current = graph.types.get(current).optional;

                bound.* = .{ .lower = depth, .upper = depth, .prefer_lower = true };
            },
            .optional => bound.* = .{ .lower = 1, .prefer_lower = true },
            .unknown => if (node.allowed != null) {
                bound.* = .{ .upper = 0, .prefer_lower = true };
            },
            else => bound.* = .{ .upper = 0, .prefer_lower = true },
        }
    }

    try propagate(graph, bounds);

    for (bounds) |*bound| {
        if (bound.prefer_lower) bound.upper = bound.lower;
    }

    try propagate(graph, bounds);

    for (bounds) |*bound| {
        if (bound.upper) |upper| bound.lower = upper;
    }

    try propagate(graph, bounds);

    const result = try graph.allocator.alloc(usize, bounds.len);

    for (result, bounds) |*value, bound| value.* = bound.lower;

    return result;
}

fn propagate(graph: *Graph, bounds: []Bound) zx.Error!void {
    for (0..bounds.len + 1) |_| {
        var changed = false;

        for (graph.assignments.items) |edge| {
            const actual = &bounds[@intFromEnum(graph.root(edge.value))];
            const expected = &bounds[@intFromEnum(graph.root(edge.expected))];
            changed = raise(expected, actual.lower) or changed;
            changed = lower(actual, expected.upper) or changed;

            if (actual.prefer_lower and !expected.prefer_lower) {
                expected.prefer_lower = true;
                changed = true;
            }

            try check(graph, actual.*, edge.span);
            try check(graph, expected.*, edge.span);
        }

        for (graph.nodes.items, 0..) |node, index| {
            if (graph.root(@enumFromInt(index)) != @as(Graph.Id, @enumFromInt(index)) or node.shape != .optional) continue;

            const parent = &bounds[index];
            const child = &bounds[@intFromEnum(graph.root(node.shape.optional))];
            changed = raise(parent, child.lower + 1) or changed;
            changed = raise(child, parent.lower - 1) or changed;

            if (child.upper) |upper| changed = lower(parent, upper + 1) or changed;

            if (parent.upper) |upper| {
                if (upper == 0) return graph.reporter.fail(.type_mismatch, node.span, "optional input cannot satisfy a non-optional requirement");

                changed = lower(child, upper - 1) or changed;
            }

            if (parent.prefer_lower != child.prefer_lower) {
                parent.prefer_lower = true;
                child.prefer_lower = true;
                changed = true;
            }

            try check(graph, parent.*, node.span);
            try check(graph, child.*, node.span);
        }

        if (!changed) return;
    }

    const span = if (graph.assignments.items.len != 0) graph.assignments.items[0].span else graph.nodes.items[0].span;

    return graph.reporter.fail(.type_mismatch, span, "inference would require a recursive optional type");
}

fn raise(bound: *Bound, value: usize) bool {
    if (value <= bound.lower) return false;

    bound.lower = value;

    return true;
}

fn lower(bound: *Bound, value: ?usize) bool {
    const limit = value orelse return false;

    if (bound.upper != null and bound.upper.? <= limit) return false;

    bound.upper = limit;

    return true;
}

fn check(graph: *Graph, bound: Bound, span: zx.Span) zx.Error!void {
    if (bound.upper != null and bound.lower > bound.upper.?) return graph.reporter.fail(.type_mismatch, span, "incompatible optional input requirements");
}
