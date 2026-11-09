const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;
const view = @import("../../node/view.zig");

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const Object) std.mem.Allocator.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("lifecycle_seed.zig").lower(builder, declarations, objects);

    const entry = @import("generated_store_lifecycle");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .objects = zx.columns.slice(@FieldType(Input, "objects"), objects),
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(builder.allocator);

    defer scratch.deinit();

    const output = entry.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const context = output.context;
    const Output = std.meta.Child(entry.Output);
    const Context = std.meta.Child(@FieldType(Output, "context"));
    const expressions_view = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), context.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), context.forms);
    const extra = zx.columns.view(std.meta.Child(@FieldType(Output, "extra")), output.extra);
    const statement_rows = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);
    const variables = zx.columns.view(std.meta.Child(@FieldType(Output, "variables")), output.variables);
    const functions = zx.columns.view(std.meta.Child(@FieldType(Output, "functions")), output.functions);
    const expressions = view.join(view.join(expressions_view, forms), extra);
    const statements = view.join(statement_rows, variables);
    const rows = @import("../../node/import_rows.zig");

    rows.append(builder.allocator, &builder.nodes.expressions, &expressions) catch |err| return failure(err);
    rows.append(builder.allocator, &builder.nodes.statements, &statements) catch |err| return failure(err);

    _ = @import("../../node/import_fields.zig").append(builder.allocator, &builder.nodes.field_columns, output.fields) catch |err| return failure(err);

    const first = builder.nodes.declaration_rows.tags.items.len;

    rows.append(builder.allocator, &builder.nodes.declaration_rows, &functions) catch |err| return failure(err);

    for (first..builder.nodes.declaration_rows.tags.items.len) |index| try declarations.append(builder.allocator, .{
        .function = try builder.nodes.materializeFunction(builder.allocator, @intCast(index)),
    });
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Store lifecycle AST"),
    };
}
