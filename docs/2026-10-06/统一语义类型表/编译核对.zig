const std = @import("std");
const Table = @import("草稿/core/type_table/root.zig");
const Storage = @import("草稿/core/type_table/storage.zig");
const structure = @import("草稿/core/type_table/structure.zig");
const borrow = @import("草稿/core/type_table/borrow.zig");
const row = @import("生成/row.zig");

export fn compileProjection(table: *const Table, index: u32) u8 {
    return @backingInt(table.at(index));
}

export fn compileStructure(table: *const Table) bool {
    return structure.valid(table.*);
}

export fn compileStorage(storage: *Storage, allocator: *const std.mem.Allocator, delta: *const Table) bool {
    storage.append(allocator.*, delta.*) catch return false;

    return true;
}

export fn compileRelease(storage: *Storage, allocator: *const std.mem.Allocator) void {
    storage.deinit(allocator.*);
}

export fn compileBorrow(arena: *std.heap.ArenaAllocator, base: *const Table, delta: *const Table, id: u32) bool {
    const Input = @typeInfo(row.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Columns = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const borrowed_base = borrow.columns(Columns, base.*);
    const borrowed_delta = borrow.columns(Columns, delta.*);
    const tables = Tables{ .base = &borrowed_base, .delta = &borrowed_delta };

    _ = row.execute(arena, &.{ .tables = &tables, .id = id }) catch return false;

    return true;
}
