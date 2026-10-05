const std = @import("std");
const impl = @import("implementation");
const data = @import("normalization_data");
const Rows = @import("normalization_rows.zig");

fn checkPart(part: u8, expected_count: usize) !void {
    var rows = Rows.init(data.normalization);
    var checked: usize = 0;

    while (try rows.next()) |row| {
        if (row.part != part) continue;

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var columns: [5][]const u21 = undefined;

        for (row.columns, &columns) |text, *column| column.* = try Rows.points(arena.allocator(), text);

        for (columns, 0..) |input, index| {
            errdefer std.debug.print("NormalizationTest Part{d} line {d} input column {d}\n", .{ part, row.line, index + 1 });

            const result = try impl.normalize(std.testing.allocator, input);

            defer std.testing.allocator.free(result);

            try std.testing.expectEqualSlices(u21, columns[if (index < 3) 1 else 3], result);
        }

        checked += 1;
    }

    try std.testing.expectEqual(expected_count, checked);
}

fn checkHash(text: []const u8, expected: []const u8) !void {
    var actual: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(text, &actual, .{});

    const hex = std.fmt.bytesToHex(actual, .lower);

    try std.testing.expectEqualStrings(expected, &hex);
}

test "Unicode18 official inputs match locked SHA256" {
    try checkHash(data.normalization, "25a50d816764b04abfb4a646d3eb2b2a803284c3873d9a06757b94fe4513dde3");
    try checkHash(data.unicode, "0736451de439ae7baf1425136617da495e09ee5afbe6e394374db7009ea08950");
}

test "NFC official Part0 specific sequences" {
    try checkPart(0, 46);
}

test "NFC official Part1 character coverage" {
    try checkPart(1, 17154);
}

test "NFC official Part2 canonical order" {
    try checkPart(2, 2004);
}

test "NFC official Part3 PRI29 sequences" {
    try checkPart(3, 194);
}

test "NFC official Part4 canonical closures excluding Hangul" {
    try checkPart(4, 735);
}

test "NFC official Part5 chained primary composites" {
    try checkPart(5, 38);
}
