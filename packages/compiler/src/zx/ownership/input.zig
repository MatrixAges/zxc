const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated_ownership");
const borrow = @import("../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);
const Types = std.meta.Child(@FieldType(Input, "types"));
const Table = std.meta.Child(@FieldType(Types, "base"));
const Symbols = std.meta.Child(@FieldType(Input, "symbols"));
const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
const Control = std.meta.Child(@FieldType(Input, "control"));
const Functions = std.meta.Child(@FieldType(Input, "functions"));

pub fn execute(arena: *std.heap.ArenaAllocator, program: ir.Program) !generated.Output {
    const base = ir.TypeTable.borrow(Table, program.types);
    const delta = ir.TypeTable.borrow(Table, .{});
    const types: Types = .{ .base = &base, .delta = &delta };
    const symbols = borrow.pointer(*const Symbols, &program.symbols);
    const expressions = borrow.pointer(*const Expressions, &program.expressions);
    const control = borrow.pointer(*const Control, program.body.control);

    const functions: Functions = .{
        .ownership = borrow.slice(@FieldType(Functions, "ownership"), program.functions.ownership),
        .stores = borrow.slice(@FieldType(Functions, "stores"), program.functions.stores),
    };

    const input: Input = .{
        .types = &types,
        .symbols = symbols,
        .expressions = expressions,
        .control = control,
        .body = if (program.body.root) |root| @backingInt(root) else null,
        .functions = &functions,
        .type_only = program.type_only,
    };

    return generated.execute(arena, &input);
}
