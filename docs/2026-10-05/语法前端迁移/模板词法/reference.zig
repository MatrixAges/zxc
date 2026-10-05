const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");
const template = lexer.template;
const generated = @import("generated");
const Part = struct { kind: enum { Text, Expression }, span: zx.Span };
const Template = struct { span: zx.Span, parts: []const Part };
const Diagnostic = struct { code: []const u8 = "", start: usize = 0, end: usize = 0, message: []const u8 = "" };
const Lexed = struct { tokens: []const zx.syntax.Token = &.{}, comments: []const zx.Span = &.{}, diagnostic: Diagnostic = .{} };
const Interpolation = struct { span: zx.Span, lexed: Lexed };

const Collector = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    templates: std.ArrayList(Template) = .empty,
    interpolations: std.ArrayList(Interpolation) = .empty,
    fn lex(self: *Collector, span: zx.Span) !Lexed {
        var reporter = zx.Reporter{};

        const result = lexer.lex(self.allocator, self.source[span.start..span.end], &reporter) catch |err| {
            const issue = reporter.diagnostic orelse return err;

            return .{ .diagnostic = .{ .code = @tagName(issue.code), .start = issue.span.start + span.start, .end = issue.span.end + span.start, .message = issue.message } };
        };

        const tokens = try self.allocator.dupe(zx.syntax.Token, result.tokens);
        const comments = try self.allocator.dupe(zx.Span, result.comments);

        for (tokens) |*token| {
            token.span.start += span.start;
            token.span.end += span.start;
        }

        for (comments) |*comment| {
            comment.start += span.start;
            comment.end += span.start;
        }

        return .{ .tokens = tokens, .comments = comments };
    }
    fn collect(self: *Collector, start: usize) anyerror!usize {
        var reporter = zx.Reporter{};
        const end = try template.end(self.source, start, &reporter, 0);
        var parts: std.ArrayList(Part) = .empty;
        var offset = start + 1;
        var text_start = offset;

        while (offset < end - 1) {
            if (self.source[offset] == '\\') {
                offset += 2;

                continue;
            }

            if (!std.mem.startsWith(u8, self.source[offset..], "${")) {
                offset += 1;

                continue;
            }

            try parts.append(self.allocator, .{ .kind = .Text, .span = .{ .start = text_start, .end = offset } });

            const body_start = offset + 2;
            const body_end = try template.interpolationEnd(self.source, body_start, &reporter, 0);
            var nested = body_start;

            while (nested < body_end) {
                if (self.source[nested] == '`') {
                    nested = try self.collect(nested);

                    continue;
                }

                if (self.source[nested] == '"') {
                    nested += 1;

                    while (nested < body_end and self.source[nested] != '"') : (nested += 1) {
                        if (self.source[nested] == '\\' and nested + 1 < body_end) nested += 1;
                    }
                } else if (std.mem.startsWith(u8, self.source[nested..], "//")) {
                    while (nested < body_end and self.source[nested] != '\n' and self.source[nested] != '\r') : (nested += 1) {}
                } else if (std.mem.startsWith(u8, self.source[nested..], "/*")) {
                    nested += (std.mem.indexOf(u8, self.source[nested + 2 ..], "*/") orelse unreachable) + 3;
                }

                nested += 1;
            }

            const span = zx.Span{ .start = body_start, .end = body_end };

            try self.interpolations.append(self.allocator, .{ .span = span, .lexed = try self.lex(span) });
            try parts.append(self.allocator, .{ .kind = .Expression, .span = span });

            offset = body_end + 1;
            text_start = offset;
        }

        try parts.append(self.allocator, .{ .kind = .Text, .span = .{ .start = text_start, .end = end - 1 } });
        try self.templates.append(self.allocator, .{ .span = .{ .start = start, .end = end }, .parts = try parts.toOwnedSlice(self.allocator) });

        return end;
    }
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var collector = Collector{ .allocator = allocator, .source = source };
    const lexed = try collector.lex(.{ .start = 0, .end = source.len });

    for (lexed.tokens) |token| {
        if (token.kind == .template) _ = try collector.collect(token.span.start);
    }

    const actual = try generated.execute(init.arena, source);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .expected = .{ .lexed = lexed, .templates = collector.templates.items, .interpolations = collector.interpolations.items }, .actual = actual }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
