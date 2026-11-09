const std = @import("std");
const zx = @import("zx");
const view = @import("view.zig");
const rows = @import("import_rows.zig");
const Storage = @import("storage.zig");
pub const Error = rows.Error;
const Mode = enum { owned, text, borrowed };

pub fn append(allocator: std.mem.Allocator, target: *Storage, comptime Module: type, source: anytype) Error!void {
    return appendModule(allocator, target, Module, source, .owned);
}

/// Text must outlive the target; non-text payloads receive owned storage.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: *Storage, comptime Module: type, source: anytype) Error!void {
    return appendModule(allocator, target, Module, source, .text);
}

/// All payloads must outlive the target; column descriptors receive owned storage.
pub fn appendBorrowed(allocator: std.mem.Allocator, target: *Storage, comptime Module: type, source: anytype) Error!void {
    return appendModule(allocator, target, Module, source, .borrowed);
}

fn appendModule(allocator: std.mem.Allocator, target: *Storage, comptime Module: type, source: anytype, comptime mode: Mode) Error!void {
    const Context = std.meta.Child(@FieldType(Module, "context"));
    const context = source.context;
    const expressions = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), context.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), context.forms);
    const values = if (@hasField(Module, "extra")) view.join(view.join(expressions, forms), zx.columns.view(std.meta.Child(@FieldType(Module, "extra")), source.extra)) else view.join(expressions, forms);

    try appendRows(allocator, &target.expressions, &values, mode);

    if (@hasField(Module, "statements")) {
        const statements = zx.columns.view(std.meta.Child(@FieldType(Module, "statements")), source.statements);
        const variables = zx.columns.view(std.meta.Child(@FieldType(Module, "variables")), source.variables);
        const commands = view.join(statements, variables);

        if (@hasField(Module, "loops")) {
            const loops = zx.columns.view(std.meta.Child(@FieldType(Module, "loops")), source.loops);
            const complete = view.join(commands, loops);

            try appendRows(allocator, &target.statements, &complete, mode);
        } else try appendRows(allocator, &target.statements, &commands, mode);
    }

    if (@hasField(Module, "fields")) {
        if (comptime mode != .owned) {
            _ = try @import("import_fields.zig").appendBorrowingText(allocator, &target.field_columns, source.fields);
        } else try @import("import_fields.zig").append(allocator, &target.field_columns, source.fields);
    }

    if (!@hasField(Module, "declarations") and !@hasField(Module, "functions")) return;

    const name = if (@hasField(Module, "declarations")) "declarations" else "functions";
    const declarations = zx.columns.view(std.meta.Child(@FieldType(Module, name)), @field(source, name));

    try appendRows(allocator, &target.declaration_rows, &declarations, mode);
}

fn appendRows(allocator: std.mem.Allocator, target: anytype, source: anytype, comptime mode: Mode) Error!void {
    return switch (mode) {
        .owned => rows.append(allocator, target, source),
        .text => rows.appendBorrowingText(allocator, target, source),
        .borrowed => rows.appendBorrowed(allocator, target, source),
    };
}
