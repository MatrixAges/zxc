const std = @import("std");
const program = @import("program");
pub const Input = std.meta.Child(program.Input);
pub const Scalar = @FieldType(Input, "marker");
pub const Bits = @Int(.unsigned, @bitSizeOf(Scalar));
pub const Pattern = struct { values: []const Bits, length: usize };
pub const Values = struct { left: Pattern, right: Pattern, marker: Bits };
pub const Case = struct { input: Values, expected: Values, owned_capture: bool };

pub fn fill(storage: []Bits, pattern: Pattern) !void {
    try std.testing.expectEqual(pattern.length, storage.len);
    try std.testing.expect(pattern.values.len > 0);
    for (storage, 0..) |*value, index| value.* = pattern.values[index % pattern.values.len];
}

pub fn expectScalar(actual: Scalar, bits: Bits) !void {
    if (std.math.isNan(@as(Scalar, @bitCast(bits)))) {
        try std.testing.expect(std.math.isNan(actual));
    } else try std.testing.expectEqual(bits, @as(Bits, @bitCast(actual)));
}

pub fn expect(actual: []const Scalar, pattern: Pattern) !void {
    try std.testing.expectEqual(pattern.length, actual.len);
    try std.testing.expect(pattern.values.len > 0);
    for (actual, 0..) |value, index| try expectScalar(value, pattern.values[index % pattern.values.len]);
}
