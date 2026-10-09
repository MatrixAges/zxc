const std = @import("std");
const ir = @import("zx").ir;
const own = @import("../../../modules/artifact/nodes/columns.zig").own;

pub fn copy(allocator: std.mem.Allocator, source: ir.ContractTable) std.mem.Allocator.Error!ir.ContractTable {
    return own(allocator, source, .{
        .symbols = try tables(allocator, source.symbols),
        .expressions = try tables(allocator, source.expressions),
    });
}

fn tables(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!@TypeOf(source) {
    const Pointer = std.meta.Elem(@TypeOf(source));
    const Table = std.meta.Child(Pointer);
    const result = try allocator.alloc(Pointer, source.len);

    for (source, result) |value, *target| {
        const table = try allocator.create(Table);
        table.* = try own(allocator, value.*, .{});
        target.* = table;
    }

    return result;
}
