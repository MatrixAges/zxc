const std = @import("std");
const ir = @import("zx").ir;
const specifier = @import("../modules/specifier.zig");

pub fn validate(program: ir.Program) bool {
    for (program.native_modules, 0..) |module, index| {
        const kind = specifier.classify(module.specifier) catch return false;

        if (kind == .file or kind == .package) return false;
        if (module.import_name.len == 0 or std.mem.indexOfScalar(u8, module.import_name, 0) != null or !std.unicode.utf8ValidateSlice(module.import_name)) return false;

        if (module.identity) |identity| {
            if (identity.len == 0 or std.mem.indexOfScalar(u8, identity, 0) != null or !std.unicode.utf8ValidateSlice(identity)) return false;
        }

        for (module.type_namespace) |part| {
            if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return false;
        }

        for (module.types, 0..) |binding, position| {
            if (@backingInt(binding.type_id) >= program.types.len or binding.name.len == 0 or std.mem.indexOfScalar(u8, binding.name, 0) != null or !std.unicode.utf8ValidateSlice(binding.name)) return false;

            for (module.types[0..position]) |previous| {
                if (std.mem.eql(u8, previous.name, binding.name)) return false;
            }

            for (program.native_modules[0..index]) |previous| {
                if (!std.mem.eql(u8, previous.key(), module.key())) continue;

                for (previous.types) |item| {
                    if (std.mem.eql(u8, item.name, binding.name) and item.type_id != binding.type_id) return false;
                }
            }
        }

        for (program.native_modules[0..index]) |previous| {
            if (std.mem.eql(u8, previous.key(), module.key()) and std.mem.eql(u8, previous.import_name, module.import_name)) return false;
        }
    }

    for (program.types, 0..) |value, type_index| {
        if (value == .native_reference and ir.nativeReferenceOwner(program, @fromBackingInt(@intCast(type_index))) == null) return false;
    }

    return true;
}

pub fn validateExport(program: ir.Program, index: usize) bool {
    const function = program.functions[index];
    const external = function.external.?;
    const name = external.exportName();
    const module = program.native_modules[@backingInt(external.module)];

    if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return false;

    if (external.errors) |errors| {
        if (!external.fallible) return false;

        for (errors, 0..) |error_name, position| {
            if (!@import("lint").checkName(error_name, .type_decl)) return false;

            for (errors[0..position]) |previous| {
                if (std.mem.eql(u8, previous, error_name)) return false;
            }
        }
    }

    for (program.native_modules) |implementation| {
        if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

        for (implementation.types) |binding| {
            if (std.mem.eql(u8, binding.name, name)) return false;
        }
    }

    for (program.functions[0..index]) |previous| {
        const other = previous.external orelse continue;

        if (!std.mem.eql(u8, program.native_modules[@backingInt(other.module)].key(), module.key())) continue;
        if (!std.mem.eql(u8, other.exportName(), name)) continue;
        if (previous.input_type != function.input_type or previous.output_type != function.output_type) return false;
        if (other.fallible != external.fallible) return false;
        if (other.concurrent != external.concurrent) return false;
        if ((other.errors == null) != (external.errors == null)) return false;

        if (external.errors) |errors| {
            const previous_errors = other.errors.?;

            if (errors.len != previous_errors.len) return false;

            for (errors) |error_name| {
                var found = false;

                for (previous_errors) |previous_error| {
                    if (std.mem.eql(u8, previous_error, error_name)) found = true;
                }

                if (!found) return false;
            }
        }
    }

    return true;
}

pub fn validateType(program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, shape: ir.NativeType, depth: usize) bool {
    if (depth >= 256) return false;

    if (shape.name) |name| {
        var found = false;

        for (program.native_modules[@backingInt(module_id)].types) |binding| {
            if (binding.type_id == type_id and std.mem.eql(u8, binding.name, name)) found = true;
        }

        if (!found) return false;
    }

    switch (program.typeOf(type_id)) {
        .task => return false,
        .native_reference => return shape.name != null and shape.children.len == 0,
        .scalar, .enumeration, .error_set => return shape.children.len == 0,
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
