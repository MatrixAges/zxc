const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("buffer_eligibility/fixture.zig");
const same = @import("fixture.zig").same;

fn check(before: f.Mode, after: f.Mode) !void {
    var original = try f.analyze(before);

    defer original.deinit();

    var changed = try f.analyze(after);

    defer changed.deinit();

    var first = try f.compiler.zig.emitModules(std.testing.allocator, &original);

    defer first.deinit();

    var second = try f.compiler.zig.emitModules(std.testing.allocator, &changed);

    defer second.deinit();

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ &original, &changed, first, second });
}

fn run(allocator: std.mem.Allocator, original: *const f.compiler.AnalysisResult, changed: *const f.compiler.AnalysisResult, first: f.compiler.zig.ModuleBundle, second: f.compiler.zig.ModuleBundle) !void {
    var cache = f.compiler.zig.GenerationCache.init(allocator);

    defer cache.deinit();

    const analyses = [_]*const f.compiler.AnalysisResult{ original, original, changed, original };
    const expected = [_]f.compiler.zig.ModuleBundle{ first, first, second, first };

    for (analyses, expected) |analysis, baseline| {
        var bundle = try f.compiler.zig.emitModulesCached(allocator, analysis, &cache);

        defer bundle.deinit();

        try same(bundle, baseline);
    }
}

test "losing buffer eligibility cleans every cache lifecycle allocation failure" {
    try check(.push, .reverse);
}

test "gaining buffer eligibility cleans every cache lifecycle allocation failure" {
    try check(.reverse, .push);
}

test "changing buffered payload cleans every cache lifecycle allocation failure" {
    try check(.push, .changed);
}
