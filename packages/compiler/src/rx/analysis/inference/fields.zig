const std = @import("std");
const Graph = @import("types.zig");
const Self = @This();
pub const Field = struct { name: []const u8, value: Graph.Id };
const Name = []const u8;
const row_bytes = @sizeOf(Name) + @sizeOf(Graph.Id);

bytes: [*]u8 = undefined,
len: usize = 0,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    if (count == 0) return .{};

    const size = std.math.mul(usize, count, row_bytes) catch return error.OutOfMemory;
    const storage = try allocator.alignedAlloc(u8, .of(Name), size);

    return .{ .bytes = storage.ptr, .len = count };
}

/// Reconstruct the descriptor from the complete value column of this layout.
pub fn fromValues(column: []const Graph.Id) Self {
    if (column.len == 0) return .{};

    const data: [*]const u8 = @ptrCast(column.ptr);

    return .{ .bytes = @constCast(data - column.len * @sizeOf(Name)), .len = column.len };
}

pub fn names(self: Self) []const []const u8 {
    return self.nameColumn();
}

pub fn values(self: Self) []const Graph.Id {
    return self.valueColumn();
}

pub fn set(self: Self, index: usize, name: []const u8, value: Graph.Id) void {
    self.nameColumn()[index] = name;
    self.valueColumn()[index] = value;
}

pub fn copyTo(self: Self, destination: Self) void {
    @memcpy(destination.nameColumn()[0..self.len], self.names());
    @memcpy(destination.valueColumn()[0..self.len], self.values());
}

fn nameColumn(self: Self) []Name {
    if (self.len == 0) return &.{};

    return @as([*]Name, @ptrCast(@alignCast(self.bytes)))[0..self.len];
}

fn valueColumn(self: Self) []Graph.Id {
    if (self.len == 0) return &.{};

    const start = self.bytes + self.len * @sizeOf(Name);

    return @as([*]Graph.Id, @ptrCast(@alignCast(start)))[0..self.len];
}
