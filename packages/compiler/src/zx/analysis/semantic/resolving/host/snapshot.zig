const std = @import("std");
const Types = @import("../../../types.zig");
const model = @import("model.zig");
const Self = @This();

resolved: model.Cache,
aliases: model.Cache,
visiting: []const []const u8,
pub fn init(allocator: std.mem.Allocator, types: *const Types) std.mem.Allocator.Error!Self {
    const resolved_names = try allocator.alloc([]const u8, types.resolved.count());
    const resolved_ids = try allocator.alloc(u32, types.resolved.count());
    var resolved = types.resolved.iterator();

    for (resolved_names, resolved_ids) |*name, *id| {
        const item = resolved.next().?;

        name.* = item.key_ptr.*;
        id.* = @backingInt(item.value_ptr.*);
    }

    const alias_names = try allocator.alloc([]const u8, types.aliases.len);
    const alias_ids = try allocator.alloc(u32, types.aliases.len);

    for (types.aliases, alias_names, alias_ids) |alias, *name, *id| {
        name.* = alias.name;
        id.* = @backingInt(alias.type_id);
    }

    const visiting = try allocator.alloc([]const u8, types.visiting.count());
    var keys = types.visiting.keyIterator();

    for (visiting) |*name| name.* = keys.next().?.*;

    return .{
        .resolved = .{ .names = resolved_names, .ids = resolved_ids },
        .aliases = .{ .names = alias_names, .ids = alias_ids },
        .visiting = visiting,
    };
}
