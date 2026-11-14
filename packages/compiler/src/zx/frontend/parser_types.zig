const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Type = grammar.reference(*const ast.Type, parse);
const Field = grammar.sequence(.{ grammar.reference(ast.Name, Parser.property), grammar.optional(grammar.token("?")), grammar.required(grammar.token(":"), "expected :"), Type, grammar.optional(grammar.token(",")) });
const Object = grammar.sequence(.{ grammar.token("{"), grammar.reference([]const ast.TypeField, fields), grammar.required(grammar.token("}"), "expected }") });
const Tuple = grammar.sequence(.{ grammar.token("["), grammar.separated(Type, ",", "]"), grammar.required(grammar.token("]"), "expected ]") });
const Argument = grammar.sequence(.{ grammar.token("<"), Type, grammar.required(grammar.token(">"), "expected >") });
const Named = grammar.sequence(.{ grammar.reference(ast.Name, qualifiedName), grammar.optional(Argument) });
const Group = grammar.sequence(.{ grammar.token("("), Type, grammar.required(grammar.token(")"), "expected )") });
const Primary = grammar.choice(.{ grammar.map(Object, ast.Type, object), grammar.map(Tuple, ast.Type, tuple), grammar.map(Named, ast.Type, named), grammar.map(Group, ast.Type, group) });

const Suffix = grammar.choice(.{
    grammar.map(grammar.token("?"), SuffixKind, optional),
    grammar.map(grammar.sequence(.{ grammar.token("["), grammar.required(grammar.token("]"), "expected ]") }), SuffixKind, list),
});

const SuffixKind = enum { optional, list };

pub fn parse(parser: *Parser) zx.Error!*const ast.Type {
    try parser.enter();

    defer parser.depth -= 1;

    var result: *const ast.Type = try wrap(parser, try grammar.run(Primary, parser, "expected a type"));

    while (true) {
        if (result.* == .named and parser.at("(")) {
            const name = result.named;

            if (std.mem.lastIndexOfScalar(u8, name.text, '.')) |dot| {
                var end = dot;

                while (end != 0 and std.ascii.isWhitespace(name.text[end - 1])) end -= 1;

                var start = dot + 1;

                while (start < name.text.len and std.ascii.isWhitespace(name.text[start])) start += 1;

                const base = try wrap(parser, .{ .named = .{
                    .text = name.text[0..end],
                    .span = .{ .start = name.span.start, .end = name.span.start + end },
                } });

                result = try selection(parser, base, .{
                    .text = name.text[start..],
                    .span = .{ .start = name.span.start + start, .end = name.span.end },
                });

                continue;
            }
        }

        const suffix = try grammar.run(grammar.optional(Suffix), parser, "expected a type suffix");

        if (suffix) |kind| {
            result = try wrap(parser, switch (kind) {
                .optional => .{ .optional = result },
                .list => .{ .list = result },
            });
        } else if (parser.take(".")) {
            result = try selection(parser, result, try parser.name());
        } else break;
    }

    const operator = parser.current();

    if (parser.take("&")) return wrap(parser, .{ .intersection = .{ .left = result, .right = try parse(parser), .span = operator.span } });

    return result;
}

fn selection(parser: *Parser, base: *const ast.Type, name: ast.Name) zx.Error!*const ast.Type {
    try parser.expect("(");

    var keys: std.ArrayList(ast.Name) = .empty;

    while (!parser.take(")")) {
        const token = parser.current();

        if (token.kind != .string) return parser.reporter.fail(.syntax, token.span, "expected a type method with static string keys");

        parser.index += 1;
        const span = zx.Span{ .start = token.span.start + 1, .end = token.span.end - 1 };

        try keys.append(parser.allocator, .{ .text = parser.source[span.start..span.end], .span = span });

        if (!parser.at(")")) try parser.expect(",");
    }

    return wrap(parser, .{ .selection = .{ .name = name, .base = base, .keys = try keys.toOwnedSlice(parser.allocator) } });
}

fn qualifiedName(parser: *Parser) zx.Error!ast.Name {
    const first = try parser.name();
    var span = first.span;

    while (parser.take(".")) span.end = (try parser.name()).span.end;

    return .{ .text = parser.source[span.start..span.end], .span = span };
}

fn object(_: *Parser, values: Object.Value) zx.Error!ast.Type {
    return .{ .object = values[1] };
}

fn tuple(_: *Parser, values: Tuple.Value) zx.Error!ast.Type {
    return .{ .tuple = values[1] };
}

fn group(_: *Parser, values: Group.Value) zx.Error!ast.Type {
    return values[1].*;
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

        if (values[4] == null and !parser.at("}") and !parser.lineBreak()) return parser.reporter.fail(.syntax, parser.current().span, "expected a comma or newline between type fields");

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
