const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");

pub fn end(source: []const u8, start: usize, reporter: *zx.Reporter, depth: usize) zx.Error!usize {
    if (depth > 256) return reporter.fail(.syntax, .{ .start = start, .end = start + 1 }, "template nesting exceeds 256 levels");

    var offset = start + 1;

    while (offset < source.len) {
        if (source[offset] == '`') return offset + 1;

        if (source[offset] == '\\') {
            if (offset + 1 < source.len and std.mem.indexOfScalar(u8, "\"\\nrt`$", source[offset + 1]) == null) return reporter.fail(.lexical, .{ .start = offset, .end = offset + 2 }, "unsupported template escape");

            offset += @min(@as(usize, 2), source.len - offset);
        } else if (std.mem.startsWith(u8, source[offset..], "${")) {
            offset = try interpolationEnd(source, offset + 2, reporter, depth + 1) + 1;
        } else offset += 1;
    }

    return reporter.fail(.lexical, .{ .start = start, .end = source.len }, "unterminated template string");
}

pub fn interpolationEnd(source: []const u8, start: usize, reporter: *zx.Reporter, depth: usize) zx.Error!usize {
    var braces: usize = 0;
    var offset = start;

    while (offset < source.len) {
        const byte = source[offset];

        if (byte == '}' and braces == 0) return offset;
        if (byte == '{') braces += 1;
        if (byte == '}') braces -= 1;

        if (byte == '`') {
            offset = try end(source, offset, reporter, depth + 1);

            continue;
        }

        if (byte == '"') {
            offset += 1;

            while (offset < source.len and source[offset] != '"') : (offset += 1) {
                if (source[offset] == '\\' and offset + 1 < source.len) offset += 1;
            }
        } else if (std.mem.startsWith(u8, source[offset..], "//")) {
            while (offset < source.len and source[offset] != '\n' and source[offset] != '\r') : (offset += 1) {}
        } else if (std.mem.startsWith(u8, source[offset..], "/*")) {
            const relative = std.mem.indexOf(u8, source[offset + 2 ..], "*/") orelse return reporter.fail(.lexical, .{ .start = offset, .end = source.len }, "unterminated comment in template");

            offset += relative + 3;
        }

        if (offset < source.len) offset += 1;
    }

    return reporter.fail(.lexical, .{ .start = start, .end = source.len }, "unterminated template interpolation");
}

pub fn parse(parser: *Parser, token: zx.syntax.Token) zx.Error![]const zx.ast.TemplatePart {
    var parts: std.ArrayList(zx.ast.TemplatePart) = .empty;
    var offset = token.span.start + 1;
    var text_start = offset;

    while (offset < token.span.end - 1) {
        if (parser.source[offset] == '\\') {
            offset += 2;

            continue;
        }

        if (!std.mem.startsWith(u8, parser.source[offset..], "${")) {
            offset += 1;

            continue;
        }

        try parts.append(parser.allocator, .{ .text = parser.source[text_start..offset] });

        const start = offset + 2;
        const finish = try interpolationEnd(parser.source, start, parser.reporter, 0);

        const lexed = @import("lex.zig").lex(parser.allocator, parser.source[start..finish], parser.reporter) catch |err| {
            if (parser.reporter.diagnostic) |*issue| {
                issue.span.start += start;
                issue.span.end += start;
            }

            return err;
        };

        const tokens = try parser.allocator.dupe(zx.syntax.Token, lexed.tokens);

        for (tokens) |*item| {
            item.span.start += start;
            item.span.end += start;
        }

        var nested = Parser{ .allocator = parser.allocator, .source = parser.source, .tokens = tokens, .reporter = parser.reporter, .depth = parser.depth + 1 };
        const expression = try nested.expression(0);

        if (nested.current().kind != .eof) return parser.reporter.fail(.syntax, nested.current().span, "expected end of template interpolation");
        try parts.append(parser.allocator, .{ .expression = expression });

        offset = finish + 1;
        text_start = offset;
    }

    try parts.append(parser.allocator, .{ .text = parser.source[text_start .. token.span.end - 1] });

    return parts.toOwnedSlice(parser.allocator);
}
