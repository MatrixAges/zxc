const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Value = @FieldType(ast.Statement, "value");
const Expression = grammar.reference(*const ast.Expression, expression);
const Name = grammar.reference(ast.Name, Parser.name);
const Type = grammar.reference(*const ast.Type, Parser.typeNode);
const Block = grammar.reference(ast.Block, Parser.block);
const Annotation = grammar.sequence(.{ grammar.token(":"), Type });
const Binding = grammar.sequence(.{ Name, grammar.optional(Annotation), grammar.required(grammar.token("="), "expected ="), Expression });
const Pattern = grammar.sequence(.{ grammar.token("["), grammar.separated(Name, ",", "]"), grammar.required(grammar.token("]"), "expected ]"), grammar.required(grammar.token("="), "expected ="), Expression });
const Declaration = grammar.choice(.{ grammar.map(Pattern, Value, destructure), grammar.map(Binding, Value, constant) });
const Constant = grammar.sequence(.{ grammar.token("const"), Declaration, grammar.reference(void, Parser.endStatement) });
const Return = grammar.sequence(.{ grammar.token("return"), grammar.reference(Value, result), grammar.reference(void, Parser.endStatement) });
const Condition = grammar.sequence(.{ grammar.required(grammar.token("("), "expected ("), Expression, grammar.required(grammar.token(")"), "expected )"), Block });
const Else = grammar.sequence(.{ grammar.token("else"), grammar.reference(ast.Block, alternative) });
const Branch = grammar.sequence(.{ grammar.token("if"), Condition, grammar.optional(Else) });
const Switch = grammar.sequence(.{ grammar.token("switch"), grammar.reference(Value, switchStatement) });
const Store = grammar.sequence(.{ grammar.peek(grammar.token("store")), grammar.reference(Value, store) });

const Statement = grammar.choice(.{
    grammar.map(Constant, Value, takeSecond(Constant)),
    grammar.map(Return, Value, takeSecond(Return)),
    grammar.map(Branch, Value, branch),
    grammar.map(Switch, Value, takeSecond(Switch)),
    grammar.map(Store, Value, takeSecond(Store)),
    InjectedStore,
    Evaluation,
});

pub fn parse(parser: *Parser) zx.Error!ast.Statement {
    try parser.enter();

    defer parser.depth -= 1;
    const start = parser.current().span.start;
    const value = try grammar.run(Statement, parser, "expected const, if, switch, return or a Store setter; ordinary mutation is forbidden");

    return .{ .span = parser.range(start), .value = value };
}

fn expression(parser: *Parser) zx.Error!*const ast.Expression {
    return parser.expression(0);
}

fn takeSecond(comptime Rule: type) fn (*Parser, Rule.Value) zx.Error!Value {
    return struct {
        fn build(_: *Parser, values: Rule.Value) zx.Error!Value {
            return values[1];
        }
    }.build;
}

fn constant(_: *Parser, values: Binding.Value) zx.Error!Value {
    return .{ .constant = .{ .name = values[0], .annotation = if (values[1]) |annotation| annotation[1] else null, .value = values[3] } };
}

fn destructure(_: *Parser, values: Pattern.Value) zx.Error!Value {
    return .{ .destructure = .{ .names = values[1], .value = values[4] } };
}

fn result(parser: *Parser) zx.Error!Value {
    const next_statement = parser.lineBreak() and (parser.at("const") or parser.at("return") or parser.at("if") or parser.at("switch") or parser.at("store"));

    return .{ .result = if (parser.at("}") or parser.current().kind == .eof or next_statement) null else try expression(parser) };
}

fn branch(_: *Parser, values: Branch.Value) zx.Error!Value {
    return .{ .branch = .{ .condition = values[1][1], .yes = values[1][3], .no = if (values[2]) |otherwise| otherwise[1] else null } };
}

fn alternative(parser: *Parser) zx.Error!ast.Block {
    if (!parser.at("if")) return parser.block();

    const nested = try parser.allocator.alloc(ast.Statement, 1);

    nested[0] = try parse(parser);

    return .{ .span = nested[0].span, .statements = nested };
}

fn store(parser: *Parser) zx.Error!Value {
    const target = try expression(parser);

    try parser.expect("=");

    const value = try expression(parser);

    try parser.endStatement();

    return .{ .store_set = .{ .target = target, .value = value } };
}

fn switchStatement(parser: *Parser) zx.Error!@FieldType(ast.Statement, "value") {
    try parser.expect("(");

    const subject = try parser.expression(0);

    try parser.expect(")");
    try parser.expect("{");

    var cases: std.ArrayList(ast.SwitchCase) = .empty;

    while (!parser.take("}")) {
        const start = parser.current().span.start;

        const value = if (parser.take("case")) try parser.expression(0) else blk: {
            try parser.expect("default");

            break :blk null;
        };

        try parser.expect(":");

        const body_start = parser.current().span.start;
        var statements: std.ArrayList(ast.Statement) = .empty;

        while (!parser.at("case") and !parser.at("default") and !parser.at("}")) {
            try statements.append(parser.allocator, try parse(parser));
        }

        try cases.append(parser.allocator, .{
            .value = value,
            .body = .{ .span = .{ .start = body_start, .end = parser.current().span.start }, .statements = try statements.toOwnedSlice(parser.allocator) },
            .span = parser.range(start),
        });
    }

    return .{ .switch_stmt = .{ .subject = subject, .cases = try cases.toOwnedSlice(parser.allocator) } };
}

const InjectedStore = struct {
    pub const Value = @FieldType(ast.Statement, "value");

    pub fn parse(parser: *Parser) zx.Error!grammar.Match(@This().Value) {
        if (!std.mem.startsWith(u8, parser.current().text(parser.source), "$")) return .miss;

        return .{ .hit = try store(parser) };
    }
};

const Evaluation = struct {
    pub const Value = @FieldType(ast.Statement, "value");

    pub fn parse(parser: *Parser) zx.Error!grammar.Match(@This().Value) {
        if (parser.current().kind != .identifier and !parser.at("(") and !parser.at("[")) return .miss;

        const value = try parser.expression(0);

        if (value.value != .call) return parser.reporter.fail(.syntax, value.span, "only calls can be used as standalone expressions");
        try parser.endStatement();

        return .{ .hit = .{ .evaluate = value } };
    }
};
