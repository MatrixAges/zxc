const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Occurs = @import("occurs.zig");
pub const enabled = @import("rx_options").generated_graph;
const generated = if (enabled) @import("generated_rx_unification_prepare") else void;
const Output = if (enabled) @typeInfo(@typeInfo(@TypeOf(generated.executeValue)).@"fn".return_type.?).error_union.payload else void;

pub const Route = if (enabled) @FieldType(Output, "route") else enum {
    Ready,
    Same,
    Depth,
    Recursive,
    Left,
    Right,
    Known,
    Child,
    Tuple,
    Object,
    SequenceMismatch,
    ShapeMismatch,
    TupleMismatch,
    ConcreteMismatch,
    ConcreteObjectMismatch,
    ConcreteContainerMismatch,
    ConcreteTupleMismatch,
};

pub const Work = struct { left: Graph.Id, right: Graph.Id, route: Route };

pub fn prepare(graph: *const Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, depth: usize) zx.Error!Work {
    if (!enabled) return prepareSeed(graph, left, right, span, depth);

    const rows = graph.nodes.slice();
    const types = &graph.types.items;
    const parents: []u32 = @constCast(graph.forest.state.items);
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeValue(scratch.allocator(), &.{
        .graph = &.{
            .kinds = rows.items(.kind),
            .members = rows.items(.members),
            .arguments = rows.items(.argument),
        },
        .types = &.{ .kinds = types.kinds.items, .sizes = types.second.items },
        .parents = @ptrCast(&parents),
        .left = @backingInt(left),
        .right = @backingInt(right),
        .depth = depth,
    }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .left = @fromBackingInt(result.left), .right = @fromBackingInt(result.right), .route = result.route };
}

fn prepareSeed(graph: *const Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, depth: usize) zx.Error!Work {
    if (depth >= 256) return .{ .left = left, .right = right, .route = .Depth };

    const a = graph.root(left);
    const b = graph.root(right);

    if (a == b) return .{ .left = a, .right = b, .route = .Same };

    try Occurs.check(graph, a, b, span);

    const first = graph.shapeAt(@backingInt(a));
    const second = graph.shapeAt(@backingInt(b));

    return .{
        .left = a,
        .right = b,
        .route = seed(first, second, concreteType(graph, first, second)),
    };
}

pub fn concreteType(graph: *const Graph, left: Graph.Shape, right: Graph.Shape) ?zx.ir.Type {
    if (left == .known and right != .unknown and right != .known) return graph.types.get(left.known);
    if (right == .known and left != .unknown and left != .known) return graph.types.get(right.known);

    return null;
}

fn seed(left: Graph.Shape, right: Graph.Shape, concrete: ?zx.ir.Type) Route {
    if (left == .unknown) return .Right;
    if (right == .unknown) return .Left;

    if (left == .known or right == .known) {
        const declared = if (left == .known) left else right;
        const inferred = if (left == .known) right else left;

        return switch (inferred) {
            .known => |id| if (declared.known == id) .Known else .ConcreteMismatch,
            .sequence => if (concrete.? == .list or concrete.? == .tuple) .Known else .SequenceMismatch,
            .object => if (concrete.? == .object) .Known else .ConcreteObjectMismatch,
            .list => if (concrete.? == .list) .Known else .ConcreteContainerMismatch,
            .optional => if (concrete.? == .optional) .Known else .ConcreteContainerMismatch,
            .tuple => |items| if (concrete.? == .tuple and concrete.?.tuple.len == items.len) .Known else .ConcreteTupleMismatch,
            .unknown => unreachable,
        };
    }

    if (left == .sequence) return if (right == .sequence or right == .list or right == .tuple) .Right else .SequenceMismatch;
    if (right == .sequence) return if (left == .list or left == .tuple) .Left else .SequenceMismatch;
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return .ShapeMismatch;

    return switch (left) {
        .list, .optional => .Child,
        .tuple => if (left.tuple.len == right.tuple.len) .Tuple else .TupleMismatch,
        .object => .Object,
        else => unreachable,
    };
}

pub fn position(names: []const []const u8, key: []const u8) ?usize {
    if (!enabled) {
        for (names, 0..) |name, index| {
            if (std.mem.eql(u8, name, key)) return index;
        }

        return null;
    }

    var bytes: [0]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&bytes);
    const index = @import("generated_rx_unification_field").executeIn(scratch.allocator(), &.{ .names = names, .name = key }) catch unreachable;

    return if (index) |value| @intCast(value) else null;
}
