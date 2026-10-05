const std = @import("std");
const program = @import("program");
const lexical = @import("lexical_compare.zig");
const structure = @import("structure_compare.zig");

const sources = [_][]const u8{
    "",
    "name /* comment */ + 42",
    "``",
    "`plain`",
    "`${1}${2}`",
    "`a${`b${2}c`}d`",
    "`a${{value: {next: 1}}}b`",
    "`a${\"} ${ `\"}b`",
    "`a${/* } ${ ` */1}b`",
    "`a${// } ${ `\r\n1}b`",
    "`a\\${literal}b`",
    "`\\`quoted\\``",
    "`a\r\n${\n$value\r\n+ 1\n}z`",
    "`a${1}` /*\n*/ `b${2}`",
    "`a${`b${3}`}c${`d${4}`}e`",
    "`a${0x}b`",
    "`a${\xff}b`",
    "`a${}b`",
    "`甲${\"乙\"}丙`",
};

fn check(source: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const actual = try program.execute(&arena, source);

    try lexical.same(arena.allocator(), source, 0, source.len, actual.lexed);

    if (actual.lexed.diagnostic.message.len == 0) {
        try structure.check(arena.allocator(), source, actual);
    }
}

test "template preparation preserves part boundaries token references and interpolation metadata" {
    for (sources, 0..) |source, index| {
        check(source) catch |err| {
            std.debug.print("template seed {d}: {s}\n", .{ index, source });

            return err;
        };
    }
}

test "template preparation preserves diagnostics at every truncated source boundary" {
    for (sources, 0..) |source, index| {
        for (0..source.len) |length| {
            check(source[0..length]) catch |err| {
                std.debug.print("template seed {d}, prefix length {d}: {s}\n", .{ index, length, source[0..length] });

                return err;
            };
        }
    }
}
