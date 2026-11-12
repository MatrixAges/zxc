const std = @import("std");
const Self = @This();
const execute = @import("generated_fixed_byte_index").executeValue;
const Parameter = @typeInfo(@TypeOf(execute)).@"fn".param_types[1].?;
const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
const capacity_ratio = 2;
pub const empty: Self = .{ .keys = &.{}, .buckets = &.{} };

keys: [][]const u8,
buckets: []u64,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    if (count == 0) return empty;

    const desired = std.math.mul(usize, count, capacity_ratio) catch return error.OutOfMemory;
    const capacity = std.math.ceilPowerOfTwo(usize, desired) catch return error.OutOfMemory;
    const keys = try allocator.alloc([]const u8, count);

    errdefer allocator.free(keys);

    const buckets = try allocator.alloc(u64, capacity);

    @memset(buckets, 0);

    return .{ .keys = keys, .buckets = buckets };
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    allocator.free(self.buckets);
    allocator.free(self.keys);
}

pub fn claim(self: *Self, row: usize, key: []const u8) bool {
    if (self.find(key, row) != null) return false;

    self.keys[row] = key;

    return true;
}

pub fn get(self: *const Self, key: []const u8) ?usize {
    return @intCast(self.find(key, null) orelse return null);
}

fn find(self: *const Self, key: []const u8, insert: ?u64) ?u64 {
    if (self.buckets.len == 0) return null;

    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const input: Input = .{
        .keys = self.keys,
        .buckets = @ptrCast(&self.buckets),
        .capacity = self.buckets.len,
        .key = key,
        .insert = insert,
    };

    return execute(scratch.allocator(), if (@typeInfo(Parameter) == .pointer) &input else input) catch unreachable;
}
