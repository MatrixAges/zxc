const std = @import("std");
const ir = @import("zx").ir;
const Record = @import("../../module_record.zig");
const Error = @import("../model.zig").Error;
const borrow = @import("../../../ir/canonical/borrow.zig");

pub fn execute(arena: *std.heap.ArenaAllocator, program: ir.Program, record: Record) Error![]const bool {
    const generated = @import("generated_artifact_roots");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const Body = std.meta.Child(@FieldType(Input, "entry"));
    const ProjectedRecord = std.meta.Child(@FieldType(Input, "record"));
    const table = ir.TypeTable.borrow(Table, program.types);

    const functions: Functions = .{
        .count = program.functions.count(),
        .input_types = program.functions.input_types,
        .output_types = program.functions.output_types,
        .native_modules = program.functions.native_modules,
        .symbols = borrow.slice(@FieldType(Functions, "symbols"), program.functions.symbols),
        .expressions = borrow.slice(@FieldType(Functions, "expressions"), program.functions.expressions),
        .contracts = borrow.slice(@FieldType(Functions, "contracts"), program.functions.contracts),
        .stores = borrow.slice(@FieldType(Functions, "stores"), program.functions.stores),
    };

    const entry: Body = .{
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
        .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
        .contracts = borrow.pointer(@FieldType(Body, "contracts"), &program.contracts),
        .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
    };

    const projected = try @import("record.zig").project(ProjectedRecord, arena.allocator(), record);

    const input: Input = .{
        .table = &table,
        .functions = &functions,
        .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules),
        .entry = &entry,
        .record = &projected,
        .max_offset = std.math.maxInt(usize),
    };

    const result = generated.execute(arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return result orelse error.InvalidModule;
}
