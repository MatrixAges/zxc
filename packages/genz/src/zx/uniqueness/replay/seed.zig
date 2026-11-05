const std = @import("std");
const Self = @This();

active: bool,
changes: []bool,
cursors: [3][]u32,
pub fn init(allocator: std.mem.Allocator, previous: anytype, key: [32]u8, identities: []const [32]u8, callees: []const []const u32) std.mem.Allocator.Error!Self {
    const changes = try allocator.alloc(bool, identities.len);
    const trace = if (previous) |value| if (std.mem.eql(u8, &value.key, &key) and value.identities.len == identities.len) value else null else null;

    for (changes, 0..) |*target, index| target.* = if (trace) |value| !std.mem.eql(u8, &value.identities[index], &identities[index]) else true;

    var self = Self{ .active = trace != null, .changes = changes, .cursors = undefined };

    for (&self.cursors) |*cursor| cursor.* = try allocator.alloc(u32, identities.len);

    if (trace) |value| {
        for (changes, 0..) |differs, index| if (differs and !std.mem.eql(u32, value.callees[index], callees[index])) {
            self.active = false;
        };

        inline for (.{ "settled", "demanded", "planned" }, 0..) |kind, position| @memcpy(self.cursors[position], @field(value, kind).starts[0..identities.len]);
    }

    return self;
}

pub fn changed(self: *const Self) []const bool {
    return self.changes;
}

pub fn following(self: *const Self) bool {
    return self.active;
}

pub fn recall(self: *Self, comptime kind: anytype, index: usize, end: u32) std.mem.Allocator.Error!?u32 {
    if (!self.active or self.changes[index]) return null;

    const cursor = &self.cursors[@backingInt(kind)][index];

    if (cursor.* == end) {
        self.active = false;

        return null;
    }

    const selected = cursor.*;

    cursor.* += 1;

    return selected;
}

pub fn expect(self: *Self, comptime kind: anytype, index: usize, end: u32) std.mem.Allocator.Error!?u32 {
    if (!self.active or !self.changes[index]) return null;

    const cursor = self.cursors[@backingInt(kind)][index];

    if (cursor == end) {
        self.active = false;

        return null;
    }

    return cursor;
}

pub fn confirm(self: *Self, comptime kind: anytype, index: usize, matched: bool) std.mem.Allocator.Error!void {
    if (!self.active or !self.changes[index]) return;

    if (!matched) {
        self.active = false;

        return;
    }

    self.cursors[@backingInt(kind)][index] += 1;
}
