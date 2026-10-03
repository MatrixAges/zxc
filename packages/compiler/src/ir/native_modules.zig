const std = @import("std");
const ir = @import("zx").ir;
const specifier = @import("../modules/specifier.zig");

pub fn validate(program: ir.Program) bool {
    for (program.native_modules, 0..) |module, index| {
        const kind = specifier.classify(module.specifier) catch return false;

        if (kind == .file or kind == .package) return false;
        if (module.import_name.len == 0 or std.mem.indexOfScalar(u8, module.import_name, 0) != null or !std.unicode.utf8ValidateSlice(module.import_name)) return false;

        for (module.type_namespace) |part| {
            if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return false;
        }

        for (module.types, 0..) |binding, position| {
            if (@intFromEnum(binding.type_id) >= program.types.len or binding.name.len == 0 or std.mem.indexOfScalar(u8, binding.name, 0) != null or !std.unicode.utf8ValidateSlice(binding.name)) return false;

            for (module.types[0..position]) |previous| {
                if (std.mem.eql(u8, previous.name, binding.name)) return false;
            }

            for (program.native_modules[0..index]) |previous| {
                if (!std.mem.eql(u8, previous.specifier, module.specifier)) continue;

                for (previous.types) |item| {
                    if (std.mem.eql(u8, item.name, binding.name) and item.type_id != binding.type_id) return false;
                }
            }
        }

        for (program.native_modules[0..index]) |previous| {
            if (std.mem.eql(u8, previous.specifier, module.specifier) and std.mem.eql(u8, previous.import_name, module.import_name)) return false;
        }
    }

    return true;
}

pub fn validateExport(program: ir.Program, index: usize) bool {
    const function = program.functions[index];
    const external = function.external.?;
    const name = external.exportName();
    const module = program.native_modules[@intFromEnum(external.module)];

    if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return false;

    for (program.native_modules) |implementation| {
        if (!std.mem.eql(u8, implementation.specifier, module.specifier)) continue;

        for (implementation.types) |binding| {
            if (std.mem.eql(u8, binding.name, name)) return false;
        }
    }

    for (program.functions[0..index]) |previous| {
        const other = previous.external orelse continue;

        if (!std.mem.eql(u8, program.native_modules[@intFromEnum(other.module)].specifier, module.specifier)) continue;
        if (!std.mem.eql(u8, other.exportName(), name)) continue;
        if (previous.input_type != function.input_type or previous.output_type != function.output_type) return false;
    }

    return true;
}

pub fn validateType(program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, shape: ir.NativeType, depth: usize) bool {
    if (depth >= 256) return false;

    if (shape.name) |name| {
        var found = false;

        for (program.native_modules[@intFromEnum(module_id)].types) |binding| {
            if (binding.type_id == type_id and std.mem.eql(u8, binding.name, name)) found = true;
        }

        if (!found) return false;
    }

    switch (program.typeOf(type_id)) {
        .scalar, .enumeration => return shape.children.len == 0,
        .optional, .list => |child| return shape.children.len == 1 and validateType(program, module_id, child, shape.children[0], depth + 1),
        .tuple => |children| {
            if (children.len != shape.children.len) return false;

            for (children, shape.children) |child, nested| {
                if (!validateType(program, module_id, child, nested, depth + 1)) return false;
            }
        },
        .object => |fields| {
            if (fields.len != shape.children.len) return false;

            for (fields, shape.children) |field, nested| {
                if (!validateType(program, module_id, field.type_id, nested, depth + 1)) return false;
            }
        },
    }

    return true;
}
