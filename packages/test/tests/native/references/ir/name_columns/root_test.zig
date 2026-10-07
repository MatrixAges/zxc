const std = @import("std");
const f = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

test "native name columns follow canonical object fields through list optional and tuple nodes" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    for (result.value.ir.functions.native_inputs) |input| {
        const values = (input orelse continue).names;

        try std.testing.expectEqual(f.names.len, values.len);

        for (f.names, values) |expected, actual| {
            if (expected) |name| {
                try std.testing.expectEqualStrings(name, actual.?);
            } else {
                try std.testing.expect(actual == null);
            }
        }
    }

    try f.check(std.testing.allocator, f.names, true);
}

test "native name columns reject every truncated prefix" {
    for (0..f.names.len) |length| try f.check(std.testing.allocator, f.names[0..length], false);
}

test "native name columns reject extra nodes after the complete shape" {
    var values: [9]?[]const u8 = undefined;

    @memcpy(values[0..8], f.names);

    for ([_]?[]const u8{ null, "Alpha", "Packet" }) |extra| {
        values[8] = extra;

        try f.check(std.testing.allocator, &values, false);
    }
}

test "native name columns reject unnamed reference leaves independently" {
    for ([_]usize{ 3, 6 }) |index| {
        var values: [8]?[]const u8 = undefined;

        @memcpy(&values, f.names);

        values[index] = null;

        try f.check(std.testing.allocator, &values, false);
    }
}

test "native name columns reject exported names at another type position" {
    var values: [8]?[]const u8 = undefined;

    @memcpy(&values, f.names);
    std.mem.swap(?[]const u8, &values[3], &values[6]);

    try f.check(std.testing.allocator, &values, false);
}

test "native name columns reject unknown names at each named node" {
    for ([_]usize{ 0, 3, 6 }) |index| {
        var values: [8]?[]const u8 = undefined;

        @memcpy(&values, f.names);

        values[index] = "Missing";

        try f.check(std.testing.allocator, &values, false);
    }
}

test "native name columns allow an unnamed structural container while requiring leaf aliases" {
    var values: [8]?[]const u8 = undefined;

    @memcpy(&values, f.names);

    values[0] = null;

    try f.check(std.testing.allocator, &values, true);
}

test "native name column acceptance releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{ f.names, true });
}

test "native name column rejection releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{ f.names[0..7], false });
}
