const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("fixture.zig");

test "Store proof deep_both analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ count: in.count, rows: in.rows.map(row => row.map(item => item)), labels: in.labels.map(label => `${label}!`) }",
        .expected = true,
        .helper = true,
        .service = true,
    }});
}

test "Store proof shallow_rows analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ count: 9, rows: in.rows.map(row => row), labels: [\"fresh\"] }",
        .expected = false,
        .helper = true,
        .service = true,
    }});
}

test "Store proof spread_replace_all analysis linking codec allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .value = "{ ...in, rows: in.rows.map(row => row.map(item => item)), labels: in.labels.map(label => `${label}!`) }",
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
