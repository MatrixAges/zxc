const std = @import("std");
const program = @import("program");
const pattern = @import("pattern.zig");

pub fn expect(actual: program.Output, expected: pattern.Values, input: *const pattern.Input, owned_capture: bool) !void {
    try pattern.expect(actual.left.items, expected.left);
    try pattern.expect(actual.right.items, expected.right);
    try pattern.expect(actual.captured, expected.left);
    try pattern.expectScalar(actual.left.marker, expected.marker);
    try pattern.expectScalar(actual.right.marker, expected.marker);

    if (input.left.len > 0) {
        try std.testing.expect(actual.left.items.ptr != input.left.ptr);
        try std.testing.expect(actual.left.items.ptr != input.right.ptr);
        try std.testing.expect(actual.left.items.ptr != actual.captured.ptr);

        if (owned_capture) {
            try std.testing.expect(actual.captured.ptr != input.left.ptr);
            try std.testing.expect(actual.captured.ptr != input.right.ptr);
        } else try std.testing.expectEqual(input.left.ptr, actual.captured.ptr);
    }

    if (input.right.len > 0) {
        try std.testing.expect(actual.right.items.ptr != input.left.ptr);
        try std.testing.expect(actual.right.items.ptr != input.right.ptr);
        try std.testing.expect(actual.right.items.ptr != actual.left.items.ptr);
        try std.testing.expect(actual.right.items.ptr != actual.captured.ptr);
    }
}
