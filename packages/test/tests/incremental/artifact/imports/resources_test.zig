const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const check = @import("check.zig");
const mutation = @import("mutation.zig");
const columns = @import("artifact_mixed_fixture");

fn sweep(kind: ?mutation.Mutation) !void {
    var analysis = try f.analyze(std.testing.allocator, f.orderings[0], true);

    defer analysis.deinit();

    const index = try f.entry(analysis);
    var control = try f.artifact.extract(std.testing.allocator, &analysis, index);

    defer control.deinit();

    try check.module(analysis, index, control.value);
    if (kind) |value| try mutation.apply(&analysis, index, value);

    var snapshots = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer snapshots.deinit();

    const types = try columns.copyColumns(snapshots.allocator(), analysis.value.ir.types);
    const origins = try columns.copyColumns(snapshots.allocator(), analysis.nominal_types);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ &analysis, index, types, origins, kind });
}

fn run(allocator: std.mem.Allocator, analysis: *const f.compiler.AnalysisResult, index: usize, types: f.ir.TypeTable, origins: @TypeOf(@as(f.compiler.AnalysisResult, undefined).nominal_types), kind: ?mutation.Mutation) !void {
    var result = f.artifact.extract(allocator, analysis, index) catch |err| {
        try columns.sameColumns(types, analysis.value.ir.types);
        try columns.sameColumns(origins, analysis.nominal_types);
        if (err == error.InvalidModule and kind != null) return;

        return err;
    };

    defer result.deinit();

    try std.testing.expect(kind == null);
    try check.module(analysis.*, index, result.value);
    try columns.sameColumns(types, analysis.value.ir.types);
    try columns.sameColumns(origins, analysis.nominal_types);
}

test "artifact aliases clean every extraction allocation failure without changing type columns" {
    try sweep(null);
}

test "invalid alias input cleans every extraction allocation failure without changing type columns" {
    try sweep(.alias_input);
}

test "invalid alias output cleans every extraction allocation failure without changing type columns" {
    try sweep(.alias_output);
}
