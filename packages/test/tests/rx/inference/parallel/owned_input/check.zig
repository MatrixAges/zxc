const std = @import("std");
const compiler = @import("compiler");
const h = @import("../check.zig");
pub const Case = h.Case;

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    var configured = case;

    const defaults: []const compiler.project.Source = &.{
        .{ .path = "consume.zx", .source = @embedFile("consume.zx") },
        .{ .path = "consume_next.zx", .source = @embedFile("consume.zx") },
        .{ .path = "consume_right.zx", .source = @embedFile("consume.zx") },
        .{ .path = "list_other.zx", .source = @embedFile("../fixtures/list.zx") },
        .{ .path = "list_read.zx", .source = @embedFile("../fixtures/list.zx") },
    };

    const sources = try std.mem.concat(allocator, compiler.project.Source, &.{ defaults, case.extra_sources });

    defer allocator.free(sources);

    configured.extra_sources = sources;

    try h.allocated(allocator, configured);
}
