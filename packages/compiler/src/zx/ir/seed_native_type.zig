const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, shape: ir.NativeType, depth: usize) bool {
    var position: usize = 0;

    return visit(program, module_id, type_id, shape.names, &position, depth) and position == shape.names.len;
}

fn visit(program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, names: []const ?[]const u8, position: *usize, depth: usize) bool {
    if (depth >= 256 or position.* == names.len) return false;

    const name = names[position.*];

    position.* += 1;

    if (name) |text| {
        var found = false;
        const bindings = program.native_modules.at(@backingInt(module_id)).types;

        for (0..bindings.count()) |index| {
            const binding = bindings.at(index);

            if (binding.type_id == type_id and std.mem.eql(u8, binding.name, text)) found = true;
        }

        if (!found) return false;
    }

    return switch (program.typeOf(type_id)) {
        .task => false,
        .native_reference => name != null,
        .scalar, .enumeration, .error_set => true,
        .optional, .list => |child| visit(program, module_id, child, names, position, depth + 1),
        .tuple => |children| blk: {
            for (0..children.len) |index| {
                if (!visit(program, module_id, children.at(index), names, position, depth + 1)) break :blk false;
            }

            break :blk true;
        },
        .object => |fields| blk: {
            for (0..fields.len) |index| {
                if (!visit(program, module_id, fields.at(index).type_id, names, position, depth + 1)) break :blk false;
            }

            break :blk true;
        },
    };
}
