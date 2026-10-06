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

    var child_end: usize = 0;
    var field_end: usize = 0;
    var name_end: usize = 0;

    for (table.kinds, table.first, table.second, table.labels) |code, first, second, label| {
        const kind = std.enums.fromInt(model.Kind, code) orelse return false;

        if (kind != .enumeration and kind != .native_reference and label.len != 0) return false;

        switch (kind) {
            .object => {
                if (first != field_end or !range(first, second, table.field_types.len)) return false;

                field_end += second;
            },
            .tuple => {
                if (first != child_end or !range(first, second, table.children.len)) return false;

                child_end += second;
            },
            .error_set, .enumeration => {
                if (first != name_end or !range(first, second, table.names.len)) return false;

                name_end += second;
            },
            .scalar => if (first >= @typeInfo(model.Scalar).@"enum".field_names.len or second != 0) return false,
            .optional, .list => if (second != 0) return false,
            .native_reference => if (first != 0 or second != 0) return false,
            .task => {},
        }
    }

    return child_end == table.children.len and field_end == table.field_types.len and name_end == table.names.len;
}

fn range(first: usize, len: usize, total: usize) bool {
    return first <= total and len <= total - first;
}
