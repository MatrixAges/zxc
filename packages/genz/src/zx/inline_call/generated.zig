const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const generated = @import("generated_inline_prepare");
const Input = std.meta.Child(generated.Input);
const Program = std.meta.Child(@FieldType(Input, "program"));
const Functions = std.meta.Child(@FieldType(Program, "functions"));
const Unit = std.meta.Child(@typeInfo(@FieldType(Input, "units")).pointer.child);

/// Runs the generated inline expansion and owns every rebuilt unit in the caller allocator.
pub fn prepare(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!ir.Program {
    if (program.functions.count() == 0) return program;

    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Program, "types")), program.types);
    var functions: Functions = undefined;

    inline for (@typeInfo(Functions).@"struct".field_names) |name| {
        @field(functions, name) = columns.slice(@FieldType(Functions, name), @field(program.functions, name));
    }

    const view = Program{
        .types = &types,
        .functions = &functions,
        .stores = columns.pointer(@FieldType(Program, "stores"), &program.stores),
        .expressions = columns.pointer(@FieldType(Program, "expressions"), &program.expressions),
        .contracts = columns.pointer(@FieldType(Program, "contracts"), &program.contracts),
        .control = columns.pointer(@FieldType(Program, "control"), program.body.control),
        .root = if (program.body.root) |root| @backingInt(root) else null,
        .output_type = @backingInt(program.output_type),
    };

    const units = try @import("../function_analysis/units.zig").build(Unit, temporary, &program);
    const pointers = try temporary.alloc(*const Unit, units.len);

    for (units, pointers) |*unit, *pointer| pointer.* = unit;

    const input = Input{ .program = &view, .units = columns.slice(@FieldType(Input, "units"), @as([]const *const Unit, pointers)) };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    var result = program;
    var storage: ir.FunctionStorage = .{};

    for (0..program.functions.count()) |index| {
        var function = program.functions.at(index);
        const rebuilt = @import("../function_analysis/abi.zig").unwrap(output[index]);

        if (rebuilt.changed) {
            const owned = try own(allocator, rebuilt);

            function.symbols = owned.symbols;
            function.expressions = owned.expressions;
            function.body = owned.body;
        }

        try storage.append(allocator, function);
    }

    result.functions = try storage.finish(allocator);

    const entry = @import("../function_analysis/abi.zig").unwrap(output[program.functions.count()]);

    if (entry.changed) {
        const owned = try own(allocator, entry);

        result.symbols = owned.symbols;
        result.expressions = owned.expressions;
        result.body = owned.body;
    }

    return result;
}

const Owned = struct { symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.ControlBody };

fn own(allocator: std.mem.Allocator, rebuilt: anytype) std.mem.Allocator.Error!Owned {
    const control = try allocator.create(ir.ControlTable);

    control.* = try columns.own(allocator, columns.columns(ir.ControlTable, rebuilt.control.*), .{});

    return .{
        .symbols = try columns.own(allocator, columns.columns(ir.SymbolTable, rebuilt.symbols.*), .{}),
        .expressions = try columns.own(allocator, columns.columns(ir.ExpressionTable, rebuilt.expressions.*), .{}),
        .body = .{ .control = control, .root = @fromBackingInt(rebuilt.root) },
    };
}
