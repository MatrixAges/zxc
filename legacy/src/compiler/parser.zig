const std = @import("std");
const ast = @import("ast.zig");
const diagnostic = @import("diagnostic.zig");
const Allocator = std.mem.Allocator;
const Error = diagnostic.Error;
const Location = diagnostic.Location;
const Reporter = diagnostic.Reporter;
const Token = ast.Token;

pub fn parse(
    allocator: Allocator,
    tokens: []const Token,
    reporter: *Reporter,
) Error!ast.Program {
    var parser = Parser{
        .allocator = allocator,
        .tokens = tokens,
        .reporter = reporter,
    };

    return parser.parseProgram();
}

const Parser = struct {
    allocator: Allocator,
    tokens: []const Token,
    reporter: *Reporter,
    index: usize = 0,
    fn parseProgram(self: *Parser) Error!ast.Program {
        var declarations: std.ArrayList(ast.Declaration) = .empty;
        var input_count: usize = 0;
        var output_count: usize = 0;

        if (self.check("import", 0)) {
            return self.reporter.fail(
                self.peek(0).location,
                "ZX cannot import RX files; cross-file imports are outside this MVP",
            );
        }

        while (self.check("export", 0) and !self.check("default", 1)) {
            const declaration = if (self.check("type", 1))
                ast.Declaration{ .type_decl = try self.parseTypeDeclaration() }

            else if (self.check("enum", 1))
                ast.Declaration{ .enum_decl = try self.parseEnumDeclaration() }
            else
                return self.reporter.fail(
                    self.peek(1).location,
                    "only exported type aliases and enums may precede the default function",
                );

            switch (declaration) {
                .type_decl => |value| {
                    if (std.mem.eql(u8, value.name, "Input")) input_count += 1;
                    if (std.mem.eql(u8, value.name, "Output")) output_count += 1;
                },
                .enum_decl => {},
            }

            try declarations.append(self.allocator, declaration);
        }

        if (input_count == 0) {
            return self.reporter.fail(self.peek(0).location, "missing `export type Input = ...;`");
        }

        if (input_count != 1) {
            return self.reporter.fail(self.peek(0).location, "Input must be declared exactly once");
        }

        if (output_count == 0) {
            return self.reporter.fail(self.peek(0).location, "missing `export type Output = ...;`");
        }

        if (output_count != 1) {
            return self.reporter.fail(self.peek(0).location, "Output must be declared exactly once");
        }

        const function_declaration = try self.parseFunctionDeclaration();

        _ = try self.consume("<eof>", "a .zx file may contain only one executable function");

        return .{
            .declarations = try declarations.toOwnedSlice(self.allocator),
            .function_declaration = function_declaration,
        };
    }
    fn parseTypeDeclaration(self: *Parser) Error!ast.TypeDeclaration {
        const location = (try self.consume("export", "expected `export`")).location;
        _ = try self.consume("type", "expected `type`");
        const name = try self.consumeIdentifier("expected a type name");
        _ = try self.consume("=", "expected `=` after the type name");
        const value_type = try self.parseType();
        _ = try self.consume(";", "expected `;` after the type declaration");

        return .{
            .name = name.lexeme,
            .value_type = value_type,
            .location = location,
        };
    }
    fn parseEnumDeclaration(self: *Parser) Error!ast.EnumDeclaration {
        const location = (try self.consume("export", "expected `export`")).location;
        _ = try self.consume("enum", "expected `enum`");
        const name = try self.consumeIdentifier("expected an enum name");
        _ = try self.consume("{", "expected `{` before enum members");
        var members: std.ArrayList(ast.NamedValue) = .empty;

        while (!self.check("}", 0)) {
            const member = try self.consumeIdentifier("expected an enum member");

            try members.append(self.allocator, .{
                .name = member.lexeme,
                .location = member.location,
            });

            if (!self.match(",")) break;
        }

        _ = try self.consume("}", "expected `}` after enum members");

        if (members.items.len == 0) {
            return self.reporter.fail(location, "an enum must contain at least one member");
        }

        return .{
            .name = name.lexeme,
            .members = try members.toOwnedSlice(self.allocator),
            .location = location,
        };
    }
    fn parseType(self: *Parser) Error!*const ast.TypeNode {
        const location = self.peek(0).location;
        var value_type: *const ast.TypeNode = undefined;

        if (self.match("{")) {
            var fields: std.ArrayList(ast.TypeField) = .empty;

            while (!self.check("}", 0)) {
                if (self.check("<eof>", 0)) {
                    return self.reporter.fail(location, "unterminated object type");
                }

                const field = try self.consumeIdentifier("expected an object field name");
                const is_optional = self.match("?");
                _ = try self.consume(":", "expected `:` after the field name");

                var field_type = try self.parseType();

                if (is_optional) {
                    field_type = try self.createType(.{ .optional = field_type });
                }

                try fields.append(self.allocator, .{
                    .name = field.lexeme,
                    .value_type = field_type,
                    .location = field.location,
                });

                if (!self.match(";") and !self.match(",")) {
                    return self.reporter.fail(
                        self.peek(0).location,
                        "expected `;` or `,` after an object field",
                    );
                }
            }

            _ = try self.consume("}", "expected `}` after object fields");

            value_type = try self.createType(.{ .object = .{
                .fields = try fields.toOwnedSlice(self.allocator),
                .location = location,
            } });
        } else {
            const name = try self.consumeIdentifier("expected a type");

            value_type = try self.createType(.{ .named = .{
                .name = name.lexeme,
                .location = name.location,
            } });
        }

        while (true) {
            if (self.match("?")) {
                value_type = try self.createType(.{ .optional = value_type });

                continue;
            }

            if (self.match("[")) {
                _ = try self.consume("]", "list types use `T[]`");
                value_type = try self.createType(.{ .list = value_type });

                continue;
            }

            break;
        }

        return value_type;
    }
    fn parseFunctionDeclaration(self: *Parser) Error!ast.FunctionDeclaration {
        const location = (try self.consume("export", "expected the default function")).location;
        _ = try self.consume("default", "expected `default` after `export`");
        _ = try self.consume("function", "expected `function` after `export default`");

        if (self.peek(0).kind == .identifier) {
            return self.reporter.fail(
                self.peek(0).location,
                "the default .zx function must be anonymous",
            );
        }

        _ = try self.consume("(", "expected `(` before function parameters");

        const input_name = try self.consumeIdentifier("expected the parameter name `in`");

        if (!std.mem.eql(u8, input_name.lexeme, "in")) {
            return self.reporter.fail(
                input_name.location,
                "the business input parameter must be named `in`",
            );
        }

        _ = try self.consume(":", "expected `:` after `in`");
        _ = try self.consume("Input", "the business parameter type must be Input");

        if (self.match(",")) {
            return self.reporter.fail(
                self.previous().location,
                "runtime values must enter through Input; extra function parameters are outside this MVP",
            );
        }

        _ = try self.consume(")", "expected `)` after function parameters");
        _ = try self.consume(":", "expected `:` before the function return type");
        _ = try self.consume("Output", "the function return type must be Output");

        return .{
            .body = try self.parseBlock(),
            .location = location,
        };
    }
    fn parseBlock(self: *Parser) Error![]const ast.Statement {
        _ = try self.consume("{", "expected `{` before a statement block");

        var statements: std.ArrayList(ast.Statement) = .empty;

        while (!self.check("}", 0)) {
            if (self.check("<eof>", 0)) {
                return self.reporter.fail(self.peek(0).location, "unterminated statement block");
            }

            try statements.append(self.allocator, try self.parseStatement());
        }

        _ = try self.consume("}", "expected `}` after a statement block");

        return statements.toOwnedSlice(self.allocator);
    }
    fn parseStatement(self: *Parser) Error!ast.Statement {
        if (self.check("const", 0)) return .{ .constant = try self.parseConstStatement() };
        if (self.check("if", 0)) return .{ .if_stmt = try self.parseIfStatement() };
        if (self.check("switch", 0)) return .{ .switch_stmt = try self.parseSwitchStatement() };
        if (self.check("return", 0)) return .{ .return_stmt = try self.parseReturnStatement() };

        return self.reporter.fail(
            self.peek(0).location,
            "the MVP supports only const, if, switch, and return statements",
        );
    }
    fn parseConstStatement(self: *Parser) Error!ast.ConstStatement {
        const location = (try self.consume("const", "expected `const`")).location;
        const name = try self.consumeIdentifier("expected a const name");
        _ = try self.consume("=", "expected `=` in const declaration");
        const initializer = try self.parseExpression();

        _ = try self.consume(";", "expected `;` after const declaration");

        return .{
            .name = name.lexeme,
            .initializer = initializer,
            .location = location,
        };
    }
    fn parseIfStatement(self: *Parser) Error!ast.IfStatement {
        const location = (try self.consume("if", "expected `if`")).location;
        _ = try self.consume("(", "expected `(` after `if`");
        const condition = try self.parseExpression();
        _ = try self.consume(")", "expected `)` after the if condition");
        const then_body = try self.parseBlock();
        var else_body: ?[]const ast.Statement = null;

        if (self.match("else")) {
            if (self.check("if", 0)) {
                const nested = try self.parseIfStatement();
                const statements = try self.allocator.alloc(ast.Statement, 1);
                statements[0] = .{ .if_stmt = nested };
                else_body = statements;
            } else {
                else_body = try self.parseBlock();
            }
        }

        return .{
            .condition = condition,
            .then_body = then_body,
            .else_body = else_body,
            .location = location,
        };
    }

    fn parseSwitchStatement(self: *Parser) Error!ast.SwitchStatement {
        const location = (try self.consume("switch", "expected `switch`")).location;
        _ = try self.consume("(", "expected `(` after `switch`");
        const subject = try self.parseExpression();
        _ = try self.consume(")", "expected `)` after the switch subject");
        _ = try self.consume("{", "expected `{` before switch cases");
        var cases: std.ArrayList(ast.SwitchCase) = .empty;
        var has_default = false;

        while (!self.check("}", 0)) {
            const case_location = self.peek(0).location;
            var value: ?*const ast.Expression = null;

            if (self.match("case")) {
                value = try self.parseExpression();
            } else if (self.match("default")) {
                if (has_default) {
                    return self.reporter.fail(case_location, "a switch may contain only one default case");
                }

                has_default = true;
            } else {
                return self.reporter.fail(self.peek(0).location, "expected `case` or `default` in switch");
            }

            _ = try self.consume(":", "expected `:` after switch case");

            var body: std.ArrayList(ast.Statement) = .empty;

            while (!self.check("case", 0) and !self.check("default", 0) and !self.check("}", 0)) {
                try body.append(self.allocator, try self.parseStatement());
            }

            try cases.append(self.allocator, .{
                .value = value,
                .body = try body.toOwnedSlice(self.allocator),
                .location = case_location,
            });
        }

        _ = try self.consume("}", "expected `}` after switch cases");

        if (cases.items.len == 0) {
            return self.reporter.fail(location, "a switch must contain at least one case");
        }

        return .{
            .subject = subject,
            .cases = try cases.toOwnedSlice(self.allocator),
            .location = location,
        };
    }
    fn parseReturnStatement(self: *Parser) Error!ast.ReturnStatement {
        const location = (try self.consume("return", "expected `return`")).location;
        const value = if (self.check(";", 0)) null else try self.parseExpression();

        _ = try self.consume(";", "expected `;` after return");

        return .{
            .value = value,
            .location = location,
        };
    }
    fn parseExpression(self: *Parser) Error!*const ast.Expression {
        const condition = try self.parseBinaryExpression(1);

        if (!self.match("?")) return condition;

        const when_true = try self.parseExpression();

        _ = try self.consume(":", "expected `:` in ternary expression");
        const when_false = try self.parseExpression();

        return self.createExpression(.{ .ternary = .{
            .condition = condition,
            .when_true = when_true,
            .when_false = when_false,
            .location = condition.location(),
        } });
    }
    fn parseBinaryExpression(self: *Parser, minimum_precedence: u8) Error!*const ast.Expression {
        var left = try self.parseUnaryExpression();

        while (true) {
            const operator = self.peek(0);
            const precedence = binaryPrecedence(operator.lexeme);

            if (precedence == 0 or precedence < minimum_precedence) break;

            _ = self.advance();

            const right = try self.parseBinaryExpression(precedence + 1);

            left = try self.createExpression(.{ .binary = .{
                .operator = operator.lexeme,
                .left = left,
                .right = right,
                .location = left.location(),
            } });
        }

        return left;
    }
    fn parseUnaryExpression(self: *Parser) Error!*const ast.Expression {
        if (self.match("!") or self.match("-")) {
            const operator = self.previous();

            return self.createExpression(.{ .unary = .{
                .operator = operator.lexeme,
                .operand = try self.parseUnaryExpression(),
                .location = operator.location,
            } });
        }

        return self.parsePostfixExpression();
    }
    fn parsePostfixExpression(self: *Parser) Error!*const ast.Expression {
        var expression = try self.parsePrimaryExpression();

        while (true) {
            if (self.match(".")) {
                const property = try self.consumeIdentifier("expected a property name after `.`");

                expression = try self.createExpression(.{ .member = .{
                    .target = expression,
                    .property = property.lexeme,
                    .location = expression.location(),
                } });

                continue;
            }

            if (self.match("[")) {
                const index = try self.parseExpression();

                _ = try self.consume("]", "expected `]` after index expression");

                expression = try self.createExpression(.{ .index = .{
                    .target = expression,
                    .index = index,
                    .location = expression.location(),
                } });

                continue;
            }

            if (self.match("(")) {
                var arguments: std.ArrayList(*const ast.Expression) = .empty;

                while (!self.check(")", 0)) {
                    try arguments.append(self.allocator, try self.parseExpression());
                    if (!self.match(",")) break;
                }

                _ = try self.consume(")", "expected `)` after call arguments");

                expression = try self.createExpression(.{ .call = .{
                    .callee = expression,
                    .arguments = try arguments.toOwnedSlice(self.allocator),
                    .location = expression.location(),
                } });

                continue;
            }

            break;
        }

        return expression;
    }
    fn parsePrimaryExpression(self: *Parser) Error!*const ast.Expression {
        const token = self.peek(0);

        if (token.kind == .number) {
            _ = self.advance();

            return self.createExpression(.{ .literal = .{
                .kind = .number,
                .source = token.lexeme,
                .location = token.location,
            } });
        }

        if (token.kind == .string) {
            _ = self.advance();

            return self.createExpression(.{ .literal = .{
                .kind = .string,
                .source = token.lexeme,
                .location = token.location,
            } });
        }

        if (self.match("true") or self.match("false")) {
            const value = self.previous();

            return self.createExpression(.{ .literal = .{
                .kind = .boolean,
                .source = value.lexeme,
                .location = value.location,
            } });
        }

        if (self.match("null")) {
            return self.createExpression(.{ .literal = .{
                .kind = .null,
                .source = "null",
                .location = token.location,
            } });
        }

        if (token.kind == .identifier) {
            _ = self.advance();

            return self.createExpression(.{ .identifier = .{
                .name = token.lexeme,
                .location = token.location,
            } });
        }

        if (self.match("(")) {
            const expression = try self.parseExpression();

            _ = try self.consume(")", "expected `)` after the expression");

            return expression;
        }

        if (self.match("{")) return self.parseObjectExpression(token.location);
        if (self.match("[")) return self.parseListExpression(token.location);

        if (self.check("...", 0)) {
            return self.reporter.fail(token.location, "spread syntax is not implemented in the MVP compiler");
        }

        return self.reporter.fail(token.location, "expected an expression");
    }
    fn parseObjectExpression(self: *Parser, location: Location) Error!*const ast.Expression {
        var fields: std.ArrayList(ast.ObjectField) = .empty;

        while (!self.check("}", 0)) {
            if (self.check("...", 0)) {
                return self.reporter.fail(
                    self.peek(0).location,
                    "object spread is not implemented in the MVP compiler",
                );
            }

            const name = try self.consumeIdentifier("expected an object field name");

            _ = try self.consume(":", "expected `:` after an object field name");

            try fields.append(self.allocator, .{
                .name = name.lexeme,
                .value = try self.parseExpression(),
                .location = name.location,
            });

            if (!self.match(",")) break;
        }

        _ = try self.consume("}", "expected `}` after object fields");

        return self.createExpression(.{ .object = .{
            .fields = try fields.toOwnedSlice(self.allocator),
            .location = location,
        } });
    }
    fn parseListExpression(self: *Parser, location: Location) Error!*const ast.Expression {
        var items: std.ArrayList(*const ast.Expression) = .empty;

        while (!self.check("]", 0)) {
            try items.append(self.allocator, try self.parseExpression());
            if (!self.match(",")) break;
        }

        _ = try self.consume("]", "expected `]` after list items");

        return self.createExpression(.{ .list = .{
            .items = try items.toOwnedSlice(self.allocator),
            .location = location,
        } });
    }
    fn createType(self: *Parser, value: ast.TypeNode) Error!*const ast.TypeNode {
        const node = try self.allocator.create(ast.TypeNode);

        node.* = value;

        return node;
    }
    fn createExpression(self: *Parser, value: ast.Expression) Error!*const ast.Expression {
        const expression = try self.allocator.create(ast.Expression);

        expression.* = value;

        return expression;
    }
    fn consumeIdentifier(self: *Parser, message: []const u8) Error!Token {
        if (self.peek(0).kind == .identifier) return self.advance();

        return self.reporter.fail(self.peek(0).location, message);
    }
    fn consume(self: *Parser, value: []const u8, message: []const u8) Error!Token {
        if (self.check(value, 0)) return self.advance();

        return self.reporter.fail(self.peek(0).location, message);
    }
    fn match(self: *Parser, value: []const u8) bool {
        if (!self.check(value, 0)) return false;

        _ = self.advance();

        return true;
    }
    fn check(self: *const Parser, value: []const u8, distance: usize) bool {
        return std.mem.eql(u8, self.peek(distance).lexeme, value);
    }
    fn advance(self: *Parser) Token {
        const token = self.peek(0);

        if (token.kind != .eof) self.index += 1;

        return token;
    }
    fn previous(self: *const Parser) Token {
        return self.tokens[self.index - 1];
    }
    fn peek(self: *const Parser, distance: usize) Token {
        const target = @min(self.index + distance, self.tokens.len - 1);

        return self.tokens[target];
    }
};

fn binaryPrecedence(operator: []const u8) u8 {
    if (std.mem.eql(u8, operator, "??")) return 1;
    if (std.mem.eql(u8, operator, "||")) return 2;
    if (std.mem.eql(u8, operator, "&&")) return 3;
    if (std.mem.eql(u8, operator, "==") or std.mem.eql(u8, operator, "!=")) return 4;

    if (std.mem.eql(u8, operator, "<") or
        std.mem.eql(u8, operator, "<=") or
        std.mem.eql(u8, operator, ">") or
        std.mem.eql(u8, operator, ">=")) return 5;

    if (std.mem.eql(u8, operator, "+") or std.mem.eql(u8, operator, "-")) return 6;

    if (std.mem.eql(u8, operator, "*") or
        std.mem.eql(u8, operator, "/") or
        std.mem.eql(u8, operator, "%")) return 7;

    return 0;
}
