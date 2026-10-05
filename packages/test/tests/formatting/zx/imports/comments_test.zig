const std = @import("std");
const f = @import("fixture.zig");

const cases = [_]struct { source: []const u8, expected: []const u8 }{
    .{
        .source = "import zeta from \"./zeta\" // zeta 尾注释\nimport alpha from \"./alpha\" // alpha tail\n\n",
        .expected = "import alpha from \"./alpha\" // alpha tail\nimport zeta from \"./zeta\" // zeta 尾注释\n\n",
    },
    .{
        .source = "import zeta from \"./zeta\" /* zeta */\nimport alpha from \"./alpha\" /* alpha */\n\n",
        .expected = "import alpha from \"./alpha\" /* alpha */\nimport zeta from \"./zeta\" /* zeta */\n\n",
    },
    .{
        .source = "import { /* inside */ Zebra, Alpha } from \"./zeta\"\nimport first from \"./alpha\"\n\n",
        .expected = "import first from \"./alpha\"\nimport { /* inside */ Zebra, Alpha } from \"./zeta\"\n\n",
    },
    .{
        .source = "// file header\nimport zeta from \"./zeta\"\nimport beta from \"./beta\"\nimport alpha from \"./alpha\"\n\n",
        .expected = "// file header\nimport zeta from \"./zeta\"\nimport alpha from \"./alpha\"\nimport beta from \"./beta\"\n\n",
    },
    .{
        .source = "import delta from \"./delta\"\nimport alpha from \"./alpha\"\n// boundary\nimport zeta from \"./zeta\"\nimport gamma from \"./gamma\"\nimport beta from \"./beta\"\n\n",
        .expected = "import alpha from \"./alpha\"\nimport delta from \"./delta\"\n// boundary\nimport zeta from \"./zeta\"\nimport beta from \"./beta\"\nimport gamma from \"./gamma\"\n\n",
    },
    .{
        .source = "import zeta from \"./zeta\"\n/* boundary */\nimport alpha from \"./alpha\"\n\n",
        .expected = "import zeta from \"./zeta\"\n/* boundary */\nimport alpha from \"./alpha\"\n\n",
    },
    .{
        .source = "import zeta from \"./zeta\" /* first */ /* second */\nimport alpha from \"./alpha\" // final tail\n\n",
        .expected = "import alpha from \"./alpha\" // final tail\nimport zeta from \"./zeta\" /* first */ /* second */\n\n",
    },
};

test "attached comments move intact and independent comments pin sorting boundaries" {
    for (cases) |case| {
        const source = try std.mem.concat(std.testing.allocator, u8, &.{ case.source, f.body });

        defer std.testing.allocator.free(source);

        const expected = try std.mem.concat(std.testing.allocator, u8, &.{ case.expected, f.body });

        defer std.testing.allocator.free(expected);

        try f.check(std.testing.allocator, source, expected);
    }
}

test "CRLF sorting preserves newline style and all comment bytes" {
    for (cases) |case| {
        const source_lf = try std.mem.concat(std.testing.allocator, u8, &.{ case.source, f.body });

        defer std.testing.allocator.free(source_lf);

        const expected_lf = try std.mem.concat(std.testing.allocator, u8, &.{ case.expected, f.body });

        defer std.testing.allocator.free(expected_lf);

        const source = try std.mem.replaceOwned(u8, std.testing.allocator, source_lf, "\n", "\r\n");

        defer std.testing.allocator.free(source);

        const expected = try std.mem.replaceOwned(u8, std.testing.allocator, expected_lf, "\n", "\r\n");

        defer std.testing.allocator.free(expected);

        try f.check(std.testing.allocator, source, expected);
    }
}
