const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const generated = @import("generated_function_facts");
const Input = std.meta.Child(generated.Input);
const Program = std.meta.Child(@FieldType(Input, "program"));
const Functions = std.meta.Child(@FieldType(Program, "functions"));

pub const Facts = struct {
    value: @import("../value_call/analysis.zig").Summary,
    io: []bool,
    process: []bool,
};

/// Borrows the program columns for the generated facts and copies the results into the caller allocator.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Facts {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

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

    const input = Input{ .program = &view };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{
        .value = .{
            .pure = try allocator.dupe(bool, output.pure),
            .local = try allocator.dupe(bool, output.local),
            .values = try allocator.dupe(bool, output.values),
            .state = .{
                .selected = try allocator.dupe(bool, output.selected),
                .keys = try allocator.dupe([32]u8, std.mem.bytesAsSlice([32]u8, output.keys)),
            },
        },
        .io = try allocator.dupe(bool, output.io),
        .process = try allocator.dupe(bool, output.process),
    };
}
