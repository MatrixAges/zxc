const std = @import("std");
const zx = @import("zx");
const Candidate = @import("collect.zig").Candidate;
const Edit = struct { span: zx.Span, text: []const u8 };

pub fn rewrite(allocator: std.mem.Allocator, source: []const u8, tokens: []const zx.syntax.Token, candidates: []const Candidate) ![]const u8 {
    var edits: std.ArrayList(Edit) = .empty;
    var openings: std.ArrayList(usize) = .empty;
    var continuations: std.ArrayList(*const zx.ast.Expression) = .empty;
    const pairs = try allocator.alloc(?usize, tokens.len);
    const newline: []const u8 = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n";

    @memset(pairs, null);

    for (tokens, 0..) |token, index| {
        if (token.kind != .punctuation) continue;

        const text = token.text(source);

        if (std.mem.eql(u8, text, "(")) try openings.append(allocator, index);
        if (std.mem.eql(u8, text, ")")) pairs[index] = openings.pop();
    }

    for (candidates) |candidate| {
        if (!candidate.nested) continue;

        const value = candidate.expression;
        const choice = value.value.conditional;
        const question = try delimiter(source, tokens, choice.condition.span.end, choice.yes.span.start, "?");
        const colon = try delimiter(source, tokens, choice.yes.span.end, choice.no.span.start, ":");
        const continues = choice.no.value == .conditional and tokens[colon + 1].span.start == choice.no.span.start and value.span.end == choice.no.span.end;
        var start = value.span.start;

        if (continues) try continuations.append(allocator, choice.no);

        for (tokens[0..question], 0..) |token, index| {
            if (token.span.start < start) continue;
            if (pairs[index]) |opening| start = @min(start, tokens[opening].span.start);
        }

        if (std.mem.indexOfScalar(*const zx.ast.Expression, continuations.items, value) == null) {
            try edits.append(allocator, .{ .span = .{ .start = start, .end = start }, .text = try std.fmt.allocPrint(allocator, "match {{{s}", .{newline}) });
            try edits.append(allocator, .{ .span = .{ .start = value.span.end, .end = value.span.end }, .text = try std.fmt.allocPrint(allocator, "{s}}}", .{newline}) });
        }

        var colon_span = tokens[colon].span;

        while (colon_span.start > choice.yes.span.end and source[colon_span.start - 1] == ' ') colon_span.start -= 1;
        try edits.append(allocator, .{ .span = tokens[question].span, .text = "=>" });
        try edits.append(allocator, .{ .span = colon_span, .text = try std.fmt.allocPrint(allocator, ",{s}{s}", .{ newline, if (continues) "" else "_ =>" }) });
    }

    std.mem.sort(Edit, edits.items, {}, struct {
        fn lessThan(_: void, left: Edit, right: Edit) bool {
            if (left.span.start != right.span.start) return left.span.start < right.span.start;

            return left.span.end < right.span.end;
        }
    }.lessThan);

    var result: std.ArrayList(u8) = .empty;
    var offset: usize = 0;

    for (edits.items) |edit| {
        if (edit.span.start < offset) return error.OverlappingEdits;
        try result.appendSlice(allocator, source[offset..edit.span.start]);
        try result.appendSlice(allocator, edit.text);

        offset = edit.span.end;
    }

    try result.appendSlice(allocator, source[offset..]);

    return result.toOwnedSlice(allocator);
}

fn delimiter(source: []const u8, tokens: []const zx.syntax.Token, start: usize, end: usize, text: []const u8) !usize {
    for (tokens, 0..) |token, index| {
        if (token.span.start >= end) break;
        if (token.span.start < start) continue;
        if (token.kind == .punctuation and std.mem.eql(u8, token.text(source), text)) return index;
    }

    return error.MissingDelimiter;
}
