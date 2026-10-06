const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
pub const Part = struct { name: ?[]const u8, value: Graph.Id, span: zx.Span };
pub const Object = struct { result: Graph.Id, parts: []const Part, span: zx.Span };

const Provider = struct { value: Graph.Id, field: bool };

pub fn propagate(graph: *Graph, object: Object, final: bool) zx.Error!void {
    var names: std.StringHashMapUnmanaged(void) = .empty;

    defer names.deinit(graph.allocator);

    try collect(graph, object.result, &names, object.span);

    for (object.parts) |part| {
        if (part.name) |name| {
            try names.put(graph.allocator, name, {});
        } else {
            const source_shape = graph.shape(part.value);

            if (final and (source_shape == .unknown or (source_shape == .object and source_shape.object.len == 0 and !closed(graph, part.value, 0)))) return graph.reporter.fail(.type_mismatch, part.span, "object spread source cannot be inferred from the available constraints");
            try collect(graph, part.value, &names, part.span);
        }
    }

    var iterator = names.keyIterator();

    while (iterator.next()) |name| {
        const target = try graph.field(object.result, name.*, object.span);
        var provider: ?Provider = null;
        var ambiguous = false;
        var index = object.parts.len;

        while (index != 0) {
            index -= 1;
            const part = object.parts[index];

            if (part.name) |explicit| {
                if (!std.mem.eql(u8, explicit, name.*)) continue;

                ambiguous = provider != null;
                provider = .{ .value = part.value, .field = false };

                break;
            }

            if (try lookup(graph, part.value, name.*, part.span)) |value| {
                ambiguous = provider != null;
                provider = .{ .value = value, .field = false };

                break;
            }

            if (closed(graph, part.value, 0)) continue;

            if (provider) |existing| {
                if (existing.field and graph.root(existing.value) == graph.root(part.value)) continue;
            }

            ambiguous = ambiguous or provider != null;
            provider = .{ .value = part.value, .field = true };
        }

        if (ambiguous) {
            if (final) return graph.reporter.fail(.type_mismatch, object.span, "multiple spread sources may provide a required field; their input types cannot be inferred uniquely");

            continue;
        }

        if (provider) |source| {
            if (source.field and optional(graph, target)) continue;
            if (source.field and !final and graph.shape(target) == .unknown and graph.nodes.items[@intFromEnum(graph.root(target))].allowed == null) continue;

            const value = if (source.field) try graph.field(source.value, name.*, object.span) else source.value;

            try graph.expect(value, target, object.span);
        } else if (final and !optional(graph, target)) {
            return graph.reporter.fail(.type_mismatch, object.span, "constructed object is missing a required field");
        }
    }
}

fn collect(graph: *Graph, value: Graph.Id, names: *std.StringHashMapUnmanaged(void), span: zx.Span) zx.Error!void {
    switch (graph.shape(value)) {
        .unknown => {},
        .object => |fields| for (fields) |field| {
            try names.put(graph.allocator, field.name, {});
        },
        .known => |id| {
            const shape = graph.types.get(id);

            if (shape != .object) return graph.reporter.fail(.type_mismatch, span, "object construction requires an object source and result");

            for (0..shape.object.len) |view_index| {
                const field = shape.object.at(view_index);

                try names.put(graph.allocator, field.name, {});
            }
        },
        else => return graph.reporter.fail(.type_mismatch, span, "object spread requires an object source"),
    }
}

fn lookup(graph: *Graph, value: Graph.Id, name: []const u8, span: zx.Span) zx.Error!?Graph.Id {
    switch (graph.shape(value)) {
        .object => |fields| for (fields) |field| {
            if (std.mem.eql(u8, field.name, name)) return field.value;
        },
        .known => |id| {
            const shape = graph.types.get(id);

            if (shape != .object) return graph.reporter.fail(.type_mismatch, span, "object spread requires an object source");

            for (0..shape.object.len) |view_index| {
                const field = shape.object.at(view_index);

                if (std.mem.eql(u8, field.name, name)) return try graph.known(field.type_id, span);
            }
        },
        else => {},
    }

    return null;
}

fn optional(graph: *Graph, value: Graph.Id) bool {
    const shape = graph.shape(value);

    return shape == .optional or (shape == .known and graph.types.get(shape.known) == .optional);
}

fn closed(graph: *const Graph, value: Graph.Id, depth: usize) bool {
    if (graph.shape(value) == .known) return true;
    if (depth >= 256) return false;

    for (graph.constructions.items) |object| {
        if (graph.root(object.result) != graph.root(value)) continue;

        var complete = true;

        for (object.parts) |part| {
            if (part.name == null and !closed(graph, part.value, depth + 1)) {
                complete = false;

                break;
            }
        }

        if (complete) return true;
    }

    return false;
}
