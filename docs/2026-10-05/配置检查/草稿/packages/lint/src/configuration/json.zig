const std = @import("std");

pub fn format(allocator: std.mem.Allocator, source: []const u8) ![]u8 {
    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, source, .{ .allocate = .alloc_always, .parse_numbers = false });

    defer parsed.deinit();

    const formatted = try std.json.Stringify.valueAlloc(allocator, parsed.value, .{ .whitespace = .indent_tab });

    defer allocator.free(formatted);

    return std.fmt.allocPrint(allocator, "{s}\n", .{formatted});
}
