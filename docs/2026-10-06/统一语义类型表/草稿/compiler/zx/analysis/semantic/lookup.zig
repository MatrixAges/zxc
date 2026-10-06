const std = @import("std");
const ir = @import("zx").ir;
pub const Value = ir.TypeValue;

pub fn find(table: ir.TypeTable, value: Value) std.mem.Allocator.Error!?ir.TypeId {
    if (!@import("parser_options").generated_parser) return @import("seed_lookup.zig").find(table, value);

    const generated = @import("generated_type_lookup");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Table = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;

    const fields: Fields = .{
        .names = if (value == .object) value.object.names else &.{},
        .types = if (value == .object) value.object.types else &.{},
    };

    const base = ir.TypeTable.borrow(Table, table);
    const delta = ir.TypeTable.borrow(Table, .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);
    const input: Input = .{ .tables = &tables, .candidate = &candidate };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const id = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return if (id) |found| @fromBackingInt(found) else null;
}
