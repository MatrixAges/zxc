const std = @import("std");
const f = @import("fixture.zig");
const symbols = @import("symbols.zig");

test "scanner punctuation pairs use longest match and preserve comment priority" {
    for (symbols.all) |left| {
        for (symbols.all) |right| {
            var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

            defer arena.deinit();

            const source = try std.fmt.allocPrint(arena.allocator(), "{s}{s}", .{ left.text, right.text });
            const result = try f.scanner.execute(&arena, source);

            if (std.mem.indexOf(u8, source, "/*")) |start| {
                try std.testing.expectEqualStrings("lexical", result.diagnostic.code);
                try std.testing.expectEqualStrings("unterminated block comment", result.diagnostic.message);
                try std.testing.expectEqual(start, result.diagnostic.start);
                try std.testing.expectEqual(source.len, result.diagnostic.end);
                try std.testing.expectEqual(@as(usize, 0), result.tokens.len);

                continue;
            }

            try std.testing.expectEqualStrings("", result.diagnostic.message);

            var cursor: usize = 0;
            var index: usize = 0;
            var comments: usize = 0;

            while (cursor < source.len) {
                const rest = source[cursor..];

                if (std.mem.startsWith(u8, rest, "//")) {
                    try std.testing.expectEqual(@as(usize, 1), result.comments.len);
                    try std.testing.expectEqual(cursor, result.comments[0].start);
                    try std.testing.expectEqual(source.len, result.comments[0].end);

                    comments += 1;

                    break;
                }

                var longest: ?symbols.Symbol = null;

                for (symbols.all) |symbol| {
                    if (std.mem.startsWith(u8, rest, symbol.text) and (longest == null or symbol.text.len > longest.?.text.len)) longest = symbol;
                }

                const expected = longest orelse return error.UnknownPunctuation;

                try std.testing.expect(index < result.tokens.len);
                try f.expectToken(result.tokens[index], .{ .text = expected.text, .kind = "Punctuation", .symbol = expected.tag }, cursor, false);

                cursor += expected.text.len;
                index += 1;
            }

            try std.testing.expectEqual(comments, result.comments.len);
            try std.testing.expectEqual(index + 1, result.tokens.len);
            try f.expectToken(result.tokens[index], .{ .text = "", .kind = "Eof" }, source.len, false);
        }
    }
}
