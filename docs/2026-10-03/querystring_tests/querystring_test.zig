const std = @import("std");
const query = @import("standard").querystring;
const Operation = enum { escape, unescape, parse, parse_with, stringify, stringify_with };
const Invalid = enum { escape, key, value };

test "querystring escape releases allocations at every failure point" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.escape});
}

test "querystring unescape replaces invalid UTF8 and releases allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.unescape});
}

test "querystring parse releases all partially built entries" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.parse});
}

test "querystring parseWith releases all partially built entries" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.parse_with});
}

test "querystring stringify releases temporary encoded fields" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.stringify});
}

test "querystring stringifyWith releases temporary encoded fields" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{Operation.stringify_with});
}

test "querystring escape rejects invalid UTF8" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.escape});
}

test "querystring stringify rejects invalid key after prior output" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.key});
}

test "querystring stringify rejects invalid value after key allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.value});
}

fn checkSuccess(allocator: std.mem.Allocator, comptime operation: Operation) !void {
    if (operation == .parse or operation == .parse_with) {
        const output = if (operation == .parse)
            try query.parse(allocator, "a=one&a=%E4%B8%AD&=value")
        else
            try query.parseWith(allocator, &.{ .query = "a:one;a:%E4%B8%AD;:value", .separator = ";", .assignment = ":", .max_keys = 0 });

        defer {
            for (output) |entry| {
                allocator.free(entry.key);
                allocator.free(entry.value);
                allocator.destroy(entry);
            }

            allocator.free(output);
        }

        try std.testing.expectEqual(@as(usize, 3), output.len);

        for (output, [_][]const u8{ "a", "a", "" }, [_][]const u8{ "one", "中", "value" }) |entry, key, value| {
            try std.testing.expectEqualStrings(key, entry.key);
            try std.testing.expectEqualStrings(value, entry.value);
        }

        return;
    }

    const output = switch (operation) {
        .escape => try query.escape(allocator, "a +中"),
        .unescape => try query.unescape(allocator, "%E4%B8%AD%FF+"),
        .stringify => try query.stringify(allocator, &.{ &.{ .key = "a", .value = "中" }, &.{ .key = "a", .value = " +" } }),
        .stringify_with => try query.stringifyWith(allocator, &.{ .entries = &.{ &.{ .key = "a", .value = "中" }, &.{ .key = "a", .value = " +" } }, .separator = ";", .assignment = ":" }),
        else => unreachable,
    };

    defer allocator.free(output);

    const expected = switch (operation) {
        .escape => "a%20%2B%E4%B8%AD",
        .unescape => "中�+",
        .stringify => "a=%E4%B8%AD&a=%20%2B",
        .stringify_with => "a:%E4%B8%AD;a:%20%2B",
        else => unreachable,
    };

    try std.testing.expectEqualStrings(expected, output);
}

fn checkInvalid(allocator: std.mem.Allocator, comptime invalid: Invalid) !void {
    const result = if (invalid == .escape)
        query.escape(allocator, "\xff")
    else
        query.stringify(allocator, &.{ &.{ .key = "first", .value = "valid" }, &.{ .key = if (invalid == .key) "\xff" else " +", .value = if (invalid == .value) "\xff" else "ok" } });

    const output = result catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUtf8, err);

        return;
    };

    defer allocator.free(output);

    return error.TestExpectedError;
}
