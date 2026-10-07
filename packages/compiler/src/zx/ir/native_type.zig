const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");

pub fn validate(allocator: std.mem.Allocator, program: ir.Program, module_id: ir.NativeModuleId, type_id: ir.TypeId, shape: ir.NativeType, depth: usize) std.mem.Allocator.Error!bool {
    if (comptime !options.generated_parser) return @import("seed_native_type.zig").validate(program, module_id, type_id, shape, depth);

    const generated = @import("generated_native_type");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, program.types);
    const bindings = program.native_modules.at(@backingInt(module_id)).types;

    const input: Input = .{
        .table = &table,
        .names = shape.names,
        .binding_names = bindings.names,
        .binding_types = bindings.type_ids,
        .type_id = @backingInt(type_id),
        .depth = depth,
    };

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}
