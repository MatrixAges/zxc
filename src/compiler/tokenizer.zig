const std = @import("std");

const ast = @import("ast.zig");
const diagnostic = @import("diagnostic.zig");

const Allocator = std.mem.Allocator;
const Error = diagnostic.Error;
const Location = diagnostic.Location;
const Reporter = diagnostic.Reporter;
const Token = ast.Token;

pub fn tokenize(
    allocator: Allocator,
    source: []const u8,
    reporter: *Reporter,
) Error![]const Token {
    var tokenizer = Tokenizer{
        .allocator = allocator,
        .source = source,
        .reporter = reporter,
    };

    return tokenizer.run();
}

const Tokenizer = struct {
    allocator: Allocator,
    source: []const u8,
    reporter: *Reporter,
    offset: usize = 0,
    line: usize = 1,
    column: usize = 1,

    fn run(self: *Tokenizer) Error![]const Token {
        var tokens: std.ArrayList(Token) = .empty;

        while (!self.atEnd()) {
            try self.skipTrivia();
            if (self.atEnd()) break;

            const token_location = self.currentLocation();
            const current = self.peek(0);
            if (isIdentifierStart(current)) {
                try tokens.append(self.allocator, self.readIdentifier(token_location));
            } else if (isDigit(current)) {
                try tokens.append(self.allocator, self.readNumber(token_location));
            } else if (current == '"') {
                try tokens.append(self.allocator, try self.readString(token_location));
            } else {
                try tokens.append(self.allocator, try self.readSymbol(token_location));
            }
        }

        try tokens.append(self.allocator, .{
            .kind = .eof,
            .lexeme = "<eof>",
            .location = self.currentLocation(),
        });
        return tokens.toOwnedSlice(self.allocator);
    }

    fn skipTrivia(self: *Tokenizer) Error!void {
        while (!self.atEnd()) {
            if (isWhitespace(self.peek(0))) {
                _ = self.advance();
                continue;
            }

            if (self.peek(0) == '/' and self.peek(1) == '/') {
                while (!self.atEnd() and self.peek(0) != '\n') {
                    _ = self.advance();
                }
                continue;
            }

            if (self.peek(0) == '/' and self.peek(1) == '*') {
                const start = self.currentLocation();
                _ = self.advance();
                _ = self.advance();
                while (!self.atEnd() and !(self.peek(0) == '*' and self.peek(1) == '/')) {
                    _ = self.advance();
                }
                if (self.atEnd()) return self.reporter.fail(start, "unterminated block comment");
                _ = self.advance();
                _ = self.advance();
                continue;
            }

            break;
        }
    }

    fn readIdentifier(self: *Tokenizer, location: Location) Token {
        const start = self.offset;
        while (isIdentifierPart(self.peek(0))) _ = self.advance();
        const lexeme = self.source[start..self.offset];

        return .{
            .kind = if (isKeyword(lexeme)) .keyword else .identifier,
            .lexeme = lexeme,
            .location = location,
        };
    }

    fn readNumber(self: *Tokenizer, location: Location) Token {
        const start = self.offset;
        while (isDigit(self.peek(0)) or self.peek(0) == '_') _ = self.advance();

        if (self.peek(0) == '.' and isDigit(self.peek(1))) {
            _ = self.advance();
            while (isDigit(self.peek(0)) or self.peek(0) == '_') _ = self.advance();
        }

        return .{
            .kind = .number,
            .lexeme = self.source[start..self.offset],
            .location = location,
        };
    }

    fn readString(self: *Tokenizer, location: Location) Error!Token {
        const start = self.offset;
        _ = self.advance();

        while (!self.atEnd() and self.peek(0) != '"') {
            if (self.peek(0) == '\n') {
                return self.reporter.fail(location, "string literals cannot contain an unescaped newline");
            }
            if (self.peek(0) != '\\') {
                _ = self.advance();
                continue;
            }

            _ = self.advance();
            if (self.atEnd()) return self.reporter.fail(location, "unterminated string literal");
            const escaped = self.advance();
            if (escaped != '"' and escaped != '\\' and escaped != 'n' and escaped != 'r' and escaped != 't') {
                return self.reporter.fail(location, "unsupported string escape");
            }
        }

        if (self.atEnd()) return self.reporter.fail(location, "unterminated string literal");
        _ = self.advance();

        return .{
            .kind = .string,
            .lexeme = self.source[start..self.offset],
            .location = location,
        };
    }

    fn readSymbol(self: *Tokenizer, location: Location) Error!Token {
        const start = self.offset;
        if (self.startsWith("...")) {
            _ = self.advance();
            _ = self.advance();
            _ = self.advance();
        } else if (isDoubleSymbol(self.peek(0), self.peek(1))) {
            _ = self.advance();
            _ = self.advance();
        } else if (isSingleSymbol(self.peek(0))) {
            _ = self.advance();
        } else {
            return self.reporter.fail(location, "unexpected character");
        }

        return .{
            .kind = .symbol,
            .lexeme = self.source[start..self.offset],
            .location = location,
        };
    }

    fn advance(self: *Tokenizer) u8 {
        const value = self.peek(0);
        if (self.atEnd()) return 0;

        self.offset += 1;
        if (value == '\n') {
            self.line += 1;
            self.column = 1;
        } else {
            self.column += 1;
        }
        return value;
    }

    fn peek(self: *const Tokenizer, distance: usize) u8 {
        const index = self.offset + distance;
        return if (index < self.source.len) self.source[index] else 0;
    }

    fn startsWith(self: *const Tokenizer, value: []const u8) bool {
        return self.offset + value.len <= self.source.len and
            std.mem.eql(u8, self.source[self.offset .. self.offset + value.len], value);
    }

    fn atEnd(self: *const Tokenizer) bool {
        return self.offset >= self.source.len;
    }

    fn currentLocation(self: *const Tokenizer) Location {
        return .{
            .offset = self.offset,
            .line = self.line,
            .column = self.column,
        };
    }
};

fn isKeyword(value: []const u8) bool {
    const keywords = [_][]const u8{
        "case",   "const",  "default",  "else", "enum",
        "export", "false",  "function", "if",   "import",
        "null",   "return", "switch",   "true", "type",
    };
    for (keywords) |keyword| {
        if (std.mem.eql(u8, value, keyword)) return true;
    }
    return false;
}

fn isDoubleSymbol(first: u8, second: u8) bool {
    return (first == '&' and second == '&') or
        (first == '|' and second == '|') or
        (first == '=' and second == '=') or
        (first == '!' and second == '=') or
        (first == '<' and second == '=') or
        (first == '>' and second == '=') or
        (first == '?' and second == '?') or
        (first == '=' and second == '>');
}

fn isSingleSymbol(value: u8) bool {
    return switch (value) {
        '{', '}', '(', ')', '[', ']', ':', ';', ',', '.', '?', '+', '-', '*', '/', '%', '!', '<', '>', '=' => true,
        else => false,
    };
}

fn isWhitespace(value: u8) bool {
    return value == ' ' or value == '\t' or value == '\r' or value == '\n';
}

fn isIdentifierStart(value: u8) bool {
    return (value >= 'A' and value <= 'Z') or
        (value >= 'a' and value <= 'z') or
        value == '_';
}

fn isIdentifierPart(value: u8) bool {
    return isIdentifierStart(value) or isDigit(value);
}

fn isDigit(value: u8) bool {
    return value >= '0' and value <= '9';
}
