const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Name = grammar.reference(ast.Name, Parser.name);
const Type = grammar.reference(*const ast.Type, parse);
const Field = grammar.sequence(.{ Name, grammar.optional(grammar.token("?")), grammar.required(grammar.token(":"), "expected :"), Type, grammar.optional(grammar.choice(.{ grammar.token(";"), grammar.token(",") })) });
const Object = grammar.sequence(.{ grammar.token("{"), grammar.reference([]const ast.TypeField, fields), grammar.required(grammar.token("}"), "expected }") });
const Tuple = grammar.sequence(.{ grammar.token("["), grammar.separated(Type, ",", "]"), grammar.required(grammar.token("]"), "expected ]") });
const Argument = grammar.sequence(.{ grammar.token("<"), Type, grammar.required(grammar.token(">"), "expected >") });
const Named = grammar.sequence(.{ Name, grammar.optional(Argument) });
const Primary = grammar.choice(.{ grammar.map(Object, ast.Type, object), grammar.map(Tuple, ast.Type, tuple), grammar.map(Named, ast.Type, named) });

const Suffix = grammar.choice(.{
    grammar.map(grammar.token("?"), SuffixKind, optional),
    grammar.map(grammar.sequence(.{ grammar.token("["), grammar.required(grammar.token("]"), "expected ]") }), SuffixKind, list),
});

const SuffixKind = enum { optional, list };

pub fn parse(parser: *Parser) zx.Error!*const ast.Type {
    try parser.enter();

    defer parser.depth -= 1;

    var result = try wrap(parser, try grammar.run(Primary, parser, "expected a type"));
    const suffixes = try grammar.run(grammar.many(Suffix), parser, "expected a type suffix");

    for (suffixes) |suffix| {
        result = try wrap(parser, switch (suffix) {
            .optional => .{ .optional = result },
            .list => .{ .list = result },
        });
    }

    return result;
}

fn object(_: *Parser, values: Object.Value) zx.Error!ast.Type {
    return .{ .object = values[1] };
}

fn tuple(_: *Parser, values: Tuple.Value) zx.Error!ast.Type {
    return .{ .tuple = values[1] };
}

fn named(_: *Parser, values: Named.Value) zx.Error!ast.Type {
    return if (values[1]) |argument| .{ .application = .{ .name = values[0], .argument = argument[1] } } else .{ .named = values[0] };
}

fn optional(_: *Parser, _: zx.syntax.Token) zx.Error!SuffixKind {
    return .optional;
}

fn list(_: *Parser, _: grammar.sequence(.{ grammar.token("["), grammar.required(grammar.token("]"), "expected ]") }).Value) zx.Error!SuffixKind {
    return .list;
}

const FieldRule = struct {
    pub const Value = ast.TypeField;

    pub fn parse(parser: *Parser) zx.Error!grammar.Match(Value) {
        if (parser.at("}")) return .miss;

        const values = try grammar.run(Field, parser, "expected a type field");

        if (values[4] == null and !parser.at("}")) return parser.reporter.fail(.syntax, parser.current().span, "expected ; or , between type fields");

        return .{ .hit = .{ .name = values[0], .value = if (values[1] != null) try wrap(parser, .{ .optional = values[3] }) else values[3] } };
    }
};

fn fields(parser: *Parser) zx.Error![]const ast.TypeField {
    return grammar.run(grammar.many(FieldRule), parser, "expected object fields");
}

fn wrap(parser: *Parser, value: ast.Type) zx.Error!*ast.Type {
    const result = try parser.allocator.create(ast.Type);

    result.* = value;

    return result;
}
