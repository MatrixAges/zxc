const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");

pub fn validate(program: ir.Program, index: usize) bool {
    if (comptime !options.generated_parser) return @import("seed_expression_rules.zig").validate(program, program.expressions.at(index), index);

    const generated = @import("generated_ir_expressions");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const table = ir.TypeTable.borrow(Table, program.types);

    const functions: Functions = .{
        .input_types = borrow.slice(@FieldType(Functions, "input_types"), program.functions.input_types),
        .output_types = borrow.slice(@FieldType(Functions, "output_types"), program.functions.output_types),
        .stores = borrow.slice(@FieldType(Functions, "stores"), program.functions.stores),
    };

    const input: Input = .{
        .table = &table,
        .expressions = borrow.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .symbols = borrow.pointer(@FieldType(Input, "symbols"), &program.symbols),
        .stores = borrow.pointer(@FieldType(Input, "stores"), &program.stores),
        .functions = &functions,
        .index = index,
        .orchestration = program.store_mode == .orchestration,
    };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}
