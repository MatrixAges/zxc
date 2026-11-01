const std = @import("std");
const Export = @import("../../../compiled.zig").Export;

pub fn columns(comptime Target: type, allocator: std.mem.Allocator, exports: []const Export) std.mem.Allocator.Error!Target {
    const MemberValue = std.meta.Child(@FieldType(Target, "members"));
    const Member = if (@typeInfo(MemberValue) == .pointer) std.meta.Child(MemberValue) else MemberValue;
    const members = try allocator.alloc(MemberValue, exports.len);
    const names = try allocator.alloc([]const u8, exports.len);
    const paths = try allocator.alloc([]const u8, exports.len);
    const functions = try allocator.alloc(?u32, exports.len);
    const type_names = try allocator.alloc([]const []const u8, exports.len);
    const type_ids = try allocator.alloc([]const u32, exports.len);
    const Optional = std.meta.Child(@FieldType(Target, "constants"));
    const Item = @typeInfo(Optional).optional.child;
    const Values = if (@typeInfo(Item) == .pointer) std.meta.Child(Item) else Item;
    const constants = try allocator.alloc(Optional, exports.len);

    for (exports, 0..) |exported, index| {
        const mapped = @import("../../../../analysis/analyzer/host/bindings.zig").imports;
        const member = try allocator.create(Member);
        member.* = @import("../../../../ir/canonical/borrow.zig").columns(Member, try mapped(allocator, exported.members));
        members[index] = if (@typeInfo(MemberValue) == .pointer) member else member.*;
        const values = try @import("../../../../analysis/constants/input.zig").marshal(Values, allocator, exported.constants);
        constants[index] = if (values) |value| if (@typeInfo(Item) == .pointer) value else value.* else null;
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

    return .{ .names = names, .paths = paths, .functions = functions, .type_names = type_names, .type_ids = type_ids, .constants = constants, .members = members };
}
