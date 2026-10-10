const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Self = @This();

names: std.StringHashMapUnmanaged([]const u8) = .empty,
declarations: std.ArrayList(node.Declaration) = .empty,
/// Buffers parameters with the same lane layout in one generated file share one named struct,
/// so a call that forwards every lane can pass the caller's buffers value unchanged.
pub fn named(lowering: *Lower, key: []const u8, fields: []const node.Field) Lower.Error!*const node.Expression {
    const self = &lowering.buffer_types;

    if (self.names.get(key)) |name| return lowering.builder.identifier(name);

    const name = try std.fmt.allocPrint(lowering.allocator, "zx_buffers_{d}", .{self.declarations.items.len});

    try self.declarations.append(lowering.allocator, .{ .constant = .{ .name = name, .value = try lowering.builder.expression(.{ .struct_type = fields }) } });
    try self.names.put(lowering.allocator, key, name);

    return lowering.builder.identifier(name);
}
