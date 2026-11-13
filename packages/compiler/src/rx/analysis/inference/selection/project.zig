const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Selection = @import("../selection.zig").Selection;
const generated = @import("generated_object_selection_project");
const covers = @import("generated_object_selection_covers");

const Fields = union(enum) {
    inferred: Graph.Fields,
    known: zx.ir.TypeFields,
    fn names(self: Fields) []const []const u8 {
        return switch (self) {
            .known => |fields| fields.names[0..fields.len],
            .inferred => |fields| fields.names(),
        };
    }
    fn id(self: Fields, graph: *const Graph, index: usize) Graph.Id {
        return switch (self) {
            .inferred => |fields| fields.values()[index],
            .known => |fields| graph.pending.known_types.get(@fromBackingInt(@intCast(fields.types[index]))).?,
        };
    }
};

pub fn apply(graph: *Graph, value: Selection, final: bool) zx.Error!void {
    const source = object(graph, graph.shape(value.source)) orelse return graph.reporter.fail(.type_mismatch, value.span, "object selection requires an object source");

    // Register all declared member types before applying the projection, in source order.
    if (source == .known) {
        for (source.known.types[0..source.known.len]) |type_id| _ = try graph.known(@fromBackingInt(@intCast(type_id)), value.span);
    }

    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    const names = source.names();

    const plan = generated.executeValue(allocator, &.{
        .fields = &.{ .names = names, .first = 0, .count = names.len, .keys = value.keys, .omit = value.omit },
        .required = final or source == .known,
    }) catch |err| return failure(err);

    switch (plan.status) {
        .Missing => return graph.reporter.fail(.name, value.span, "unknown object selection field"),
        .Wait => return,
        .Ready => {},
    }

    if (plan.all) {
        for (names, 0..) |name, index| try graph.unify(try graph.field(value.result, name, value.span), source.id(graph, index), value.span);
    } else {
        for (plan.indices) |index| try graph.unify(try graph.field(value.result, names[index], value.span), source.id(graph, index), value.span);
    }

    if (!final) return;

    const shape = graph.shape(value.result);

    const result = object(graph, shape) orelse {
        if (shape == .known) return graph.reporter.fail(.type_mismatch, value.span, "object selection requires an object result");

        return;
    };

    const valid = covers.executeValue(allocator, &.{
        .source = names,
        .result = result.names(),
        .indices = plan.indices,
        .all = plan.all,
    }) catch |err| return failure(err);

    if (!valid) return graph.reporter.fail(.name, value.span, "field is outside the object selection result");
}

fn object(graph: *const Graph, shape: Graph.Shape) ?Fields {
    return switch (shape) {
        .object => |fields| .{ .inferred = fields },
        .known => |id| switch (graph.types.get(id)) {
            .object => |fields| .{ .known = fields },
            else => null,
        },
        else => null,
    };
}

fn failure(err: anyerror) zx.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
