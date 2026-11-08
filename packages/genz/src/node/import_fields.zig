const std = @import("std");
const node = @import("../node.zig");
const Fields = @import("stored.zig").Fields;
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

/// Imports complete field columns and owns their text in the target allocator.
pub fn append(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    _ = try appendFields(allocator, target, source, false);
}

/// Text must outlive the target; field descriptors receive owned column storage.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!Fields {
    return appendFields(allocator, target, source, true);
}

/// Materializes standalone fields; borrowed text must outlive the returned descriptors.
pub fn materializeBorrowingText(allocator: std.mem.Allocator, source: anytype) Error![]const node.Field {
    const count = source.name.len;

    inline for (@typeInfo(std.meta.Child(@TypeOf(source))).@"struct".field_names) |name| {
        if (@field(source, name).len != count) return error.InvalidAst;
    }

    const result = try allocator.alloc(node.Field, count);

    for (result, 0..) |*item, index| item.* = .{
        .name = source.name[index],
        .value = @fromBackingInt(source.value[index]),
        .default_value = if (source.default_value[index]) |id| @fromBackingInt(id) else null,
        .comptime_parameter = source.comptime_parameter[index],
    };

    return result;
}

fn appendFields(allocator: std.mem.Allocator, target: anytype, source: anytype, comptime borrow_text: bool) Error!Fields {
    const count = source.name.len;

    inline for (@typeInfo(std.meta.Child(@TypeOf(source))).@"struct".field_names) |name| {
        if (@field(source, name).len != count) return error.InvalidAst;
    }

    if (count > std.math.maxInt(u32) - target.count()) return error.OutOfMemory;

    const start: u32 = @intCast(target.count());

    try target.reserve(allocator, count);

    for (0..count) |index| target.append(node.Field{
        .name = if (comptime borrow_text) source.name[index] else try allocator.dupe(u8, source.name[index]),
        .value = @fromBackingInt(source.value[index]),
        .default_value = if (source.default_value[index]) |id| @fromBackingInt(id) else null,
        .comptime_parameter = source.comptime_parameter[index],
    });

    return .{ .start = start, .len = @intCast(count) };
}
