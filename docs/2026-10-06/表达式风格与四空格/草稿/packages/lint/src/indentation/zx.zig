const std = @import("std");
const syntax = @import("zx").syntax;
const spacing = @import("../spacing.zig");
const indentation = @import("root.zig");
const Frame = struct { level: usize, selection: bool = false };

pub fn format(allocator: std.mem.Allocator, source: []const u8, tokens: anytype, comments: anytype) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var stack: std.ArrayList(Frame) = .empty;
    var edits: std.ArrayList(spacing.Edit) = .empty;
    var token_index: usize = 0;
    var comment_index: usize = 0;
    var cursor: usize = 0;
    var covered_until: usize = 0;
    var line_start: usize = 0;
    var active_line: ?usize = null;
    var level: usize = 0;
    var continued = false;
    var continuation: ?usize = null;

    while (token_index < tokens.len or comment_index < comments.len) {
        const is_comment = comment_index < comments.len and (token_index == tokens.len or syntax.header.span(syntax.borrow.item(comments, comment_index)).start < syntax.borrow.item(tokens, token_index).span.start);
        const span = if (is_comment) syntax.header.span(syntax.borrow.item(comments, comment_index)) else syntax.header.span(syntax.borrow.item(tokens, token_index).span);

        if (is_comment) comment_index += 1 else token_index += 1;
        if (span.start == span.end) continue;
        if (is_comment and span.start < covered_until) continue;
        if (!is_comment) covered_until = span.end;

        const text = source[span.start..span.end];

        if (std.mem.lastIndexOfScalar(u8, source[cursor..span.start], '\n')) |newline| line_start = cursor + newline + 1;

        cursor = span.start;

        const closing = !is_comment and (std.mem.eql(u8, text, "}") or std.mem.eql(u8, text, "]") or std.mem.eql(u8, text, ")"));
        const opening = !is_comment and (std.mem.eql(u8, text, "{") or std.mem.eql(u8, text, "[") or std.mem.eql(u8, text, "("));
        const selection = !is_comment and stack.items.len != 0 and (std.mem.eql(u8, text, "case") or std.mem.eql(u8, text, "default"));
        const closed = if (closing) stack.pop().? else null;

        if (active_line == null or active_line.? != line_start) {
            const base = if (closed) |frame| frame.level else if (stack.items.len != 0) block: {
                const parent = stack.items[stack.items.len - 1];

                break :block parent.level + 1 + @intFromBool(parent.selection and !selection);
            } else 0;

            if (continued and !closing and !selection) {
                if (continuation == null) continuation = level + 1;

                level = @max(base, continuation.?);
            } else {
                continuation = null;
                level = base;
            }

            if (try indentation.line(temporary, source, span.start, level)) |edit| try edits.append(temporary, edit);

            active_line = line_start;
        }

        if (opening) try stack.append(temporary, .{ .level = level });
        if (selection) stack.items[stack.items.len - 1].selection = true;
        if (!is_comment) continued = continues(text);
    }

    return spacing.format(allocator, source, edits.items);
}

fn continues(text: []const u8) bool {
    inline for (.{ "=", "=>", "?", ":", "+", "-", "*", "/", "%", "&&", "||", "??", "==", "!=", "<", ">", "<=", ">=" }) |operator| {
        if (std.mem.eql(u8, text, operator)) return true;
    }

    return false;
}
