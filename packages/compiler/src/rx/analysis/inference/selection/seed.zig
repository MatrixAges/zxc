const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Selection = @import("../selection.zig").Selection;

pub fn apply(graph: *Graph, value: Selection, final: bool) zx.Error!void {
    var fields: std.ArrayList(Graph.Field) = .empty;

    defer fields.deinit(graph.allocator);

    switch (graph.shape(value.source)) {
        .object => |items| for (items.names(), items.values()) |name, field| {
            try fields.append(graph.allocator, .{ .name = name, .value = field });
        },
        .known => |id| {
            const target = graph.types.get(id);

            if (target != .object) return graph.reporter.fail(.type_mismatch, value.span, "object selection requires an object source");

            for (0..target.object.len) |index| {
                const field = target.object.at(index);

                try fields.append(graph.allocator, .{ .name = field.name, .value = try graph.known(field.type_id, value.span) });
            }
        },
        else => return graph.reporter.fail(.type_mismatch, value.span, "object selection requires an object source"),
    }

    for (value.keys) |key| {
        const found = for (fields.items) |field| {
            if (std.mem.eql(u8, key, field.name)) break true;
        } else false;

        if (!found) {
            if (final or graph.shape(value.source) == .known) return graph.reporter.fail(.name, value.span, "unknown object selection field");

            return;
        }
    }

    for (fields.items) |field| {
        if (requested(value, field.name) != value.omit) try graph.unify(try graph.field(value.result, field.name, value.span), field.value, value.span);
    }

    if (final) switch (graph.shape(value.result)) {
        .object => |items| for (items.names()) |name| {
            if (!selected(value, fields.items, name)) return graph.reporter.fail(.name, value.span, "field is outside the object selection result");
        },
        .known => |id| {
            const target = graph.types.get(id);

            if (target != .object) return graph.reporter.fail(.type_mismatch, value.span, "object selection requires an object result");

            for (0..target.object.len) |index| {
                if (!selected(value, fields.items, target.object.at(index).name)) return graph.reporter.fail(.name, value.span, "field is outside the object selection result");
            }
        },
        else => {},
    };
}

fn selected(value: Selection, fields: []const Graph.Field, name: []const u8) bool {
    if (requested(value, name) == value.omit) return false;
    for (fields) |field| if (std.mem.eql(u8, name, field.name)) return true;

    return false;
}

fn requested(value: Selection, name: []const u8) bool {
    for (value.keys) |key| if (std.mem.eql(u8, key, name)) return true;

    return false;
}
