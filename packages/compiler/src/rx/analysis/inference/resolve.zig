const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Nodes = @import("nodes.zig");

pub fn resolve(graph: *Graph, value: Graph.Id) zx.Error!zx.ir.TypeId {
    if (!@import("rx_options").generated_graph) return @import("resolve/seed.zig").resolve(graph, value, 0);

    const rows = graph.nodes.slice();
    const index = @backingInt(graph.root(value));

    if (rows.items(.kind)[index] == .Known) return @fromBackingInt(rows.items(.argument)[index]);

    return run(graph, rows, index);
}

fn run(graph: *Graph, rows: Nodes.Storage.Slice, root: u32) zx.Error!zx.ir.TypeId {
    const generated = @import("generated_rx_resolve_type");
    const Request = @typeInfo(@TypeOf(generated.executeState)).@"fn".param_types[1].?;
    const View = std.meta.Child(@FieldType(Request, "graph"));

    const view: View = .{
        .kinds = rows.items(.kind),
        .arguments = rows.items(.argument),
        .members = rows.items(.members),
        .allowed = rows.items(.allowed),
        .fallback = rows.items(.fallback),
    };

    var overflow = std.heap.ArenaAllocator.init(graph.scratch);

    defer overflow.deinit();

    var buffer: [512]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, overflow.allocator());

    var state: Request = .{
        .graph = &view,
        .parents = graph.forest.state,
        .frames = .{ .items = &.{}, .storage = .plain },
        .values = .{ .items = &.{}, .storage = .plain },
        .depth = 0,
        .used = 0,
        .count = 0,
        .node = root,
        .completed = null,
        .route = .Search,
    };

    while (true) {
        state = generated.executeState(scratch.allocator(), state) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
            else => unreachable,
        };

        std.debug.assert(state.parents.items.ptr == graph.forest.state.items.ptr);

        const span = rows.items(.span)[state.node];

        const type_id: zx.ir.TypeId = switch (state.route) {
            .Complete => return @fromBackingInt(state.completed.?),
            .Scalar => @fromBackingInt(state.completed.?),
            .List, .Optional, .Tuple, .Object => try materialize(graph, rows, state),
            .Depth => return graph.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels"),
            .Sequence => return graph.reporter.fail(.contract, span, "sequence constraints must be finalized before type resolution"),
            .Unconstrained => return graph.reporter.fail(.type_mismatch, span, "input type cannot be inferred from the available constraints"),
            .NumericMismatch => return graph.reporter.fail(.type_mismatch, span, "numeric constraints do not determine an accepted default type"),
            .Search => unreachable,
        };

        graph.setShape(state.node, .{ .known = type_id });

        graph.object_revision += 1;

        if (state.depth == 0) return type_id;

        state.completed = @backingInt(type_id);
        state.count = 0;
        state.route = .Search;
    }
}

fn materialize(graph: *Graph, rows: Nodes.Storage.Slice, state: anytype) zx.Error!zx.ir.TypeId {
    const generated = @import("generated_rx_materialize_type");
    const Input = std.meta.Child(generated.Input);
    const Tables = std.meta.Child(@FieldType(Input, "tables"));
    const Table = std.meta.Child(@FieldType(Tables, "base"));
    const Aggregate = std.meta.Child(@FieldType(Input, "aggregate"));
    const children = state.values.items[@intCast(state.used)..][0..@intCast(state.count)];

    const names = if (state.route == .Object)
        Graph.Fields.fromValues(@ptrCast(rows.items(.members)[state.node])).names()

    else
        &.{};

    const base = zx.ir.TypeTable.borrow(Table, graph.types.items.view());
    const empty = zx.ir.TypeTable.borrow(Table, .{});

    const input: Input = .{
        .tables = &.{ .base = &base, .delta = &empty },
        .aggregate = &@as(Aggregate, .{
            .route = @fromBackingInt(@backingInt(state.route)),
            .child = state.completed orelse 0,
            .children = if (state.route == .Tuple) children else &.{},
            .fields = &.{ .names = names, .types = if (state.route == .Object) children else &.{} },
        }),
    };

    var overflow = std.heap.ArenaAllocator.init(graph.scratch);

    defer overflow.deinit();

    var buffer: [512]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, overflow.allocator());

    return @import("frontend").constructTypeWith(generated.executeValue, &graph.types, scratch.allocator(), &input, false);
}
