const std = @import("std");
const labels = @import("labels.zig");
const punycode = @import("punycode.zig");

pub fn toAscii(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return convert(allocator, input, true);
}

pub fn toUnicode(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return convert(allocator, input, false);
}

fn convert(allocator: std.mem.Allocator, input: []const u8, ascii: bool) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const parts = try labels.parse(temporary, input);
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    for (parts, 0..) |label, index| {
        if (index != 0) try output.append(allocator, '.');

        if (ascii and !labels.isAscii(label)) {
            try output.appendSlice(allocator, "xn--");
            try output.appendSlice(allocator, try punycode.encode(temporary, label));
        } else {
            for (label) |point| {
                var bytes: [4]u8 = undefined;
                const length = try std.unicode.utf8Encode(point, &bytes);

                try output.appendSlice(allocator, bytes[0..length]);
            }
        }
    }

    return output.toOwnedSlice(allocator);
}
