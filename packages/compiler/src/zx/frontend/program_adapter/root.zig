const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_parser");
const Context = @import("context.zig");

pub fn convert(allocator: std.mem.Allocator, source: []const u8, output: generated.Output) !zx.ast.Program {
    const program = output.program;

    const context = Context{
        .allocator = allocator,
        .source = source,
        .program = program,
        .types = try allocator.alloc(zx.ast.Type, program.body.expression.types.tree.nodes.len),
        .expressions = try allocator.alloc(zx.ast.Expression, program.body.expression.tree.nodes.len),
        .blocks = try allocator.alloc(zx.ast.Block, program.body.tree.blocks.len),
    };

    try @import("types.zig").fill(context);
    try @import("blocks.zig").fill(context);
    try @import("expressions.zig").fill(context);

    const imports = try allocator.alloc(zx.ast.Import, program.prefix.imports.len);

    for (program.prefix.imports, imports) |item, *value| {
        const names = try allocator.alloc(zx.ast.Name, @intCast(item.count));

        for (names, program.prefix.names[@intCast(item.first)..][0..names.len]) |*name, position| name.* = context.name(position);

        value.* = .{
            .kind = switch (item.kind) {
                .Function => .function,
                .Enumeration => .enumeration,
                .TypeOnly => .type_only,
            },
            .names = names,
            .path = source[@intCast(item.path.start + 1)..@intCast(item.path.end - 1)],
            .span = Context.span(item.span),
        };
    }

    const declarations = try allocator.alloc(zx.ast.Declaration, program.prefix.declarations.len);

    for (program.prefix.declarations, declarations) |item, *value| {
        const declared_type = if (item.enumeration) blk: {
            const names = try allocator.alloc(zx.ast.Name, @intCast(item.count));

            for (names, program.prefix.members[@intCast(item.first)..][0..names.len]) |*name, position| name.* = context.name(position);

            const enumeration = try allocator.create(zx.ast.Type);

            enumeration.* = .{ .enumeration = names };

            break :blk enumeration;
        } else context.typeValue(item.value);

        value.* = .{ .name = context.name(item.name), .span = Context.span(item.span), .value = declared_type };
    }

    const contracts = try allocator.alloc(zx.ast.Contract, program.contracts.len);

    for (program.contracts, contracts) |item, *value| value.* = .{
        .kind = if (item.ensures) .ensures else .requires,
        .predicate = context.expression(item.predicate),
        .span = Context.span(item.span),
    };

    return .{
        .imports = imports,
        .declarations = declarations,
        .contracts = contracts,
        .consumes_input = program.header.consumes_input,
        .has_store = program.header.has_store,
        .function_start = @intCast(program.prefix.function_start),
        .body = if (program.prefix.present) context.block(program.body.control.result) else null,
    };
}

pub fn lexed(allocator: std.mem.Allocator, output: generated.Output) !zx.syntax.Lexed {
    const input = output.program.body.expression.prepared.lexical.lexed;
    const tokens = try allocator.alloc(zx.syntax.Token, input.tokens.len);
    const comments = try allocator.alloc(zx.Span, input.comments.len);

    for (input.tokens, tokens) |token, *item| item.* = .{
        .kind = switch (token.kind) {
            .Identifier => .identifier,
            .Keyword => .keyword,
            .Number => .number,
            .String => .string,
            .Template => .template,
            .Punctuation => .punctuation,
            .Eof => .eof,
        },
        .span = Context.span(token.span),
    };

    for (input.comments, comments) |span, *item| item.* = Context.span(span);

    return .{ .tokens = tokens, .comments = comments };
}
