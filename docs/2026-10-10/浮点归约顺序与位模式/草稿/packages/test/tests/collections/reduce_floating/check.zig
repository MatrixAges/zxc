const std = @import("std");
const program = @import("program");
const Input = std.meta.Child(program.Input);
const Scalar = @typeInfo(@FieldType(Input, "items")).pointer.child;
const Bits = @Int(.unsigned, @bitSizeOf(Scalar));

pub fn check(values: []const Bits, seed: Bits, expected: union(enum) { value: ?Bits, missing_initial }) !void {
    var storage: [4098]Bits = @splat(std.math.maxInt(Bits));

    try std.testing.expect(values.len <= storage.len - 2);

    @memcpy(storage[1..][0..values.len], values);

    const snapshot = storage;

    const input: Input = .{
        .items = std.mem.bytesAsSlice(Scalar, std.mem.sliceAsBytes(storage[1..][0..values.len])),
        .seed = @bitCast(seed),
    };

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const original_items = input.items;
    const actual = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(Bits, &snapshot, &storage);
    try std.testing.expectEqual(seed, @as(Bits, @bitCast(input.seed)));
    try std.testing.expectEqual(values.len, input.items.len);
    try std.testing.expectEqual(@intFromPtr(original_items.ptr), @intFromPtr(input.items.ptr));

    switch (expected) {
        .missing_initial => try std.testing.expectError(error.IndexOutOfBounds, actual),
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
