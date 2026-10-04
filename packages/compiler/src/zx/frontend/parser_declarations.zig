const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Name = grammar.reference(ast.Name, Parser.name);
const Type = grammar.reference(*const ast.Type, Parser.typeNode);
const TypeDecl = grammar.sequence(.{ grammar.token("export"), grammar.token("type"), Name, grammar.required(grammar.token("="), "expected ="), Type, grammar.required(grammar.token(";"), "expected ;") });
const EnumDecl = grammar.sequence(.{ grammar.token("export"), grammar.token("enum"), Name, grammar.required(grammar.token("{"), "expected {"), grammar.separated(Name, ",", "}"), grammar.required(grammar.token("}"), "expected }") });
pub const Declaration = grammar.choice(.{ grammar.map(TypeDecl, ast.Declaration, typeDeclaration), grammar.map(EnumDecl, ast.Declaration, enumDeclaration) });

fn typeDeclaration(parser: *Parser, values: TypeDecl.Value) zx.Error!ast.Declaration {
    return .{ .name = values[2], .value = values[4], .span = parser.range(values[0].span.start) };
}

fn enumDeclaration(parser: *Parser, values: EnumDecl.Value) zx.Error!ast.Declaration {
    const value = try parser.allocator.create(ast.Type);

    value.* = .{ .enumeration = values[4] };

    return .{ .name = values[2], .value = value, .span = parser.range(values[0].span.start) };
}
