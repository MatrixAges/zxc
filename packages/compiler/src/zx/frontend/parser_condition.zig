const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const Expression = zx.ast.Expression;

pub const term_limit: u16 = 4;
const Connector = enum { and_value, or_value, xor_value, nand_value, nor_value };

pub fn parse(parser: *Parser) zx.Error!*const Expression {
    const start = parser.current().span.start;
    const saved = parser.condition_end;

    defer parser.condition_end = saved;

    try parser.expect("-");

    parser.condition_end = boundary(parser);

    var result = try negate(parser, try negate(parser, try parser.expression(0)));

    while (!parser.at(")")) {
        if (!parser.at("-") or !parser.lineBreak()) return parser.reporter.fail(.syntax, parser.current().span, "expected a condition bullet or )");

        parser.index += 1;

        const text = parser.current().text(parser.source);
        const connector: Connector = if (std.mem.eql(u8, text, "and") or std.mem.eql(u8, text, "&&")) .and_value else if (std.mem.eql(u8, text, "or") or std.mem.eql(u8, text, "||")) .or_value else if (std.mem.eql(u8, text, "xor")) .xor_value else if (std.mem.eql(u8, text, "nand")) .nand_value else if (std.mem.eql(u8, text, "nor")) .nor_value else return parser.reporter.fail(.syntax, parser.current().span, "expected and, or, xor, nand, nor, && or || after condition bullet");

        if (parser.lineBreak()) return parser.reporter.fail(.syntax, parser.current().span, "expected and, or, xor, nand, nor, && or || after condition bullet");

        parser.index += 1;
        parser.condition_end = boundary(parser);
        const right = try parser.expression(0);
        const terms = @min(term_limit, result.condition_terms + right.condition_terms);
        const left_value = if (connector == .xor_value) try negate(parser, result) else result;
        const right_value = if (connector == .xor_value) try negate(parser, right) else right;

        const operator: zx.syntax.Operator = switch (connector) {
            .and_value, .nand_value => .logical_and,
            .or_value, .nor_value => .logical_or,
            .xor_value => .not_equal,
        };

        result = try mark(parser, try parser.make(start, .{ .binary = .{ .operator = operator, .left = left_value, .right = right_value } }), terms);

        if (connector == .nand_value or connector == .nor_value) result = try negate(parser, result);
    }

    const value = @constCast(result);

    value.span.start = start;

    return value;
}

fn negate(parser: *Parser, value: *const Expression) zx.Error!*const Expression {
    return mark(parser, try parser.make(value.span.start, .{ .unary = .{ .operator = .not, .operand = value } }), value.condition_terms);
}

fn mark(parser: *Parser, value: *const Expression, terms: u16) zx.Error!*const Expression {
    _ = parser;

    const result = @constCast(value);

    result.condition_list = true;
    result.condition_terms = terms;

    return result;
}

fn boundary(parser: *const Parser) usize {
    var index = parser.index;
    var depth: usize = 0;

    while (index < parser.tokens.len) : (index += 1) {
        const token = parser.tokens[index];
        const text = token.text(parser.source);
        const closing = std.mem.eql(u8, text, ")") or std.mem.eql(u8, text, "]") or std.mem.eql(u8, text, "}");
        const line_break = index > 0 and std.mem.indexOfAny(u8, parser.source[parser.tokens[index - 1].span.end..token.span.start], "\r\n") != null;

        if (token.kind == .eof or (depth == 0 and (closing or (line_break and std.mem.eql(u8, text, "-"))))) return index;
        if (closing) depth -= 1;
        if (std.mem.eql(u8, text, "(") or std.mem.eql(u8, text, "[") or std.mem.eql(u8, text, "{")) depth += 1;
    }

    return index;
}
