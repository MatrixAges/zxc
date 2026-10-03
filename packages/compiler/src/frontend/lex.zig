const std = @import("std");
const zx = @import("zx");
const Token = zx.syntax.Token;

pub fn lex(allocator: std.mem.Allocator, source: []const u8, reporter: *zx.Reporter) zx.Error!zx.syntax.Lexed {
    if (!std.unicode.utf8ValidateSlice(source)) return reporter.fail(.lexical, .{ .start = 0, .end = source.len }, "source must be valid UTF-8");

    var tokens: std.ArrayList(Token) = .empty;
    var comments: std.ArrayList(zx.Span) = .empty;
    var offset: usize = 0;

    while (offset < source.len) {
        const start = offset;
        const byte = source[offset];

        if (std.ascii.isWhitespace(byte)) {
            offset += 1;

            continue;
        }

        if (std.mem.startsWith(u8, source[offset..], "//")) {
            while (offset < source.len and source[offset] != '\n' and source[offset] != '\r') : (offset += 1) {}
            try comments.append(allocator, .{ .start = start, .end = offset });

            continue;
        }

        if (std.mem.startsWith(u8, source[offset..], "/*")) {
            const relative_end = std.mem.indexOf(u8, source[offset + 2 ..], "*/") orelse
                return reporter.fail(.lexical, .{ .start = start, .end = source.len }, "unterminated block comment");

            offset += relative_end + 4;

            try comments.append(allocator, .{ .start = start, .end = offset });

            continue;
        }

        var kind: @FieldType(Token, "kind") = .punctuation;

        if (std.ascii.isAlphabetic(byte) or byte == '_' or byte == '$') {
            offset += 1;

            while (offset < source.len and (std.ascii.isAlphanumeric(source[offset]) or source[offset] == '_')) : (offset += 1) {}

            kind = if (zx.syntax.isKeyword(source[start..offset])) .keyword else .identifier;
        } else if (std.ascii.isDigit(byte)) {
            offset += 1;

            while (offset < source.len and (std.ascii.isDigit(source[offset]) or source[offset] == '_')) : (offset += 1) {}

            if (offset + 1 < source.len and source[offset] == '.' and std.ascii.isDigit(source[offset + 1])) {
                offset += 1;

                while (offset < source.len and (std.ascii.isDigit(source[offset]) or source[offset] == '_')) : (offset += 1) {}
            }

            if (offset < source.len and (source[offset] == 'e' or source[offset] == 'E')) {
                offset += 1;

                if (offset < source.len and (source[offset] == '+' or source[offset] == '-')) offset += 1;

                while (offset < source.len and (std.ascii.isDigit(source[offset]) or source[offset] == '_')) : (offset += 1) {}
            }

            const text = source[start..offset];
            const span = zx.Span{ .start = start, .end = offset };

            for (text, 0..) |digit, index| {
                if (digit == '_' and (index == 0 or index + 1 == text.len or !std.ascii.isDigit(text[index - 1]) or !std.ascii.isDigit(text[index + 1]))) {
                    return reporter.fail(.lexical, span, "digit separators must occur between digits");
                }
            }

            if (!std.ascii.isDigit(text[text.len - 1])) {
                return reporter.fail(.lexical, span, "an exponent requires at least one digit");
            }

            kind = .number;
        } else if (byte == '`') {
            offset = try @import("template.zig").end(source, start, reporter, 0);
            kind = .template;
        } else if (byte == '"') {
            offset += 1;

            while (offset < source.len and source[offset] != '"') : (offset += 1) {
                if (source[offset] < 32) return reporter.fail(.lexical, .{ .start = start, .end = offset + 1 }, "control characters must be escaped in strings");

                if (source[offset] == '\\') {
                    offset += 1;

                    if (offset == source.len) break;

                    if (std.mem.indexOfScalar(u8, "\"\\nrt", source[offset]) == null) {
                        return reporter.fail(.lexical, .{ .start = offset - 1, .end = offset + 1 }, "unsupported string escape");
                    }
                }
            }

            if (offset == source.len) return reporter.fail(.lexical, .{ .start = start, .end = offset }, "unterminated string");

            offset += 1;
            kind = .string;
        } else {
            if (std.mem.indexOfScalar(u8, "{}():;,.?[]+-*/%<>=!&|", byte) == null) {
                return reporter.fail(.lexical, .{ .start = start, .end = start + 1 }, "unexpected character");
            }

            if (std.mem.startsWith(u8, source[offset..], "...")) {
                offset += 3;
            } else if (std.mem.startsWith(u8, source[offset..], "=>")) {
                offset += 2;
            } else {
                offset += 1;

                if (offset < source.len and zx.syntax.Operator.parse(source[start .. offset + 1]) != null) offset += 1;
            }
        }

        try tokens.append(allocator, .{ .kind = kind, .span = .{ .start = start, .end = offset } });
    }

    try tokens.append(allocator, .{ .kind = .eof, .span = .{ .start = source.len, .end = source.len } });

    return .{ .tokens = try tokens.toOwnedSlice(allocator), .comments = try comments.toOwnedSlice(allocator) };
}
