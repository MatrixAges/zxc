const std = @import("std");
const ir = @import("ir.zig");

pub fn contains(allocator: std.mem.Allocator, types: ir.TypeTable, id: ir.TypeId) std.mem.Allocator.Error!bool {
    const index = @backingInt(id);

    if (types.at(index) == .native_reference) return true;

    const first = for (0..index) |offset| {
        const value = types.at(offset);

        if (value == .native_reference) break offset;
    } else return false;

    const flags = try allocator.alloc(bool, index + 1);

    defer allocator.free(flags);
    @memset(flags[0..first], false);

    for (first..index + 1) |offset| {
        const value = types.at(offset);

        flags[offset] = switch (value) {
            .native_reference => true,
            .optional, .list => |child| flags[@backingInt(child)],
            .task => |task| flags[@backingInt(task.result)],
            .tuple => |children| blk: {
                for (0..children.len) |child_index| if (flags[@backingInt(children.at(child_index))]) break :blk true;

                break :blk false;
            },
            .object => |fields| blk: {
                for (0..fields.len) |field_index| if (flags[@backingInt(fields.at(field_index).type_id)]) break :blk true;

                break :blk false;
            },
            else => false,
        };
    }

    return flags[index];
}

pub fn owner(program: ir.Program, id: ir.TypeId) ?[]const u8 {
    if (!program.native_modules.validStructure()) return null;

    const value = program.typeOf(id);

    if (value != .native_reference) return null;

    var identity: ?[]const u8 = null;
    var declared = false;

    for (0..program.native_modules.count()) |module_row| {
        const module = program.native_modules.at(module_row);

        for (0..module.types.count()) |binding_index| {
            const binding = module.types.at(binding_index);

            if (binding.type_id != id) continue;
            if (identity) |key| if (!std.mem.eql(u8, key, module.key())) return null;

            identity = module.key();
            declared = declared or std.mem.eql(u8, binding.name, value.native_reference);
        }
    }

    return if (declared) identity else null;
}
