const std = @import("std");
const Export = @import("../../../compiled.zig").Export;

pub fn columns(comptime Target: type, allocator: std.mem.Allocator, exports: []const Export) std.mem.Allocator.Error!Target {
    const names = try allocator.alloc([]const u8, exports.len);
    const paths = try allocator.alloc([]const u8, exports.len);
    const functions = try allocator.alloc(?u32, exports.len);
    const type_names = try allocator.alloc([]const []const u8, exports.len);
    const type_ids = try allocator.alloc([]const u32, exports.len);

    for (exports, 0..) |exported, index| {
        names[index] = exported.name;
        paths[index] = exported.path;
        functions[index] = if (exported.function) |id| @backingInt(id) else null;
        const row_names = try allocator.alloc([]const u8, exported.types.len);
        const row_ids = try allocator.alloc(u32, exported.types.len);

        for (exported.types, row_names, row_ids) |item, *name, *id| {
            name.* = item.name;
            id.* = @backingInt(item.type_id);
        }

        type_names[index] = row_names;
        type_ids[index] = row_ids;
    }

    return .{ .names = names, .paths = paths, .functions = functions, .type_names = type_names, .type_ids = type_ids };
}
