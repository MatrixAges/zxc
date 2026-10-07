const std = @import("std");
const ir = @import("../ir.zig");
const Table = @import("root.zig");
const Self = @This();

paths: std.ArrayList([]const u8) = .empty,
types: std.ArrayList(u32) = .empty,
handles: std.ArrayList([]const u8) = .empty,
readable: std.ArrayList(bool) = .empty,
writable: std.ArrayList(bool) = .empty,
pub fn count(self: *const Self) usize {
    return self.paths.items.len;
}

pub fn at(self: *const Self, index: usize) ir.StoreSlot {
    return self.view().at(index);
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: ir.StoreSlot) std.mem.Allocator.Error!void {
    if (self.count() == std.math.maxInt(u32)) return error.OutOfMemory;

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        try @field(self, name).ensureUnusedCapacity(allocator, 1);
    }

    self.paths.appendAssumeCapacity(value.path);
    self.types.appendAssumeCapacity(@backingInt(value.type_id));
    self.handles.appendAssumeCapacity(value.handle);
    self.readable.appendAssumeCapacity(value.readable);
    self.writable.appendAssumeCapacity(value.writable);
}

pub fn view(self: *const Self) Table {
    var result: Table = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Table {
    var result: Table = .{};

    errdefer {
        inline for (@typeInfo(Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = try @field(self, name).toOwnedSlice(allocator);

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
