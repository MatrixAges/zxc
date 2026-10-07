const std = @import("std");
const f = @import("fixture.zig");
const words = @import("words.zig");

fn check(text: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try f.scanner.execute(&arena, text);

    try std.testing.expectEqualStrings("", result.diagnostic.message);
    try std.testing.expectEqual(@as(usize, 2), result.tokens.len);
    try f.expectToken(result.tokens[0], try words.expected(arena.allocator(), text), 0, false);
    try f.expectToken(result.tokens[1], .{ .text = "", .kind = "Eof" }, text.len, false);
}

test "scanner distinguishes every reserved and contextual word and its prefixes" {
    for (words.all) |word| {
        for (1..word.len + 1) |length| try check(word[0..length]);
    }
}

test "scanner word suffixes and leading dollar do not retain keyword metadata" {
    for (words.all) |word| {
        for ([_][]const u8{ "x", "0", "_" }) |suffix| {
            const text = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}", .{ word, suffix });

            defer std.testing.allocator.free(text);

            try check(text);
        }

        const dollar = try std.fmt.allocPrint(std.testing.allocator, "${s}", .{word});

        defer std.testing.allocator.free(dollar);

        try check(dollar);
    }
}

test "scanner word recognition remains case sensitive at every character" {
    for (words.all) |word| {
        for (word, 0..) |byte, index| {
            if (!std.ascii.isAlphabetic(byte)) continue;

            const changed = try std.testing.allocator.dupe(u8, word);

            defer std.testing.allocator.free(changed);

            changed[index] = if (std.ascii.isUpper(byte)) std.ascii.toLower(byte) else std.ascii.toUpper(byte);

            try check(changed);
        }
    }
}

test "scanner dollar begins a new identifier after a complete word" {
    for (words.all) |word| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const source = try std.fmt.allocPrint(arena.allocator(), "{s}${s}", .{ word, word });
        const result = try f.scanner.execute(&arena, source);

        try std.testing.expectEqualStrings("", result.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 3), result.tokens.len);
        try f.expectToken(result.tokens[0], try words.expected(arena.allocator(), word), 0, false);
        try f.expectToken(result.tokens[1], try words.expected(arena.allocator(), source[word.len..]), word.len, false);
        try f.expectToken(result.tokens[2], .{ .text = "", .kind = "Eof" }, source.len, false);
    }
}
