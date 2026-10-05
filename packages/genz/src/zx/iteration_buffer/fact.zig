const std = @import("std");

pub const Value = union(enum) { none, stale, version: usize, aggregate: []const Value };

pub fn contains(value: Value) bool {
    return switch (value) {
        .none => false,
        .version, .stale => true,
        .aggregate => |items| blk: {
            for (items) |item| if (contains(item)) break :blk true;

            break :blk false;
        },
    };
}

pub fn observe(value: Value, current: usize) bool {
    return switch (value) {
        .none => true,
        .stale => false,
        .version => |version| version == current,
        .aggregate => |items| blk: {
            for (items) |item| if (!observe(item, current)) break :blk false;

            break :blk true;
        },
    };
}

pub fn merge(allocator: std.mem.Allocator, left: Value, right: Value, left_version: usize, right_version: usize, joined: usize) std.mem.Allocator.Error!Value {
    if (!contains(left) and !contains(right)) return .none;
    if (left == .version and right == .version and left.version == left_version and right.version == right_version) return .{ .version = joined };

    if (left == .aggregate and right == .aggregate and left.aggregate.len == right.aggregate.len) {
        const items = try allocator.alloc(Value, left.aggregate.len);

        for (left.aggregate, right.aggregate, items) |a, b, *item| item.* = try merge(allocator, a, b, left_version, right_version, joined);

        return .{ .aggregate = items };
    }

    return .stale;
}

pub fn field(value: Value, index: u32) Value {
    return if (value == .aggregate and index < value.aggregate.len) value.aggregate[index] else if (contains(value)) .stale else .none;
}
