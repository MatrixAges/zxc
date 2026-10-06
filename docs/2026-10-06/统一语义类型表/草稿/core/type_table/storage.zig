const std = @import("std");
const Table = @import("root.zig");
const model = @import("model.zig");
const Self = @This();

kinds: std.ArrayList(u8) = .empty,
first: std.ArrayList(u32) = .empty,
second: std.ArrayList(u32) = .empty,
labels: std.ArrayList([]const u8) = .empty,
children: std.ArrayList(u32) = .empty,
field_types: std.ArrayList(u32) = .empty,
field_names: std.ArrayList([]const u8) = .empty,
names: std.ArrayList([]const u8) = .empty,
pub const Error = std.mem.Allocator.Error || error{TypeTableLimit};

pub fn view(self: *const Self) Table {
    return .{
        .kinds = self.kinds.items,
        .first = self.first.items,
        .second = self.second.items,
        .labels = self.labels.items,
        .children = self.children.items,
        .field_types = self.field_types.items,
        .field_names = self.field_names.items,
        .names = self.names.items,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).deinit(allocator);
    }

    self.* = .{};
}

pub fn append(self: *Self, allocator: std.mem.Allocator, delta: Table) Error!void {
    const limit = std.math.maxInt(u32);

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const current = @field(self, name).items.len;
        const added = @field(delta, name).len;

        if (current > limit or added > limit - current) return error.TypeTableLimit;
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, @field(delta, name).len);
    }

    const child_offset: u32 = @intCast(self.children.items.len);
    const field_offset: u32 = @intCast(self.field_types.items.len);
    const name_offset: u32 = @intCast(self.names.items.len);

    for (delta.kinds, delta.first) |code, first| {
        const kind: model.Kind = @fromBackingInt(@intCast(code));

        const adjusted = first + switch (kind) {
            .object => field_offset,
            .tuple => child_offset,
            .error_set, .enumeration => name_offset,
            else => @as(u32, 0),
        };

        self.first.appendAssumeCapacity(adjusted);
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        if (comptime !std.mem.eql(u8, name, "first")) {
            @field(self, name).appendSliceAssumeCapacity(@field(delta, name));
        }
    }
}
