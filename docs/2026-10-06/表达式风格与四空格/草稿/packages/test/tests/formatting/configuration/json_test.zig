const std = @import("std");
const allocation_testing = @import("allocation_testing");
const lint = @import("lint");

fn precise(allocator: std.mem.Allocator) !void {
    const source = try allocator.dupe(u8, "{\"large\":9007199254740993,\"negative_zero\":-0,\"fraction\":1.2300e+04,\"wide\":340282366920938463463374607431768211455,\"array\":[3,2,1]}");

    const output = lint.configuration.json.format(allocator, source) catch |err| {
        allocator.free(source);

        return err;
    };

    allocator.free(source);
    defer allocator.free(output);
    try std.testing.expectEqualStrings("{\n    \"large\": 9007199254740993,\n    \"negative_zero\": -0,\n    \"fraction\": 1.2300e+04,\n    \"wide\": 340282366920938463463374607431768211455,\n    \"array\": [\n        3,\n        2,\n        1\n    ]\n}\n", output);

    const repeated = try lint.configuration.json.format(allocator, output);

    defer allocator.free(repeated);

    try std.testing.expectEqualStrings(output, repeated);
}

fn duplicate(allocator: std.mem.Allocator) !void {
    const output = lint.configuration.json.format(allocator, "{\"field\":1,\"field\":2}") catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.DuplicateField, err);

        return;
    };

    allocator.free(output);

    return error.ExpectedDuplicateRejection;
}

test "configuration JSON preserves raw number lexemes order ownership and all allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, precise, .{});
}

test "configuration JSON rejects duplicate fields and cleans up every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, duplicate, .{});
}
