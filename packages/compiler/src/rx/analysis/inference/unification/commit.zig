const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Restriction = @import("../scalar/restriction.zig");
const seed = @import("../scalar/seed.zig");

pub fn publish(graph: *Graph, parent: Graph.Id, child: Graph.Id, first: Graph.Node, second: Graph.Node, shape: Graph.Shape, span: zx.Span) zx.Error!void {
    graph.setShape(@backingInt(parent), shape);

    if (!@import("rx_options").generated_graph) return publishSeed(graph, parent, child, first, second, span);

    const generated = @import("generated_rx_unification_commit");
    const parents: []u32 = @constCast(graph.forest.state.items);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeValue(scratch.allocator(), &.{
        .parents = @ptrCast(&parents),
        .graph = &Restriction.borrow(graph, &parents),
        .parent = @backingInt(parent),
        .child = @backingInt(child),
        .left = &.{
            .allowed = if (first.allowed) |allowed| allowed.bits.mask else null,
            .fallback = if (first.fallback) |fallback| @backingInt(fallback) else null,
        },
        .right = &.{
            .allowed = if (second.allowed) |allowed| allowed.bits.mask else null,
            .fallback = if (second.fallback) |fallback| @backingInt(fallback) else null,
        },
    }) catch unreachable;

    graph.nodes.items(.fallback)[@backingInt(parent)] = if (result.fallback) |code| @intCast(code) else null;

    graph.revision += 1;
    graph.object_revision += 1;

    if (result.restriction) |restriction| try Restriction.apply(graph, restriction, span);
}

fn publishSeed(graph: *Graph, parent: Graph.Id, child: Graph.Id, first: Graph.Node, second: Graph.Node, span: zx.Span) zx.Error!void {
    graph.forest.state.items[@backingInt(child)] = @backingInt(parent);

    const constraints = seed.combine(
        .{ .allowed = first.allowed, .fallback = first.fallback },
        .{ .allowed = second.allowed, .fallback = second.fallback },
    );

    graph.nodes.items(.fallback)[@backingInt(parent)] = if (constraints.fallback) |scalar| @backingInt(scalar) else null;

    graph.revision += 1;
    graph.object_revision += 1;

    if (constraints.allowed) |mask| try graph.restrict(parent, mask, span);
}
