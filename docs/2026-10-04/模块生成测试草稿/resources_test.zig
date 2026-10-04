const std = @import("std");
const f = @import("fixture.zig");

test "uncached module generation cleans every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "generation cache populate reuse replace cleans every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

fn run(allocator: std.mem.Allocator, cached: bool) !void {
    var cache = f.compiler.zig.GenerationCache.init(allocator);

    defer cache.deinit();

    var original = try f.analyze(std.testing.allocator, false);

    defer original.deinit();

    var changed = try f.analyze(std.testing.allocator, true);

    defer changed.deinit();

    for ([_]*const f.compiler.AnalysisResult{ &original, &original, &changed }) |analysis| {
        var bundle = try f.compiler.zig.emitModulesCached(allocator, analysis, if (cached) &cache else null);

        defer bundle.deinit();

        try std.testing.expectEqual(@as(usize, 1), bundle.modules.len);
    }
}
