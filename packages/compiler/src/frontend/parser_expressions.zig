const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;

pub fn parse(parser: *Parser, minimum: u8) zx.Error!*const ast.Expression {
    try parser.enter();

    defer parser.depth -= 1;

    var left = try primary(parser);

    while (zx.syntax.Operator.parse(parser.current().text(parser.source))) |operator| {
        if (operator.precedence() < minimum) break;

        parser.index += 1;

        const right = try parse(parser, operator.precedence() + 1);

        left = try parser.make(left.span.start, .{ .binary = .{ .operator = operator, .left = left, .right = right } });
    }

    if (minimum == 0 and parser.take("?")) {
        const yes = try parse(parser, 0);

        try parser.expect(":");

        const no = try parse(parser, 0);
        left = try parser.make(left.span.start, .{ .conditional = .{ .condition = left, .yes = yes, .no = no } });
    }

    return left;
}

fn primary(parser: *Parser) zx.Error!*const ast.Expression {
    try parser.enter();

    defer parser.depth -= 1;
    const token = parser.current();
    var result: *const ast.Expression = undefined;

    if (parser.take("!")) {
        return parser.make(token.span.start, .{ .unary = .{ .operator = .not, .operand = try primary(parser) } });
    } else if (parser.take("-")) {
        return parser.make(token.span.start, .{ .unary = .{ .operator = .negate, .operand = try primary(parser) } });
    } else if (isLambda(parser)) {
        return lambda(parser);
    } else if (parser.take("(")) {
        result = try parse(parser, 0);

        try parser.expect(")");
    } else if (parser.take("{")) {
        var fields: std.ArrayList(ast.Field) = .empty;

        while (!parser.take("}")) {
            if (parser.take("...")) {
                const value = try parse(parser, 0);

                try fields.append(parser.allocator, .{ .name = .{ .text = "", .span = value.span }, .value = value, .spread = true });
            } else {
                const name = try parser.name();
                const value = if (parser.take(":")) try parse(parser, 0) else try parser.make(name.span.start, .{ .identifier = name });

                try fields.append(parser.allocator, .{ .name = name, .value = value });
            }

            if (!parser.take(",") and !parser.at("}")) try parser.expect(",");
        }

        result = try parser.make(token.span.start, .{ .object = try fields.toOwnedSlice(parser.allocator) });
    } else if (parser.take("[")) {
        result = try parser.make(token.span.start, .{ .list = try arguments(parser, "]") });
    } else if (parser.take("null")) {
        result = try parser.make(token.span.start, .null_value);
    } else if (parser.take("true") or parser.take("false")) {
        result = try parser.make(token.span.start, .{ .boolean = std.mem.eql(u8, token.text(parser.source), "true") });
    } else if (token.kind == .template) {
        parser.index += 1;
        result = try parser.make(token.span.start, .{ .template = try @import("template.zig").parse(parser, token) });
    } else if (token.kind == .number or token.kind == .string) {
        parser.index += 1;
        result = try parser.make(token.span.start, if (token.kind == .number) .{ .number = token.text(parser.source) } else .{ .string = token.text(parser.source) });
    } else {
        result = try parser.make(token.span.start, .{ .identifier = try parser.name() });
    }

    while (true) {
        if (parser.take(".")) {
            result = try parser.make(token.span.start, .{ .field = .{ .target = result, .name = try parser.name() } });
        } else if (parser.take("[")) {
            const index = try parse(parser, 0);

            try parser.expect("]");

            result = try parser.make(token.span.start, .{ .index = .{ .target = result, .index = index } });
        } else {
            const generic = result.value == .field and isGenericMethod(result.value.field.name.text) and parser.take("<");
            const type_argument = if (generic) try parser.typeNode() else null;

            if (generic) try parser.expect(">");

            if (!parser.take("(")) {
                if (generic) try parser.expect("(");

                break;
            }

            result = try parser.make(token.span.start, .{ .call = .{ .callee = result, .arguments = try arguments(parser, ")"), .type_argument = type_argument } });
        }
    }

    return result;
}

fn arguments(parser: *Parser, closing: []const u8) zx.Error![]const *const ast.Expression {
    var items: std.ArrayList(*const ast.Expression) = .empty;

    while (!parser.take(closing)) {
        try items.append(parser.allocator, try parse(parser, 0));
        if (!parser.take(",") and !parser.at(closing)) try parser.expect(",");
    }

    return items.toOwnedSlice(parser.allocator);
}

fn isLambda(parser: *const Parser) bool {
    var index = parser.index;
    const parenthesized = parser.at("(");

    if (parenthesized) index += 1;

    while (index < parser.tokens.len) {
        if (parenthesized and std.mem.eql(u8, parser.tokens[index].text(parser.source), ")")) {
            index += 1;

            break;
        }

        if (parser.tokens[index].kind != .identifier) return false;

        index += 1;

        if (!parenthesized) break;
        if (index >= parser.tokens.len) return false;

        const text = parser.tokens[index].text(parser.source);

        if (std.mem.eql(u8, text, ",")) index += 1 else if (!std.mem.eql(u8, text, ")")) return false;
    }

    return index < parser.tokens.len and std.mem.eql(u8, parser.tokens[index].text(parser.source), "=>");
}

fn lambda(parser: *Parser) zx.Error!*const ast.Expression {
    const start = parser.current().span.start;
    const parenthesized = parser.take("(");
    var parameters: std.ArrayList(ast.Name) = .empty;

    if (parenthesized) {
        while (!parser.take(")")) {
            try parameters.append(parser.allocator, try parser.name());
            if (!parser.take(",") and !parser.at(")")) try parser.expect(",");
        }
    } else try parameters.append(parser.allocator, try parser.name());

    try parser.expect("=>");

    return parser.make(start, .{ .lambda = .{ .parameters = try parameters.toOwnedSlice(parser.allocator), .body = try parse(parser, 0) } });
}

fn isGenericMethod(name: []const u8) bool {
    for ([_][]const u8{ "queryOne", "queryMany", "insert", "update", "delete", "transaction" }) |method| {
        if (std.mem.eql(u8, name, method)) return true;
    }

    return false;
}
