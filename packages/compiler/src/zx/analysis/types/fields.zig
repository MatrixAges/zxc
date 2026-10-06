const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

names: [][]const u8,
types: []u32,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const names = try allocator.alloc([]const u8, count);

    errdefer allocator.free(names);

    return .{ .names = names, .types = try allocator.alloc(u32, count) };
}

pub fn set(self: Self, index: usize, name: []const u8, type_id: ir.TypeId) void {
    self.names[index] = name;
    self.types[index] = @backingInt(type_id);
}

pub fn prefix(self: Self, count: usize) Self {
    return .{ .names = self.names[0..count], .types = self.types[0..count] };
}

pub fn view(self: Self) ir.TypeFields {
    return .{ .names = self.names, .types = self.types, .len = self.names.len };
}

pub fn sort(self: Self) std.mem.Allocator.Error!void {
    if (!@import("parser_options").generated_parser) {
        std.sort.pdqContext(0, self.names.len, self);

        return;
    }

    const generated = @import("generated_field_sort");
    const columns = @import("field_columns");
    const data = columns.View{ .names = self.names, .types = self.types };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, @ptrCast(&data)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn lessThan(self: Self, a: usize, b: usize) bool {
    return std.mem.lessThan(u8, self.names[a], self.names[b]);
}

pub fn swap(self: Self, a: usize, b: usize) void {
    std.mem.swap([]const u8, &self.names[a], &self.names[b]);
    std.mem.swap(u32, &self.types[a], &self.types[b]);
}
