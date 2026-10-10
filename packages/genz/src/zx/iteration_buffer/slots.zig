const std = @import("std");

/// Dense state table that records written slots, so snapshots, restores and joins touch only those slots.
pub fn Slots(comptime Item: type, comptime empty: Item) type {
    return struct {
        const Self = @This();
        const untouched = std.math.maxInt(u32);
        pub const Saved = struct { items: []const Item, len: usize };
        items: []Item,
        positions: []u32,
        written: std.ArrayList(u32) = .empty,
        pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
            const self = Self{ .items = try allocator.alloc(Item, count), .positions = try allocator.alloc(u32, count) };

            @memset(self.items, empty);
            @memset(self.positions, untouched);

            return self;
        }
        pub fn set(self: *Self, allocator: std.mem.Allocator, index: usize, item: Item) std.mem.Allocator.Error!void {
            if (self.positions[index] == untouched) {
                self.positions[index] = @intCast(self.written.items.len);

                try self.written.append(allocator, @intCast(index));
            }

            self.items[index] = item;
        }
        pub fn save(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Saved {
            const items = try allocator.alloc(Item, self.written.items.len);

            for (self.written.items, items) |index, *item| item.* = self.items[index];

            return .{ .items = items, .len = items.len };
        }
        pub fn restore(self: *Self, saved: Saved) void {
            for (self.written.items, 0..) |index, position| self.items[index] = savedAt(saved, position);
        }
        /// Value of one slot in a saved table; slots written after the save were still empty then.
        pub fn lookup(self: *const Self, saved: Saved, index: usize) Item {
            return savedAt(saved, self.positions[index]);
        }
        pub fn savedAt(saved: Saved, position: usize) Item {
            return if (position < saved.len) saved.items[position] else empty;
        }
    };
}
