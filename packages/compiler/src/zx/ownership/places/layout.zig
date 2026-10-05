const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

const Node = struct {
    parent: ?usize = null,
    child: ?usize = null,
    sibling: ?usize = null,
    reference: bool,
};

const Children = std.AutoHashMapUnmanaged(struct { parent: usize, index: u32 }, usize);

nodes: []const Node,
cached: []const []const usize,
children: Children,
pub fn init(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    var builder = Builder{ .allocator = allocator, .program = program };

    defer builder.nodes.deinit(allocator);
    errdefer builder.children.deinit(allocator);

    for (program.symbols) |symbol| _ = try builder.root(symbol.type_id);

    const cached = try allocator.alloc([]const usize, program.expressions.len);

    @memset(cached, &.{});

    errdefer {
        for (cached) |items| allocator.free(items);

        allocator.free(cached);
    }

    const roots = try allocator.alloc(std.ArrayList(usize), program.expressions.len);

    @memset(roots, .empty);

    defer {
        for (roots) |*items| items.deinit(allocator);

        allocator.free(roots);
    }

    for (program.expressions, 0..) |expression, index| {
        if (expression.value != .object) continue;

        const evaluation = expression.value.object.evaluation;
        const positions = try allocator.alloc(usize, evaluation.len);

        cached[index] = positions;

        for (evaluation, positions) |id, *position| {
            position.* = try builder.root(program.expression(id).type_id);

            try roots[@backingInt(id)].append(allocator, position.*);
        }
    }

    const bindings = try allocator.alloc(?usize, program.expressions.len);

    defer allocator.free(bindings);
    @memset(bindings, null);

    for (program.expressions, 0..) |expression, index| {
        switch (expression.value) {
            .reference => |symbol| bindings[index] = @backingInt(symbol),
            .field, .tuple_field => |field| {
                if (bindings[@backingInt(field.target)]) |parent| bindings[index] = try builder.child(parent, field.index, expression.type_id);

                var ancestor: ir.ExprId = @fromBackingInt(@intCast(index));

                while (true) {
                    ancestor = switch (program.expression(ancestor).value) {
                        .field, .tuple_field => |item| item.target,
                        else => break,
                    };

                    for (roots[@backingInt(ancestor)].items) |root| _ = try builder.path(root, ancestor, @fromBackingInt(@intCast(index)));
                }
            },
            else => {},
        }
    }

    return .{ .nodes = try builder.nodes.toOwnedSlice(allocator), .cached = cached, .children = builder.children };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    allocator.free(self.nodes);

    for (self.cached) |items| allocator.free(items);

    allocator.free(self.cached);
    self.children.deinit(allocator);
}

pub fn child(self: Self, parent: usize, index: u32) ?usize {
    return self.children.get(.{ .parent = parent, .index = index });
}

pub fn isReference(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list, .object, .tuple, .task => true,
        .optional => |item| isReference(program, item),
        .scalar => |scalar| scalar == .string,
        else => false,
    };
}

const Builder = struct {
    allocator: std.mem.Allocator,
    program: ir.Program,
    nodes: std.ArrayList(Node) = .empty,
    children: Children = .empty,
    fn root(self: *Builder, type_id: ir.TypeId) std.mem.Allocator.Error!usize {
        const id = self.nodes.items.len;

        try self.nodes.append(self.allocator, .{ .reference = isReference(self.program, type_id) });

        return id;
    }
    fn child(self: *Builder, parent: usize, index: u32, type_id: ir.TypeId) std.mem.Allocator.Error!usize {
        const entry = try self.children.getOrPut(self.allocator, .{ .parent = parent, .index = index });

        if (!entry.found_existing) {
            entry.value_ptr.* = self.nodes.items.len;

            try self.nodes.append(self.allocator, .{ .parent = parent, .sibling = self.nodes.items[parent].child, .reference = isReference(self.program, type_id) });

            self.nodes.items[parent].child = entry.value_ptr.*;
        }

        return entry.value_ptr.*;
    }
    fn path(self: *Builder, root_id: usize, ancestor: ir.ExprId, id: ir.ExprId) std.mem.Allocator.Error!usize {
        if (id == ancestor) return root_id;

        const expression = self.program.expression(id);

        const field = switch (expression.value) {
            .field, .tuple_field => |item| .{ .target = item.target, .index = item.index },
            else => unreachable,
        };

        const parent = try self.path(root_id, ancestor, field.target);

        return self.child(parent, field.index, expression.type_id);
    }
};
