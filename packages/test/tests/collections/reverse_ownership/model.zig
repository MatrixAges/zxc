const std = @import("std");
const mode = @import("options").mode;

pub fn isMode(name: []const u8) bool {
    return std.mem.eql(u8, mode, name);
}

pub fn mapped() bool {
    return isMode("map_unique") or isMode("map_shared") or isMode("object_unique") or isMode("tuple_unique") or isMode("loop_unique") or isMode("loop_shared");
}

pub fn check(actual: anytype, input: []const i64) !void {
    var values: std.ArrayList(i64) = .empty;

    defer values.deinit(std.testing.allocator);

    if (isMode("literal")) {
        try values.appendSlice(std.testing.allocator, &.{ 3, 1, 2 });
    } else {
        for (input) |item| {
            if ((isMode("filter_unique") or isMode("filter_shared")) and item <= 0) continue;
            try values.append(std.testing.allocator, if (mapped()) item + 1 else item);
        }
    }

    const shared = isMode("map_shared") or isMode("filter_shared") or isMode("loop_shared") or isMode("literal");

    try std.testing.expectEqualSlices(i64, if (shared) values.items else input, actual.original);

    std.mem.reverse(i64, values.items);

    try std.testing.expectEqualSlices(i64, values.items, actual.reversed);
}
