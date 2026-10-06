const Table = @import("root.zig");

pub fn columns(comptime Target: type, table: Table) Target {
    if (@typeInfo(Target).@"struct".field_names.len != @typeInfo(Table).@"struct".field_names.len) {
        @compileError("semantic type table column count mismatch");
    }

    var result: Target = undefined;

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        if (@TypeOf(@field(result, name)) != @FieldType(Table, name)) {
            @compileError("semantic type table column layout mismatch: " ++ name);
        }

        @field(result, name) = @field(table, name);
    }

    return result;
}
