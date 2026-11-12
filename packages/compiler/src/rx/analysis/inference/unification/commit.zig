const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Scalar = @import("../scalar.zig");
const seed = @import("../scalar/seed.zig");

pub fn publish(graph: *Graph, parent: Graph.Id, child: Graph.Id, first: Graph.Node, second: Graph.Node, shape: Graph.Shape, span: zx.Span) zx.Error!void {
    graph.setShape(@backingInt(parent), shape);

    const constraints = merge(graph, parent, child, first, second);

    graph.nodes.items(.fallback)[@backingInt(parent)] = if (constraints.fallback) |scalar| @backingInt(scalar) else null;

    graph.revision += 1;
    graph.object_revision += 1;

    if (constraints.allowed) |mask| try graph.restrict(parent, mask, span);
}

fn merge(graph: *Graph, parent: Graph.Id, child: Graph.Id, first: Graph.Node, second: Graph.Node) Scalar.Constraints {
    if (!@import("rx_options").generated_graph) {
        graph.forest.state.items[@backingInt(child)] = @backingInt(parent);

        return seed.combine(
            .{ .allowed = first.allowed, .fallback = first.fallback },
            .{ .allowed = second.allowed, .fallback = second.fallback },
        );
    }

    const generated = @import("generated_rx_unification_commit");
    const parents: []u32 = @constCast(graph.forest.state.items);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeValue(scratch.allocator(), .{
        .parents = @ptrCast(&parents),
        .parent = @backingInt(parent),
        .child = @backingInt(child),
        .left = .{
            .allowed = if (first.allowed) |allowed| allowed.bits.mask else null,
            .fallback = if (first.fallback) |fallback| @backingInt(fallback) else null,
        },
        .right = .{
            .allowed = if (second.allowed) |allowed| allowed.bits.mask else null,
            .fallback = if (second.fallback) |fallback| @backingInt(fallback) else null,
        },
    }) catch unreachable;

    return .{
        .allowed = if (result.allowed) |bits| .{ .bits = .{ .mask = @intCast(bits) } } else null,
        .fallback = if (result.fallback) |code| @fromBackingInt(@intCast(code)) else null,
    };
}
