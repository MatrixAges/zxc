const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const enabled = @import("rx_options").generated_graph;
const generated_sequence = if (enabled) @import("generated_rx_sequence") else void;
const generated_index = if (enabled) @import("generated_rx_index") else void;

const Kind = if (enabled) @FieldType(@typeInfo(generated_sequence.Input).pointer.child, "kind") else enum {
    Unknown,
    Sequence,
    List,
    Tuple,
    Scalar,
    Other,
};

const SequenceRoute = if (enabled) generated_sequence.Output else enum { Wait, List, Tuple, Length, Invalid };
const IndexRoute = if (enabled) generated_index.Output else enum { Wait, List, Tuple, String, MissingLiteral, OutOfBounds, Invalid };

pub const Target = union(enum) {
    unknown,
    sequence,
    list: Graph.Id,
    tuple: []const Graph.Id,
    declared_list: zx.ir.TypeId,
    declared_tuple: @FieldType(zx.ir.Type, "tuple"),
    scalar: zx.ir.Scalar,
    other,
    pub fn read(graph: *const Graph, id: Graph.Id) Target {
        return switch (graph.shape(id)) {
            .unknown => .unknown,
            .sequence => .sequence,
            .list => |element| .{ .list = element },
            .tuple => |children| .{ .tuple = children },
            .known => |declared| switch (graph.types.get(declared)) {
                .list => |element| .{ .declared_list = element },
                .tuple => |children| .{ .declared_tuple = children },
                .scalar => |scalar| .{ .scalar = scalar },
                else => .other,
            },
            else => .other,
        };
    }
    pub fn sequenceRoute(self: Target, count: usize) SequenceRoute {
        const kind = self.classify();
        const length = self.tupleLength();

        if (!enabled) return switch (kind) {
            .Sequence => .Wait,
            .List => .List,
            .Tuple => if (length == count) .Tuple else .Length,
            else => if (count == 0) .Wait else .Invalid,
        };

        var bytes: [0]u8 = undefined;
        var scratch = std.heap.FixedBufferAllocator.init(&bytes);

        return generated_sequence.executeIn(scratch.allocator(), &.{ .kind = kind, .length = length, .count = count }) catch unreachable;
    }
    pub fn indexRoute(self: Target, position: ?u64) IndexRoute {
        const kind = self.classify();
        const length = self.tupleLength();
        const scalar_type = if (self == .scalar) self.scalar else .void;

        if (!enabled) return switch (kind) {
            .Unknown, .Sequence => .Wait,
            .List => .List,
            .Tuple => if (position) |value| (if (value < length) .Tuple else .OutOfBounds) else .MissingLiteral,
            .Scalar => if (scalar_type == .string) .String else .Invalid,
            .Other => .Invalid,
        };

        var bytes: [0]u8 = undefined;
        var scratch = std.heap.FixedBufferAllocator.init(&bytes);

        return generated_index.executeIn(scratch.allocator(), &.{
            .target = &.{ .kind = kind, .scalar = @backingInt(scalar_type) },
            .tuple = &.{ .length = length, .position = position },
        }) catch unreachable;
    }

    pub fn child(self: Target, graph: *Graph, position: usize, span: zx.Span) zx.Error!Graph.Id {
        return switch (self) {
            .list => |value| value,
            .tuple => |children| children[position],
            .declared_list => |value| graph.known(value, span),
            .declared_tuple => |children| graph.known(children.at(position), span),
            else => unreachable,
        };
    }
    fn classify(self: Target) Kind {
        return switch (self) {
            .unknown => .Unknown,
            .sequence => .Sequence,
            .list, .declared_list => .List,
            .tuple, .declared_tuple => .Tuple,
            .scalar => .Scalar,
            .other => .Other,
        };
    }

    fn tupleLength(self: Target) usize {
        return switch (self) {
            .tuple => |children| children.len,
            .declared_tuple => |children| children.len,
            else => 0,
        };
    }
};
