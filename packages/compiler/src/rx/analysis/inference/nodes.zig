const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const enabled = @import("rx_options").generated_graph;
const generated = if (enabled) @import("generated_rx_unification_occurs") else void;
const View = if (enabled) std.meta.Child(@FieldType(std.meta.Child(generated.Input), "graph")) else void;

pub const Kind = if (enabled) std.meta.Elem(@FieldType(View, "kinds")) else enum {
    Unknown,
    Sequence,
    Known,
    Object,
    List,
    Optional,
    Tuple,
};

const Facts = struct {
    span: zx.Span,
    allowed: ?Graph.Mask = null,
    fallback: ?zx.ir.Scalar = null,
};

const Row = struct {
    kind: Kind,
    argument: u32,
    members: []const u32,
    facts: Facts,
};

pub const Storage = std.MultiArrayList(Row);

pub fn record(value: Graph.Shape, span: zx.Span) Row {
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
        .argument = switch (value) {
            .known => |id| @backingInt(id),
            .list, .optional => |child| @backingInt(child),
            else => 0,
        },
        .members = switch (value) {
            .object => |fields| @ptrCast(fields.values()),
            .tuple => |members| @ptrCast(members),
            else => &.{},
        },
        .facts = .{ .span = span },
    };
}

pub fn shape(rows: Storage.Slice, index: usize) Graph.Shape {
    return switch (rows.items(.kind)[index]) {
        .Unknown => .unknown,
        .Sequence => .sequence,
        .Known => .{ .known = @fromBackingInt(rows.items(.argument)[index]) },
        .Object => .{ .object = Graph.Fields.fromValues(@ptrCast(rows.items(.members)[index])) },
        .List => .{ .list = @fromBackingInt(rows.items(.argument)[index]) },
        .Optional => .{ .optional = @fromBackingInt(rows.items(.argument)[index]) },
        .Tuple => .{ .tuple = @ptrCast(rows.items(.members)[index]) },
    };
}

pub fn get(rows: Storage.Slice, index: usize) Graph.Node {
    const facts = rows.items(.facts)[index];

    return .{ .shape = shape(rows, index), .span = facts.span, .allowed = facts.allowed, .fallback = facts.fallback };
}

pub fn setShape(rows: Storage.Slice, index: usize, value: Graph.Shape) void {
    const encoded = record(value, undefined);

    rows.items(.kind)[index] = encoded.kind;
    rows.items(.argument)[index] = encoded.argument;
    rows.items(.members)[index] = encoded.members;
}
