const std = @import("std");
const f = @import("fixture.zig");
const Pair = struct { source: f.ir.TypeId, local: f.ir.TypeId };

const Graph = struct {
    memory: std.mem.Allocator,
    source: f.ir.TypeTable,
    target: f.ir.TypeTable,
    mapping: []?f.ir.TypeId,
    inverse: []?f.ir.TypeId,
    queue: std.ArrayList(Pair) = .empty,
    fn append(self: *Graph, source: f.ir.TypeId, local: f.ir.TypeId) !void {
        try std.testing.expect(@backingInt(source) < self.source.count());
        try std.testing.expect(@backingInt(local) < self.target.count());
        try self.queue.append(self.memory, .{ .source = source, .local = local });
    }
    fn visit(self: *Graph, pair: Pair) !void {
        const index = @backingInt(pair.source);
        const local = @backingInt(pair.local);

        if (self.mapping[index]) |known| {
            try std.testing.expectEqual(known, pair.local);

            return;
        }

        try std.testing.expectEqual(null, self.inverse[local]);

        self.mapping[index] = pair.local;
        self.inverse[local] = pair.source;

        const a = self.source.at(index);
        const b = self.target.at(local);

        try std.testing.expectEqual(std.meta.activeTag(a), std.meta.activeTag(b));

        switch (a) {
            .scalar => |value| try std.testing.expectEqual(value, b.scalar),
            .optional => |child| try self.append(child, b.optional),
            .list => |child| try self.append(child, b.list),
            .task => |task| {
                try self.append(task.result, b.task.result);
                try self.append(task.errors, b.task.errors);
            },
            .tuple => |children| {
                try std.testing.expectEqual(children.len, b.tuple.len);
                for (0..children.len) |position| try self.append(children.at(position), b.tuple.at(position));
            },
            .object => |fields| {
                try std.testing.expectEqual(fields.len, b.object.len);

                for (0..fields.len) |position| {
                    const left = fields.at(position);
                    const right = b.object.at(position);

                    try std.testing.expectEqualStrings(left.name, right.name);
                    try self.append(left.type_id, right.type_id);
                }
            },
            .native_reference => |name| try std.testing.expectEqualStrings(name, b.native_reference),
            .error_set => |names| try namesEqual(names, b.error_set),
            .enumeration => |value| {
                try std.testing.expectEqualStrings(value.name, b.enumeration.name);
                try namesEqual(value.members, b.enumeration.members);
            },
        }
    }

    fn roots(self: *Graph, source: []const f.ir.Export, local: []const f.ir.Export) !void {
        try std.testing.expectEqual(source.len, local.len);

        for (source, local) |a, b| {
            try std.testing.expectEqualStrings(a.name, b.name);
            try self.append(a.type_id, b.type_id);
        }
    }
};

pub fn check(memory: std.mem.Allocator, source: f.ir.TypeTable, exports: []const f.ir.Export, imports: []const f.ir.Export, module: f.artifact.Module) !void {
    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();

    const allocator = arena.allocator();

    var graph: Graph = .{
        .memory = allocator,
        .source = source,
        .target = module.types,
        .mapping = try allocator.alloc(?f.ir.TypeId, source.count()),
        .inverse = try allocator.alloc(?f.ir.TypeId, module.types.count()),
    };

    @memset(graph.mapping, null);
    @memset(graph.inverse, null);

    try std.testing.expect(source.validStructure() and module.types.validStructure());

    for (std.enums.values(f.ir.Scalar), 0..) |scalar, index| {
        const id: f.ir.TypeId = @fromBackingInt(@intCast(index));

        try std.testing.expectEqual(scalar, source.at(index).scalar);
        try graph.append(id, id);
    }

    try graph.roots(exports, module.exports);
    try graph.roots(imports, module.type_imports);

    var cursor: usize = 0;

    while (cursor < graph.queue.items.len) : (cursor += 1) try graph.visit(graph.queue.items[cursor]);
    for (graph.inverse) |mapped| try std.testing.expect(mapped != null);
    try std.testing.expect(module.function == null and module.functions.len == 0 and module.function_imports.len == 0);
    try std.testing.expectEqual(@as(usize, 1), module.nominal_types.count());

    const origin = module.nominal_types.at(0);

    try std.testing.expectEqualStrings("Mode", origin.name);
    try std.testing.expectEqualStrings("/project/leaf.zx", origin.origin.source);
    try std.testing.expectEqualStrings("Mode", module.types.get(origin.type_id).enumeration.name);
}

fn namesEqual(left: []const []const u8, right: []const []const u8) !void {
    try std.testing.expectEqual(left.len, right.len);
    for (left, right) |a, b| try std.testing.expectEqualStrings(a, b);
}
