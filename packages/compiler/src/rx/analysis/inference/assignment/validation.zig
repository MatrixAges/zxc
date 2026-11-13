const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Edges = std.MultiArrayList(@import("../assignment.zig").Edge).Slice;

pub fn validate(graph: *Graph) zx.Error!void {
    const edges = graph.pending.assignments.slice();

    if (!@import("rx_options").generated_graph) return seed(graph, edges);
    if (edges.len == 0) return;

    const generated = @import("generated_assignment_validation");
    const Request = @typeInfo(@TypeOf(generated.executeState)).@"fn".param_types[1].?;
    const View = std.meta.Child(@FieldType(Request, "graph"));
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var index: usize = 0;
    var source: ?u32 = null;
    var target: ?u32 = null;

    while (index < edges.len) {
        const rows = graph.nodes.slice();

        const view: View = .{
            .kinds = rows.items(.kind),
            .arguments = rows.items(.argument),
            .types = &.{ .kinds = graph.types.items.kinds.items, .children = graph.types.items.first.items },
        };

        const result = generated.executeState(empty.allocator(), .{
            .graph = &view,
            .edges = .{ .left = .{ .items = @ptrCast(edges.items(.value)), .storage = .plain }, .right = .{ .items = @ptrCast(edges.items(.expected)), .storage = .plain } },
            .parents = graph.forest.state,
            .index = index,
            .source_type = source,
            .target_type = target,
            .node = 0,
            .action = .Scan,
        }) catch unreachable;

        std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

        index = @intCast(result.index);

        switch (result.action) {
            .Scan => return,
            .ResolveSource => {
                source = @backingInt(try graph.resolve(@fromBackingInt(result.node)));
                target = null;
            },
            .ResolveTarget => {
                source = result.source_type;
                target = @backingInt(try graph.resolve(@fromBackingInt(result.node)));
            },
            .Mismatch => return mismatch(graph, edges.items(.span)[index]),
        }
    }
}

fn seed(graph: *Graph, edges: Edges) zx.Error!void {
    for (edges.items(.value), edges.items(.expected), edges.items(.span)) |source, target, span| {
        const actual = try graph.resolve(source);
        const expected = try graph.resolve(target);

        if (!seedAccepts(graph.types.items.view(), actual, expected)) return mismatch(graph, span);
    }
}

fn seedAccepts(table: zx.ir.TypeTable, actual: zx.ir.TypeId, expected: zx.ir.TypeId) bool {
    const optional = @backingInt(std.meta.Tag(zx.ir.Type).optional);
    var current = expected;

    while (current != actual) {
        const index = @backingInt(current);

        if (table.kinds[index] != optional) return false;

        current = @fromBackingInt(table.first[index]);
    }

    return true;
}

fn mismatch(graph: *const Graph, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, "inferred value cannot be passed to the required type");
}
