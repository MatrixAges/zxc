const std = @import("std");

/// Element storage for generated list slices, which hold either values or pointers to values.
pub fn List(comptime Slice: type) type {
    return struct {
        pub const Element = @typeInfo(Slice).pointer.child;
        pub const Value = if (single(Element)) @typeInfo(Element).pointer.child else Element;

        values: []Value,
        pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!@This() {
            return .{ .values = try allocator.alloc(Value, count) };
        }
        pub fn finish(self: @This(), allocator: std.mem.Allocator) std.mem.Allocator.Error!Slice {
            if (Element == Value) return self.values;

            const pointers = try allocator.alloc(Element, self.values.len);

            for (self.values, pointers) |*item, *pointer| pointer.* = item;

            return pointers;
        }
    };
}

pub fn unwrap(item: anytype) @TypeOf(if (comptime single(@TypeOf(item))) item.* else item) {
    return if (comptime single(@TypeOf(item))) item.* else item;
}

fn single(comptime T: type) bool {
    return @typeInfo(T) == .pointer and @typeInfo(T).pointer.size == .one;
}
