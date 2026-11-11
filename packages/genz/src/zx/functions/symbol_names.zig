const std = @import("std");

pub fn initialize(allocator: std.mem.Allocator, names: [][]const u8) std.mem.Allocator.Error!void {
    if (!@import("genz_options").generated_analysis) {
        for (names, 0..) |*item, index| item.* = if (index == 0) "in" else try std.fmt.allocPrint(allocator, "value_{d}", .{index});

        return;
    }

    const entry = @import("generated_function_symbol_names");
    const input: u64 = names.len;

    const packed_names = entry.executeValue(allocator, input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    var start: usize = 0;

    for (names) |*name| {
        const end = std.mem.indexOfScalarPos(u8, packed_names, start, 0).?;

        name.* = packed_names[start..end];
        start = end + 1;
    }
}
