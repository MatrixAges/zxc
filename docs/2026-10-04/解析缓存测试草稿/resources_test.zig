const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "cache insert hit replacement rejection and repair clean allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, cacheTrace, .{});
}

test "cached project analysis and dependency change clean allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, projectTrace, .{});
}

fn cacheTrace(allocator: std.mem.Allocator) !void {
    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    for ([_][]const u8{ f.helper, f.helper, f.changed, f.invalid, f.helper }) |source| {
        _ = try cache.get(source, "helper.zx");
    }

    try std.testing.expectEqual(@as(usize, 4), cache.parsed);
    try std.testing.expectEqual(@as(usize, 1), cache.reused);
}

fn projectTrace(allocator: std.mem.Allocator) !void {
    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    for ([_][]const u8{ f.helper, f.helper, f.changed }) |source| {
        var result = try f.run(allocator, &cache, source);

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
    }

    try std.testing.expectEqual(@as(usize, 3), cache.parsed);
}
