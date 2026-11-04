const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");
pub const Result = struct { syntax: *const model.Syntax, native: *const model.Native };

pub fn convert(comptime contents: enum { header, full }, allocator: std.mem.Allocator, program: zx.ast.Program) std.mem.Allocator.Error!Result {
    var context = Context{ .allocator = allocator, .types = .{ .allocator = allocator } };
    const body = if (program.body) |value| try context.block(if (contents == .full) value else .{ .span = value.span, .statements = &.{} }) else null;
    const source_imports = if (contents == .full) program.imports else &.{};
    const imports = try allocator.alloc(*const model.Import, source_imports.len);
    var import_spans: std.ArrayList(*const model.Span) = .empty;
    var import_sources: std.ArrayList(*const model.Span) = .empty;
    var import_names: std.ArrayList([]const u8) = .empty;

    for (source_imports, imports) |item, *value| {
        const first = import_names.items.len;

        for (item.names, 0..) |name, index| {
            const source = (if (item.source_names.len == 0) item.names else item.source_names)[index];

            try import_sources.append(allocator, try context.span(source.span));
            try import_spans.append(allocator, try context.span(name.span));
            try import_names.append(allocator, name.text);
        }

        value.* = try context.keep(model.Import, .{
            .exported = item.exported,
            .wildcard = item.wildcard,
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

    const roots = try allocator.alloc(struct { annotation: u64, value: u64 }, program.constants.len);

    for (program.constants, roots) |item, *root| {
        try context.constant_names.append(allocator, item.name.text);

        root.* = .{
            .annotation = try context.typeReference(item.annotation),
            .value = try context.expression(item.value),
        };
    }

    const tables = try @import("finish.zig").apply(&context, program.declarations, import_names.items, if (program.function_name) |name| name.text else null);
    const constants = try allocator.alloc(*const model.Constant, program.constants.len);

    for (program.constants, roots, constants) |item, root, *value| value.* = try context.keep(model.Constant, .{
        .name = try context.span(item.name.span),
        .span = try context.span(item.span),
        .annotation = root.annotation,
        .value = root.value,
        .types = &model.empty_types,
        .type_order = &model.empty_order,
        .expressions = tables.expressions,
        .blocks = tables.blocks,
    });

    const fields = .{
        .types = &model.empty_types,
        .type_order = &model.empty_order,
        .expressions = tables.expressions,
        .blocks = tables.blocks,
        .tokens = @as(@FieldType(model.Syntax, "tokens"), &.{}),
        .comments = @as(@FieldType(model.Syntax, "comments"), &.{}),
        .imports = imports,
        .import_names = import_spans.items,
        .import_sources = import_sources.items,
        .declarations = @as(@FieldType(model.Syntax, "declarations"), &.{}),
        .constants = constants,
        .members = @as(@FieldType(model.Syntax, "members"), &.{}),
        .contracts = contracts,
        .has_store = program.has_store,
        .function_start = program.function_start,
        .body = body,
        .diagnostic = &model.empty_diagnostic,
    };

    var syntax_value: model.Syntax = undefined;

    inline for (@typeInfo(model.Syntax).@"struct".field_names) |name| {
        @field(syntax_value, name) = if (comptime std.mem.eql(u8, name, "function_name"))
            if (program.function_name) |function| try context.span(function.span) else null
        else
            @field(fields, name);
    }

    const syntax = try context.keep(model.Syntax, syntax_value);

    return .{ .syntax = syntax, .native = tables.native };
}
