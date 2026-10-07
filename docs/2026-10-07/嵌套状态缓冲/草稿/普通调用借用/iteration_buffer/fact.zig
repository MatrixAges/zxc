const std = @import("std");

pub const Value = union(enum) { none, stale, version: usize, borrowed: usize, aggregate: []const Value };

pub fn contains(value: Value) bool {
    return switch (value) {
        .none => false,
        .version, .borrowed, .stale => true,
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
        .version, .borrowed => |version| version == current,
        .aggregate => |items| blk: {
            for (items) |item| if (!observe(item, current)) break :blk false;

            break :blk true;
        },
    };
}

pub fn merge(allocator: std.mem.Allocator, left: Value, right: Value, left_version: usize, right_version: usize, joined: usize) std.mem.Allocator.Error!Value {
    if (!contains(left) and !contains(right)) return .none;
    if (left == .version and right == .version and left.version == left_version and right.version == right_version) return .{ .version = joined };

    const left_readable = left == .none or ((left == .version or left == .borrowed) and observe(left, left_version));
    const right_readable = right == .none or ((right == .version or right == .borrowed) and observe(right, right_version));

    if (left_readable and right_readable) return .{ .borrowed = joined };

    if (left == .aggregate and right == .aggregate and left.aggregate.len == right.aggregate.len) {
        const items = try allocator.alloc(Value, left.aggregate.len);

        for (left.aggregate, right.aggregate, items) |a, b, *item| item.* = try merge(allocator, a, b, left_version, right_version, joined);

        return .{ .aggregate = items };
    }

    if (left == .aggregate and right == .none) {
        const items = try allocator.alloc(Value, left.aggregate.len);

        for (left.aggregate, items) |a, *item| item.* = try merge(allocator, a, .none, left_version, right_version, joined);

        return .{ .aggregate = items };
    }

    if (left == .none and right == .aggregate) return merge(allocator, right, left, right_version, left_version, joined);

    return .stale;
}

pub fn field(value: Value, index: u32) Value {
    return if (value == .aggregate and index < value.aggregate.len) value.aggregate[index] else if (contains(value)) .stale else .none;
}

pub fn retains(value: Value, path: []const usize, current: usize) bool {
    if (path.len == 0) return value == .version and value.version == current;
    if (value != .aggregate or path[0] >= value.aggregate.len) return false;

    for (value.aggregate, 0..) |child, index| {
        if (index == path[0]) {
            if (!retains(child, path[1..], current)) return false;
        } else if (contains(child)) return false;
    }

    return true;
}

pub fn count(value: Value) usize {
    return switch (value) {
        .none => 0,
        .version, .borrowed, .stale => 1,
        .aggregate => |items| blk: {
            var total: usize = 0;

            for (items) |item| total += count(item);

            break :blk total;
        },
    };
}

pub fn equal(left: Value, right: Value) bool {
    if (!contains(left) and !contains(right)) return true;
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .none, .stale => true,
        .version => |version| version == right.version,
        .borrowed => |version| version == right.borrowed,
        .aggregate => |items| blk: {
            if (items.len != right.aggregate.len) break :blk false;
            for (items, right.aggregate) |a, b| if (!equal(a, b)) break :blk false;

            break :blk true;
        },
    };
}
