const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Scalar = @import("../scalar.zig");
const Nodes = @import("../nodes.zig");
const seed = @import("seed.zig");
const enabled = @import("rx_options").generated_graph;
const entry = if (enabled) @import("generated_rx_scalar_restriction") else void;
const Input = if (enabled) std.meta.Child(entry.Input) else void;
const Target = if (enabled) std.meta.Child(@FieldType(Input, "target")) else void;
pub const View = if (enabled) std.meta.Child(@FieldType(Target, "graph")) else void;

pub fn borrow(graph: *const Graph, parents: *const []u32) View {
    const rows = graph.nodes.slice();
    const types = &graph.types.items;

    return .{
        .parents = @ptrCast(parents),
        .kinds = rows.items(.kind),
        .arguments = rows.items(.argument),
        .allowed = rows.items(.allowed),
        .type_kinds = types.kinds.items,
        .type_arguments = types.first.items,
    };
}

pub fn restrict(graph: *Graph, id: Graph.Id, allowed: Scalar.Mask, span: zx.Span) zx.Error!void {
    if (!enabled) return restrictSeed(graph, id, allowed, span);

    const parents: []u32 = @constCast(graph.forest.state.items);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const input: Input = .{
        .target = &.{ .graph = &borrow(graph, &parents), .node = @backingInt(id) },
        .requested = allowed.bits.mask,
    };

    const result = zx.columns.invoke(entry.executeValue, scratch.allocator(), &input) catch unreachable;

    return apply(graph, result, span);
}

pub fn apply(graph: *Graph, result: anytype, span: zx.Span) zx.Error!void {
    switch (result.issue) {
        .None => {},
        .Empty => return failure(graph, .empty, span),
        .Operator => return failure(graph, .operator, span),
        .Structure => return failure(graph, .structure, span),
    }

    graph.nodes.items(.allowed)[result.root] = @intCast(result.allowed);
    graph.revision += @intFromBool(result.changed);
}

fn restrictSeed(graph: *Graph, id: Graph.Id, allowed: Scalar.Mask, span: zx.Span) zx.Error!void {
    const index = @backingInt(graph.root(id));
    const current = graph.shapeAt(index);
    const rows = graph.nodes.slice();

    const scalar: ?zx.ir.Scalar = if (current == .known) switch (graph.types.get(current.known)) {
        .scalar => |value| value,
        else => null,
    } else null;

    const shape: Scalar.Shape = switch (current) {
        .unknown => .open,
        .known => if (scalar != null) .scalar else .concrete,
        else => .structure,
    };

    const merged = seed.restrict(Nodes.allowed(rows, index), allowed, shape, scalar);

    if (merged.issue != .none) return failure(graph, merged.issue, span);

    const bits: u16 = @intCast(merged.allowed.bits.mask);
    const previous = &rows.items(.allowed)[index];

    if (previous.* == null or previous.*.? != bits) graph.revision += 1;

    previous.* = bits;
}

fn failure(graph: *const Graph, issue: Scalar.Issue, span: zx.Span) zx.Error {
    return graph.reporter.fail(.type_mismatch, span, switch (issue) {
        .empty => "incompatible inferred scalar requirements",
        .operator => "inferred type does not satisfy the operator",
        .structure => "the operator requires a scalar value",
        .none => unreachable,
    });
}
