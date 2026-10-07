const std = @import("std");
const Types = @import("../../../types.zig");
const model = @import("model.zig");
const Self = @This();

resolved: model.Cache,
aliases: model.Cache,
visiting: []const []const u8,
pub fn init(allocator: std.mem.Allocator, types: *const Types) std.mem.Allocator.Error!Self {
    const Id = @import("zx").ir.TypeId;

    if (@typeInfo(Id).@"enum".tag_type != u32 or @sizeOf(Id) != @sizeOf(u32) or @alignOf(Id) != @alignOf(u32)) @compileError("Incompatible resolved type ID representation");

    const values = types.resolved.values();
    const resolved_ids = @as([*]const u32, @ptrCast(values.ptr))[0..values.len];
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
        .resolved = .{ .names = types.resolved.keys(), .ids = resolved_ids },
        .aliases = .{ .names = alias_names, .ids = alias_ids },
        .visiting = visiting,
    };
}
