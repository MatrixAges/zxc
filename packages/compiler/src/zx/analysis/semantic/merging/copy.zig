const std = @import("std");
const ir = @import("zx").ir;

pub fn value(allocator: std.mem.Allocator, source: ir.TypeValue) std.mem.Allocator.Error!ir.TypeValue {
    return switch (source) {
        .scalar, .optional, .list, .task => source,
        .native_reference => |name| .{ .native_reference = try allocator.dupe(u8, name) },
        .tuple => |children| .{ .tuple = try allocator.dupe(ir.TypeId, children) },
        .object => |fields| blk: {
            const names = try allocator.alloc([]const u8, fields.len);

            for (fields.names, names) |name, *copied| copied.* = try allocator.dupe(u8, name);

            break :blk .{ .object = .{ .names = names, .types = fields.types, .len = fields.len } };
        },
        .error_set => |names| blk: {
            const members = try allocator.alloc([]const u8, names.len);

            for (names, members) |member, *owned| owned.* = try allocator.dupe(u8, member);

            break :blk .{ .error_set = members };
        },
        .enumeration => |entry| blk: {
            const members = try allocator.alloc([]const u8, entry.members.len);

            for (entry.members, members) |member, *copied| copied.* = try allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try allocator.dupe(u8, entry.name), .members = members } };
        },
    };
}
