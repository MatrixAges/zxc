const std = @import("std");
const Id = @import("types.zig").Id;
const enabled = @import("rx_options").generated_graph;
const extend = if (enabled) @import("generated_rx_forest_extend") else void;
const halve = if (enabled) @import("generated_rx_forest_halve") else void;
const link = if (enabled) @import("generated_rx_forest_link") else void;

const State = if (enabled)
    @typeInfo(@typeInfo(@TypeOf(extend.executeState)).@"fn".return_type.?).error_union.payload

else
    std.ArrayList(u32);

const Self = @This();

state: State = if (enabled) .{ .items = &.{}, .storage = .plain } else .empty,
pub fn append(self: *Self, allocator: std.mem.Allocator, id: Id) std.mem.Allocator.Error!void {
    std.debug.assert(self.state.items.len == @backingInt(id));

    if (!enabled) return self.state.append(allocator, @backingInt(id));

    self.state = extend.executeState(allocator, self.state) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
    };
}

pub fn parent(self: *const Self, id: Id) Id {
    return @fromBackingInt(self.state.items[@backingInt(id)]);
}

/// Parent compression changes the cache without changing the equivalence relation.
pub fn root(self: *const Self, id: Id) Id {
    const parents = self.state.items;
    const index = @backingInt(id);
    const first = parents[index];

    if (first == index or parents[first] == first) return @fromBackingInt(first);
    if (!enabled) return @fromBackingInt(seedRoot(parents, index, first));

    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const result = halve.executeState(empty.allocator(), .{ .parents = self.state, .item = index, .parent = first }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == parents.ptr);

    return @fromBackingInt(result.item);
}

pub fn connect(self: *Self, representative: Id, member: Id) void {
    if (!enabled) {
        self.state.items[@backingInt(member)] = @backingInt(representative);

        return;
    }

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = link.executeState(empty.allocator(), .{
        .parents = self.state,
        .parent = @backingInt(representative),
        .child = @backingInt(member),
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == self.state.items.ptr);

    self.state = result.parents;
}

fn seedRoot(parents: []u32, index: u32, first: u32) u32 {
    var current = index;
    var next = first;

    while (next != current) {
        const grandparent = parents[next];

        parents[current] = grandparent;
        current = grandparent;
        next = parents[current];
    }

    return current;
}
