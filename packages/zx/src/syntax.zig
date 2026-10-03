const std = @import("std");
const Span = @import("source.zig").Span;
pub const ContractKind = enum { requires, ensures };

pub const Token = struct {
    kind: enum { identifier, keyword, number, string, template, punctuation, eof },
    span: Span,
    pub fn text(self: Token, source: []const u8) []const u8 {
        return source[self.span.start..self.span.end];
    }
};

pub const Lexed = struct {
    tokens: []const Token,
    comments: []const Span,
};

pub fn isKeyword(name: []const u8) bool {
    const keywords = [_][]const u8{
        "export", "type", "default", "function", "const", "if",     "else",
        "return", "true", "false",   "import",   "enum",  "switch", "null",
        "let",    "var",  "for",     "while",    "new",   "throw",  "async",
        "await",  "case", "break",   "match",
    };

    for (keywords) |keyword| {
        if (std.mem.eql(u8, name, keyword)) return true;
    }

    return false;
}

pub const Operator = enum {
    coalesce,
    add,
    subtract,
    multiply,
    divide,
    remainder,
    equal,
    not_equal,
    less,
    less_equal,
    greater,
    greater_equal,
    logical_and,
    logical_or,
    pub fn parse(text: []const u8) ?Operator {
        for (operators) |rule| {
            if (std.mem.eql(u8, text, rule.spelling)) return rule.operator;
        }

        return null;
    }
    pub fn precedence(self: Operator) u8 {
        for (operators) |rule| {
            if (rule.operator == self) return rule.precedence;
        }

        unreachable;
    }
};

pub const OperatorRule = struct { operator: Operator, spelling: []const u8, precedence: u8 };

pub const operators = [_]OperatorRule{
    .{ .operator = .coalesce, .spelling = "??", .precedence = 1 },
    .{ .operator = .logical_or, .spelling = "||", .precedence = 2 },
    .{ .operator = .logical_and, .spelling = "&&", .precedence = 3 },
    .{ .operator = .equal, .spelling = "==", .precedence = 4 },
    .{ .operator = .not_equal, .spelling = "!=", .precedence = 4 },
    .{ .operator = .less, .spelling = "<", .precedence = 5 },
    .{ .operator = .less_equal, .spelling = "<=", .precedence = 5 },
    .{ .operator = .greater, .spelling = ">", .precedence = 5 },
    .{ .operator = .greater_equal, .spelling = ">=", .precedence = 5 },
    .{ .operator = .add, .spelling = "+", .precedence = 6 },
    .{ .operator = .subtract, .spelling = "-", .precedence = 6 },
    .{ .operator = .multiply, .spelling = "*", .precedence = 7 },
    .{ .operator = .divide, .spelling = "/", .precedence = 7 },
    .{ .operator = .remainder, .spelling = "%", .precedence = 7 },
};

comptime {
    for (std.enums.values(Operator)) |operator| {
        var count: usize = 0;

        for (operators) |rule| {
            if (rule.operator == operator) count += 1;
        }

        if (count != 1) @compileError("every operator must have exactly one grammar rule");
    }

    for (operators, 0..) |rule, index| {
        for (operators[0..index]) |previous| {
            if (std.mem.eql(u8, previous.spelling, rule.spelling)) @compileError("operator spellings must be unique");
        }
    }
}
