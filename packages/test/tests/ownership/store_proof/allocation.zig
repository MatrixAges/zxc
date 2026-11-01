const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("fixture.zig");

test "Store proof deep_both analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ count: in.count, rows: map(in.rows, row => map(row, item => item)), labels: map(in.labels, label => `${label}!`) }",
        .expected = true,
        .helper = true,
        .service = true,
    }});
}

test "Store proof shallow_rows analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ count: 9, rows: map(in.rows, row => row), labels: [\"fresh\"] }",
        .expected = false,
        .helper = true,
        .service = true,
    }});
}

test "Store proof spread_replace_all analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ ...in, rows: map(in.rows, row => map(row, item => item)), labels: map(in.labels, label => `${label}!`) }",
        .expected = true,
        .helper = true,
        .service = true,
    }});
}

test "Store proof branch_borrowed analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "in.count == 0 ? { count: 9, rows: [[1,2]], labels: [\"fresh\"] } : in",
        .expected = false,
        .helper = true,
        .service = true,
    }});
}
