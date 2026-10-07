const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (comptime !options.generated_parser) return @import("seed_stores.zig").validate(allocator, program);

    const generated = @import("generated_ir_stores");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, program.types);
    const input: Input = .{ .table = &table, .paths = program.stores.paths, .slot_types = program.stores.types, .type_only = program.type_only };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}

pub fn call(program: ir.Program, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) bool {
    if (comptime !options.generated_parser) return @import("seed_stores.zig").call(program, invocation);

    const generated = @import("generated_ir_store_call");
    const Input = std.meta.Child(generated.Input);
    const target = program.functions.stores[@backingInt(invocation.function)];

    const input: Input = .{
        .available = borrow.pointer(@FieldType(Input, "available"), &program.stores),
        .required = borrow.pointer(@FieldType(Input, "required"), target),
        .slots = invocation.stores,
        .orchestration = program.store_mode == .orchestration,
    };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}
