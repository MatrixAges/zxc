const std = @import("std");
const ir = @import("zx").ir;

pub fn join(allocator: std.mem.Allocator, base: ir.FunctionTable, delta: ir.FunctionTable) std.mem.Allocator.Error!ir.FunctionTable {
    if (delta.count() == 0) return base;
    if (base.count() == 0) return delta;

    var result: ir.FunctionTable = .{};

    inline for (@typeInfo(ir.FunctionTable).@"struct".field_names) |name| {
        const first = @field(base, name);
        const second = @field(delta, name);
        const values = try allocator.alloc(std.meta.Elem(@TypeOf(first)), first.len + second.len);

        @memcpy(values[0..first.len], first);
        @memcpy(values[first.len..], second);
        @field(result, name) = values;
    }

    return result;
}

pub fn hasPrefix(table: ir.FunctionTable, prefix: ir.FunctionTable) bool {
    if (!table.validStructure() or !prefix.validStructure() or table.count() < prefix.count()) return false;

    inline for (@typeInfo(ir.FunctionTable).@"struct".field_names) |name| {
        const values = @field(table, name);
        const expected = @field(prefix, name);

        for (values[0..expected.len], expected) |actual, previous| {
            if (!std.meta.eql(actual, previous)) return false;
        }
    }

    return true;
}
