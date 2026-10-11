const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;

/// Borrowed unit rows for the generated analyses: every function first, then the program entry.
pub fn build(comptime Unit: type, allocator: std.mem.Allocator, program: *const ir.Program) std.mem.Allocator.Error![]Unit {
    const count = program.functions.count();
    const units = try allocator.alloc(Unit, count + 1);
    const table = program.functions;

    for (units[0..count], 0..) |*unit, index| unit.* = .{
        .input_type = table.input_types[index],
        .output_type = table.output_types[index],
        .symbols = columns.pointer(@FieldType(Unit, "symbols"), table.symbols[index]),
        .expressions = columns.pointer(@FieldType(Unit, "expressions"), table.expressions[index]),
        .control = columns.pointer(@FieldType(Unit, "control"), table.control[index]),
        .root = table.roots[index],
        .stores = columns.pointer(@FieldType(Unit, "stores"), table.stores[index]),
        .contracts = columns.pointer(@FieldType(Unit, "contracts"), table.contracts[index]),
        .external = table.native_modules[index] != null,
    };

    units[count] = .{
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .symbols = columns.pointer(@FieldType(Unit, "symbols"), &program.symbols),
        .expressions = columns.pointer(@FieldType(Unit, "expressions"), &program.expressions),
        .control = columns.pointer(@FieldType(Unit, "control"), program.body.control),
        .root = if (program.body.root) |root| @backingInt(root) else null,
        .stores = columns.pointer(@FieldType(Unit, "stores"), &program.stores),
        .contracts = columns.pointer(@FieldType(Unit, "contracts"), &program.contracts),
        .external = false,
    };

    return units;
}
