const std = @import("std");
const Graph = @import("types.zig");
const Self = @This();
pub const Field = struct { name: []const u8, value: Graph.Id };
const Storage = std.MultiArrayList(Field);

bytes: [*]u8 = undefined,
len: usize = 0,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const storage = try Storage.initCapacity(allocator, count);

    return .{ .bytes = storage.bytes, .len = count };
}

pub fn names(self: Self) []const []const u8 {
    return self.columns().items(.name);
}

pub fn values(self: Self) []const Graph.Id {
    return self.columns().items(.value);
}

pub fn set(self: Self, index: usize, name: []const u8, value: Graph.Id) void {
    var storage = self.columns();

    storage.set(index, .{ .name = name, .value = value });
}

pub fn copyTo(self: Self, destination: Self) void {
    const storage = destination.columns();

    @memcpy(storage.items(.name)[0..self.len], self.names());
    @memcpy(storage.items(.value)[0..self.len], self.values());
}

fn columns(self: Self) Storage.Slice {
    const storage: Storage = .{ .bytes = self.bytes, .len = self.len, .capacity = self.len };

    return storage.slice();
}
