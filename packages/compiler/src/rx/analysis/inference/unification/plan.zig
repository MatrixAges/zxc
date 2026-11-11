const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
pub const enabled = @import("rx_options").generated_graph;
const generated = if (enabled) @import("generated_rx_unification") else void;

pub const Route = if (enabled) generated.Output else enum {
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

pub fn choose(left: Graph.Shape, right: Graph.Shape, concrete: ?zx.ir.Type) Route {
    if (!enabled) return seed(left, right, concrete);

    const Input = @typeInfo(generated.Input).pointer.child;
    const Shape = @typeInfo(@FieldType(Input, "left")).pointer.child;
    const first = describe(Shape, left, if (left == .known) concrete else null);
    const second = describe(Shape, right, if (right == .known) concrete else null);
    var bytes: [0]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&bytes);

    return generated.executeIn(scratch.allocator(), &.{ .left = &first, .right = &second }) catch unreachable;
}

fn describe(comptime Shape: type, value: Graph.Shape, concrete: ?zx.ir.Type) Shape {
    return .{
        .kind = switch (value) {
            .unknown => .Unknown,
            .sequence => .Sequence,
            .known => .Known,
            .object => .Object,
            .list => .List,
            .optional => .Optional,
            .tuple => .Tuple,
        },
        .identity = if (value == .known) @backingInt(value.known) else 0,
        .size = if (value == .tuple) value.tuple.len else if (concrete != null and concrete.? == .tuple) concrete.?.tuple.len else 0,
        .concrete = if (concrete) |kind| switch (kind) {
            .scalar => .Scalar,
            .object => .Object,
            .optional => .Optional,
            .list => .List,
            .tuple => .Tuple,
            .error_set => .ErrorSet,
            .task => .Task,
            .enumeration => .Enumeration,
            .native_reference => .NativeReference,
        } else .Scalar,
    };
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
