const std = @import("std");

fn check(comptime program: type) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const T = @FieldType(@typeInfo(program.Input).pointer.child, "left");
    const result = try program.execute(&arena, &.{ .left = 9, .right = 2 });

    try std.testing.expectEqual(@as(T, 11), result.sum);
    try std.testing.expectEqual(@as(T, 7), result.difference);
    try std.testing.expectEqual(@as(T, 18), result.product);
    try std.testing.expectEqual(@as(T, if (@typeInfo(T) == .float) 4.5 else 4), result.quotient);
    try std.testing.expectEqual(@as(T, 1), result.remainder);

    const equal = try program.execute(&arena, &.{ .left = 1, .right = 1 });

    try std.testing.expectEqual(@as(T, 0), equal.difference);
    try std.testing.expectEqual(@as(T, 1), equal.product);
    try std.testing.expectEqual(@as(T, 1), equal.quotient);
    try std.testing.expectEqual(@as(T, 0), equal.remainder);
}

test "runtime numeric u8: native arithmetic results" {
    try check(@import("numeric_u8"));
}

test "runtime numeric u16: native arithmetic results" {
    try check(@import("numeric_u16"));
}

test "runtime numeric u32: native arithmetic results" {
    try check(@import("numeric_u32"));
}

test "runtime numeric u64: native arithmetic results" {
    try check(@import("numeric_u64"));
}

test "runtime numeric i32: native arithmetic results" {
    try check(@import("numeric_i32"));
}

test "runtime numeric i64: native arithmetic results" {
    try check(@import("numeric_i64"));
}

test "runtime numeric f32: native arithmetic results" {
    try check(@import("numeric_f32"));
}

test "runtime numeric f64: native arithmetic results" {
    try check(@import("numeric_f64"));
}
