const std = @import("std");
const h = @import("../check.zig");
pub const Case = h.Case;

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    var configured = case;

    configured.extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("consume.zx") }};

    try h.allocated(allocator, configured);
}
