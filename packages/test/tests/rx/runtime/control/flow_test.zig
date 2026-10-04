const std = @import("std");
const program = @import("program");

fn check(enabled: bool, value: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .enabled = enabled, .value = value };

    try std.testing.expectEqual(expected, try program.execute(&arena, &input));
}

test "RX nested Task Default preserves zero" {
    try check(false, 0, 0);
}

test "RX nested Task Default preserves runtime value" {
    try check(false, 7, 7);
}

test "RX nested Case service Return resumes caller" {
    try check(true, 0, 11);
}

test "RX nested Case service receives runtime value" {
    try check(true, 7, 18);
}

test "RX unselected service does not overflow maximum" {
    try check(false, std.math.maxInt(u64), std.math.maxInt(u64));
}

test "RX nested Case preserves maximum safe addition" {
    try check(true, std.math.maxInt(u64) - 11, std.math.maxInt(u64));
}
