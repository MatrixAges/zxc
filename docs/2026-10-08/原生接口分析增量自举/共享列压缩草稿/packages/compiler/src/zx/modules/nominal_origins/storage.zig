const std = @import("std");
const Table = @import("table.zig");
const model = @import("model.zig");
const Self = @This();

ids: std.ArrayList(u32) = .empty,
kinds: std.ArrayList(u8) = .empty,
owners: std.ArrayList([]const u8) = .empty,
members: std.ArrayList([]const u8) = .empty,
names: std.ArrayList([]const u8) = .empty,
pub fn view(self: *const Self) Table {
    return .{
        .ids = self.ids.items,
        .kinds = self.kinds.items,
        .owners = self.owners.items,
        .members = self.members.items,
        .names = self.names.items,
    };
}

pub fn append(self: *Self, allocator: std.mem.Allocator, item: model.Item) std.mem.Allocator.Error!void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, 1);
    }

    const kind: u8 = switch (item.origin) {
        .source => 0,
        .native => 1,
        .external => 2,
    };

    const owner = switch (item.origin) {
        .source, .native => |value| value,
        .external => |value| value.module,
    };

    self.ids.appendAssumeCapacity(@backingInt(item.type_id));
    self.kinds.appendAssumeCapacity(kind);
    self.owners.appendAssumeCapacity(owner);
    self.members.appendAssumeCapacity(if (item.origin == .external) item.origin.external.member else "");
    self.names.appendAssumeCapacity(item.name);
}

pub fn appendTable(self: *Self, allocator: std.mem.Allocator, table: Table) std.mem.Allocator.Error!void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, table.count());
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).appendSliceAssumeCapacity(@field(table, name));
    }
}

pub fn retainPrefix(self: *Self, len: usize) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).items = @field(self, name).items[0..len];
    }
}

pub fn clearRetainingCapacity(self: *Self) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).clearRetainingCapacity();
    }
}
