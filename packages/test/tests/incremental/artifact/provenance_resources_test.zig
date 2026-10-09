const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("provenance/check.zig");
const f = h.f;
const Kind = enum { valid, source, compiled };

fn run(allocator: std.mem.Allocator, analysis: *const f.compiler.AnalysisResult, selected: usize, original: []const f.Record, before: []const u8, kind: Kind) !void {
    var result = f.artifact.extract(allocator, analysis, selected) catch |err| {
        try f.unchanged(before, analysis.*);

        var recovered = analysis.*;
        recovered.modules = original;

        try f.control(&recovered, selected);

        if (err == error.OutOfMemory) return err;
        try std.testing.expect(kind != .valid);
        try std.testing.expectEqual(error.InvalidModule, err);

        return;
    };

    defer result.deinit();

    try std.testing.expectEqual(Kind.valid, kind);
    try std.testing.expect(result.value.types.validStructure());
    try f.unchanged(before, analysis.*);
}

fn sweep(kind: Kind) !void {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const original = analysis.modules;
    var selected = try f.index(analysis, f.main_path);

    if (kind == .source) selected = try h.mutation.source(&analysis, .entry_path);
    if (kind == .compiled) try h.mutation.compiled(&analysis, selected, 0);

    const before = try f.snapshot(analysis);

    defer std.testing.allocator.free(before);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ &analysis, selected, original, before, kind });
}

test "valid artifact extraction releases each allocation failure without changing semantic inputs" {
    try sweep(.valid);
}

test "source rejection releases each allocation failure and permits restored extraction" {
    try sweep(.source);
}

test "compiled dependency rejection releases each allocation failure and permits restored extraction" {
    try sweep(.compiled);
}
