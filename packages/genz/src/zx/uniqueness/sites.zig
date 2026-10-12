const std = @import("std");
const ir = @import("zx").ir;
const Order = @import("order.zig");
const Slots = @import("slots.zig");
const Summaries = @import("summaries.zig");
const Self = @This();
/// Every read of a root (a symbol, or an expression node), followed through projections, the aggregates and bindings
/// that carry it, and whether a list slot of that root is used linearly: at most one consuming read on any path, no
/// consuming read repeated by a loop the root lives outside of, and every observation before the consuming read.
/// Lengths are read from the list value itself, so they never conflict with an update.
/// Root slot `r` of a site is slot `r + delta` of its `top` value; `region` is the deepest arm the path to it runs
/// through, which decides exclusivity once the walk has climbed out of the arms the value was carried in, and `arms` the
/// last arms it entered, which tell apart a value carried out of one branch into the arms of a later one. A path only
/// runs when every arm on it does, so any pair of them in exclusive arms keeps two sites apart.
/// Paths that end on the same consuming `edge` at the same `delta` met at an alternative, so only one of them runs.
pub const Site = struct { lo: u32, hi: u32, delta: i32, top: ir.ExprId, region: u32, arms: Arms, edge: u32, parent: u32, role: Order.Role };

/// The most recent arms a path entered, leaving out an arm that only encloses the one before it.
pub const Arms = struct {
    items: [4]u32 = @splat(0),
    len: u8 = 0,
    fn enter(self: Arms, regions: []const Order.Region, region: u32) Arms {
        if (regions[region].depth == 0) return self;

        if (self.len != 0) {
            var last = self.items[self.len - 1];

            while (regions[last].depth > regions[region].depth) last = regions[last].parent;
            if (last == region) return self;
        }

        var next = self;

        if (next.len == next.items.len) {
            std.mem.copyForwards(u32, next.items[0 .. next.items.len - 1], next.items[1..]);

            next.len -= 1;
        }

        next.items[next.len] = region;
        next.len += 1;

        return next;
    }

    fn apart(self: Arms, order: *const Order, time: u32, other: Arms, other_time: u32) bool {
        for (self.items[0..self.len]) |left| for (other.items[0..other.len]) |right| {
            if (order.apart(left, time, right, other_time)) return true;
        };

        return false;
    }
};

order: *const Order,
slots: Slots,
expressions: ir.ExpressionTable,
symbols: ir.SymbolTable,
summaries: *const Summaries,
first: []u32,
sites: []Site,
/// Where the list slots of each root start in a dense per-slot table; the facts of a body index their slots by it.
slot_first: []const u32,
/// Whether each root slot is used linearly, once decided. Uses depend only on the body and the fixed callee mutation
/// and output types, so the answers hold across every analysis of the body.
memo: []Memo,
pub fn create(allocator: std.mem.Allocator, order: *const Order, slots: Slots, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, summaries: *const Summaries) std.mem.Allocator.Error!Self {
    const symbol_count = symbols.count();
    const roots = symbol_count + expressions.count();
    const consumers = try group(allocator, order, expressions.count());
    const buckets = try allocator.alloc(std.ArrayList(Site), roots);

    @memset(buckets, .empty);

    var walker = Walker{ .allocator = allocator, .order = order, .slots = slots, .expressions = expressions, .consumers = consumers, .references = try references(allocator, order, expressions, symbol_count), .buckets = buckets };

    for (0..expressions.count()) |index| {
        if (order.time[index] == Order.none) continue;

        const id: ir.ExprId = @fromBackingInt(@intCast(index));
        const value = expressions.get(id);
        const size = slots.count(value.type_id);

        if (size == 0) continue;

        switch (value.value) {
            .field, .tuple_field, .optional_value => {},
            .reference => |symbol| try walker.walk(@backingInt(symbol), id, 0, .{}, 0, 0, size),
            else => try walker.walk(symbol_count + index, id, 0, .{}, 0, 0, size),
        }
    }

    const first = try allocator.alloc(u32, roots + 1);
    var sites: std.ArrayList(Site) = .empty;

    for (buckets, 0..) |bucket, index| {
        first[index] = @intCast(sites.items.len);

        try sites.appendSlice(allocator, bucket.items);
    }

    first[roots] = @intCast(sites.items.len);

    var self = Self{ .order = order, .slots = slots, .expressions = expressions, .symbols = symbols, .summaries = summaries, .first = first, .sites = sites.items, .slot_first = &.{}, .memo = &.{} };
    const slot_first = try allocator.alloc(u32, roots + 1);
    var total: u32 = 0;

    for (slot_first[0..roots], 0..) |*start, root| {
        start.* = total;
        total += slots.count(self.rootType(@intCast(root)));
    }

    slot_first[roots] = total;
    self.slot_first = slot_first;
    self.memo = try allocator.alloc(Memo, total);

    @memset(self.memo, .unknown);

    return self;
}

const Memo = enum(u8) { unknown, linear, shared };

pub fn symbolRoot(symbol: ir.SymbolId) u32 {
    return @backingInt(symbol);
}

pub fn nodeRoot(self: Self, id: ir.ExprId) u32 {
    return @intCast(self.symbols.count() + @backingInt(id));
}

pub fn rootType(self: Self, root: u32) ir.TypeId {
    const symbol_count = self.symbols.count();

    return if (root < symbol_count) self.symbols.at(root).type_id else self.expressions.get(@fromBackingInt(@intCast(root - symbol_count))).type_id;
}

fn defLoop(self: Self, root: u32) u32 {
    const symbol_count = self.symbols.count();

    return if (root < symbol_count) self.order.def_loop[root] else self.order.loop[root - symbol_count];
}

/// Only observations read the slot, as a loop condition must for its state to stay in place.
pub fn observed(self: *Self, root: u32, slot: u32) bool {
    for (self.sites[self.first[root]..self.first[root + 1]]) |site| {
        if (slot < site.lo or slot >= site.hi) continue;
        if (self.role(site, slot) != .observe) return false;
    }

    return true;
}

pub fn linear(self: *Self, root: u32, slot: u32) bool {
    const index = self.slot_first[root] + slot;

    if (index >= self.slot_first[root + 1]) return self.decide(root, slot);

    switch (self.memo[index]) {
        .linear => return true,
        .shared => return false,
        .unknown => {},
    }

    const result = self.decide(root, slot);

    self.memo[index] = if (result) .linear else .shared;

    return result;
}

fn decide(self: *Self, root: u32, slot: u32) bool {
    const range = self.sites[self.first[root]..self.first[root + 1]];
    const home = self.defLoop(root);
    const order = self.order;

    for (range, 0..) |site, index| {
        if (slot < site.lo or slot >= site.hi or self.role(site, slot) == .observe) continue;
        if (order.loop[@backingInt(site.top)] != home) return false;

        for (range, 0..) |other, other_index| {
            if (other_index == index or slot < other.lo or slot >= other.hi or (other.edge == site.edge and other.delta == site.delta)) continue;
            if (order.apart(site.region, order.time[@backingInt(site.top)], other.region, order.time[@backingInt(other.top)])) continue;
            if (site.arms.apart(order, order.time[@backingInt(site.top)], other.arms, order.time[@backingInt(other.top)])) continue;
            if (self.role(other, slot) != .observe) return false;
            if (!before(order, other, site)) return false;
        }
    }

    return true;
}

/// An observation comes first when its value is read before the consumed one, inside the consuming node, or, for a value
/// both read through one shared node, when the observing node finishes before the consuming node starts. A statement
/// consumes its value once the value is built, so whatever the building reads comes first.
fn before(order: *const Order, observation: Site, consumer: Site) bool {
    const seen = order.time[@backingInt(observation.top)];

    if (seen < order.time[@backingInt(consumer.top)]) return true;
    if (consumer.parent == Order.none) return seen < order.finish[@backingInt(consumer.top)];
    if (observation.parent != Order.none and order.finish[observation.parent] <= order.time[consumer.parent]) return true;

    return seen > order.time[consumer.parent] and seen < order.finish[consumer.parent];
}

/// A call argument slot only observes unless the callee may write that input slot in place or return it.
pub fn role(self: Self, site: Site, slot: u32) Order.Role {
    if (site.role != .argument) return site.role;

    const callee = self.expressions.get(@fromBackingInt(site.parent)).value.call.function;
    const input: u32 = @intCast(@as(i64, slot) + site.delta);

    return if (self.summaries.mayHold(callee, input) or self.summaries.mayMutate(callee, input)) .use else .observe;
}

const Walker = struct {
    allocator: std.mem.Allocator,
    order: *const Order,
    slots: Slots,
    expressions: ir.ExpressionTable,
    consumers: Consumers,
    references: Consumers,
    buckets: []std.ArrayList(Site),
    fn walk(self: *Walker, root: usize, node: ir.ExprId, outer: u32, entered: Arms, delta: i32, lo: u32, hi: u32) std.mem.Allocator.Error!void {
        const index = @backingInt(node);
        const regions = self.order.regions.items;

        for (self.consumers.edges[self.consumers.first[index]..self.consumers.first[index + 1]], self.consumers.first[index]..) |edge, position| {
            const anchor = if (regions[edge.region].depth > regions[outer].depth) edge.region else outer;
            const arms = entered.enter(regions, edge.region);

            switch (edge.role) {
                .evaluation => continue,
                .flow => {
                    try self.walk(root, @fromBackingInt(edge.parent), anchor, arms, delta, lo, hi);

                    continue;
                },
                .member => {
                    const parent: ir.ExprId = @fromBackingInt(edge.parent);
                    const member = self.slots.member(self.expressions.get(parent).type_id, edge.index);

                    try self.walk(root, parent, anchor, arms, delta + @as(i32, @intCast(member.offset)), lo, hi);

                    continue;
                },
                .bind => {
                    for (self.references.edges[self.references.first[edge.index]..self.references.first[edge.index + 1]]) |reference| try self.walk(root, reference.child, anchor, arms, delta, lo, hi);

                    continue;
                },
                else => {},
            }

            if (edge.parent != Order.none) {
                const parent: ir.ExprId = @fromBackingInt(edge.parent);

                switch (self.expressions.get(parent).value) {
                    .field, .tuple_field => |projection| if (projection.target == node) {
                        const member = self.slots.member(self.expressions.get(node).type_id, projection.index);
                        const offset: i64 = @as(i64, member.offset) - delta;
                        const first: u32 = @intCast(@max(offset, lo));
                        const last: u32 = @intCast(@max(@min(offset + self.slots.count(member.type_id), hi), first));

                        if (first < last) try self.walk(root, parent, anchor, arms, delta - @as(i32, @intCast(member.offset)), first, last);

                        continue;
                    },
                    .optional_value => {
                        try self.walk(root, parent, anchor, arms, delta, lo, hi);

                        continue;
                    },
                    .length => continue,
                    else => {},
                }
            }

            try self.buckets[root].append(self.allocator, .{ .lo = lo, .hi = hi, .delta = delta, .top = node, .region = anchor, .arms = arms, .edge = @intCast(position), .parent = edge.parent, .role = edge.role });
        }
    }
};

/// The reference nodes of each symbol, as edges from no parent.
fn references(allocator: std.mem.Allocator, order: *const Order, expressions: ir.ExpressionTable, count: usize) std.mem.Allocator.Error!Consumers {
    const first = try allocator.alloc(u32, count + 1);
    var total: usize = 0;

    @memset(first, 0);

    for (0..expressions.count()) |index| {
        if (order.time[index] == Order.none) continue;

        switch (expressions.get(@fromBackingInt(@intCast(index))).value) {
            .reference => |symbol| {
                first[@backingInt(symbol) + 1] += 1;

                total += 1;
            },
            else => {},
        }
    }

    for (1..first.len) |index| first[index] += first[index - 1];

    const edges = try allocator.alloc(Order.Edge, total);
    const cursor = try allocator.dupe(u32, first[0..count]);

    for (0..expressions.count()) |index| {
        if (order.time[index] == Order.none) continue;

        switch (expressions.get(@fromBackingInt(@intCast(index))).value) {
            .reference => |symbol| {
                const slot = &cursor[@backingInt(symbol)];

                edges[slot.*] = .{ .parent = Order.none, .child = @fromBackingInt(@intCast(index)), .role = .use };
                slot.* += 1;
            },
            else => {},
        }
    }

    return .{ .first = first, .edges = edges };
}

const Consumers = struct { first: []u32, edges: []Order.Edge };

fn group(allocator: std.mem.Allocator, order: *const Order, count: usize) std.mem.Allocator.Error!Consumers {
    const first = try allocator.alloc(u32, count + 1);
    const edges = try allocator.alloc(Order.Edge, order.edges.items.len);

    @memset(first, 0);

    for (order.edges.items) |edge| first[@backingInt(edge.child) + 1] += 1;
    for (1..first.len) |index| first[index] += first[index - 1];

    const cursor = try allocator.dupe(u32, first[0..count]);

    for (order.edges.items) |edge| {
        const slot = &cursor[@backingInt(edge.child)];

        edges[slot.*] = edge;
        slot.* += 1;
    }

    return .{ .first = first, .edges = edges };
}
