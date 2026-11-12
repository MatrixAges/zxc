const std = @import("std");
const Self = @This();
const Table = @import("zx").bytes.Map(usize);
pub const empty: Self = .{ .paths = .empty };

paths: Table,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    var result = empty;

    try result.paths.ensureTotalCapacity(allocator, std.math.cast(u32, count) orelse return error.OutOfMemory);

    return result;
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    var paths = self.paths;

    paths.deinit(allocator);
}

pub fn claim(self: *Self, row: usize, key: []const u8) bool {
    const found = self.paths.getOrPutAssumeCapacity(key);

    if (found.found_existing) return false;

    found.value_ptr.* = row;

    return true;
}

pub fn get(self: *const Self, key: []const u8) ?usize {
    return self.paths.get(key);
}
