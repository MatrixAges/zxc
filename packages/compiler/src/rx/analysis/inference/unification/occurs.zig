const zx = @import("zx");
const Graph = @import("../types.zig");
const Nodes = @import("../nodes.zig");

pub fn check(graph: *const Graph, left: Graph.Id, right: Graph.Id, span: zx.Span) zx.Error!void {
    const rows = graph.nodes.slice();
    const kinds = rows.items(.kind);
    const members = rows.items(.members);
    const a = @backingInt(left);
    const b = @backingInt(right);

    if (!hasChildren(kinds[a], members[a]) and !hasChildren(kinds[b], members[b])) return;
    if (try contains(graph, left, right, span, 0) or try contains(graph, right, left, span, 0)) return recursive(graph, span);
}

fn hasChildren(kind: Nodes.Kind, members: []const u32) bool {
    return kind == .List or kind == .Optional or (kind != .Known and members.len != 0);
}

pub fn recursive(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, "inference would require a recursive input type");
}

pub fn depthLimit(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");
}

fn contains(self: *const Graph, parent: Graph.Id, child: Graph.Id, span: zx.Span, depth: usize) zx.Error!bool {
    if (depth >= 256) return depthLimit(self, span);

    const root = self.root(parent);

    if (root == child) return true;

    switch (self.shapeAt(@backingInt(root))) {
        .list, .optional => |nested| return contains(self, nested, child, span, depth + 1),
        .tuple => |items| for (items) |item| {
            if (try contains(self, item, child, span, depth + 1)) return true;
        },
        .object => |fields| for (fields.values()) |value| {
            if (try contains(self, value, child, span, depth + 1)) return true;
        },
        else => {},
    }

    return false;
}
