const std = @import("std");
const zx = @import("zx");
const generated = @import("generated");

pub fn lex(allocator: std.mem.Allocator, source: []const u8, reporter: *zx.Reporter) zx.Error!zx.syntax.Lexed {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const result = generated.execute(&arena, source) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated lexer failed with {s}", .{@errorName(err)})),
    };

    if (result.diagnostic.message.len != 0) {
        const code = std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable;
        const message = try allocator.dupe(u8, result.diagnostic.message);

        return reporter.fail(code, .{ .start = @intCast(result.diagnostic.start), .end = @intCast(result.diagnostic.end) }, message);
    }

    const tokens = try allocator.alloc(zx.syntax.Token, result.tokens.len);

    errdefer allocator.free(tokens);

    const comments = try allocator.alloc(zx.Span, result.comments.len);

    for (result.tokens, tokens) |token, *item| item.* = .{
        .kind = switch (token.kind) {
            .Identifier => .identifier,
            .Keyword => .keyword,
            .Number => .number,
            .String => .string,
            .Template => .template,
            .Punctuation => .punctuation,
            .Eof => .eof,
        },
        .span = .{ .start = @intCast(token.span.start), .end = @intCast(token.span.end) },
    };

    for (result.comments, comments) |span, *item| item.* = .{ .start = @intCast(span.start), .end = @intCast(span.end) };

    return .{ .tokens = tokens, .comments = comments };
}
