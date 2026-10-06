const std = @import("std");
const ir = @import("zx").ir;

pub fn value(allocator: std.mem.Allocator, borrowed: ir.TypeValue) std.mem.Allocator.Error!ir.TypeValue {
    return switch (borrowed) {
        .scalar => |scalar| .{ .scalar = scalar },
        .native_reference => |name| .{ .native_reference = try allocator.dupe(u8, name) },
        .task, .optional, .list, .tuple => borrowed,
        .object => |fields| blk: {
            const names = try allocator.alloc([]const u8, fields.len);

            for (fields.names, names) |name, *owned| owned.* = try allocator.dupe(u8, name);

            break :blk .{ .object = .{ .names = names, .types = fields.types, .len = fields.len } };
        },
        .error_set => |names| blk: {
            const members = try allocator.alloc([]const u8, names.len);

            for (names, members) |member, *owned| owned.* = try allocator.dupe(u8, member);

            break :blk .{ .error_set = members };
        },
        .enumeration => |value_enum| blk: {
            const members = try allocator.alloc([]const u8, value_enum.members.len);

            for (value_enum.members, members) |member, *owned| owned.* = try allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try allocator.dupe(u8, value_enum.name), .members = members } };
        },
    };
}
