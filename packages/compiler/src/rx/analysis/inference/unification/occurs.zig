const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Nodes = @import("../nodes.zig");
const enabled = @import("rx_options").generated_graph;

pub fn check(graph: *const Graph, left: Graph.Id, right: Graph.Id, span: zx.Span) zx.Error!void {
    const rows = graph.nodes.slice();
    const kinds = rows.items(.kind);
    const members = rows.items(.members);
    const a = @backingInt(left);
    const b = @backingInt(right);

    if (!hasChildren(kinds[a], members[a]) and !hasChildren(kinds[b], members[b])) return;

    if (!enabled) {
        if (try contains(graph, left, right, span, 0) or try contains(graph, right, left, span, 0)) return recursive(graph, span);

        return;
    }

    const generated = @import("generated_rx_unification_occurs");
    const Input = @typeInfo(@TypeOf(generated.executeState)).@"fn".param_types[1].?;
    const View = std.meta.Child(@FieldType(Input, "graph"));
    const view: View = .{ .kinds = kinds, .members = members, .arguments = rows.items(.argument) };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .source = a,
        .target = b,
        .depth = 0,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return switch (result.reach) {
        .Absent => {},
        .Present => recursive(graph, span),
        .Depth => depthLimit(graph, span),
    };
}

fn hasChildren(kind: Nodes.Kind, members: []const u32) bool {
    return kind == .List or kind == .Optional or members.len != 0;
}

fn recursive(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, "inference would require a recursive input type");
}

fn depthLimit(graph: *const Graph, span: zx.Span) zx.Error {
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
