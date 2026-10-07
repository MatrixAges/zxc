const std = @import("std");
const data = @import("normalization.zig");

pub fn normalize(allocator: std.mem.Allocator, input: []const u21) ![]const u21 {
    var output: std.ArrayList(u21) = .empty;

    errdefer output.deinit(allocator);

    for (input) |point| {
        if (point > 0x10ffff or (point >= 0xd800 and point <= 0xdfff)) return error.InvalidUnicodeScalar;

        if (point >= 0xac00 and point < 0xd7a4) {
            const offset = point - 0xac00;

            try output.appendSlice(allocator, &.{ 0x1100 + offset / 588, 0x1161 + (offset % 588) / 28 });

            if (offset % 28 != 0) try output.append(allocator, 0x11a7 + offset % 28);
        } else if (data.decomposition(point)) |values| {
            try output.appendSlice(allocator, values);
        } else try output.append(allocator, point);
    }

    var start: usize = 0;

    for (output.items, 0..) |point, index| {
        if (data.combiningClass(point) != 0) continue;

        std.mem.sort(u21, output.items[start..index], {}, lessThan);

        start = index + 1;
    }

    std.mem.sort(u21, output.items[start..], {}, lessThan);

    var written: usize = 0;
    var starter: ?usize = null;
    var previous_class: u8 = 0;

    for (output.items) |point| {
        const current_class = data.combiningClass(point);

        if (starter) |index| {
            if (previous_class == 0 or previous_class < current_class) {
                if (data.compose(output.items[index], point)) |composed| {
                    output.items[index] = composed;

                    continue;
                }
            }
        }

        if (current_class == 0) starter = written;

        output.items[written] = point;
        written += 1;
        previous_class = current_class;
    }

    output.items.len = written;

    return output.toOwnedSlice(allocator);
}

fn lessThan(_: void, left: u21, right: u21) bool {
    return data.combiningClass(left) < data.combiningClass(right);
}
