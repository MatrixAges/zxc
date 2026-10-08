const std = @import("std");
const program = @import("program");

test "filter singleton false predicate returns a native list container" {
    try check(&.{11});
}

test "filter empty source returns a native list container" {
    try check(&.{});
}

fn check(input: []const i64) !void {
    const output_type = @typeInfo(program.Output);

    try std.testing.expect(output_type == .pointer);
    try std.testing.expectEqual(.slice, output_type.pointer.size);
    try std.testing.expect(output_type.pointer.child == i64);

    const writable = try std.testing.allocator.dupe(i64, input);

    defer std.testing.allocator.free(writable);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const output = try program.execute(&arena, writable);

    try std.testing.expectEqualSlices(i64, input, writable);
    try std.testing.expectEqualSlices(i64, &.{}, output);
}
