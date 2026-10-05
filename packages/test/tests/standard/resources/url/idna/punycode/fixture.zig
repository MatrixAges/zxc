const std = @import("std");
const impl = @import("implementation");

pub fn checkEncode(allocator: std.mem.Allocator, input: []const u21, expected: []const u8) !void {
    const output = try impl.encode(allocator, input);

    defer allocator.free(output);

    try std.testing.expectEqualStrings(expected, output);
}

pub fn checkDecode(allocator: std.mem.Allocator, input: []const u8, expected: []const u21) !void {
    const output = try impl.decode(allocator, input);

    defer allocator.free(output);

    try std.testing.expectEqualSlices(u21, expected, output);
}
