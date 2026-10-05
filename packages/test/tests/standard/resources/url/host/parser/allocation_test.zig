const std = @import("std");
const fixture = @import("fixture.zig");
const cases = @import("cases.zig");

test "host success paths release all partial allocations" {
    for (cases.valid, 0..) |entry, index| {
        errdefer std.debug.print("host successful allocation case {d}\n", .{index});

        try std.testing.checkAllAllocationFailures(std.testing.allocator, fixture.success, .{ entry.input, entry.is_opaque, entry.expected });
    }
}

test "host rejection paths release all decoded and normalized temporaries" {
    for (cases.invalid, 0..) |entry, index| {
        errdefer std.debug.print("host rejected allocation case {d}\n", .{index});

        try std.testing.checkAllAllocationFailures(std.testing.allocator, fixture.rejection, .{ entry.input, entry.is_opaque, entry.expected });
    }
}
