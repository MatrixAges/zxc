const std = @import("std");
const ir = @import("zx").ir;

pub fn own(allocator: std.mem.Allocator, scope: anytype, offset: u64) std.mem.Allocator.Error![]const ir.Constant {
    const values = scope orelse return &.{};
    const first: usize = @intCast(offset);
    const constants = try allocator.alloc(ir.Constant, values.names.len - first);

    for (values.names[first..], values.values[first..], constants) |name, literal, *constant| constant.* = .{
        .name = try allocator.dupe(u8, name),
        .type_id = @fromBackingInt(literal.type_id),
        .value = try @import("input.zig").own(allocator, literal),
    };

    return constants;
}
