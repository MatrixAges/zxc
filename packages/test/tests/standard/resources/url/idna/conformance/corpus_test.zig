const std = @import("std");
const impl = @import("implementation");
const text = @import("idna_data").text;
const Rows = @import("rows.zig");
const unescape = @import("unescape.zig");
const Mode = enum { ascii, unicode };

fn check(row: Rows.Row, mode: Mode) !void {
    const input = try unescape.decode(std.testing.allocator, row.input);

    defer std.testing.allocator.free(input);

    const result = (switch (mode) {
        .ascii => impl.toAscii(std.testing.allocator, input),
        .unicode => impl.toUnicode(std.testing.allocator, input),
    }) catch |err| {
        if (err != error.InvalidDomain and err != error.InvalidPunycode) return err;
        if (row.accepted) return err;

        return;
    };

    defer std.testing.allocator.free(result);

    if (!row.accepted) return error.ExpectedRejection;

    const expected = try unescape.decode(std.testing.allocator, if (mode == .ascii) row.ascii else row.unicode);

    defer std.testing.allocator.free(expected);

    if (!std.mem.eql(u8, expected, result)) return error.OutputMismatch;
}

fn checkCorpus(mode: Mode) !void {
    var rows = Rows.init(text);
    var accepted: usize = 0;
    var rejected: usize = 0;
    var failures: usize = 0;

    while (try rows.next()) |row| {
        if (row.accepted) accepted += 1 else rejected += 1;

        check(row, mode) catch |err| {
            if (err == error.OutOfMemory) return err;

            failures += 1;

            if (failures <= 30) std.debug.print("IDNA line {d} {t}: {s}\n", .{ row.line, mode, @errorName(err) });
        };
    }

    try std.testing.expectEqual(@as(usize, 847), accepted);
    try std.testing.expectEqual(@as(usize, 5549), rejected);
    try std.testing.expectEqual(@as(usize, 0), failures);
}

test "Unicode18 IDNA input matches fixed official SHA256" {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(text, &digest, .{});

    const actual = std.fmt.bytesToHex(digest, .lower);

    try std.testing.expectEqualStrings("0236b75c5b20dfd857b3b5cf75509887959d6ab00d6c7bda9b7dc3df518c1fde", &actual);
}

test "IDNA ToASCII checks all 6396 official nontransitional inputs" {
    try checkCorpus(.ascii);
}

test "IDNA internal strict ToUnicode checks all 6396 profile inputs" {
    try checkCorpus(.unicode);
}

test "IDNA decoded corpus matches independent parser digest" {
    var hashing = std.crypto.hash.sha2.Sha256.init(.{});
    var rows = Rows.init(text);

    while (try rows.next()) |row| {
        hashing.update(&.{@intFromBool(row.accepted)});

        for ([_][]const u8{ row.input, row.unicode, row.ascii }) |field| {
            const value = try unescape.decode(std.testing.allocator, field);

            defer std.testing.allocator.free(value);

            var length: [8]u8 = undefined;

            std.mem.writeInt(u64, &length, @intCast(value.len), .little);
            hashing.update(&length);
            hashing.update(value);
        }
    }

    var digest: [32]u8 = undefined;

    hashing.final(&digest);

    const actual = std.fmt.bytesToHex(digest, .lower);

    try std.testing.expectEqualStrings("36015d2470100ed26eb5e6c4525c2e876caff7102026737088b74e983fd28a53", &actual);
}
