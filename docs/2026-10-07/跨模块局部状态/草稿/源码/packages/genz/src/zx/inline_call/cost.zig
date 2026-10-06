const std = @import("std");
const ir = @import("zx").ir;
const limit = @import("plan.zig").limit;

pub fn count(costs: []const usize, value: anytype) usize {
    const T = @TypeOf(value);

    if (T == ir.ExprId) return costs[@backingInt(value)];

    var result: usize = 0;

    switch (@typeInfo(T)) {
        .@"struct" => |info| inline for (info.field_names) |name| {
            result +|= count(costs, @field(value, name));
        },
        .@"union" => |info| inline for (info.field_names) |name| {
            if (std.mem.eql(u8, @tagName(value), name)) result = count(costs, @field(value, name));
        },
        .optional => if (value) |child| {
            result = count(costs, child);
        },
        .pointer => |info| if (info.size == .slice and info.child != u8) {
            for (value) |child| result +|= count(costs, child);
        },
        else => {},
    }

    return @min(limit + 1, result);
}
