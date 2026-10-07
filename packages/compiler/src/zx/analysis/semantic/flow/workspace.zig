const std = @import("std");
const zx = @import("zx");
const Self = @This();
pub const Event = struct { kind: u64, a: u64, b: u64, c: u64 };
const Change = struct { index: usize, value: bool };

allocator: std.mem.Allocator,
facts: *zx.Refinement,
active: []bool = &.{},
declared: []bool = &.{},
owners: []u64 = &.{},
history: std.ArrayList(Change) = .empty,
events: std.ArrayList(Event) = .empty,
current: Event = .{ .kind = 0, .a = 0, .b = 0, .c = 0 },
pub fn init(allocator: std.mem.Allocator, count: usize, facts: *zx.Refinement) std.mem.Allocator.Error!Self {
    var self = Self{ .allocator = allocator, .facts = facts };

    errdefer self.deinit();

    self.active = try allocator.alloc(bool, count);
    self.declared = try allocator.alloc(bool, count);
    self.owners = try allocator.alloc(u64, count);

    @memset(self.active, false);
    @memset(self.declared, false);
    @memset(self.owners, 0);

    return self;
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.active);
    self.allocator.free(self.declared);
    self.allocator.free(self.owners);
    self.history.deinit(self.allocator);
    self.events.deinit(self.allocator);
}

pub fn setActive(self: *Self, index: usize, value: bool) std.mem.Allocator.Error!void {
    if (self.active[index] == value) return;
    try self.history.append(self.allocator, .{ .index = index, .value = self.active[index] });

    self.active[index] = value;
}

pub fn restoreActive(self: *Self, mark: usize) void {
    while (self.history.items.len > mark) {
        const change = self.history.pop().?;

        self.active[change.index] = change.value;
    }
}
