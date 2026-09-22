const std = @import("std");
const zx = @import("zx");
const ast = zx.ast;
const Self = @This();

allocator: std.mem.Allocator,
source: []const u8,
tokens: []const zx.syntax.Token,
reporter: *zx.Reporter,
index: usize = 0,
depth: usize = 0,
pub fn current(self: *const Self) zx.syntax.Token {
    return self.tokens[self.index];
}

pub fn at(self: *const Self, text: []const u8) bool {
    return std.mem.eql(u8, self.current().text(self.source), text);
}

pub fn take(self: *Self, text: []const u8) bool {
    if (!self.at(text)) return false;

    self.index += 1;

    return true;
}

pub fn expect(self: *Self, text: []const u8) zx.Error!void {
    if (!self.take(text)) return self.reporter.fail(.syntax, self.current().span, text);
}

pub fn name(self: *Self) zx.Error!ast.Name {
    const token = self.current();

    if (token.kind != .identifier) return self.reporter.fail(.syntax, token.span, "expected an identifier");

    self.index += 1;

    return .{ .text = token.text(self.source), .span = token.span };
}

pub fn enter(self: *Self) zx.Error!void {
    if (self.depth >= 256) return self.reporter.fail(.unsupported, self.current().span, "syntax nesting exceeds 256 levels");

    self.depth += 1;
}

pub fn program(self: *Self) zx.Error!ast.Program {
    return @import("parser_top.zig").parse(self);
}

pub fn typeNode(self: *Self) zx.Error!*const ast.Type {
    return @import("parser_types.zig").parse(self);
}

pub fn statement(self: *Self) zx.Error!ast.Statement {
    return @import("parser_statements.zig").parse(self);
}

pub fn expression(self: *Self, minimum: u8) zx.Error!*const ast.Expression {
    return @import("parser_expressions.zig").parse(self, minimum);
}

pub fn block(self: *Self) zx.Error!ast.Block {
    try self.enter();

    defer self.depth -= 1;
    const start = self.current().span.start;

    try self.expect("{");

    var statements: std.ArrayList(ast.Statement) = .empty;

    while (!self.take("}")) try statements.append(self.allocator, try self.statement());

    return .{ .span = self.range(start), .statements = try statements.toOwnedSlice(self.allocator) };
}

pub fn range(self: *const Self, start: usize) zx.Span {
    return .{ .start = start, .end = self.tokens[self.index - 1].span.end };
}

pub fn make(self: *Self, start: usize, value: @FieldType(ast.Expression, "value")) zx.Error!*const ast.Expression {
    var child_depth: u16 = 0;

    switch (value) {
        .field => |field| child_depth = field.target.depth,
        .index => |item| child_depth = @max(item.target.depth, item.index.depth),
        .unary => |unary| child_depth = unary.operand.depth,
        .binary => |binary| child_depth = @max(binary.left.depth, binary.right.depth),
        .conditional => |conditional| child_depth = @max(conditional.condition.depth, conditional.yes.depth, conditional.no.depth),
        .object => |fields| for (fields) |field| {
            child_depth = @max(child_depth, field.value.depth);
        },
        .list => |items| for (items) |item| {
            child_depth = @max(child_depth, item.depth);
        },
        .call => |call| {
            child_depth = call.callee.depth;

            for (call.arguments) |argument| child_depth = @max(child_depth, argument.depth);
        },
        .lambda => |lambda| child_depth = lambda.body.depth,
        .template => |parts| for (parts) |part| {
            if (part == .expression) child_depth = @max(child_depth, part.expression.depth);
        },
        else => {},
    }

    if (child_depth >= 256) return self.reporter.fail(.unsupported, self.range(start), "expression nesting exceeds 256 levels");

    const result = try self.allocator.create(ast.Expression);

    result.* = .{ .span = self.range(start), .depth = child_depth + 1, .value = value };

    return result;
}
