const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Token = @import("root.zig").Token;

pub const Projection = struct {
    source: []const u8,
    tokens: []Token,
    pub fn init(allocator: std.mem.Allocator, source: []const u8, tokens: anytype, comments: anytype) std.mem.Allocator.Error!Projection {
        var result: std.ArrayList(Token) = .empty;
        var token_index: usize = 0;
        var comment_index: usize = 0;
        var previous: usize = 0;

        while (token_index < tokens.len or comment_index < comments.len) {
            const comment = comment_index < comments.len and (token_index == tokens.len or zx.syntax.header.span(syntax.item(comments, comment_index)).start < syntax.item(tokens, token_index).span.start);
            const span = if (comment) zx.syntax.header.span(syntax.item(comments, comment_index)) else zx.syntax.header.span(syntax.item(tokens, token_index).span);

            if (comment) comment_index += 1 else token_index += 1;
            if (span.start == span.end or span.start < previous) continue;

            const text = source[span.start..span.end];

            try result.append(allocator, .{
                .text = text,
                .start = span.start,
                .end = span.end,
                .gap = @intFromBool(span.start > previous),
                .object = !comment and std.mem.eql(u8, text, "{"),
                .comment = comment,
                .newline = std.mem.indexOfScalar(u8, source[previous..span.start], '\n') != null,
            });

            previous = span.end;
        }

        return .{ .source = source, .tokens = try result.toOwnedSlice(allocator) };
    }
    pub fn excludeStart(self: *Projection, offset: usize, block: bool) void {
        const index = self.find(offset) orelse return;
        const token = &self.tokens[index];

        if (!std.mem.eql(u8, token.text, "{")) return;

        token.object = false;
        token.block = block;
    }
    pub fn excludeEnding(self: *Projection, end: usize, block: bool) void {
        var first: usize = 0;
        var limit = self.tokens.len;

        while (first < limit) {
            const middle = first + (limit - first) / 2;

            if (self.tokens[middle].end <= end) first = middle + 1 else limit = middle;
        }

        if (first == 0) return;

        const closer = self.tokens[first - 1].text;
        const opener: []const u8 = if (std.mem.eql(u8, closer, "}")) "{" else if (std.mem.eql(u8, closer, "]")) "[" else return;
        var index = first;
        var depth: usize = 0;

        while (index != 0) {
            index -= 1;
            const token = &self.tokens[index];

            if (token.end > end) continue;
            if (std.mem.eql(u8, token.text, closer)) depth += 1;
            if (!std.mem.eql(u8, token.text, opener)) continue;
            if (depth == 0) return;

            depth -= 1;

            if (depth != 0) continue;

            token.object = false;
            token.block = block;

            return;
        }
    }

    pub fn boundary(self: *Projection, offset: usize) void {
        const index = self.find(offset) orelse return;

        self.tokens[index].boundary = true;
    }
    pub fn list(self: *Projection, start: usize, count: usize) void {
        if (count < 2) return;

        var index = self.find(start) orelse return;

        while (index < self.tokens.len and (self.tokens[index].comment or std.mem.eql(u8, self.tokens[index].text, "("))) : (index += 1) {}
        if (index < self.tokens.len and std.mem.eql(u8, self.tokens[index].text, "[")) self.tokens[index].multiline = true;
    }
    pub fn excludeRange(self: *Projection, span: zx.Span) void {
        self.boundary(span.start);

        var index = self.find(span.start) orelse return;

        while (index < self.tokens.len and self.tokens[index].end <= span.end) : (index += 1) {
            self.tokens[index].object = false;
        }
    }
    fn find(self: *const Projection, offset: usize) ?usize {
        var first: usize = 0;
        var end = self.tokens.len;

        while (first < end) {
            const middle = first + (end - first) / 2;

            if (self.tokens[middle].start < offset) first = middle + 1 else end = middle;
        }

        return if (first < self.tokens.len and self.tokens[first].start == offset) first else null;
    }
};
