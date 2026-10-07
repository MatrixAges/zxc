const std = @import("std");
const allocation_testing = @import("allocation_testing");
const check = @import("check.zig");
const cases = @import("scenario.zig");

fn allocation(scenario: cases.Scenario) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const source = try cases.create(arena.allocator(), scenario);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.analyze, .{ source, scenario });
}

test "native signature batch keeps zero scalar object and tuple columns independent" {
    try check.run(std.testing.allocator, .{ .functions = 4, .aliases = 0 });
}

test "native signature batch retains long alias names across cache growth" {
    try check.run(std.testing.allocator, .{ .functions = 32, .aliases = 64 });
}

test "native signature declaration reorder preserves every named parameter column" {
    try check.run(std.testing.allocator, .{ .functions = 32, .aliases = 64, .reverse = true });
}

test "native signature repeated analyses own their complete name columns" {
    for (0..8) |index| try check.run(std.testing.allocator, .{ .functions = 8, .aliases = index * 8, .reverse = index % 2 == 1 });
}

test "native signature late invalid output retains its source diagnostic" {
    try check.run(std.testing.allocator, .{ .functions = 32, .aliases = 64, .invalid = true });
}

test "native signature batch releases every failed allocation after multiple declarations" {
    try allocation(.{ .functions = 4, .aliases = 4 });
}

test "native signature late diagnostic releases every failed allocation" {
    try allocation(.{ .functions = 4, .aliases = 4, .invalid = true });
}
