const std = @import("std");
const ir = @import("ir.zig");

pub fn contains(allocator: std.mem.Allocator, types: []const ir.Type, id: ir.TypeId) std.mem.Allocator.Error!bool {
    const index = @backingInt(id);

    if (types[index] == .native_reference) return true;

    const first = for (types[0..index], 0..) |value, offset| {
        if (value == .native_reference) break offset;
    } else return false;

    const flags = try allocator.alloc(bool, index + 1);

    defer allocator.free(flags);
    @memset(flags[0..first], false);

    for (types[first .. index + 1], first..) |value, offset| {
        flags[offset] = switch (value) {
            .native_reference => true,
            .optional, .list => |child| flags[@backingInt(child)],
            .task => |task| flags[@backingInt(task.result)],
            .tuple => |children| blk: {
                for (children) |child| if (flags[@backingInt(child)]) break :blk true;

                break :blk false;
            },
            .object => |fields| blk: {
                for (fields) |field| if (flags[@backingInt(field.type_id)]) break :blk true;

                break :blk false;
            },
            else => false,
        };
    }

    return flags[index];
}

pub fn owner(program: ir.Program, id: ir.TypeId) ?[]const u8 {
    const value = program.typeOf(id);

    if (value != .native_reference) return null;

    var identity: ?[]const u8 = null;
    var declared = false;

    for (program.native_modules) |module| {
        for (module.types) |binding| {
            if (binding.type_id != id) continue;
            if (identity) |key| if (!std.mem.eql(u8, key, module.key())) return null;

            identity = module.key();
            declared = declared or std.mem.eql(u8, binding.name, value.native_reference);
        }
    }

    return if (declared) identity else null;
}
