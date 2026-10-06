const std = @import("std");
const compiler = @import("compiler");
const allocations = @import("../support/allocation_testing.zig");
const f = @import("fixture.zig");
const Route = enum { analyze, direct_analyze, cache_destroy, direct_cache_destroy, semantic_destroy, direct_semantic_destroy, cache_replace, direct_cache_replace, semantic_replace, direct_semantic_replace };

fn check(allocator: std.mem.Allocator, route: Route) !void {
    var output = blk: {
        var caller = std.heap.ArenaAllocator.init(allocator);

        defer caller.deinit();

        const source = try caller.allocator().dupe(u8, f.source);
        const path = try caller.allocator().dupe(u8, "main.zx");
        const sources: []const compiler.project.Source = &.{.{ .path = path, .source = source }};

        const result = switch (route) {
            .analyze => try compiler.analyzeProject(allocator, sources, f.options),
            .direct_analyze => try compiler.project.analyze(allocator, sources, f.options),
            .cache_destroy, .direct_cache_destroy, .cache_replace, .direct_cache_replace => cache_blk: {
                var cache = compiler.project.ParseCache{ .allocator = allocator };

                defer cache.deinit();

                var analyzed = if (route == .cache_destroy or route == .cache_replace)
                    try compiler.analyzeProjectWithCache(allocator, sources, f.options, &cache)
                else
                    try compiler.project.analyzeWithCache(allocator, sources, f.options, &cache);

                errdefer analyzed.deinit();

                try std.testing.expect(analyzed.value == .diagnostic);
                try f.check(analyzed.value.diagnostic, 0);

                if (route == .cache_replace or route == .direct_cache_replace) {
                    _ = try cache.get(f.repaired, "/project/main.zx");

                    try f.check(analyzed.value.diagnostic, 0);
                }

                break :cache_blk analyzed;
            },
            .semantic_destroy, .direct_semantic_destroy, .semantic_replace, .direct_semantic_replace => cache_blk: {
                var cache = compiler.project.SemanticCache.init(allocator);

                defer cache.deinit();

                var analyzed = if (route == .semantic_destroy or route == .semantic_replace)
                    try compiler.analyzeProjectIncremental(allocator, sources, f.options, &cache)
                else
                    try compiler.project.analyzeIncremental(allocator, sources, f.options, &cache);

                errdefer analyzed.deinit();

                try std.testing.expect(analyzed.value == .diagnostic);
                try f.check(analyzed.value.diagnostic, 0);

                if (route == .semantic_replace or route == .direct_semantic_replace) {
                    _ = try cache.parse_cache.get(f.repaired, "/project/main.zx");

                    try f.check(analyzed.value.diagnostic, 0);
                }

                break :cache_blk analyzed;
            },
        };

        @memset(source, 'x');
        @memset(path, 'x');

        break :blk result;
    };

    defer output.deinit();

    try std.testing.expect(output.value == .diagnostic);
    try f.check(output.value.diagnostic, 0);
}

test "analyzeProject syntax diagnostic outlives its internal parse cache" {
    try check(std.testing.allocator, .analyze);
}

test "direct project analyze syntax diagnostic outlives its internal parse cache" {
    try check(std.testing.allocator, .direct_analyze);
}

test "analyzeProjectWithCache syntax diagnostic outlives cache destruction" {
    try check(std.testing.allocator, .cache_destroy);
}

test "direct project analyzeWithCache syntax diagnostic outlives cache destruction" {
    try check(std.testing.allocator, .direct_cache_destroy);
}

test "analyzeProjectIncremental syntax diagnostic outlives semantic cache destruction" {
    try check(std.testing.allocator, .semantic_destroy);
}

test "direct project analyzeIncremental syntax diagnostic outlives semantic cache destruction" {
    try check(std.testing.allocator, .direct_semantic_destroy);
}

test "analyzeProjectWithCache syntax diagnostic survives parse cache replacement" {
    try check(std.testing.allocator, .cache_replace);
}

test "direct project analyzeWithCache syntax diagnostic survives parse cache replacement" {
    try check(std.testing.allocator, .direct_cache_replace);
}

test "analyzeProjectIncremental syntax diagnostic survives parse cache replacement" {
    try check(std.testing.allocator, .semantic_replace);
}

test "direct project analyzeIncremental syntax diagnostic survives parse cache replacement" {
    try check(std.testing.allocator, .direct_semantic_replace);
}

test "project syntax diagnostics release every failed allocation across public cache boundaries" {
    for (std.enums.values(Route)) |route| {
        try allocations.checkAllAllocationFailures(std.testing.allocator, check, .{route});
    }
}
