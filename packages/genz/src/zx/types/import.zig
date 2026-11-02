const std = @import("std");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");

pub const Payloads = enum { copy, borrow_text, retain };

/// Field names must outlive the AST; retained payloads already belong to its allocator.
pub fn append(self: *Lower, declarations: anytype, comptime Output: type, output: anytype, fields: anytype, payloads: Payloads) Lower.Error!void {
    const Expressions = std.meta.Child(@FieldType(Output, "expressions"));
    const Definitions = std.meta.Child(@FieldType(Output, "definitions"));
    var expressions: Expressions = undefined;
    var definitions: Definitions = undefined;

    inline for (@typeInfo(Expressions).@"struct".field_names) |name| @field(expressions, name) = @field(output.expressions, name);
    inline for (@typeInfo(Definitions).@"struct".field_names) |name| @field(definitions, name) = @field(output.definitions, name);

    const combined = view.join(expressions, definitions);

    const imported = if (payloads == .retain)
        rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &combined)

    else if (payloads == .borrow_text)
        rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &combined)
    else
        rows.append(self.allocator, &self.builder.nodes.expressions, &combined);

    imported catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    try self.builder.nodes.field_columns.reserve(self.allocator, fields.len);

    for (fields) |item| {
        self.builder.nodes.field_columns.append(.{
            .name = item.name,
            .value = @fromBackingInt(item.value),
            .default_value = if (item.default_value) |value| @fromBackingInt(value) else null,
            .comptime_parameter = item.comptime_parameter,
        });
    }

    try declarations.ensureUnusedCapacity(self.allocator, output.declarations.len);

    for (output.declarations) |item| {
        const name = if (payloads != .copy) item.name else try self.allocator.dupe(u8, item.name);

        declarations.appendAssumeCapacity(.{ .constant = .{
            .name = name,
            .type_expr = if (item.type_expr) |value| @fromBackingInt(value) else null,
            .value = @fromBackingInt(item.value),
            .exported = item.exported,
        } });
    }
}
