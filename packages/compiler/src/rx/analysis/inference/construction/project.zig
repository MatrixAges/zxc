const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const ObjectClosure = @import("../object_closure.zig");
const Object = @import("../construction.zig").Object;
const generated = @import("generated_object_construction_resolve");
const Input = @typeInfo(generated.Input).pointer.child;
const Parts = @typeInfo(@FieldType(Input, "parts")).pointer.child;
const NameSet = std.StringHashMapUnmanaged(void);

pub fn propagate(graph: *Graph, closure: *ObjectClosure, object: Object, final: bool) zx.Error!void {
    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    var names: NameSet = .empty;
    const parts = try project(graph, closure, allocator, object, final, &names);
    var iterator = names.keyIterator();

    while (iterator.next()) |name| {
        const target = try graph.field(object.result, name.*, object.span);
        const node = graph.nodes.items[@backingInt(graph.root(target))];
        const optional = node.shape == .optional or (node.shape == .known and graph.types.get(node.shape.known) == .optional);

        const plan = generated.executeValue(allocator, &.{
            .parts = &parts,
            .name = name.*,
            .optional = optional,
            .unrestricted = node.shape == .unknown and node.allowed == null,
            .final = final,
        }) catch |err| return failure(err);

        // Concrete fields are registered even when an open spread makes the choice ambiguous.
        const direct = switch (plan.candidate.kind) {
            .Named, .AmbiguousNamed => try concrete(graph, object, target, parts, @intCast(plan.candidate.part), @intCast(plan.candidate.field)),
            else => null,
        };

        switch (plan.action) {
            .Skip => {},
            .Bind => try graph.expect(direct.?, target, object.span),
            .Infer => {
                const part = object.parts[@intCast(plan.candidate.part)];
                const value = try graph.field(part.value, name.*, object.span);

                try graph.expect(value, target, object.span);
            },
            .Ambiguous => return graph.reporter.fail(.type_mismatch, object.span, "multiple spread sources may provide a required field; their input types cannot be inferred uniquely"),
            .Missing => return graph.reporter.fail(.type_mismatch, object.span, "constructed object is missing a required field"),
        }
    }
}

fn project(graph: *Graph, closure: *ObjectClosure, allocator: std.mem.Allocator, object: Object, final: bool, names: *NameSet) zx.Error!Parts {
    const result = graph.root(object.result);
    const result_fields = try Fields.from(graph, graph.nodes.items[@backingInt(result)].shape, object.span);

    try result_fields.register(allocator, names);

    const count = object.parts.len;

    const spreads = for (object.parts) |part| {
        if (part.name == null) break true;
    } else false;

    const spread_columns = if (spreads) count else 0;
    const explicit = try allocator.alloc(?[]const u8, count);
    const fields = try allocator.alloc([]const []const u8, spread_columns);
    const roots = try allocator.alloc(u64, spread_columns);
    const open = try allocator.alloc(bool, spread_columns);
    const aliases = try allocator.alloc(bool, spread_columns);

    @memset(fields, &.{});
    @memset(roots, 0);
    @memset(open, false);
    @memset(aliases, false);

    for (object.parts, explicit, 0..) |part, *name, index| {
        name.* = part.name;

        if (part.name) |value| {
            try names.put(allocator, value, {});

            continue;
        }

        const root = graph.root(part.value);
        const shape = graph.nodes.items[@backingInt(root)].shape;

        if (final and shape == .unknown) return graph.reporter.fail(.type_mismatch, part.span, "object spread source cannot be inferred from the available constraints");

        const source = try Fields.from(graph, shape, part.span);
        const alias = root == result;
        const closed = shape == .known or (if (!alias or (final and source.empty())) try closure.prove(graph, root, .spread) else false);

        if (final and source.empty() and !closed) return graph.reporter.fail(.type_mismatch, part.span, "object spread source cannot be inferred from the available constraints");

        try source.register(allocator, names);

        roots[index] = @backingInt(root);
        aliases[index] = alias;
        open[index] = !closed;

        if (!alias) fields[index] = source.names();
    }

    return .{ .explicit = explicit, .fields = fields, .roots = roots, .open = open, .aliases = aliases };
}

fn concrete(graph: *Graph, object: Object, target: Graph.Id, parts: Parts, part_index: usize, field_index: usize) zx.Error!Graph.Id {
    const part = object.parts[part_index];

    if (part.name != null) return part.value;
    if (parts.aliases[part_index]) return target;

    return switch (graph.shape(part.value)) {
        .object => |fields| fields.values()[field_index],
        .known => |id| graph.known(graph.types.get(id).object.at(field_index).type_id, part.span),
        else => unreachable,
    };
}

const Fields = union(enum) {
    inferred: Graph.Fields,
    known: zx.ir.TypeFields,
    fn from(graph: *Graph, shape: Graph.Shape, span: zx.Span) zx.Error!Fields {
        return switch (shape) {
            .unknown => .{ .inferred = .{} },
            .object => |items| .{ .inferred = items },
            .known => |id| switch (graph.types.get(id)) {
                .object => |value| .{ .known = value },
                else => graph.reporter.fail(.type_mismatch, span, "object construction requires an object source and result"),
            },
            else => graph.reporter.fail(.type_mismatch, span, "object spread requires an object source"),
        };
    }
    fn empty(self: Fields) bool {
        return switch (self) {
            .inferred => |items| items.len == 0,
            .known => |items| items.len == 0,
        };
    }
    fn register(self: Fields, allocator: std.mem.Allocator, set: *NameSet) std.mem.Allocator.Error!void {
        for (self.names()) |name| try set.put(allocator, name, {});
    }
    fn names(self: Fields) []const []const u8 {
        return switch (self) {
            .known => |items| items.names[0..items.len],
            .inferred => |items| items.names(),
        };
    }
};

fn failure(err: anyerror) zx.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
