const std = @import("std");
const node = @import("../node.zig");
const Tag = std.meta.Tag(node.Declaration);
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

/// Imports constant declaration columns directly into an unstored declaration list.
pub fn append(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), source: anytype) Error!void {
    const count = source.tags.len;

    if (source.offsets.len != count or source.constant_name.len != count or source.constant_type_expr.len != count or source.constant_value.len != count or source.constant_exported.len != count) return error.InvalidAst;
    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;

    for (source.tags, source.offsets) |tag, offset| {
        if (@backingInt(tag) != @backingInt(Tag.constant) or offset >= count) return error.InvalidAst;
    }

    try target.ensureUnusedCapacity(allocator, count);

    for (source.offsets) |offset| {
        target.appendAssumeCapacity(.{ .constant = .{
            .name = try allocator.dupe(u8, source.constant_name[offset]),
            .type_expr = if (source.constant_type_expr[offset]) |id| @fromBackingInt(id) else null,
            .value = @fromBackingInt(source.constant_value[offset]),
            .exported = source.constant_exported[offset],
        } });
    }
}
