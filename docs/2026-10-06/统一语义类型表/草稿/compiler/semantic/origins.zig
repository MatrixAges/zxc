const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");

pub fn valid(types: ir.TypeTable, values: Origins.Table) std.mem.Allocator.Error!bool {
    if (!@import("parser_options").generated_parser) return @import("seed_origins.zig").valid(types, values);

    const generated = @import("generated_origin_validation");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const table = ir.TypeTable.borrow(Table, types);
    const bindings = Origins.Table.borrow(Bindings, values);
    const input: Input = .{ .table = &table, .origins = &bindings, .names = values.names };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
