const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");

pub fn borrow(comptime Entry: type, graph: *const Graph) std.meta.Child(@FieldType(std.meta.Child(Entry.Input), "graph")) {
    const rows = graph.nodes.slice();
    const types = &graph.types.items;

    return .{
        .kinds = rows.items(.kind),
        .arguments = rows.items(.argument),
        .members = rows.items(.members),
        .type_kinds = types.kinds.items,
        .type_first = types.first.items,
        .type_second = types.second.items,
        .type_children = types.children.items,
    };
}

pub fn child(graph: *Graph, value: u32, declared: bool, span: zx.Span) zx.Error!Graph.Id {
    return if (declared) graph.known(@fromBackingInt(value), span) else @fromBackingInt(value);
}

pub const Seed = union(enum) {
    unknown,
    sequence,
    list: Graph.Id,
    tuple: []const Graph.Id,
    declared_list: zx.ir.TypeId,
    declared_tuple: @FieldType(zx.ir.Type, "tuple"),
    scalar: zx.ir.Scalar,
    other,
    const SequenceRoute = enum { Wait, List, Tuple, Length, Invalid };
    const IndexRoute = enum { Wait, List, Tuple, String, MissingLiteral, OutOfBounds, Invalid };
    pub const Child = struct { value: u32, declared: bool };

    pub fn read(graph: *const Graph, id: Graph.Id) Seed {
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
    pub fn sequenceRoute(self: Seed, count: usize) SequenceRoute {
        return switch (self) {
            .sequence => .Wait,
            .list, .declared_list => .List,
            .tuple, .declared_tuple => if (self.tupleLength() == count) .Tuple else .Length,
            else => if (count == 0) .Wait else .Invalid,
        };
    }

    pub fn indexRoute(self: Seed, position: ?u64) IndexRoute {
        return switch (self) {
            .unknown, .sequence => .Wait,
            .list, .declared_list => .List,
            .tuple, .declared_tuple => if (position) |value| (if (value < self.tupleLength()) .Tuple else .OutOfBounds) else .MissingLiteral,
            .scalar => |value| if (value == .string) .String else .Invalid,
            .other => .Invalid,
        };
    }

    pub fn member(self: Seed, position: usize) Child {
        return switch (self) {
            .list => |value| .{ .value = @backingInt(value), .declared = false },
            .tuple => |children| .{ .value = @backingInt(children[position]), .declared = false },
            .declared_list => |value| .{ .value = @backingInt(value), .declared = true },
            .declared_tuple => |children| .{ .value = @backingInt(children.at(position)), .declared = true },
            else => unreachable,
        };
    }

    fn tupleLength(self: Seed) usize {
        return switch (self) {
            .tuple => |children| children.len,
            .declared_tuple => |children| children.len,
            else => unreachable,
        };
    }
};
