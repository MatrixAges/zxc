const std = @import("std");
const ir = @import("zx").ir;

pub fn copy(allocator: std.mem.Allocator, values: []const ir.Type) std.mem.Allocator.Error![]const ir.Type {
    const result = try allocator.dupe(ir.Type, values);

    for (result) |*value| switch (value.*) {
        .object => |fields| {
            const owned = try allocator.dupe(ir.TypeField, fields);

            for (owned) |*field| field.name = try allocator.dupe(u8, field.name);

            value.* = .{ .object = owned };
        },
        .native_reference => |name| value.* = .{ .native_reference = try allocator.dupe(u8, name) },
        .tuple => |children| value.* = .{ .tuple = try allocator.dupe(ir.TypeId, children) },
        .error_set => |names| {
            const members = try allocator.alloc([]const u8, names.len);

            for (names, members) |member, *owned| owned.* = try allocator.dupe(u8, member);

            value.* = .{ .error_set = members };
        },
        .enumeration => |enumeration| {
            const members = try allocator.alloc([]const u8, enumeration.members.len);

            for (enumeration.members, members) |member, *owned| owned.* = try allocator.dupe(u8, member);

            value.* = .{ .enumeration = .{ .name = try allocator.dupe(u8, enumeration.name), .members = members } };
        },
        else => {},
    };

    return result;
}
