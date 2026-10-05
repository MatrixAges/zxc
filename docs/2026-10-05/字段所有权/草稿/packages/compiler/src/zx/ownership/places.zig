const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
pub const State = enum { copy, borrowed, owned, loaned, moved };

const Node = struct {
    parent: ?usize = null,
    child: ?usize = null,
    sibling: ?usize = null,
    reference: bool,
};

nodes: []const Node,
expressions: []const ?usize,
pub fn init(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    var nodes: std.ArrayList(Node) = .empty;

    defer nodes.deinit(allocator);

    for (program.symbols) |symbol| try nodes.append(allocator, .{ .reference = isReference(program, symbol.type_id) });

    const expressions = try allocator.alloc(?usize, program.expressions.len);

    errdefer allocator.free(expressions);
    @memset(expressions, null);

    var children: std.AutoHashMapUnmanaged(struct { parent: usize, index: u32 }, usize) = .empty;

    defer children.deinit(allocator);

    for (program.expressions, 0..) |expression, index| {
        switch (expression.value) {
            .reference => |symbol| expressions[index] = @intFromEnum(symbol),
            .field, .tuple_field => |field| {
                const parent = expressions[@intFromEnum(field.target)] orelse continue;
                const entry = try children.getOrPut(allocator, .{ .parent = parent, .index = field.index });

                if (!entry.found_existing) {
                    entry.value_ptr.* = nodes.items.len;

                    try nodes.append(allocator, .{ .parent = parent, .sibling = nodes.items[parent].child, .reference = isReference(program, expression.type_id) });

                    nodes.items[parent].child = entry.value_ptr.*;
                }

                expressions[index] = entry.value_ptr.*;
            },
            else => {},
        }
    }

    return .{ .nodes = try nodes.toOwnedSlice(allocator), .expressions = expressions };
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    allocator.free(self.nodes);
    allocator.free(self.expressions);
}

pub fn assign(self: Self, states: []State, id: usize, state: State) void {
    self.subtree(states, id, state);
    self.parents(states, id, state);
}

fn subtree(self: Self, states: []State, id: usize, state: State) void {
    const node = self.nodes[id];

    states[id] = if (node.reference or state == .moved) state else .copy;

    var child = node.child;

    while (child) |index| {
        self.subtree(states, index, state);

        child = self.nodes[index].sibling;
    }
}

pub fn borrow(self: Self, states: []State, id: usize, permanent: bool) void {
    const state = &states[id];

    if (state.* == .owned or (permanent and state.* == .loaned)) state.* = if (permanent) .borrowed else .loaned;

    var child = self.nodes[id].child;

    while (child) |index| {
        self.borrow(states, index, permanent);

        child = self.nodes[index].sibling;
    }

    self.parents(states, id, states[id]);
}

fn parents(self: Self, states: []State, id: usize, state: State) void {
    var parent = self.nodes[id].parent;

    while (parent) |index| {
        states[index] = combine(states[index], state);
        parent = self.nodes[index].parent;
    }
}

pub fn combine(left: State, right: State) State {
    if (left == .moved or right == .moved) return .moved;
    if (left == .borrowed or right == .borrowed) return .borrowed;
    if (left == .loaned or right == .loaned) return .loaned;

    return left;
}

pub fn isReference(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list, .object, .tuple => true,
        .optional => |child| isReference(program, child),
        .scalar => |scalar| scalar == .string,
        else => false,
    };
}
