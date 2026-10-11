//! Column-wise operations over the shared tables, which store each row field in its own list. A table view has the
//! same fields as its storage, each holding that list's items.
const std = @import("std");

/// The length of every column of `Storage`.
pub fn Lengths(comptime Storage: type) type {
    return [@typeInfo(Storage).@"struct".field_names.len]usize;
}

pub fn measure(storage: anytype) Lengths(@TypeOf(storage.*)) {
    var result: Lengths(@TypeOf(storage.*)) = undefined;

    inline for (@typeInfo(@TypeOf(storage.*)).@"struct".field_names, 0..) |name, index| result[index] = @field(storage, name).items.len;

    return result;
}

/// Whether the rows `left` added between `left_start` and `left_end` equal those `right` added from `right_start` on.
pub fn equal(left: anytype, left_start: anytype, left_end: @TypeOf(left_start), right: @TypeOf(left), right_start: @TypeOf(left_start), right_end: @TypeOf(left_start)) bool {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names, 0..) |name, index| {
        if (left_end[index] - left_start[index] != right_end[index] - right_start[index]) return false;
        if (!same(@field(left, name)[left_start[index]..left_end[index]], @field(right, name)[right_start[index]..right_end[index]])) return false;
    }

    return true;
}

/// Appends the rows `source` holds between `start` and `end` to `storage`, sharing what they point to.
pub fn transplant(allocator: std.mem.Allocator, storage: anytype, source: anytype, start: Lengths(@TypeOf(storage.*)), end: Lengths(@TypeOf(storage.*))) std.mem.Allocator.Error!void {
    inline for (@typeInfo(@TypeOf(storage.*)).@"struct".field_names, 0..) |name, index| {
        try @field(storage, name).appendSlice(allocator, @field(source, name)[start[index]..end[index]]);
    }
}

/// Structural equality: slices and single pointers compare what they reference.
pub fn same(left: anytype, right: @TypeOf(left)) bool {
    const T = @TypeOf(left);

    return switch (@typeInfo(T)) {
        .int, .bool, .@"enum", .float, .void => left == right,
        .optional => if (left) |value| if (right) |other| same(value, other) else false else right == null,
        .array => same(left[0..], right[0..]),
        .pointer => |pointer| switch (pointer.size) {
            .one => left == right or same(left.*, right.*),
            .slice => slices(left, right),
            else => @compileError("cannot compare " ++ @typeName(T)),
        },
        .@"struct" => |info| {
            inline for (info.field_names) |name| if (!same(@field(left, name), @field(right, name))) return false;

            return true;
        },
        .@"union" => {
            if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

            return switch (left) {
                inline else => |value, tag| same(value, @field(right, @tagName(tag))),
            };
        },
        else => @compileError("cannot compare " ++ @typeName(T)),
    };
}

fn slices(left: anytype, right: @TypeOf(left)) bool {
    const Element = std.meta.Elem(@TypeOf(left));

    if (left.len != right.len) return false;
    if (left.len == 0 or left.ptr == right.ptr) return true;

    if (comptime std.meta.hasUniqueRepresentation(Element)) return std.mem.eql(Element, left, right);

    for (left, right) |a, b| if (!same(a, b)) return false;

    return true;
}
