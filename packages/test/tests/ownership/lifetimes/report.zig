const std = @import("std");
const zx = @import("zx");
const compiler = @import("compiler");
const entry = @import("loan_report").loan_report;
const Input = std.meta.Child(entry.Input);
const Functions = std.meta.Child(@FieldType(Input, "functions"));

pub fn run(allocator: std.mem.Allocator, program: compiler.ir.Program) !entry.Output {
    return withInput(allocator, program, entry.executeIn);
}

pub fn withInput(allocator: std.mem.Allocator, program: compiler.ir.Program, comptime execute: anytype) !entry.Output {
    const types = compiler.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    var functions: Functions = undefined;

    inline for (@typeInfo(Functions).@"struct".field_names) |name| {
        @field(functions, name) = zx.columns.slice(@FieldType(Functions, name), @field(program.functions, name));
    }

    const input: Input = .{
        .types = &types,
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .control = zx.columns.pointer(@FieldType(Input, "control"), program.body.control),
        .body = if (program.body.root) |root| @backingInt(root) else null,
        .functions = &functions,
    };

    return execute(allocator, &input);
}
