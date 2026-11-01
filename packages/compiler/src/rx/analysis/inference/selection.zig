const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const selection = @import("frontend").object_selection;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub const Selection = struct { source: Graph.Id, result: Graph.Id, keys: []const []const u8, omit: bool, span: zx.Span };

pub fn infer(self: *Expression, expression: anytype) zx.Error!Graph.Id {
    if (!selection.matches(expression)) return self.graph.reporter.fail(.unsupported, self.sourceSpan(expression.span), @import("../value_rules.zig").message);

    var reporter: zx.Reporter = .{};

    const keys = selection.keys(self.graph.allocator, expression, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = reporter.diagnostic.?;

        return self.graph.reporter.fail(issue.code, self.sourceSpan(issue.span), issue.message);
    };

    const field = syntax.value(syntax.value(expression).call.callee).field;
    const source = try self.infer(field.target, null);
    const span = self.sourceSpan(expression.span);
    const result = try self.graph.add(.{ .object = &.{} }, span);

    try self.graph.selections.append(self.graph.allocator, .{ .source = source, .result = result, .keys = keys, .omit = std.mem.eql(u8, field.name.text, "omit"), .span = span });

    return result;
}

pub fn propagate(graph: *Graph, value: Selection, final: bool) zx.Error!void {
    if (!complete(graph, value.source, 0)) {
        if (final) return graph.reporter.fail(.type_mismatch, value.span, "object selection requires a complete source type; declare Args or Input");

        return;
    }

    var fields: std.ArrayList(Graph.Field) = .empty;

    defer fields.deinit(graph.allocator);

    switch (graph.shape(value.source)) {
        .object => |items| try fields.appendSlice(graph.allocator, items),
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
        .object => |items| for (items) |field| {
            if (!selected(value, fields.items, field.name)) return graph.reporter.fail(.name, value.span, "field is outside the object selection result");
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

fn complete(graph: *const Graph, value: Graph.Id, depth: usize) bool {
    if (graph.shape(value) == .known) return true;
    if (depth >= 256) return false;

    for (graph.constructions.items) |object| {
        if (graph.root(object.result) != graph.root(value)) continue;

        const closed = for (object.parts) |part| {
            if (part.name == null and !complete(graph, part.value, depth + 1)) break false;
        } else true;

        if (closed) return true;
    }

    for (graph.selections.items) |operation| {
        if (graph.root(operation.result) == graph.root(value) and complete(graph, operation.source, depth + 1)) return true;
    }

    return false;
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
