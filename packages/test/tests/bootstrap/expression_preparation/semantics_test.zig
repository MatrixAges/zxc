const std = @import("std");
const compare = @import("compare.zig");
const fragments = [_][]const u8{ "x", "return", "(", ")", ",", "=>" };

fn enumerate(buffer: *[40]u8, length: usize, depth: usize) !usize {
    compare.check(buffer[0..length], 0) catch |err| {
        std.debug.print("expression lookahead sequence: {s}\n", .{buffer[0..length]});

        return err;
    };

    var count: usize = 1;

    if (depth == 5) return count;

    for (fragments) |fragment| {
        const start = length + @intFromBool(depth != 0);

        if (depth != 0) buffer[length] = ' ';

        @memcpy(buffer[start..][0..fragment.len], fragment);

        count += try enumerate(buffer, start + fragment.len, depth + 1);
    }

    return count;
}

test "expression lookahead matches bounded parameter token sequences" {
    var buffer: [40]u8 = undefined;

    try std.testing.expectEqual(@as(usize, 9331), try enumerate(&buffer, 0, 0));
}

test "expression lookahead matches long parameter lists and trivia boundaries" {
    for ([_]usize{ 0, 1, 2, 16, 64 }) |count| {
        for ([_][]const u8{ " ", "\n", "/**/", "/*\r\n*/" }) |gap| {
            var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

            defer arena.deinit();

            var source: std.ArrayList(u8) = .empty;

            try source.appendSlice(arena.allocator(), "(");
            try source.appendSlice(arena.allocator(), gap);

            for (0..count) |index| {
                if (index != 0) try source.appendSlice(arena.allocator(), ",");
                try source.appendSlice(arena.allocator(), gap);
                try source.appendSlice(arena.allocator(), "value");
                try source.appendSlice(arena.allocator(), gap);
            }

            try source.appendSlice(arena.allocator(), ")");
            try source.appendSlice(arena.allocator(), gap);
            try source.appendSlice(arena.allocator(), "=> value");
            try compare.check(source.items, 0);
        }
    }
}

test "expression lookahead distinguishes operators generic names and near misses" {
    for ([_][]const u8{
        "?? || && == != < <= > >= + - * / % = => ? : ...",
        "queryOne queryMany insert update delete transaction",
        "$queryOne queryOne2 QueryOne _queryOne \"queryOne\" querymany",
        "(x,) => x",
        "(x,,y) => x",
        "(x: u64) => x",
        "({x}) => x",
        "(return) => x",
        "x /*\n*/ => x",
        "\xff",
        "0x",
    }) |source| try compare.check(source, 0);
}

test "expression lookahead keeps nested interpolation streams separate" {
    try compare.check("`a${x => x + 1}b${`c${(x,y) => x ?? y}`}d`", 3);
    try compare.check("`a${queryOne<T>()}b${\"=> queryOne\"}c`", 2);
    try compare.check("`a${0x}b${x => x}c`", 2);
    try compare.check("`a${}b`", 1);
}
