const std = @import("std");
const zx = @import("zx");
const view = @import("view.zig");
const rows = @import("import_rows.zig");
const Storage = @import("storage.zig");
pub const Error = rows.Error;

pub fn append(allocator: std.mem.Allocator, target: *Storage, comptime Module: type, source: anytype) Error!void {
    const Context = std.meta.Child(@FieldType(Module, "context"));
    const context = source.context;
    const expressions = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), context.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), context.forms);
    const extra = zx.columns.view(std.meta.Child(@FieldType(Module, "extra")), source.extra);
    const values = view.join(view.join(expressions, forms), extra);

    try rows.append(allocator, &target.expressions, &values);

    if (@hasField(Module, "statements")) {
        const statements = zx.columns.view(std.meta.Child(@FieldType(Module, "statements")), source.statements);
        const variables = zx.columns.view(std.meta.Child(@FieldType(Module, "variables")), source.variables);
        const commands = view.join(statements, variables);

        if (@hasField(Module, "loops")) {
            const loops = zx.columns.view(std.meta.Child(@FieldType(Module, "loops")), source.loops);
            const complete = view.join(commands, loops);

            try rows.append(allocator, &target.statements, &complete);
        } else try rows.append(allocator, &target.statements, &commands);
    }

    if (@hasField(Module, "fields")) _ = try @import("import_fields.zig").append(allocator, &target.field_columns, source.fields);

    const name = if (@hasField(Module, "declarations")) "declarations" else "functions";
    const declarations = zx.columns.view(std.meta.Child(@FieldType(Module, name)), @field(source, name));

    try rows.append(allocator, &target.declaration_rows, &declarations);
}
