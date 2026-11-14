const std = @import("std");
const zx = @import("zx");
const Entry = @import("../entries.zig").Entry;
const generated = @import("parser_options").generated_parser;
const Self = @This();
const initial_capacity = 8;
const load_denominator = 4;
const capacity_growth = 2;

pub const empty: Self = .{};

keys: std.ArrayList([]const u8) = .empty,
values: std.ArrayList(*Entry) = .empty,
buckets: []u64 = &.{},
pub const Slot = struct { position: usize, existing: ?*Entry = null };

pub fn get(self: *const Self, path: []const u8) ?*Entry {
    return self.probe(path).existing;
}

pub fn probe(self: *const Self, path: []const u8) Slot {
    if (self.buckets.len == 0) return .{ .position = 0 };

    const located = self.locate(path);

    return .{
        .position = located.slot,
        .existing = if (located.entry != 0) self.values.items[@intCast(located.entry - 1)] else null,
    };
}

const Located = struct { slot: usize, entry: u64 };

fn locate(self: *const Self, path: []const u8) Located {
    if (comptime generated) {
        const rule = @import("generated_byte_index_slot");

        const input: std.meta.Child(rule.Input) = .{
            .keys = self.keys.items,
            .buckets = @ptrCast(&self.buckets),
            .capacity = self.buckets.len,
            .key = path,
        };

        var empty_buffer = std.heap.FixedBufferAllocator.init(&.{});
        const found = zx.columns.invoke(rule.executeValue, empty_buffer.allocator(), &input) catch unreachable;

        return .{ .slot = @intCast(found.slot), .entry = found.entry };
    }

    return seedProbe(self.keys.items, self.buckets, path);
}

pub fn reserve(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!bool {
    try self.keys.ensureUnusedCapacity(allocator, 1);
    try self.values.ensureUnusedCapacity(allocator, 1);

    const count = self.keys.items.len + 1;
    const previous = self.buckets.len;
    const limit = previous - previous / load_denominator;

    if (count <= limit) return false;

    const capacity = if (previous == 0) initial_capacity else std.math.mul(usize, previous, capacity_growth) catch return error.OutOfMemory;
    const buckets = try allocator.alloc(u64, capacity);

    @memset(buckets, 0);
    self.rebuild(buckets);
    allocator.free(self.buckets);

    self.buckets = buckets;

    return true;
}

fn rebuild(self: *const Self, buckets: []u64) void {
    if (comptime generated) {
        const rule = @import("generated_byte_index_rebuild");

        const input: std.meta.Child(rule.Input) = .{
            .keys = self.keys.items,
            .buckets = @ptrCast(&buckets),
            .capacity = buckets.len,
        };

        var empty_buffer = std.heap.FixedBufferAllocator.init(&.{});
        const count = zx.columns.invoke(rule.executeValue, empty_buffer.allocator(), &input) catch unreachable;

        std.debug.assert(count == self.keys.items.len);

        return;
    }

    for (self.keys.items, 1..) |key, entry| {
        buckets[seedProbe(self.keys.items, buckets, key).slot] = entry;
    }
}

pub fn append(self: *Self, slot: usize, key: []const u8, entry: *Entry) void {
    std.debug.assert(self.buckets[slot] == 0);
    self.keys.appendAssumeCapacity(key);
    self.values.appendAssumeCapacity(entry);

    self.buckets[slot] = self.keys.items.len;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.keys.deinit(allocator);
    self.values.deinit(allocator);
    allocator.free(self.buckets);
}

fn seedProbe(keys: []const []const u8, buckets: []const u64, path: []const u8) Located {
    const mask = buckets.len - 1;
    var slot: usize = @intCast(zx.bytes.hash(0, path) & mask);

    while (true) : (slot = (slot + 1) & mask) {
        const entry = buckets[slot];

        if (entry == 0 or zx.bytes.equal(keys[@intCast(entry - 1)], path)) return .{ .slot = slot, .entry = entry };
    }
}
