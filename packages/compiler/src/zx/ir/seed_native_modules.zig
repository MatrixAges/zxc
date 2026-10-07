const std = @import("std");
const ir = @import("zx").ir;
const specifier = @import("../modules/specifier.zig");

pub fn validate(program: ir.Program) bool {
    if (!program.native_modules.validStructure()) return false;

    for (0..program.native_modules.count()) |index| {
        const module = program.native_modules.at(index);
        const kind = specifier.classify(module.specifier) catch return false;

        if (kind == .file or kind == .package) return false;
        if (module.import_name.len == 0 or std.mem.indexOfScalar(u8, module.import_name, 0) != null or !std.unicode.utf8ValidateSlice(module.import_name)) return false;

        if (module.identity) |identity| {
            if (identity.len == 0 or std.mem.indexOfScalar(u8, identity, 0) != null or !std.unicode.utf8ValidateSlice(identity)) return false;
        }

        for (module.type_namespace) |part| {
            if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return false;
        }

        for (0..module.types.count()) |position| {
            const binding = module.types.at(position);

            if (@backingInt(binding.type_id) >= program.types.count() or binding.name.len == 0 or std.mem.indexOfScalar(u8, binding.name, 0) != null or !std.unicode.utf8ValidateSlice(binding.name)) return false;

            for (0..position) |previous_index| {
                const previous = module.types.at(previous_index);

                if (std.mem.eql(u8, previous.name, binding.name)) return false;
            }

            for (0..index) |previous_row| {
                const previous = program.native_modules.at(previous_row);

                if (!std.mem.eql(u8, previous.key(), module.key())) continue;

                for (0..previous.types.count()) |item_index| {
                    const item = previous.types.at(item_index);

                    if (std.mem.eql(u8, item.name, binding.name) and item.type_id != binding.type_id) return false;
                }
            }
        }

        for (0..index) |previous_row| {
            const previous = program.native_modules.at(previous_row);

            if (std.mem.eql(u8, previous.key(), module.key()) and std.mem.eql(u8, previous.import_name, module.import_name)) return false;
        }
    }

    for (0..program.types.count()) |type_index| {
        const value = program.types.at(type_index);

        if (value == .native_reference and ir.nativeReferenceOwner(program, @fromBackingInt(@intCast(type_index))) == null) return false;
    }

    return true;
}

pub fn validateExport(program: ir.Program, index: usize) bool {
    const function = program.functions.at(index);
    const external = function.external.?;
    const name = external.exportName();
    const module = program.native_modules.at(@backingInt(external.module));

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

    for (0..program.native_modules.count()) |implementation_row| {
        const implementation = program.native_modules.at(implementation_row);

        if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

        for (0..implementation.types.count()) |binding_index| {
            const binding = implementation.types.at(binding_index);

            if (std.mem.eql(u8, binding.name, name)) return false;
        }
    }

    for (0..index) |previous_index| {
        const previous = program.functions.at(previous_index);
        const other = previous.external orelse continue;

        if (!std.mem.eql(u8, program.native_modules.at(@backingInt(other.module)).key(), module.key())) continue;
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
