const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;

pub fn parse(parser: *Parser) zx.Error!ast.Import {
    const start = parser.current().span.start;
    const exported = parser.take("export");

    if (!exported) try parser.expect("import");

    const type_only = parser.take("type");
    const wildcard = exported and parser.take("*");
    const named = wildcard or parser.take("{");
    var names: std.ArrayList(ast.Name) = .empty;
    var sources: std.ArrayList(ast.Name) = .empty;

    if (!wildcard) {
        while (true) {
            if (named and parser.take("}")) break;

            const source = if (named and parser.at("default")) value: {
                const token = parser.current();
                parser.index += 1;

                break :value ast.Name{ .text = token.text(parser.source), .span = token.span };
            } else try parser.name();

            const name = if (named and parser.take("as")) (if (exported) try binding(parser) else try parser.name()) else source;

            if (!exported and std.mem.eql(u8, name.text, "default")) return parser.reporter.fail(.syntax, name.span, "default imports in braces require an alias");
            try names.append(parser.allocator, name);
            try sources.append(parser.allocator, source);
            if (!named) break;
            if (parser.take("}")) break;
            try parser.expect(",");
        }
    }

    if (!wildcard and names.items.len == 0) return parser.reporter.fail(.syntax, parser.current().span, "an import must bind at least one name");
    if (type_only and !named) return parser.reporter.fail(.syntax, parser.current().span, "type imports require named bindings");
    if (exported and !named) return parser.reporter.fail(.syntax, parser.current().span, "re-exports require named bindings or *");
    try parser.expect("from");

    const token = parser.current();

    if (token.kind != .string) return parser.reporter.fail(.syntax, token.span, "import path must be a string literal");

    parser.index += 1;

    const text = token.text(parser.source);
    const path = try @import("string_literal.zig").decode(parser.allocator, text[1 .. text.len - 1]);

    try parser.endStatement();

    return .{ .kind = if (type_only) .type_only else if (named) .enumeration else .function, .names = try names.toOwnedSlice(parser.allocator), .source_names = try sources.toOwnedSlice(parser.allocator), .exported = exported, .wildcard = wildcard, .path = path, .span = parser.range(start) };
}

fn binding(parser: *Parser) zx.Error!ast.Name {
    if (!parser.at("default")) return parser.name();

    const token = parser.current();

    parser.index += 1;

    return .{ .text = token.text(parser.source), .span = token.span };
}
