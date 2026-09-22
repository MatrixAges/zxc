const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Name = grammar.reference(ast.Name, Parser.name);
const Named = grammar.sequence(.{ grammar.token("{"), grammar.separated(Name, ",", "}"), grammar.required(grammar.token("}"), "expected }") });
const Names = struct { names: []const ast.Name, named: bool };
const Bindings = grammar.choice(.{ grammar.map(Named, Names, named), grammar.map(Name, Names, single) });
const Rule = grammar.sequence(.{ grammar.token("import"), grammar.optional(grammar.token("type")), Bindings, grammar.required(grammar.token("from"), "expected from"), grammar.reference([]const u8, path), grammar.required(grammar.token(";"), "expected ;") });
pub const Import = grammar.map(Rule, ast.Import, declaration);

fn named(_: *Parser, values: Named.Value) zx.Error!Names {
    return .{ .names = values[1], .named = true };
}

fn single(parser: *Parser, name: ast.Name) zx.Error!Names {
    const names = try parser.allocator.alloc(ast.Name, 1);

    names[0] = name;

    return .{ .names = names, .named = false };
}

fn path(parser: *Parser) zx.Error![]const u8 {
    const token = parser.current();

    if (token.kind != .string) return parser.reporter.fail(.syntax, token.span, "import path must be a string literal");

    parser.index += 1;

    const text = token.text(parser.source);

    return @import("string_literal.zig").decode(parser.allocator, text[1 .. text.len - 1]);
}

fn declaration(parser: *Parser, values: Rule.Value) zx.Error!ast.Import {
    const bindings = values[2];

    if (bindings.names.len == 0) return parser.reporter.fail(.syntax, values[0].span, "an import must bind at least one name");
    if (values[1] != null and !bindings.named) return parser.reporter.fail(.syntax, values[0].span, "type imports require named bindings");

    return .{ .kind = if (values[1] != null) .type_only else if (bindings.named) .enumeration else .function, .names = bindings.names, .path = values[4], .span = parser.range(values[0].span.start) };
}
