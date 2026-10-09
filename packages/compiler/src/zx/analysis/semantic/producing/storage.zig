const std = @import("std");
const data = @import("nominal_data");
const Self = @This();

ids: Buffer(u32),
kinds: Buffer(u8),
owners: Buffer([]const u8),
members: Buffer([]const u8),
fn Buffer(comptime Element: type) type {
    return struct {
        list: std.ArrayList(Element),
        started: bool = true,
    };
}

pub fn init(items: *const data.Storage) Self {
    var result: Self = undefined;

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(result, name) = .{ .list = @field(items, name) };
    }

    return result;
}

pub fn apply(self: Self, items: *data.Storage) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(items, name) = @field(self, name).list;
    }
}
