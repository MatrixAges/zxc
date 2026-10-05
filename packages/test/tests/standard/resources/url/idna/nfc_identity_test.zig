const std = @import("std");
const impl = @import("implementation");
const data = @import("normalization_data");
const Rows = @import("normalization_rows.zig");

test "NFC preserves every assigned scalar absent from official Part1" {
    const listed = try std.testing.allocator.alloc(bool, 0x110000);

    defer std.testing.allocator.free(listed);

    @memset(listed, false);

    var rows = Rows.init(data.normalization);

    while (try rows.next()) |row| {
        if (row.part != 1) continue;

        const point = try std.fmt.parseInt(u21, row.columns[0], 16);

        listed[point] = true;
    }

    var lines = std.mem.tokenizeScalar(u8, data.unicode, '\n');
    var range_start: ?u21 = null;
    var checked: usize = 0;

    while (lines.next()) |line| {
        var fields = std.mem.splitScalar(u8, line, ';');
        const point = try std.fmt.parseInt(u21, fields.next().?, 16);
        const name = fields.next().?;

        if (std.mem.endsWith(u8, name, ", First>")) {
            try std.testing.expectEqual(null, range_start);

            range_start = point;

            continue;
        }

        const start = if (std.mem.endsWith(u8, name, ", Last>")) range_start orelse return error.RangeStartMissing else point;

        range_start = null;

        for (start..@as(usize, point) + 1) |value| {
            if (listed[value] or (value >= 0xd800 and value <= 0xdfff)) continue;

            errdefer std.debug.print("NFC identity failed at U+{X}\n", .{value});

            const input = [_]u21{@intCast(value)};
            const result = try impl.normalize(std.testing.allocator, &input);

            defer std.testing.allocator.free(result);

            try std.testing.expectEqualSlices(u21, &input, result);

            checked += 1;
        }
    }

    try std.testing.expectEqual(null, range_start);
    try std.testing.expectEqual(@as(usize, 293187), checked);
}
