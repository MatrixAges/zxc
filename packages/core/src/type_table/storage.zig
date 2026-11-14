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
    const firsts = try self.reserveDelta(allocator, delta);
    const child_offset: u32 = @intCast(self.children.items.len);
    const field_offset: u32 = @intCast(self.field_types.items.len);
    const name_offset: u32 = @intCast(self.names.items.len);

    for (delta.kinds, delta.first, firsts) |code, first, *destination| {
        const kind: model.Kind = @fromBackingInt(@intCast(code));

        destination.* = first + switch (kind) {
            .object => field_offset,
            .tuple => child_offset,
            .error_set, .enumeration => name_offset,
            else => @as(u32, 0),
        };
    }

    self.publishDelta(delta);
}

/// Reserves all columns and lends the unpublished first-column tail for rebasing.
pub fn reserveDelta(self: *Self, allocator: std.mem.Allocator, delta: Table) Error![]u32 {
    const limit = std.math.maxInt(u32);

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const current = @field(self, name).items.len;
        const added = @field(delta, name).len;

        if (current > limit or added > limit - current) return error.OutOfMemory;
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, @field(delta, name).len);
    }

    return self.first.unusedCapacitySlice()[0..delta.first.len];
}

/// Publishes a reserved delta after its first-column tail is initialized.
pub fn publishDelta(self: *Self, delta: Table) void {
    self.publish(delta, false);
}

/// Publishes a reserved delta whose text columns are already initialized in their tails.
pub fn publishOwnedDelta(self: *Self, delta: Table) void {
    self.publish(delta, true);
}

fn publish(self: *Self, delta: Table, comptime text_in_tail: bool) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const source = @field(delta, name);

        if (comptime std.mem.eql(u8, name, "first") or (text_in_tail and std.meta.Elem(@TypeOf(source)) == []const u8)) {
            _ = @field(self, name).addManyAsSliceAssumeCapacity(source.len);
        } else {
            @field(self, name).appendSliceAssumeCapacity(source);
        }
    }
}
