const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const graph = @import("graph.zig");
const metadata = @import("metadata.zig");

test "entry extraction alone cleans every allocation failure and preserves input columns" {
    try checked("/project/main.zx", .none);
}

test "pure type extraction alone cleans every allocation failure and preserves input columns" {
    try checked("/project/types.zx", .none);
}

test "missing native origin extraction cleans every allocation failure and preserves input columns" {
    try checked("/project/main.zx", .missing_node);
}

fn checked(path: []const u8, mutation: f.Mutation) !void {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    try f.mutate(&analysis, mutation);

    const index = try f.moduleIndex(analysis, path);
    var snapshots = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer snapshots.deinit();

    const types = try f.copyColumns(snapshots.allocator(), analysis.value.ir.types);
    const origins = try f.copyColumns(snapshots.allocator(), analysis.nominal_types);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ &analysis, index, types, origins, mutation });
}

fn run(allocator: std.mem.Allocator, analysis: *const f.compiler.AnalysisResult, index: usize, types: f.ir.TypeTable, origins: f.Origins, mutation: f.Mutation) !void {
    var result = f.artifact.extract(allocator, analysis, index) catch |err| {
        try f.sameColumns(types, analysis.value.ir.types);
        try f.sameColumns(origins, analysis.nominal_types);
        if (err == error.MissingNominalOrigin and mutation == .missing_node) return;

        return err;
    };

    defer result.deinit();

    try f.sameColumns(types, analysis.value.ir.types);
    try f.sameColumns(origins, analysis.nominal_types);
    try std.testing.expectEqual(f.Mutation.none, mutation);

    const module = result.value;

    const ids = if (module.function) |function|
        try graph.check(module.types, function.input_type, function.output_type)
    else
        try graph.check(module.types, try graph.exported(module, "Request"), try graph.exported(module, "Response"));
    try metadata.nominal(module, ids);
    try metadata.native(module, ids.node);
    try metadata.dependencies(module);

    if (module.function != null) {
        try metadata.functions(module, ids.node);
        try graph.task(module);
    }
}
