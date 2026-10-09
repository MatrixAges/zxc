const std = @import("std");
const program = @import("program");
const postcondition = @import("options").kind == .discard_post;

fn run(length: usize, count: u64) !void {
    var values: [4098]u64 = @splat(987654321);

    for (values[1..][0..length], 0..) |*value, index| value.* = @intCast(index % 97);

    const input = @typeInfo(program.Input).pointer.child{ .values = values[1..][0..length], .count = count, .choice = false };
    const iterations = if (postcondition) @max(1, count) else count;
    var empty: [0]u8 = .{};
    var fixed = std.heap.FixedBufferAllocator.init(&empty);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const actual = program.execute(&arena, &input);

    if (iterations > length) {
        try std.testing.expectError(error.IndexOutOfBounds, actual);
    } else {
        try std.testing.expectEqual(count, try actual);
    }

    try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());
    try std.testing.expectEqual(count, input.count);
    try std.testing.expect(!input.choice);
    try std.testing.expectEqual(length, input.values.len);
    try std.testing.expectEqual(values[1..].ptr, input.values.ptr);
    for (input.values, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index % 97)), value);
    try std.testing.expectEqual(@as(u64, 987654321), values[0]);
    try std.testing.expectEqual(@as(u64, 987654321), values[length + 1]);
}

test "discarded deep initial state needs no arena at zero body steps" {
    try run(0, 0);
    try run(1, 0);
    try run(17, 0);
}

test "discarded deep loop executes first and later source reads without allocation" {
    for ([_]u64{ 1, 2, 3, 16, 17 }) |count| try run(17, count);
}

test "discarded deep loop preserves bounds errors instead of failing allocation" {
    try run(0, 1);
    try run(1, 2);
    try run(17, 18);
    try run(0, std.math.maxInt(u64));
}

test "discarded deep loop precondition and postcondition retain different empty behavior" {
    try run(0, 0);
    try run(0, 1);
    try run(1, 0);
}

test "discarded deep loop scales to long input with zero arena capacity" {
    try run(4096, 4096);
    try run(4096, 4097);
}

test "discarded deep initialization and bounds are repeated for each execution" {
    for (0..17) |_| {
        try run(3, 3);
        try run(3, 4);
        try run(0, 0);
    }
}
