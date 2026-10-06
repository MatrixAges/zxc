const std = @import("std");
const ir = @import("zx").ir;

pub fn contains(allocator: std.mem.Allocator, table: ir.TypeTable, id: ir.TypeId, native_references: bool) std.mem.Allocator.Error!bool {
    const generated = @import("generated_type_query");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const borrowed = ir.TypeTable.borrow(Table, table);
    const input: Input = .{ .table = &borrowed, .id = @backingInt(id), .native_references = native_references };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
