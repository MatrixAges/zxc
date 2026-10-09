const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (comptime !options.generated_parser) return @import("seed_scopes.zig").validate(allocator, program);

    const generated = @import("generated_ir_scopes");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const Body = std.meta.Child(@FieldType(Input, "body"));
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const table = ir.TypeTable.borrow(Table, program.types);
    const functions = @import("canonical/functions/input.zig").view(Functions, program.functions);

    const body: Body = .{
        .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
        .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
        .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
        .control = borrow.pointer(@FieldType(Body, "control"), program.body.control),
        .root = if (program.body.root) |id| @backingInt(id) else null,
    };

    const input: Input = .{ .table = &table, .body = &body, .functions = &functions, .output_type = @backingInt(program.output_type), .transaction = program.store_mode == .transaction };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return false,
    };
}
