const std = @import("std");
const ir = @import("zx").ir;

pub fn copy(allocator: std.mem.Allocator, values: ir.TypeTable) std.mem.Allocator.Error!ir.TypeTable {
    return .{
        .kinds = try allocator.dupe(u8, values.kinds),
        .first = try allocator.dupe(u32, values.first),
        .second = try allocator.dupe(u32, values.second),
        .labels = try names(allocator, values.labels),
        .children = try allocator.dupe(u32, values.children),
        .field_types = try allocator.dupe(u32, values.field_types),
        .field_names = try names(allocator, values.field_names),
        .names = try names(allocator, values.names),
    };
}

fn names(allocator: std.mem.Allocator, values: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    const result = try allocator.alloc([]const u8, values.len);

    for (values, result) |value, *owned| owned.* = try allocator.dupe(u8, value);

    return result;
}
