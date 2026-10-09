const std = @import("std");
pub const f = @import("fixture.zig");
pub const mutation = @import("mutation.zig");

pub fn rejected(analysis: *const f.compiler.AnalysisResult, selected: usize, expected: anyerror) !void {
    try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, analysis.value.ir));

    const before = try f.snapshot(analysis.*);

    defer std.testing.allocator.free(before);

    try std.testing.expectError(expected, f.artifact.extract(std.testing.allocator, analysis, selected));
    try f.unchanged(before, analysis.*);
}

pub fn source(kind: mutation.Kind) !void {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const original = analysis.modules;
    const selected = try mutation.source(&analysis, kind);

    try rejected(&analysis, selected, error.InvalidModule);

    analysis.modules = original;

    try f.control(&analysis, selected);
}

pub fn compiled(position: usize) !void {
    for (f.orders) |order| {
        var analysis = try f.analyze(order);

        defer analysis.deinit();

        const selected = try f.index(analysis, f.main_path);

        try f.control(&analysis, selected);
        try mutation.compiled(&analysis, selected, position);
        try rejected(&analysis, selected, error.InvalidModule);
    }
}

pub fn unused(path: []const u8) !void {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const selected = try f.index(analysis, path);

    try f.control(&analysis, selected);
    try mutation.unused(&analysis, selected);
    try rejected(&analysis, selected, error.InvalidModule);
}
