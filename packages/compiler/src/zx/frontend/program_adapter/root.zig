const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");

pub fn convert(allocator: std.mem.Allocator, source: []const u8, output: anytype) !zx.ast.Program {
    const program = output;
    const context = try Context.init(allocator, source, program);
    const header = @import("../syntax/header.zig").View(@TypeOf(program)){ .source = source, .storage = program };

    try @import("types.zig").fill(context);
    try @import("blocks.zig").fill(context);
    try @import("expressions.zig").fill(context);

    const imports = try allocator.alloc(zx.ast.Import, program.imports.len);

    for (program.imports, imports) |item, *value| {
        const names = try allocator.alloc(zx.ast.Name, @intCast(item.count));

        for (names, program.import_names[@intCast(item.first)..][0..names.len]) |*name, position| name.* = context.name(position);

        const sources = try allocator.alloc(zx.ast.Name, names.len);

        for (sources, program.import_sources[@intCast(item.first)..][0..sources.len]) |*name, position| name.* = context.name(position);

        value.* = .{
            .exported = item.exported,
            .wildcard = item.wildcard,
            .source_names = sources,
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

    const declarations = try allocator.alloc(zx.ast.Declaration, program.declarations.len);

    for (program.declarations, declarations) |item, *value| {
        const declared_type = if (item.enumeration) blk: {
            const names = try allocator.alloc(zx.ast.Name, @intCast(item.count));

            for (names, program.members[@intCast(item.first)..][0..names.len]) |*name, position| name.* = context.name(position);

            const enumeration = try allocator.create(zx.ast.Type);

            enumeration.* = .{ .enumeration = names };

            break :blk enumeration;
        } else context.typeValue(item.value);

        value.* = .{ .name = context.name(item.name), .span = Context.span(item.span), .value = declared_type };
    }

    const contracts = try allocator.alloc(zx.ast.Contract, program.contracts.len);
    const constants = try allocator.alloc(zx.ast.Constant, program.constants.len);

    for (program.constants, constants) |item, *value| {
        const constant = try Context.init(allocator, source, item);

        try @import("types.zig").fill(constant);
        try @import("blocks.zig").fill(constant);
        try @import("expressions.zig").fill(constant);

        value.* = .{
            .name = constant.name(item.name),
            .annotation = constant.typeValue(item.annotation),
            .value = constant.expression(item.value),
            .span = Context.span(item.span),
        };
    }

    for (program.contracts, contracts) |item, *value| value.* = .{
        .kind = if (item.ensures) .ensures else .requires,
        .predicate = context.expression(item.predicate),
        .span = Context.span(item.span),
    };

    return .{
        .imports = imports,
        .declarations = declarations,
        .constants = constants,
        .contracts = contracts,
        .has_store = program.has_store,
        .function_name = header.functionName(),
        .function_start = @intCast(program.function_start),
        .body = if (program.body) |index| context.block(index) else null,
    };
}

pub fn lexed(allocator: std.mem.Allocator, input: anytype) !zx.syntax.Lexed {
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

pub fn expression(allocator: std.mem.Allocator, source: []const u8, output: anytype) !*const zx.ast.Expression {
    const context = try Context.init(allocator, source, output);

    try @import("types.zig").fill(context);
    try @import("blocks.zig").fill(context);
    try @import("expressions.zig").fill(context);

    return context.expression(output.result);
}
