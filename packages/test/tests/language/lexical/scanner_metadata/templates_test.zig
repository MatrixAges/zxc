const std = @import("std");
const f = @import("fixture.zig");
const templates = @import("templates.zig");

test "nested template internals preserve only outer trivia metadata" {
    const before: f.Token = .{ .text = "$before", .kind = "Identifier", .word = "Dead", .dollar = true };
    const after: f.Token = .{ .text = "return", .kind = "Keyword", .word = "Return" };

    for (templates.all) |template| {
        for ([_][]const u8{ " ", "\n", "/*\r*/", "//before\n" }) |left| {
            for ([_][]const u8{ " ", "\r\n", "/**/", "/*after\n*/" }) |right| {
                var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

                defer arena.deinit();

                const source = try std.fmt.allocPrint(arena.allocator(), "{s}{s}{s}{s}{s}", .{ before.text, left, template, right, after.text });
                const result = try f.scanner.execute(&arena, source);
                const start = before.text.len + left.len;

                try std.testing.expectEqualStrings("", result.diagnostic.message);
                try std.testing.expectEqual(@as(usize, 4), result.tokens.len);
                try f.expectToken(result.tokens[0], before, 0, false);
                try f.expectToken(result.tokens[1], .{ .text = template, .kind = "Template" }, start, f.lineBreak(left));
                try f.expectToken(result.tokens[2], after, start + template.len + right.len, f.lineBreak(right));
                try f.expectToken(result.tokens[3], .{ .text = "", .kind = "Eof" }, source.len, false);

                const left_comment = std.mem.startsWith(u8, left, "/");
                const right_comment = std.mem.startsWith(u8, right, "/");

                try std.testing.expectEqual(@as(usize, @intFromBool(left_comment)) + @intFromBool(right_comment), result.comments.len);

                if (left_comment) {
                    try std.testing.expectEqual(before.text.len, result.comments[0].start);
                    try std.testing.expectEqual(start - @intFromBool(left[left.len - 1] == '\n'), result.comments[0].end);
                }

                if (right_comment) {
                    const index: usize = @intFromBool(left_comment);

                    try std.testing.expectEqual(start + template.len, result.comments[index].start);
                    try std.testing.expectEqual(start + template.len + right.len, result.comments[index].end);
                }
            }
        }
    }
}
