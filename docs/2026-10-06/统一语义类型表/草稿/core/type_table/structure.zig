const std = @import("std");
const Table = @import("root.zig");
const model = @import("model.zig");

pub fn valid(table: Table) bool {
    const count = table.count();

    if (count > std.math.maxInt(u32)) return false;
    if (table.first.len != count or table.second.len != count or table.labels.len != count) return false;
    if (table.field_names.len != table.field_types.len) return false;

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        if (@field(table, name).len > std.math.maxInt(u32)) return false;
    }

    for (table.kinds, table.first, table.second) |code, first, second| {
        const kind = std.enums.fromInt(model.Kind, code) orelse return false;

        switch (kind) {
            .object => if (!range(first, second, table.field_types.len)) return false,
            .tuple => if (!range(first, second, table.children.len)) return false,
            .error_set, .enumeration => if (!range(first, second, table.names.len)) return false,
            .scalar => if (first >= @typeInfo(model.Scalar).@"enum".field_names.len) return false,
            else => {},
        }
    }

    return true;
}

fn range(first: usize, len: usize, total: usize) bool {
    return first <= total and len <= total - first;
}
