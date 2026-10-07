const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, shape: ir.NativeType, depth: usize) bool {
    if (depth >= 256) return false;

    if (shape.name) |name| {
        var found = false;
        const bindings = program.native_modules.at(@backingInt(module_id)).types;

        for (0..bindings.count()) |binding_index| {
            const binding = bindings.at(binding_index);

            if (binding.type_id == type_id and std.mem.eql(u8, binding.name, name)) found = true;
        }

        if (!found) return false;
    }

    switch (program.typeOf(type_id)) {
        .task => return false,
        .native_reference => return shape.name != null and shape.children.len == 0,
        .scalar, .enumeration, .error_set => return shape.children.len == 0,
        .optional, .list => |child| return shape.children.len == 1 and validate(program, module_id, child, shape.children[0], depth + 1),
        .tuple => |children| {
            if (children.len != shape.children.len) return false;

            for (0..children.len, shape.children) |view_index, nested| {
                const child = children.at(view_index);

                if (!validate(program, module_id, child, nested, depth + 1)) return false;
            }
        },
        .object => |fields| {
            if (fields.len != shape.children.len) return false;

            for (0..fields.len, shape.children) |item_index, nested| {
                const field = fields.at(item_index);

                if (!validate(program, module_id, field.type_id, nested, depth + 1)) return false;
            }
        },
    }

    return true;
}
