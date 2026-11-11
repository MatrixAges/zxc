const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const enabled = @import("rx_options").generated_graph;
const walk_rule = if (enabled) @import("generated_rx_optional_walk") else void;
const known_rule = if (enabled) @import("generated_rx_optional_known") else void;
const View = if (enabled) std.meta.Child(@FieldType(std.meta.Child(walk_rule.Input), "graph")) else void;
const Route = if (enabled) @FieldType(std.meta.Child(walk_rule.Output), "route") else enum { Boundary, Stable, Open, Declared };
const Types = if (enabled) std.meta.Child(@FieldType(View, "types")) else void;
const optional_tag = @backingInt(std.meta.Tag(zx.ir.Type).optional);
const nesting_limit = 256;

const Step = struct {
    value: u32,
    root: Graph.Id,
    remaining: u64,
    route: Route = .Boundary,
};

pub fn guarded(graph: *Graph, source: Graph.Id, span: zx.Span) zx.Error!?Graph.Id {
    const step = walk(graph, source, 1);

    return switch (step.route) {
        .Open => null,
        .Stable, .Boundary => @fromBackingInt(step.value),
        .Declared => try graph.known(@fromBackingInt(step.value), span),
    };
}

pub fn hint(graph: *Graph, source: Graph.Id) zx.Error!?Graph.Id {
    var value = source;

    while (true) {
        const step = walk(graph, value, std.math.maxInt(u64));

        switch (step.route) {
            .Stable => return @fromBackingInt(step.value),
            .Open => return if (graph.nodes.items(.facts)[@backingInt(step.root)].allowed != null) @fromBackingInt(step.value) else null,
            .Declared => value = try register(graph, step),
            .Boundary => unreachable,
        }
    }
}

pub fn payload(graph: *Graph, source: Graph.Id) zx.Error!Graph.Id {
    var value = source;
    var remaining: u64 = nesting_limit;

    while (true) {
        const step = walk(graph, value, remaining);

        switch (step.route) {
            .Stable, .Open => return step.root,
            .Declared => {
                value = try register(graph, step);
                remaining = step.remaining;
            },
            .Boundary => {
                const root = graph.root(@fromBackingInt(step.value));

                return graph.reporter.fail(.unsupported, graph.nodes.items(.facts)[@backingInt(root)].span, "type inference nesting exceeds 256 levels");
            },
        }
    }
}

pub fn accepts(table: zx.ir.TypeTable, actual: zx.ir.TypeId, expected: zx.ir.TypeId) bool {
    if (actual == expected) return true;
    if (table.kinds[@backingInt(expected)] != optional_tag) return false;

    if (!enabled) {
        var current = expected;

        while (current != actual) {
            const index = @backingInt(current);

            if (table.kinds[index] != optional_tag) return false;

            current = @fromBackingInt(table.first[index]);
        }

        return true;
    }

    const types: Types = .{ .kinds = table.kinds, .children = table.first };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return (known_rule.executeValue(empty.allocator(), &.{
        .types = &types,
        .expected = @backingInt(expected),
        .actual = @backingInt(actual),
    }) catch unreachable).accepts;
}

pub fn depth(table: zx.ir.TypeTable, value: zx.ir.TypeId) u64 {
    const index = @backingInt(value);

    if (table.kinds[index] != optional_tag) return 0;

    if (!enabled) {
        var current = index;
        var count: u64 = 0;

        while (table.kinds[current] == optional_tag) : (count += 1) current = table.first[current];

        return count;
    }

    const types: Types = .{ .kinds = table.kinds, .children = table.first };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return (known_rule.executeValue(empty.allocator(), &.{
        .types = &types,
        .expected = index,
        .actual = null,
    }) catch unreachable).depth;
}

fn walk(graph: *const Graph, source: Graph.Id, remaining: u64) Step {
    if (!enabled) return seedWalk(graph, source, remaining);

    const rows = graph.nodes.slice();
    const types: Types = .{ .kinds = graph.types.items.kinds.items, .children = graph.types.items.first.items };
    const view: View = .{ .kinds = rows.items(.kind), .arguments = rows.items(.argument), .types = &types };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = walk_rule.executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .value = @backingInt(source),
        .root = @backingInt(source),
        .remaining = remaining,
        .route = .Boundary,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return .{ .value = result.value, .root = @fromBackingInt(result.root), .remaining = result.remaining, .route = result.route };
}

fn register(graph: *Graph, step: Step) zx.Error!Graph.Id {
    return graph.known(@fromBackingInt(step.value), graph.nodes.items(.facts)[@backingInt(step.root)].span);
}

fn seedWalk(graph: *const Graph, source: Graph.Id, remaining: u64) Step {
    var step: Step = .{ .value = @backingInt(source), .root = source, .remaining = remaining };

    while (step.remaining != 0) {
        step.root = graph.root(@fromBackingInt(step.value));

        switch (graph.shapeAt(@backingInt(step.root))) {
            .optional => |child| {
                step.value = @backingInt(child);
                step.remaining -= 1;
            },
            .known => |declared| {
                const value = graph.types.get(declared);

                if (value == .optional) {
                    step.value = @backingInt(value.optional);
                    step.remaining -= 1;
                    step.route = .Declared;
                } else {
                    step.route = .Stable;
                }

                return step;
            },
            .unknown => {
                step.route = .Open;

                return step;
            },
            else => {
                step.route = .Stable;

                return step;
            },
        }
    }

    return step;
}
