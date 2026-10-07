const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");
pub const validateType = @import("native_type.zig").validate;

pub fn validate(program: ir.Program) bool {
    if (comptime !options.generated_parser) return @import("seed_native_modules.zig").validate(program);

    const generated = @import("generated_native_modules");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, program.types);

    const input: Input = .{
        .table = &table,
        .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules),
    };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}

pub fn validateExport(program: ir.Program, index: usize) bool {
    if (comptime !options.generated_parser) return @import("seed_native_modules.zig").validateExport(program, index);

    const generated = @import("generated_native_export");
    const Input = std.meta.Child(generated.Input);
    const Functions = std.meta.Child(@FieldType(Input, "functions"));

    const functions: Functions = .{
        .input_types = program.functions.input_types,
        .output_types = program.functions.output_types,
        .native_modules = program.functions.native_modules,
        .native_members = program.functions.native_members,
        .native_exports = program.functions.native_exports,
        .native_fallible = program.functions.native_fallible,
        .native_errors = program.functions.native_errors,
        .native_concurrent = program.functions.native_concurrent,
    };

    const input: Input = .{
        .functions = &functions,
        .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules),
        .index = index,
    };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}
