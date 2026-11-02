const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const generated = @import("generated_abi_definitions");

pub fn build(self: *Lower, declarations: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!bool {
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(@FieldType(std.meta.Child(generated.Output), "types"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const input: Input = .{
        .types = &types,
        .names = self.type_names,
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .exported = exported,
    };

    const result = generated.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const output = result.types;

    if (!output.valid) return error.OutOfMemory;

    const Expressions = std.meta.Child(@FieldType(Output, "expressions"));
    const Definitions = std.meta.Child(@FieldType(Output, "definitions"));
    var expressions: Expressions = undefined;
    var definitions: Definitions = undefined;

    inline for (@typeInfo(Expressions).@"struct".field_names) |name| @field(expressions, name) = @field(output.expressions, name);
    inline for (@typeInfo(Definitions).@"struct".field_names) |name| @field(definitions, name) = @field(output.definitions, name);

    const combined = view.join(expressions, definitions);

    const imported = if (self.type_names != null)
        rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &combined)

    else
        rows.append(self.allocator, &self.builder.nodes.expressions, &combined);

    imported catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    const fields = result.fields;

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
        const name = if (self.type_names != null) item.name else try self.allocator.dupe(u8, item.name);

        declarations.appendAssumeCapacity(.{ .constant = .{
            .name = name,
            .type_expr = if (item.type_expr) |value| @fromBackingInt(value) else null,
            .value = @fromBackingInt(item.value),
            .exported = item.exported,
        } });
    }

    for (output.values, output.layouts, self.types, self.layouts) |value, layout, *type_target, *layout_target| {
        type_target.* = @fromBackingInt(value);
        layout_target.* = @fromBackingInt(layout);
    }

    return output.has_lists;
}
