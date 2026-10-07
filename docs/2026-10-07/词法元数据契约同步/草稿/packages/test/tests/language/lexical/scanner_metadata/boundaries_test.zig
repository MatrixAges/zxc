const std = @import("std");
const f = @import("fixture.zig");
const eof: f.Token = .{ .text = "", .kind = "Eof" };

test "scanner metadata resets across token and trivia boundaries" {
    for ([_][]const u8{ "", "\n", "/*\r\n*/" }) |prefix| {
        for (f.tokens) |left| {
            for (f.gaps) |gap| {
                for (f.tokens) |right| {
                    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

                    defer arena.deinit();

                    const source = try std.fmt.allocPrint(arena.allocator(), "{s}{s}{s}{s}", .{ prefix, left.text, gap, right.text });
                    const result = try f.scanner.execute(&arena, source);

                    try std.testing.expectEqualStrings("", result.diagnostic.message);
                    try std.testing.expectEqual(@as(usize, 3), result.tokens.len);
                    try f.expectToken(result.tokens[0], left, prefix.len, false);
                    try f.expectToken(result.tokens[1], right, prefix.len + left.text.len + gap.len, f.lineBreak(gap));
                    try f.expectToken(result.tokens[2], eof, source.len, false);
                }
            }
        }
    }
}

test "scanner EOF records trailing trivia but ignores template interior newlines" {
    for (f.tokens) |token| {
        for (f.gaps) |gap| {
            var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

            defer arena.deinit();

            const source = try std.fmt.allocPrint(arena.allocator(), "{s}{s}", .{ token.text, gap });
            const result = try f.scanner.execute(&arena, source);

            try std.testing.expectEqualStrings("", result.diagnostic.message);
            try std.testing.expectEqual(@as(usize, 2), result.tokens.len);
            try f.expectToken(result.tokens[0], token, 0, false);
            try f.expectToken(result.tokens[1], eof, source.len, f.lineBreak(gap));
        }
    }
}

test "scanner trivia-only input has a first EOF without line break metadata" {
    for (f.gaps) |source| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const result = try f.scanner.execute(&arena, source);

        try std.testing.expectEqualStrings("", result.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 1), result.tokens.len);
        try f.expectToken(result.tokens[0], eof, source.len, false);
    }
}
