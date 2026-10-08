const std = @import("std");
const f = @import("fixture.zig");

fn shape(case: f.Case, tuple_size: ?usize) !void {
    var result = try f.analyze(std.testing.allocator, case);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try f.inspect(std.testing.allocator, result.value.ir, case);

    const function = result.value.ir.functions.at(0);
    const input = result.value.ir.typeOf(function.input_type);

    if (tuple_size) |size| {
        try std.testing.expect(input == .tuple);
        try std.testing.expectEqual(size, input.tuple.len);
    } else try std.testing.expect(input == .scalar);
}

test "one native tuple parameter keeps a tuple without argument expansion" {
    try shape(.{ .declaration = "export type Pair = [u64, u64]\n\nexport declare function apply(pair: Pair): u64\n", .input = "[u64, u64]", .members = &.{.{ .name = "apply" }} }, 2);
}

test "two native scalar parameters expand the same tuple shape" {
    try shape(.{ .declaration = "export declare function apply(left: u64, right: u64): u64\n", .input = "[u64, u64]", .call = "host.apply(in[0], in[1])", .members = &.{.{ .name = "apply", .expanded = true }} }, 2);
}

test "one native empty tuple parameter is not a zero argument call" {
    try shape(.{ .declaration = "export type Empty = []\n\nexport declare function apply(value: Empty): u64\n", .input = "[]", .members = &.{.{ .name = "apply" }} }, 0);
}

test "injected allocator does not turn one tuple parameter into expanded arguments" {
    try shape(.{ .declaration = "export type Pair = [u64, u64]\n\nexport declare function apply(allocator, pair: Pair): u64 throws {}\n", .input = "[u64, u64]", .members = &.{.{ .name = "apply", .allocating = true, .fallible = true, .errors = &.{} }} }, 2);
}

test "injected IO does not count as an ordinary native parameter" {
    try shape(.{ .declaration = "export declare function apply(io, value: u64): u64 concurrent\n", .members = &.{.{ .name = "apply", .io = true, .concurrent = true }} }, null);
}
