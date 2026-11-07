const std = @import("std");
const node = @import("../node.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

/// Imports complete field columns and owns their text in the target allocator.
pub fn append(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    const count = source.name.len;

    if (source.value.len != count or source.default_value.len != count or source.comptime_parameter.len != count) return error.InvalidAst;
    if (count > std.math.maxInt(u32) - target.count()) return error.OutOfMemory;
    try target.reserve(allocator, count);

    for (source.name, source.value, source.default_value, source.comptime_parameter) |name, value, default, comptime_parameter| {
        target.append(node.Field{
            .name = try allocator.dupe(u8, name),
            .value = @fromBackingInt(value),
            .default_value = if (default) |id| @fromBackingInt(id) else null,
            .comptime_parameter = comptime_parameter,
        });
    }
}
