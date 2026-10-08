const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
pub const Input = std.meta.Child(program.Input);

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

fn rightBase(input: *const Input) []const i64 {
    return if (isMode("shared") or isMode("duplicate") or (isMode("branch") and !input.enabled)) input.left else input.right;
}

pub fn invalid(input: *const Input) bool {
    if (input.count == 0 or !input.enabled) return false;

    return (!isMode("growth") and input.left_index >= input.left.len) or input.right_index >= rightBase(input).len;
}

pub fn check(output: program.Output, input: *const Input) !void {
    const updates: i64 = @intCast(if (input.enabled) input.count else 0);
    const appended: usize = if (isMode("growth")) @intCast(updates) else 0;

    try std.testing.expectEqual(input.left.len + appended, output.columns.left.len);
    try std.testing.expectEqual(rightBase(input).len, output.columns.right.len);
    try std.testing.expectEqual(input.marker, output.marker);
    try std.testing.expectEqual(input.count, output.rounds);

    for (input.left, output.columns.left[0..input.left.len], 0..) |initial, actual, index| {
        const increment = if (!isMode("growth") and index == input.left_index) updates * input.delta else 0;

        try std.testing.expectEqual(initial + increment, actual);
    }

    for (output.columns.left[input.left.len..]) |value| try std.testing.expectEqual(input.delta, value);

    for (rightBase(input), output.columns.right, 0..) |initial, actual, index| {
        const decrement = if (index == input.right_index) updates * input.delta else 0;

        try std.testing.expectEqual(initial - decrement, actual);
    }

    try std.testing.expectEqualSlices(i64, input.left, output.original.left);
    try std.testing.expectEqualSlices(i64, input.right, output.original.right);
    try std.testing.expectEqual(input.left.ptr, output.original.left.ptr);
    try std.testing.expectEqual(input.right.ptr, output.original.right.ptr);
    try std.testing.expectEqualSlices(i64, input.left, output.before.left);
    try std.testing.expectEqualSlices(i64, input.right, output.before.right);

    if (isMode("retained_target") or isMode("retained_parent")) {
        if (input.left.len != 0) try std.testing.expect(output.before.left.ptr != input.left.ptr);
    } else try std.testing.expectEqual(input.left.ptr, output.before.left.ptr);

    if (isMode("retained_parent")) {
        if (input.right.len != 0) try std.testing.expect(output.before.right.ptr != input.right.ptr);
    } else try std.testing.expectEqual(input.right.ptr, output.before.right.ptr);
}
