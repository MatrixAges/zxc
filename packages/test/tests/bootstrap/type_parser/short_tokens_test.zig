const std = @import("std");
const comparison = @import("check.zig");
const tokens = [_][]const u8{ "T", "return", "$x", "0", "_", "[", "]", "{", "}", ":", "?", "<", ">", "," };
const gaps = [_][]const u8{ "", " ", "\n", "/*\n*/" };

fn check(source: []const u8, start: u64) !void {
    comparison.check(source, start, 0) catch |err| {
        std.debug.print("short type sequence at {d}: {s}\n", .{ start, source });

        return err;
    };
}

fn enumerate(prefix: []const u8, start: u64) !void {
    try check(prefix, start);

    for (tokens) |first| {
        const single = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}", .{ prefix, first });

        defer std.testing.allocator.free(single);

        try check(single, start);

        for (gaps) |gap| {
            for (tokens) |second| {
                const pair = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}{s}{s}", .{ prefix, first, gap, second });

                defer std.testing.allocator.free(pair);

                try check(pair, start);

                for (tokens) |third| {
                    const triple = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}{s}", .{ pair, gap, third });

                    defer std.testing.allocator.free(triple);

                    try check(triple, start);
                }
            }
        }
    }
}

test "generated type parser matches all short sequences from the first token" {
    try enumerate("", 0);
}

test "generated type parser matches all short sequences after a token prefix" {
    try enumerate("prefix ; ", 2);
}
