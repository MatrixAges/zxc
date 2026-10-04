const std = @import("std");
const params = @import("standard").url_search_params;
const Entries = @typeInfo(@TypeOf(params.stringify)).@"fn".params[1].type.?;
const Operation = enum { sort, remove_key, remove_value, remove_absent };

fn check(allocator: std.mem.Allocator, operation: Operation) !void {
    const input: Entries = &.{ &.{ .key = "b", .value = "0" }, &.{ .key = "a", .value = "1" }, &.{ .key = "b", .value = "2" }, &.{ .key = "a", .value = "3" } };
    const output = if (operation == .sort)
        try params.sort(allocator, input)
    else
        try params.remove(allocator, &.{ .entries = input, .key = if (operation == .remove_absent) "missing" else "a", .value = if (operation == .remove_value) "1" else null });

    defer allocator.free(output);

    const expected: []const usize = switch (operation) {
        .sort => &.{ 1, 3, 0, 2 },
        .remove_key => &.{ 0, 2 },
        .remove_value => &.{ 0, 2, 3 },
        .remove_absent => &.{ 0, 1, 2, 3 },
    };

    try std.testing.expectEqual(expected.len, output.len);
    try std.testing.expect(output.ptr != input.ptr);

    for (output, expected) |entry, index| try std.testing.expectEqual(input[index], entry);
    try std.testing.expectEqualStrings("b", input[0].key);
    try std.testing.expectEqualStrings("a", input[1].key);
}

test "URL stable sort releases temporary UTF16 keys and shares entries" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.sort});
}

test "URL remove by key owns only filtered list across allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.remove_key});
}

test "URL remove by value preserves nonmatching duplicate pointers" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.remove_value});
}

test "URL remove absent key preserves every entry across allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.remove_absent});
}
