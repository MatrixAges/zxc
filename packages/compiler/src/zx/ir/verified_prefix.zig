const std = @import("std");
const ir = @import("zx").ir;
const field_names = @typeInfo(ir.FunctionTable).@"struct".field_names;

pub fn count(table: ir.FunctionTable, verified: ir.FunctionTable) usize {
    if (!table.validStructure() or !verified.validStructure()) return 0;

    const limit = @min(table.count(), verified.count());

    if (shared(table, verified)) return limit;

    for (0..limit) |row| {
        inline for (field_names) |name| {
            if (!std.meta.eql(@field(table, name)[row], @field(verified, name)[row])) return row;
        }
    }

    return limit;
}

fn shared(table: ir.FunctionTable, verified: ir.FunctionTable) bool {
    inline for (field_names) |name| {
        if (@field(table, name).ptr != @field(verified, name).ptr) return false;
    }

    return true;
}
