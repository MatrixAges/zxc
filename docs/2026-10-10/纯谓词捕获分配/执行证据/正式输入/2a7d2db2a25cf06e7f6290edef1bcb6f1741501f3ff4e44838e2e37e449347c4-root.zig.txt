const std = @import("std");
const check = @import("check.zig");
const lengths = [_]usize{ 0, 1, 2, 17, 257, 4096 };

fn observe(comptime interface: check.Interface, deny: bool) !usize {
    var violations: usize = 0;

    for (lengths) |count| {
        for (0..3) |pattern| {
            if (!try check.observe(interface, count, pattern, deny)) violations += 1;
        }
    }

    return violations;
}

test "pure pointer predicates preserve results and input" {
    _ = try observe(.pointer, false);
}

test "pure value predicates preserve results and input" {
    _ = try observe(.value, false);
}

test "pure pointer predicates execute without heap allocation" {
    try std.testing.expectEqual(@as(usize, 0), try observe(.pointer, true));
}

test "pure value predicates execute without heap allocation" {
    try std.testing.expectEqual(@as(usize, 0), try observe(.value, true));
}

test "ordinary Zig predicate baseline needs no allocator" {
    const values = [_]i64{ -3, 11, 0, 7, 8 };

    try std.testing.expectEqual(!@import("options").universal, check.expected(&values, 7));
    try std.testing.expectEqual(@import("options").universal, check.expected(&.{}, 7));
}
