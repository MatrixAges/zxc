const std = @import("std");
const program = @import("program");
const Input = std.meta.Child(program.Input);
const Scalar = @FieldType(Input, "safe");
const Bits = @Int(.unsigned, @bitSizeOf(Scalar));

pub fn check(choose: bool, values: []const Bits, safe: Bits, expected: union(enum) { value: ?Bits, bounds }) !void {
    var storage: [259]Bits = @splat(std.math.maxInt(Bits));

    try std.testing.expect(values.len <= storage.len - 2);

    @memcpy(storage[1..][0..values.len], values);

    const snapshot = storage;

    const input: Input = .{
        .choose = choose,
        .items = std.mem.bytesAsSlice(Scalar, std.mem.sliceAsBytes(storage[1..][0..values.len])),
        .safe = @bitCast(safe),
    };

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const original_items = input.items;
    const actual = program.execute(&arena, &input);
    const next_bits = safe ^ (@as(Bits, 1) << (@bitSizeOf(Bits) - 1));
    const next: Input = .{ .choose = true, .items = &.{}, .safe = @bitCast(next_bits) };
    const later = try program.execute(&arena, &next);

    if (std.math.isNan(next.safe)) {
        try std.testing.expect(std.math.isNan(later));
    } else try std.testing.expectEqual(next_bits, @as(Bits, @bitCast(later)));

    try std.testing.expectEqualSlices(Bits, &snapshot, &storage);
    try std.testing.expectEqual(safe, @as(Bits, @bitCast(input.safe)));
    try std.testing.expectEqual(choose, input.choose);
    try std.testing.expectEqual(values.len, input.items.len);
    try std.testing.expectEqual(@intFromPtr(original_items.ptr), @intFromPtr(input.items.ptr));

    switch (expected) {
        .bounds => try std.testing.expectError(error.IndexOutOfBounds, actual),
        .value => |bits| {
            const value = try actual;

            if (bits) |pattern| {
                try std.testing.expectEqual(pattern, @as(Bits, @bitCast(value)));
            } else {
                try std.testing.expect(std.math.isNan(value));
            }
        },
    }
}
