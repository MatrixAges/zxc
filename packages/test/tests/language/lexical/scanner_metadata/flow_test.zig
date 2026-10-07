const std = @import("std");
const f = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

fn expectFailure(result: anytype, start: usize, end: usize, message: []const u8) !void {
    try std.testing.expectEqualStrings("lexical", result.diagnostic.code);
    try std.testing.expectEqualStrings(message, result.diagnostic.message);
    try std.testing.expectEqual(start, result.diagnostic.start);
    try std.testing.expectEqual(end, result.diagnostic.end);
    try std.testing.expectEqual(@as(usize, 0), result.tokens.len);
    try std.testing.expectEqual(@as(usize, 0), result.comments.len);
}

fn invalidUtf8(source: []const u8) !void {
    try std.testing.expect(!std.unicode.utf8ValidateSlice(source));

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try expectFailure(try f.scanner.execute(&arena, source), 0, source.len, "source must be valid UTF-8");
}

test "scanner flow rejects every standalone continuation and invalid leading byte" {
    for (0x80..0xc2) |byte| try invalidUtf8(&.{@intCast(byte)});
    for (0xf5..0x100) |byte| try invalidUtf8(&.{@intCast(byte)});
}

test "scanner flow rejects truncated overlong surrogate and out of range sequences" {
    for ([_][]const u8{
        "\xc2",          "\xe0",             "\xe0\xa0",     "\xf0",             "\xf0\x90", "\xf0\x90\x80",
        "\xe0\x80\x80",  "\xf0\x80\x80\x80", "\xed\xa0\x80", "\xf4\x90\x80\x80", "\xc2A",    "\xe2A\x80",
        "\xf1\x90A\x80",
    }) |source| try invalidUtf8(source);
}

test "scanner flow publishes valid UTF8 scalar boundaries with byte spans" {
    for ([_][]const u8{
        "\xc2\x80",     "\xdf\xbf",     "\xe0\xa0\x80",     "\xed\x9f\xbf",
        "\xee\x80\x80", "\xef\xbf\xbf", "\xf0\x90\x80\x80", "\xf4\x8f\xbf\xbf",
    }) |text| {
        try std.testing.expect(std.unicode.utf8ValidateSlice(text));

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const source = try std.mem.concat(arena.allocator(), u8, &.{ "\"", text, "\"" });
        const result = try f.scanner.execute(&arena, source);

        try std.testing.expectEqualStrings("", result.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 2), result.tokens.len);
        try std.testing.expectEqual(@as(usize, 0), result.comments.len);
        try f.expectToken(result.tokens[0], .{ .text = source, .kind = "String" }, 0, false);
        try f.expectToken(result.tokens[1], .{ .text = "", .kind = "Eof" }, source.len, false);
    }
}

test "scanner flow validates the entire UTF8 source before lexical diagnostics" {
    for ([_][]const u8{ "return /**/ \"unfinished\xff", "/*unfinished\x80", "#\xc0\xaf" }) |source| {
        try invalidUtf8(source);
    }
}

test "scanner flow discards accumulated tokens and comments on finish failure" {
    const prefix = "return /**/ ";

    for ([_]struct { source: []const u8, message: []const u8 }{
        .{ .source = prefix ++ "/*tail", .message = "unterminated block comment" },
        .{ .source = prefix ++ "\"tail", .message = "unterminated string" },
        .{ .source = prefix ++ "`tail", .message = "unterminated template string" },
    }) |item| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        try expectFailure(try f.scanner.execute(&arena, item.source), prefix.len, item.source.len, item.message);
    }
}

test "scanner flow keeps the first scanning diagnostic before malformed trailing input" {
    const prefix = "return /**/ ";

    for ([_][]const u8{ "/*tail", "\"tail", "`tail" }) |tail| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const source = try std.mem.concat(arena.allocator(), u8, &.{ prefix, "#", tail });

        try expectFailure(try f.scanner.execute(&arena, source), prefix.len, prefix.len + 1, "unexpected character");
    }
}

fn recovery(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    for ([_]struct { source: []const u8, message: []const u8, start: usize }{
        .{ .source = "\xff", .message = "source must be valid UTF-8", .start = 0 },
        .{ .source = "return /**/ \"tail", .message = "unterminated string", .start = "return /**/ ".len },
        .{ .source = "return", .message = "", .start = 0 },
    }) |item| {
        const original = try f.scanner.execute(&arena, item.source);
        const repeated = try f.scanner.execute(&arena, "return");

        try std.testing.expectEqualStrings("", repeated.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 2), repeated.tokens.len);
        try f.expectToken(repeated.tokens[0], .{ .text = "return", .kind = "Keyword", .word = "Return" }, 0, false);
        try f.expectToken(repeated.tokens[1], .{ .text = "", .kind = "Eof" }, 6, false);

        if (item.message.len != 0) {
            try expectFailure(original, item.start, item.source.len, item.message);
        } else {
            try std.testing.expectEqualStrings("", original.diagnostic.message);
            try std.testing.expectEqual(@as(usize, 2), original.tokens.len);
            try f.expectToken(original.tokens[0], .{ .text = "return", .kind = "Keyword", .word = "Return" }, 0, false);
            try f.expectToken(original.tokens[1], .{ .text = "", .kind = "Eof" }, 6, false);
        }
    }
}

test "scanner flow branches retain results and clean every allocation failure" {
    try recovery(std.testing.allocator);
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, recovery, .{});
}
