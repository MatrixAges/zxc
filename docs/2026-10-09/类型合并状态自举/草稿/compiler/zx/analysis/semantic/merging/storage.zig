const std = @import("std");
const Self = @This();

mapping: Buffer(u32) = .{},
delta: struct {
    kinds: Buffer(u8) = .{},
    first: Buffer(u32) = .{},
    second: Buffer(u32) = .{},
    labels: Buffer([]const u8) = .{},
    children: Buffer(u32) = .{},
    field_types: Buffer(u32) = .{},
    field_names: Buffer([]const u8) = .{},
    names: Buffer([]const u8) = .{},
} = .{},
origins: struct {
    ids: Buffer(u32) = .{},
    kinds: Buffer(u8) = .{},
    owners: Buffer([]const u8) = .{},
    members: Buffer([]const u8) = .{},
} = .{},
references: Buffer(u32) = .{},
fn Buffer(comptime Element: type) type {
    return struct {
        list: std.ArrayList(Element) = .empty,
        started: bool = false,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(@TypeOf(self.delta)).@"struct".field_names) |name| {
        @field(self.delta, name).list.deinit(allocator);
    }

    inline for (@typeInfo(@TypeOf(self.origins)).@"struct".field_names) |name| {
        @field(self.origins, name).list.deinit(allocator);
    }

    self.references.list.deinit(allocator);
}
