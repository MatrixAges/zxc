const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const oracle = @import("oracle.zig");

test "wide shared extraction cleans every allocation failure without mutating inputs" {
    try sweep(.{ .depth = 17, .width = 65 });
}

test "empty dynamic extraction cleans every allocation failure without mutating inputs" {
    try sweep(.{ .depth = 0, .width = 0 });
}

fn sweep(args: f.Case) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var analysis = try f.analyze(setup.allocator(), args);

    defer analysis.deinit();

    const types = try f.ownedColumns(setup.allocator(), analysis.value.ir.types);
    const origins = try f.ownedColumns(setup.allocator(), analysis.nominal_types);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ &analysis, try f.entry(analysis), types, origins });
}

fn run(memory: std.mem.Allocator, analysis: *const f.compiler.AnalysisResult, index: usize, types: f.ir.TypeTable, origins: f.Origins) !void {
    var result = f.artifact.extract(memory, analysis, index) catch |err| {
        try f.sameColumns(types, analysis.value.ir.types);
        try f.sameColumns(origins, analysis.nominal_types);

        return err;
    };

    defer result.deinit();

    try f.sameColumns(types, analysis.value.ir.types);
    try f.sameColumns(origins, analysis.nominal_types);

    const record = analysis.modules[index];

    try oracle.check(std.testing.allocator, types, record.exports, record.type_imports, result.value);
}
