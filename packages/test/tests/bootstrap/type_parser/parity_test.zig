const std = @import("std");
const comparison = @import("check.zig");
const insertions = @import("insertions.zig");
const Case = struct { name: []const u8, source: []const u8, start: u64, depth: u64, sha256: []const u8 };

test "generated ZX type grammar matches native tree index and diagnostics" {
    const cases = try std.json.parseFromSlice([]const Case, std.testing.allocator, @embedFile("cases.json"), .{});

    defer cases.deinit();

    try std.testing.expect(cases.value.len != 0);

    for (cases.value) |case| {
        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(case.source, &digest, .{});

        try std.testing.expectEqualStrings(case.sha256, &std.fmt.bytesToHex(digest, .lower));

        comparison.check(case.source, case.start, case.depth) catch |err| {
            std.debug.print("type case {s}, start {d}, depth {d}: {s}\n", .{ case.name, case.start, case.depth, case.source });

            return err;
        };
    }
}

test "generated type parser matches insertion mutations from the first token" {
    try insertions.run("", 0);
}

test "generated type parser matches insertion mutations after a token prefix" {
    try insertions.run("prefix ; ", 2);
}
