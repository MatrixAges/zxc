const std = @import("std");
const allocation_testing = @import("allocation_testing");
const params = @import("standard").url_search_params;
const Entries = @typeInfo(@TypeOf(params.stringify)).@"fn".param_types[1].?;
const Operation = enum { keys, values, get_all };

fn check(allocator: std.mem.Allocator, operation: Operation) !void {
    const input: Entries = &.{ &.{ .key = "a", .value = "one" }, &.{ .key = "b", .value = "two" }, &.{ .key = "a", .value = "three" } };

    const output = switch (operation) {
        .keys => try params.keys(allocator, input),
        .values => try params.values(allocator, input),
        .get_all => try params.getAll(allocator, &.{ .entries = input, .key = "a" }),
    };

    defer allocator.free(output);

    const indices: []const usize = if (operation == .get_all) &.{ 0, 2 } else &.{ 0, 1, 2 };

    try std.testing.expectEqual(indices.len, output.len);

    for (output, indices) |item, index| {
        const expected = if (operation == .keys) input[index].key else input[index].value;

        try std.testing.expectEqualStrings(expected, item);
        try std.testing.expectEqual(expected.ptr, item.ptr);
    }
}

fn checkEmpty(allocator: std.mem.Allocator) !void {
    const parsed = try params.parse(allocator, "?&&");

    defer allocator.free(parsed);

    const sorted = try params.sort(allocator, parsed);

    defer allocator.free(sorted);

    const text = try params.stringify(allocator, sorted);

    defer allocator.free(text);

    const matches = try params.getAll(allocator, &.{ .entries = parsed, .key = "missing" });

    defer allocator.free(matches);

    try std.testing.expectEqual(@as(usize, 0), parsed.len);
    try std.testing.expectEqual(@as(usize, 0), sorted.len);
    try std.testing.expectEqualStrings("", text);
    try std.testing.expectEqual(@as(usize, 0), matches.len);
}

test "URL keys allocates list and borrows key strings" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.keys});
}

test "URL values allocates list and borrows value strings" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.values});
}

test "URL getAll owns only selected outer list" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Operation.get_all});
}

test "URL empty results release their zero length allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkEmpty, .{});
}
