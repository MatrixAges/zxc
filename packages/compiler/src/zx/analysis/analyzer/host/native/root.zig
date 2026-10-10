const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");
const borrow = @import("../../../../ir/canonical/borrow.zig");
const Reference = @import("../../../semantic/resolving/host/model.zig").Reference;

pub const Result = struct { syntax: *const model.Syntax, native: *const model.Native };

pub fn convert(comptime contents: enum { header, full }, allocator: std.mem.Allocator, program: zx.ast.Program) std.mem.Allocator.Error!Result {
    var context = Context{ .allocator = allocator, .types = .{ .allocator = allocator } };
    const body = if (program.body) |value| try context.block(if (contents == .full) value else .{ .span = value.span, .statements = &.{} }) else null;
    const source_imports = if (contents == .full) program.imports else &.{};
    const imports = try allocator.alloc(*const model.Import, source_imports.len);
    var import_spans: std.ArrayList(*const model.Span) = .empty;
    var import_names: std.ArrayList([]const u8) = .empty;

    for (source_imports, imports) |item, *value| {
        const first = import_names.items.len;

        for (item.names) |name| {
            try import_spans.append(allocator, try context.span(name.span));
            try import_names.append(allocator, name.text);
        }

        value.* = try context.keep(model.Import, .{
            .kind = switch (item.kind) {
                .function => .Function,
                .enumeration => .Enumeration,
                .type_only => .TypeOnly,
            },
            .span = try context.span(item.span),
            .path = &model.empty_span,
            .first = first,
            .count = item.names.len,
        });
    }

    const source_contracts = if (contents == .full) program.contracts else &.{};
    const contracts = try allocator.alloc(*const model.Contract, source_contracts.len);

    for (source_contracts, contracts) |item, *value| value.* = try context.keep(model.Contract, .{
        .ensures = item.kind == .ensures,
        .predicate = try context.expression(item.predicate),
        .span = try context.span(item.span),
    });

    while (context.pending.pop()) |pending| switch (pending) {
        .expression => |value| try @import("expressions.zig").fill(&context, value),
        .block => |value| try @import("blocks.zig").fill(&context, value),
    };

    const types = try context.types.prepare(program.declarations, null);

    const text = try context.keep(model.Text, .{
        .expression_names = context.expression_names.items,
        .expression_values = context.expression_values.items,
        .field_names = context.field_names.items,
        .parameter_names = context.parameter_names.items,
        .template_values = context.template_values.items,
        .statement_names = context.statement_names.items,
        .destructure_names = context.destructure_names.items,
        .type_references = borrow.slice(@FieldType(model.Text, "type_references"), @as([]const *const Reference, context.type_references.items)),
    });

    const native = try context.keep(model.Native, .{
        .types = borrow.pointer(@FieldType(model.Native, "types"), types.source),
        .text = text,
        .import_names = import_names.items,
    });

    const expressions = try context.keep(model.Expressions, .{
        .nodes = context.nodes.items,
        .items = context.items.items,
        .fields = context.fields.items,
        .parameters = context.parameters.items,
        .parts = context.parts.items,
        .arms = context.arms.items,
    });

    const blocks = try context.keep(model.Blocks, .{
        .statements = context.statements.items,
        .blocks = context.blocks.items,
        .items = context.block_items.items,
        .names = context.names.items,
        .cases = context.cases.items,
    });

    const syntax = try context.keep(model.Syntax, .{
        .types = &model.empty_types,
        .type_order = &model.empty_order,
        .expressions = expressions,
        .blocks = blocks,
        .tokens = &.{},
        .comments = &.{},
        .imports = imports,
        .import_names = import_spans.items,
        .declarations = &.{},
        .members = &.{},
        .contracts = contracts,
        .has_store = program.has_store,
        .function_start = program.function_start,
        .body = body,
        .diagnostic = &model.empty_diagnostic,
    });

    return .{ .syntax = syntax, .native = native };
}
