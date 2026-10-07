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
pub const Error = std.mem.Allocator.Error;

pub fn count(self: *const Self) usize {
    return self.kinds.items.len;
}

pub fn get(self: *const Self, id: model.TypeId) model.Type {
    return self.view().get(id);
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Table {
    var result: Table = .{};

    errdefer {
        inline for (@typeInfo(Self).@"struct".field_names) |name| {
            allocator.free(@field(result, name));
        }
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(result, name) = try @field(self, name).toOwnedSlice(allocator);
    }

    return result;
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: @import("value.zig").Value) Error!void {
    const fields: model.Fields = if (value == .object) value.object else .{ .names = &.{}, .types = &.{}, .len = 0 };
    const children: []const model.TypeId = if (value == .tuple) value.tuple else &.{};

    const names: []const []const u8 = switch (value) {
        .error_set => |items| items,
        .enumeration => |item| item.members,
        else => &.{},
    };

    const sizes = .{ .kinds = 1, .first = 1, .second = 1, .labels = 1, .children = children.len, .field_types = fields.len, .field_names = fields.len, .names = names.len };

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const current = @field(self, name).items.len;
        const added = @field(sizes, name);

        if (current > std.math.maxInt(u32) or added > std.math.maxInt(u32) - current) return error.OutOfMemory;
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, @field(sizes, name));
    }

    const first: u32 = switch (value) {
        .scalar => |item| @intCast(@backingInt(item)),
        .optional, .list => |child| @backingInt(child),
        .task => |task| @backingInt(task.result),
        .object => @intCast(self.field_types.items.len),
        .tuple => @intCast(self.children.items.len),
        .error_set, .enumeration => @intCast(self.names.items.len),
        .native_reference => 0,
    };

    const second: u32 = switch (value) {
        .object => @intCast(fields.len),
        .tuple => @intCast(children.len),
        .error_set, .enumeration => @intCast(names.len),
        .task => |task| @backingInt(task.errors),
        else => 0,
    };

    self.kinds.appendAssumeCapacity(@intCast(@backingInt(value)));
    self.first.appendAssumeCapacity(first);
    self.second.appendAssumeCapacity(second);
    self.labels.appendAssumeCapacity(value.nominalName() orelse "");
    self.field_names.appendSliceAssumeCapacity(fields.names);
    self.field_types.appendSliceAssumeCapacity(fields.types);
    for (children) |child| self.children.appendAssumeCapacity(@backingInt(child));

    self.names.appendSliceAssumeCapacity(names);
}

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

pub fn retainPrefix(self: *Self, len: usize) void {
    const prefix = self.view().prefix(len);

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).items.len = @field(prefix, name).len;
    }
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        @field(self, name).deinit(allocator);
    }

    self.* = .{};
}

pub fn appendDelta(self: *Self, allocator: std.mem.Allocator, delta: Table) Error!void {
    const limit = std.math.maxInt(u32);

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const current = @field(self, name).items.len;
        const added = @field(delta, name).len;

        if (current > limit or added > limit - current) return error.OutOfMemory;
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
