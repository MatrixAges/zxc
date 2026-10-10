const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const flow = @import("flow.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error;
pub const Index = u32;
pub const Kind = enum { none, all, base, join, call, iteration };

pub const Node = struct {
    low: Index,
    active: bool = true,
    kind: Kind = .none,
    mask: ?[]const usize = null,
    owned: ?[]const usize = null,
    base: []const usize = &.{},
    children: []const Index = &.{},
    lanes: u32 = 0,
};

const Key = struct { expression: ir.ExprId, path: []const u32 };

const KeyContext = struct {
    pub fn hash(_: @This(), key: Key) u64 {
        var value = std.hash.Wyhash.init(@backingInt(key.expression));

        value.update(std.mem.sliceAsBytes(key.path));

        return value.final();
    }

    pub fn eql(_: @This(), left: Key, right: Key) bool {
        return left.expression == right.expression and std.mem.eql(u32, left.path, right.path);
    }
};

trace: *Trace,
allocator: std.mem.Allocator,
origins: []const []const u32,
owners: []const ir.TypeId,
loops: []const []const flow.Iteration,
words: usize,
universe: []const usize,
indices: std.HashMapUnmanaged(Key, Index, KeyContext, std.hash_map.default_max_load_percentage) = .empty,
nodes: std.ArrayList(Node) = .empty,
rows: std.ArrayList(usize) = .empty,
stack: std.ArrayList(Index) = .empty,
scratch: []usize,
filters: std.AutoHashMapUnmanaged(ir.TypeId, ?[]const usize) = .empty,
current: ?Index = null,
/// Origin sets of every (expression, path) query of one trace; loops[i] are the loops selected for origin i.
pub fn init(allocator: std.mem.Allocator, trace: *Trace, origins: []const []const u32, loops: []const []const flow.Iteration) Error!Self {
    const words = (origins.len + @bitSizeOf(usize) - 1) / @bitSizeOf(usize);
    const universe = try allocator.alloc(usize, words);
    const owners = try allocator.alloc(ir.TypeId, origins.len);

    @memset(universe, 0);

    for (origins, owners, 0..) |origin, *owner, position| {
        owner.* = @import("reach/masks.zig").owner(trace, origin);

        universe[position / @bitSizeOf(usize)] |= @as(usize, 1) << @intCast(position % @bitSizeOf(usize));
    }

    return .{ .trace = trace, .allocator = allocator, .origins = origins, .owners = owners, .loops = loops, .words = words, .universe = universe, .scratch = try allocator.alloc(usize, words) };
}

pub fn contains(self: *Self, id: ir.ExprId, path: []const u32, origin: usize) Error!bool {
    return self.has(try self.visit(id, path), origin);
}

pub fn has(self: *const Self, index: Index, origin: usize) bool {
    return self.row(index)[origin / @bitSizeOf(usize)] & (@as(usize, 1) << @intCast(origin % @bitSizeOf(usize))) != 0;
}

pub fn row(self: *const Self, index: Index) []usize {
    return self.rows.items[index * self.words ..][0..self.words];
}

pub fn visit(self: *Self, id: ir.ExprId, path: []const u32) Error!Index {
    if (self.indices.get(.{ .expression = id, .path = path })) |index| {
        if (self.nodes.items[index].active) if (self.current) |caller| self.connect(caller, index);

        return index;
    }

    const index: Index = @intCast(self.nodes.items.len);

    try self.indices.put(self.allocator, .{ .expression = id, .path = try self.allocator.dupe(u32, path) }, index);
    try self.nodes.append(self.allocator, .{ .low = index });
    try self.rows.appendNTimes(self.allocator, 0, self.words);
    try self.stack.append(self.allocator, index);

    const parent = self.current;
    self.current = index;

    var node = try @import("reach/equation.zig").build(self, id, path);

    self.current = parent;
    node.low = self.nodes.items[index].low;
    self.nodes.items[index] = node;
    _ = self.store(index);

    if (self.nodes.items[index].low == index) self.close(index);
    if (parent) |caller| self.connect(caller, self.nodes.items[index].low);

    return index;
}

fn connect(self: *Self, caller: Index, low: Index) void {
    self.nodes.items[caller].low = @min(self.nodes.items[caller].low, low);
}

fn close(self: *Self, root: Index) void {
    const first = std.mem.lastIndexOfScalar(Index, self.stack.items, root).?;
    const members = self.stack.items[first..];

    if (members.len > 1 or self.recursive(root)) while (true) {
        var changed = false;

        for (members) |member| changed = self.store(member) or changed;
        if (!changed) break;
    };

    for (members) |member| self.nodes.items[member].active = false;

    self.stack.shrinkRetainingCapacity(first);
}

fn recursive(self: *const Self, index: Index) bool {
    return std.mem.indexOfScalar(Index, self.nodes.items[index].children, index) != null;
}

fn store(self: *Self, index: Index) bool {
    const node = self.nodes.items[index];
    const next = self.scratch;

    switch (node.kind) {
        .none => @memset(next, 0),
        .all => @memcpy(next, self.universe),
        .base => @memcpy(next, node.base),
        .join, .call => {
            @memset(next, 0);

            for (node.children) |child| for (next, self.row(child)) |*word, value| {
                word.* |= value;
            };

            if (node.kind == .call and node.lanes != 0) if (node.owned) |owned| {
                for (next, self.row(node.children[0]), owned) |*word, first, selected| word.* = (word.* & ~selected) | (first & selected);
            };
        },
        .iteration => for (next, self.row(node.children[0]), self.row(node.children[1]), node.owned.?) |*word, initial, body, chosen| {
            word.* = initial | (body & ~chosen);
        },
    }

    if (node.mask) |mask| for (next, mask) |*word, value| {
        word.* &= value;
    };

    const target = self.row(index);

    if (std.mem.eql(usize, target, next)) return false;

    @memcpy(target, next);

    return true;
}
