const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("fixture.zig");

test "Store archive rejects forged whole helper owned summary" {
    try h.run(.{ .value = "in", .expected = false, .helper = true, .service = false, .forge_summary = true });
}

test "Store archive rejects forged whole nested service owned summary" {
    try h.run(.{ .value = "in", .expected = false, .helper = true, .service = true, .forge_summary = true });
}

test "Store archive rejects forged rows helper owned summary" {
    try h.run(.{ .value = "{ count: 9, rows: in.rows.map(row => row), labels: [\"fresh\"] }", .expected = false, .helper = true, .service = false, .forge_summary = true });
}

test "Store archive rejects forged rows nested service owned summary" {
    try h.run(.{ .value = "{ count: 9, rows: in.rows.map(row => row), labels: [\"fresh\"] }", .expected = false, .helper = true, .service = true, .forge_summary = true });
}

test "Store archive rejects forged labels helper owned summary" {
    try h.run(.{ .value = "{ count: 9, rows: [[1]], labels: in.labels.map(label => label) }", .expected = false, .helper = true, .service = false, .forge_summary = true });
}

test "Store archive rejects forged labels nested service owned summary" {
    try h.run(.{ .value = "{ count: 9, rows: [[1]], labels: in.labels.map(label => label) }", .expected = false, .helper = true, .service = true, .forge_summary = true });
}

test "Store archive rejects forged branch helper owned summary" {
    try h.run(.{ .value = "in.count == 0 ? {count: 9, rows: [[1]], labels: [\"fresh\"]} : in", .expected = false, .helper = true, .service = false, .forge_summary = true });
}

test "Store archive rejects forged branch nested service owned summary" {
    try h.run(.{ .value = "in.count == 0 ? {count: 9, rows: [[1]], labels: [\"fresh\"]} : in", .expected = false, .helper = true, .service = true, .forge_summary = true });
}

test "Store forged whole summary allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .value = "in", .expected = false, .helper = true, .service = true, .forge_summary = true }});
}

test "Store forged rows summary allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .value = "{ count: 9, rows: in.rows.map(row => row), labels: [\"fresh\"] }", .expected = false, .helper = true, .service = true, .forge_summary = true }});
}
