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

    const tables = try @import("finish.zig").apply(&context, program.declarations, import_names.items);

    const syntax = try context.keep(model.Syntax, .{
        .types = &model.empty_types,
        .type_order = &model.empty_order,
        .expressions = tables.expressions,
        .blocks = tables.blocks,
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

    return .{ .syntax = syntax, .native = tables.native };
}
