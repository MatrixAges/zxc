const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
pub const Key = struct { expression: ir.ExprId, path: []const u32, origin: []const u32 };
pub const Node = struct { low: usize, active: bool = true, value: bool = false };
pub const Lookup = struct { index: usize, existing: bool };

const Context = struct {
    pub fn hash(_: @This(), key: Key) u64 {
        var value = std.hash.Wyhash.init(0);
        const expression = @backingInt(key.expression);

        value.update(std.mem.asBytes(&expression));
        value.update(std.mem.asBytes(&key.path.len));
        value.update(std.mem.sliceAsBytes(key.path));
        value.update(std.mem.sliceAsBytes(key.origin));

        return value.final();
    }

    pub fn eql(_: @This(), left: Key, right: Key) bool {
        return left.expression == right.expression and std.mem.eql(u32, left.path, right.path) and std.mem.eql(u32, left.origin, right.origin);
    }
};

indices: std.HashMapUnmanaged(Key, usize, Context, std.hash_map.default_max_load_percentage) = .empty,
nodes: std.ArrayList(Node) = .empty,
stack: std.ArrayList(usize) = .empty,
paths: ?std.heap.ArenaAllocator = null,
current: ?usize = null,
pub fn lookup(self: *Self, allocator: std.mem.Allocator, key: Key) std.mem.Allocator.Error!Lookup {
    if (self.indices.get(key)) |index| return .{ .index = index, .existing = true };

    const owned = self.storage(allocator);
    const index = self.nodes.items.len;

    try self.nodes.append(allocator, .{ .low = index });
    try self.stack.append(allocator, index);

    try self.indices.put(allocator, .{
        .expression = key.expression,
        .path = try owned.dupe(u32, key.path),
        .origin = try owned.dupe(u32, key.origin),
    }, index);

    return .{ .index = index, .existing = false };
}

pub fn connect(self: *Self, parent: usize, low: usize) void {
    self.nodes.items[parent].low = @min(self.nodes.items[parent].low, low);
}

pub fn finish(self: *Self, index: usize, value: bool) void {
    self.nodes.items[index].value = value;

    if (self.nodes.items[index].low != index) return;

    var first = self.stack.items.len;
    var result = false;

    while (first != 0) {
        first -= 1;
        const member = self.stack.items[first];

        result = result or self.nodes.items[member].value;

        if (member == index) break;
    }

    for (self.stack.items[first..]) |member| {
        self.nodes.items[member].active = false;
        self.nodes.items[member].value = result;
    }

    self.stack.shrinkRetainingCapacity(first);
}

pub fn storage(self: *Self, backing: std.mem.Allocator) std.mem.Allocator {
    if (self.paths == null) self.paths = std.heap.ArenaAllocator.init(backing);

    return self.paths.?.allocator();
}

pub fn clear(self: *Self) void {
    std.debug.assert(self.current == null and self.stack.items.len == 0);
    self.indices.clearRetainingCapacity();
    self.nodes.clearRetainingCapacity();

    if (self.paths) |*paths| _ = paths.reset(.retain_capacity);
}
