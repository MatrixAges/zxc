const std = @import("std");
const allocation_testing = @import("allocation_testing");
const params = @import("standard").url_search_params;
const Invalid = enum { key, value, sort_key };

fn checkParse(allocator: std.mem.Allocator, invalid: bool) !void {
    const output = try params.parse(allocator, if (invalid) "?first=ok&\xff=\xe2\x82&x=%ED%A0%80" else "?a=one&a=%E4%B8%AD&=+");

    defer {
        for (output) |entry| {
            allocator.free(entry.key);
            allocator.free(entry.value);
            allocator.destroy(entry);
        }

        allocator.free(output);
    }

    const keys: [3][]const u8 = if (invalid) .{ "first", "�", "x" } else .{ "a", "a", "" };
    const values: [3][]const u8 = if (invalid) .{ "ok", "�", "���" } else .{ "one", "中", " " };

    try std.testing.expectEqual(@as(usize, 3), output.len);

    for (output, keys, values) |entry, key, value| {
        try std.testing.expectEqualStrings(key, entry.key);
        try std.testing.expectEqualStrings(value, entry.value);
    }
}

fn checkStringify(allocator: std.mem.Allocator) !void {
    const output = try params.stringify(allocator, &.{ &.{ .key = "a b", .value = "中+~" }, &.{ .key = "a b", .value = "" } });

    defer allocator.free(output);

    try std.testing.expectEqualStrings("a+b=%E4%B8%AD%2B%7E&a+b=", output);
}

fn checkInvalid(allocator: std.mem.Allocator, invalid: Invalid) !void {
    const Entries = @typeInfo(@TypeOf(params.stringify)).@"fn".param_types[1].?;
    const input: Entries = &.{ &.{ .key = "first", .value = "valid" }, &.{ .key = if (invalid == .value) " +" else "\xff", .value = if (invalid == .value) "\xff" else "ok" } };

    if (invalid == .sort_key) {
        const output = params.sort(allocator, input) catch |err| {
            if (err == error.OutOfMemory) return err;

            try std.testing.expectEqual(error.InvalidUtf8, err);

            return;
        };

        defer allocator.free(output);

        return error.TestExpectedError;
    }

    const output = params.stringify(allocator, input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidUtf8, err);

        return;
    };

    defer allocator.free(output);

    return error.TestExpectedError;
}

test "URL parse releases partial entries at every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkParse, .{false});
}

test "URL parse replaces raw and escaped invalid UTF8 with failure cleanup" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkParse, .{true});
}

test "URL stringify releases partial form encoded output" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkStringify, .{});
}

test "URL stringify invalid key releases preceding output" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.key});
}

test "URL stringify invalid value releases encoded key and preceding output" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.value});
}

test "URL sort invalid key releases earlier UTF16 keys" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkInvalid, .{Invalid.sort_key});
}
