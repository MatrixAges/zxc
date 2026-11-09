const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Builder = @import("../../builder.zig");
const state = @import("../state.zig");

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const state.Object, requirements: state.Requirements, execute: bool) std.mem.Allocator.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("request_seed.zig").lower(builder, declarations, objects, requirements, execute);
    try @import("regions.zig").lower(builder, declarations, objects);

    const entry = @import("generated_store_request");
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
        .declaration_base = @intCast(builder.nodes.declaration_rows.tags.items.len),
        .execute = execute,
        .io = requirements.io,
        .process = requirements.process,
    };

    var scratch = std.heap.ArenaAllocator.init(builder.allocator);

    defer scratch.deinit();

    const output = entry.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = std.meta.Child(entry.Output);
    const Context = std.meta.Child(@FieldType(Output, "context"));
    const context = output.context;
    const expressions = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), context.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), context.forms);
    const extra = zx.columns.view(std.meta.Child(@FieldType(Output, "extra")), output.extra);
    const statements = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);
    const variables = zx.columns.view(std.meta.Child(@FieldType(Output, "variables")), output.variables);
    const columns = zx.columns.view(std.meta.Child(@FieldType(Output, "declarations")), output.declarations);
    const roots = zx.columns.view(struct { roots: @FieldType(Output, "roots") }, output).roots;
    const values = view.join(view.join(expressions, forms), extra);
    const commands = view.join(statements, variables);
    const rows = @import("../../node/import_rows.zig");

    rows.append(builder.allocator, &builder.nodes.expressions, &values) catch |err| return failure(err);
    rows.append(builder.allocator, &builder.nodes.statements, &commands) catch |err| return failure(err);

    _ = @import("../../node/import_fields.zig").append(builder.allocator, &builder.nodes.field_columns, output.fields) catch |err| return failure(err);

    rows.append(builder.allocator, &builder.nodes.declaration_rows, &columns) catch |err| return failure(err);
    for (roots) |index| try declarations.append(builder.allocator, try builder.nodes.materializeDeclaration(builder.allocator, index));
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Store request AST"),
    };
}
