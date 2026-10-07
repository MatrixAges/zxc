const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
pub const State = enum { copy, borrowed, owned, loaned, moved };
const Layout = @import("places/layout.zig");

layout: Layout,
pub fn init(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    return .{ .layout = try Layout.init(allocator, program) };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.layout.deinit(allocator);
}

pub fn assign(self: Self, states: []State, id: usize, state: State) void {
    self.subtree(states, id, state);
    self.parents(states, id, state);
}

fn subtree(self: Self, states: []State, id: usize, state: State) void {
    const node = self.layout.nodes[id];

    states[id] = if (node.reference or state == .moved) state else .copy;

    var child = node.child;

    while (child) |index| {
        self.subtree(states, index, state);

        child = self.layout.nodes[index].sibling;
    }
}

pub fn borrow(self: Self, states: []State, id: usize, permanent: bool) void {
    const state = &states[id];

    if (state.* == .owned or (permanent and state.* == .loaned)) state.* = if (permanent) .borrowed else .loaned;

    var child = self.layout.nodes[id].child;

    while (child) |index| {
        self.borrow(states, index, permanent);

        child = self.layout.nodes[index].sibling;
    }

    self.parents(states, id, states[id]);
}

fn parents(self: Self, states: []State, id: usize, state: State) void {
    var parent = self.layout.nodes[id].parent;

    while (parent) |index| {
        states[index] = combine(states[index], state);
        parent = self.layout.nodes[index].parent;
    }
}

pub fn combine(left: State, right: State) State {
    if (left == .moved or right == .moved) return .moved;
    if (left == .borrowed or right == .borrowed) return .borrowed;
    if (left == .loaned or right == .loaned) return .loaned;

    return left;
}

pub fn isReference(program: ir.Program, id: ir.TypeId) bool {
    return Layout.isReference(program, id);
}
