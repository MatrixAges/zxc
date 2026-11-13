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
    const Publication = std.meta.Child(@FieldType(Request, "publication"));
    const kinds = rows.items(.kind);
    const arguments = rows.items(.argument);
    const kind_bytes = std.mem.sliceAsBytes(kinds);
    const revision: []u64 = (&graph.object_revision)[0..1];

    comptime {
        if (@sizeOf(Nodes.Kind) != @sizeOf(u8)) @compileError("inference kind column must store one byte per row");
    }

    const view: View = .{
        .kinds = kinds,
        .arguments = arguments,
        .members = rows.items(.members),
        .allowed = rows.items(.allowed),
        .fallback = rows.items(.fallback),
    };

    const publication: Publication = .{
        .kinds = @ptrCast(&kind_bytes),
        .arguments = @ptrCast(&arguments),
        .revision = @ptrCast(&revision),
        .known_kind = @backingInt(Nodes.Kind.Known),
    };

    var overflow = std.heap.ArenaAllocator.init(graph.scratch);

    defer overflow.deinit();

    var buffer: [512]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, overflow.allocator());

    var state: Request = .{
        .graph = &view,
        .publication = &publication,
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

        switch (state.route) {
            .Complete => return @fromBackingInt(state.completed.?),
            .List, .Optional, .Tuple, .Object => state.completed = @backingInt(try materialize(graph, rows, state)),
            .Depth, .Sequence, .Unconstrained, .NumericMismatch => return failure(graph, rows.items(.span)[state.node], state.route),
            .Search => unreachable,
        }
    }
}

fn failure(graph: *Graph, span: zx.Span, route: anytype) zx.Error {
    const generated = @import("generated_rx_resolution_diagnostic");
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const result = generated.executeValue(empty.allocator(), @fromBackingInt(@backingInt(route))) catch unreachable;

    return graph.reporter.fail(switch (result.issue) {
        .Unsupported => .unsupported,
        .Contract => .contract,
        .TypeMismatch => .type_mismatch,
    }, span, result.message);
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
