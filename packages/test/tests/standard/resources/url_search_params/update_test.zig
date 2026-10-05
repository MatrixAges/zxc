const std = @import("std");
const allocation_testing = @import("allocation_testing");
const params = @import("standard").url_search_params;
const Entries = @typeInfo(@TypeOf(params.stringify)).@"fn".param_types[1].?;
const Operation = enum { append, replace, absent };

fn check(allocator: std.mem.Allocator, operation: Operation) !void {
    const input: Entries = &.{ &.{ .key = "b", .value = "0" }, &.{ .key = "a", .value = "1" }, &.{ .key = "b", .value = "2" }, &.{ .key = "a", .value = "3" } };
    const key: []const u8 = if (operation == .absent) "z" else "a";
    const value: []const u8 = "replacement";

    const output = if (operation == .append)
        try params.append(allocator, &.{ .entries = input, .key = key, .value = value })

    else
        try params.set(allocator, &.{ .entries = input, .key = key, .value = value });

    defer allocator.free(output);

    const fresh_index: usize = if (operation == .replace) 1 else 4;

    defer allocator.destroy(output[fresh_index]);

    try std.testing.expectEqual(@as(usize, if (operation == .replace) 3 else 5), output.len);
    try std.testing.expect(output.ptr != input.ptr);
    try std.testing.expectEqual(key.ptr, output[fresh_index].key.ptr);
    try std.testing.expectEqual(value.ptr, output[fresh_index].value.ptr);
    try std.testing.expectEqualStrings(key, output[fresh_index].key);
    try std.testing.expectEqualStrings(value, output[fresh_index].value);

    if (operation == .replace) {
        try std.testing.expectEqual(input[0], output[0]);
        try std.testing.expectEqual(input[2], output[2]);
    } else {
        for (input, output[0..input.len]) |original, item| try std.testing.expectEqual(original, item);
    }

    try std.testing.expectEqualStrings("1", input[1].value);
    try std.testing.expectEqualStrings("3", input[3].value);
}

test "URL append owns only new entry and outer list across allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.append});
}

test "URL set replaces first duplicate without owning retained entries" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.replace});
}

test "URL set missing key releases entry when list allocation fails" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.absent});
}
