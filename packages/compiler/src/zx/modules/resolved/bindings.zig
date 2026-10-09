const std = @import("std");
const ir = @import("zx").ir;
const Input = @import("../resolved.zig").Input;

pub fn valid(header: anytype, input: Input, types: ir.TypeTable) bool {
    if (!input.functions.validStructure()) return false;

    for (input.aliases, 0..) |alias, index| {
        if (@backingInt(alias.type_id) >= types.count() or !declared(header, alias.name, false)) return false;

        for (input.aliases[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, alias.name)) return false;
        }
    }

    for (input.imports, 0..) |binding, index| {
        if (!declared(header, binding.namespace orelse binding.name, true)) return false;
        if (@backingInt(binding.id) >= input.functions.count()) return false;

        for (input.imports[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, binding.name) and std.mem.eql(u8, previous.namespace orelse "", binding.namespace orelse "")) return false;
        }

        const function = input.functions.at(@backingInt(binding.id));

        if (binding.input_type != function.input_type or binding.output_type != function.output_type) return false;
        if (@backingInt(binding.input_type) >= types.count() or @backingInt(binding.output_type) >= types.count()) return false;
    }

    for (0..header.importCount()) |index| {
        const item = header.importAt(index);

        if (item.kind == .function and header.importNameCount(index) != 1) return false;

        for (0..header.importNameCount(index)) |name_index| {
            const name = header.importNameAt(index, name_index).text;

            for (0..index + 1) |previous_index| {
                const count = if (previous_index == index) name_index else header.importNameCount(previous_index);

                for (0..count) |previous_name| {
                    if (std.mem.eql(u8, name, header.importNameAt(previous_index, previous_name).text)) return false;
                }
            }

            var found = false;

            if (item.kind == .function) {
                for (input.imports) |binding| {
                    if (std.mem.eql(u8, name, binding.namespace orelse binding.name)) found = true;
                }
            } else {
                for (input.aliases) |alias| {
                    if (!std.mem.eql(u8, name, alias.name)) continue;
                    if (item.kind == .enumeration and types.at(@backingInt(alias.type_id)) != .enumeration) return false;

                    found = true;
                }
            }

            if (!found) return false;
        }
    }

    return true;
}

fn declared(header: anytype, name: []const u8, function: bool) bool {
    for (0..header.importCount()) |index| {
        if ((header.importAt(index).kind == .function) != function) continue;

        for (0..header.importNameCount(index)) |name_index| {
            if (std.mem.eql(u8, header.importNameAt(index, name_index).text, name)) return true;
        }
    }

    return false;
}
