const std = @import("std");
const fixture = @import("fixture.zig");
const cases = @import("rfc_cases.zig").cases;

test "Punycode all RFC encodings release every partial allocation" {
    for (cases) |entry| {
        errdefer std.debug.print("RFC {s} allocation encode\n", .{entry.id});

        try std.testing.checkAllAllocationFailures(std.testing.allocator, fixture.checkEncode, .{ entry.points, entry.encoded });
    }
}

test "Punycode all RFC decodings release every partial allocation" {
    for (cases) |entry| {
        errdefer std.debug.print("RFC {s} allocation decode\n", .{entry.id});

        try std.testing.checkAllAllocationFailures(std.testing.allocator, fixture.checkDecode, .{ entry.original, entry.points });
    }
}
